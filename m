Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab1FNRmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 13:42:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52334 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab1FNRmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 13:42:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=OzvTLMyICqMUNxnnEFHkVya0awUba9mgR86X/fqN0A8Fh9peqMUoqn3FbijocJLeaO
         9v5/Oeh88DMhA3G1Dp7QFSUz/01DWYW1GWZz/tpB0GEwrG5sARnUi8szx/2/qKsHRR4O
         WwyhXi/LyrHWRi9FOE29rordaGzOnhSvQAtHI=
From: Christian Lamparter <chunkeey@googlemail.com>
To: Joe Perches <joe@perches.com>
Subject: Re: [ath9k-devel] [PATCH net-next 1/2] wireless: Remove casts of void *
Date: Tue, 14 Jun 2011 19:43:15 +0200
User-Agent: KMail/1.13.5 (Linux/3.0.0-rc2-wl+; KDE/4.4.5; x86_64; ; )
Cc: Pavel Roskin <proski@gnu.org>, netdev@vger.kernel.org,
        Intel Linux Wireless <ilw@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        Jouni Malinen <jmalinen@atheros.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        ath9k-devel@venema.h4ckr.net, "Wey-Yi Guy" <wey-yi.w.guy@intel.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
References: <cover.1308024069.git.joe@perches.com> <4DF78CEC.70409@gnu.org> <1308069831.21026.9.camel@Joe-Laptop>
In-Reply-To: <1308069831.21026.9.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106141943.15887.chunkeey@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 June 2011 18:43:51 Joe Perches wrote:
> On Tue, 2011-06-14 at 12:31 -0400, Pavel Roskin wrote:
> > On 06/14/2011 12:02 AM, Joe Perches wrote:
> > >   		/* Get the message ID */
> > > -		msg_id = (__be16 *) ((void *) htc_hdr +
> > > -				     sizeof(struct htc_frame_hdr));
> > > +		msg_id = (void *)htc_hdr + sizeof(struct htc_frame_hdr);
> > I would never do stuff like this without verifying by sparse that no 
> > warnings are introduced.
> 
> I did that.  I believe there are no new warnings.
> 
> > Sparse warnings should be avoided to keep sparse checks useful. 
> > Otherwise, important warnings would drown in the noise.
> 
> $ make allyesconfig
> $ git log -1 --pretty=oneline drivers/net/wireless/ath/ath9k/htc_hst.c
> 337c22b774ff7f007b90b266b25c9a33ff555c48 wireless: Remove casts of void *
> $ make C=2 drivers/net/wireless/ath/ath9k/htc_hst.o

Just a quick FYI: To perform endianness checks, you may define __CHECK_ENDIAN__:

make C=2 CF="-D__CHECK_ENDIAN__"

[Although, it doesn't look like your patch introduced any new endianness
problems]

Regards,
	Chr
