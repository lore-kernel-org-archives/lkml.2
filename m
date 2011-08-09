Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab1HIQuH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 12:50:07 -0400
Received: from gw1.transmode.se ([195.58.98.146]:50788 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754056Ab1HIQuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 12:50:06 -0400
In-Reply-To: <20110809114504.6140.qmail@science.horizon.com>
References: <4E40CCCF.5070000@systemfabricworks.com> <20110809114504.6140.qmail@science.horizon.com>
Subject: Re: [patch v4 1/7] crc32: move-to-documentation.diff
X-KeepSent: 2A1D4C02:965787E8-C12578E7:005C021E;
 type=4; name=$KeepSent
To: "George Spelvin" <linux@horizon.com>
Cc: akpm@linux-foundation.org, fzago@systemfabricworks.com,
        linux-kernel@vger.kernel.org, rdunlap@xenotime.net,
        rpearson@systemfabricworks.com
X-Mailer: Lotus Notes Release 8.5.2FP3 Aug 10, 2010
Message-ID: <OF2A1D4C02.965787E8-ONC12578E7.005C021E-C12578E7.005C7904@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Tue, 9 Aug 2011 18:50:02 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.2FP3|July 10, 2011) at
 08/09/2011 18:50:03
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"George Spelvin" <linux@horizon.com> wrote on 2011/08/09 13:45:04:
>
> Here's a hopefully-improved Documentation file, which explains the slicing
> algorithm as well.  As long as you have a big diff, it seems worth tweaking.
>
> You also might want to leave a pointer in lib/crc32.c to the relocated docs.
>
> (I'm just inclding the whole changed file because I assume it's easier
> to review that way; do you prefer a diff?)

Nice, reading this once again I think I found an old typo. See below

Perhaps Bob can add this addition to his patch series?

>
> === Cut here ===
...
> Or in little-endian:
> for (i = 0; i < input_bytes; i++) {
>    remainder ^= next_input_byte();
>    for (j = 0; j < 8; j++) {
>       multiple = (remainder & 1) ? CRCPOLY : 0;
>       remainder = (remainder << 1) ^ multiple;

Should not above line be:
       remainder = (remainder >> 1) ^ multiple;
?

>    }
> }
>
> If the input is a multiple of 32 bits, you can even XOR in a 32-bit
> word at a time and increase the inner loop count to 32.

