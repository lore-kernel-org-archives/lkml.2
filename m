Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab1IGQfP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:35:15 -0400
Received: from gw1.transmode.se ([195.58.98.146]:47709 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178Ab1IGQfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:35:12 -0400
In-Reply-To: <20110811153401.21426.qmail@science.horizon.com>
References: <4E4309E4.2080108@systemfabricworks.com> <20110811153401.21426.qmail@science.horizon.com>
Subject: Re: [patch v5 7/8] crc32-add-slicing-by-8.diff
X-KeepSent: 718A605A:F3B31DD6-C1257904:003A5AB7;
 type=4; name=$KeepSent
To: "George Spelvin" <linux@horizon.com>
Cc: akpm@linux-foundation.org, fzago@systemfabricworks.com,
        linux-kernel@vger.kernel.org, rpearson@systemfabricworks.com
X-Mailer: Lotus Notes Release 8.5.2FP3 Aug 10, 2010
Message-ID: <OF718A605A.F3B31DD6-ONC1257904.003A5AB7-C1257904.003A8AD4@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Wed, 7 Sep 2011 12:39:26 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.2FP3|July 10, 2011) at
 09/07/2011 12:39:27
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


"George Spelvin" <linux@horizon.com> wrote on 2011/08/11 17:34:01:
>
> I don't know if you care, but here's some slightly more compact code for
> creating the tables.  It produces the same results, and I don't think
> it's any slower.
>
> I can explain it if anyone's confused, but it's hopefully fairly
> easy to figure out assuming a backgriund in CRC math.
>
> (Tested against existing code, not in kernel.)
> Signed-off-by: George Spelvin <linux@horizon.com>

Forgot about this mail. Looks really neat :)
Easy to generalize to support crc16 too.

 Jocke
>
> static void crc32init_le(void)
> {
>    unsigned i, j, k;
>    uint32_t crc = 1;
>
>    for (i = 0; i < LE_TABLE_ROWS; i++) {
>       crc32table_le[i][0] = 0;
>       for (j = LE_TABLE_SIZE >> 1; j; j >>= 1) {
>          crc = (crc >> 1) ^ (crc & 1 ? CRCPOLY_LE : 0);
>          for (k = 0; k < LE_TABLE_SIZE; k += 2 * j)
>             crc32table_le[i][j + k] = crc ^ crc32table_le[i][k];
>       }
>    }
> }
>
> static void crc32init_be(void)
> {
>    unsigned i, j, k;
>    uint32_t crc = 0x80000000;
>
>    for (i = 0; i < BE_TABLE_ROWS; i++) {
>       crc32table_be[i][0] = 0;
>       for (j = 1; j < BE_TABLE_SIZE; j <<= 1) {
>          crc = (crc << 1) ^ (crc & 0x80000000 ? CRCPOLY_BE : 0);
>          for (k = 0; k < j; k++)
>             crc32table_be[i][j + k] = crc ^ crc32table_be[i][k];
>       }
>    }
> }

