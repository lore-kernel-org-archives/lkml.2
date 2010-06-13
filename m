Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab0FMKub (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 06:50:31 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43606 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab0FMKu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 06:50:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=pGnMLJvnvyXBKIDIhppLEo3FSkOLfDTO82ENskgjuWjGxyupbdAkoC1FJyeM6J8429
         hJR3WBjWpaEjBwUSbR4G+6iZY4C5Ar6qtTHj4cjOGEiwOvSTnBG/YOis3Ln39vvKdj1f
         4FSet42hElph/jxYwX1icuxT0o6veDTrKkKNs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
Subject: Re: [PATCH] rt3070: Fixed a line over 80 character warning reported by checkpatch.pl tool
Date: Sun, 13 Jun 2010 12:42:41 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.33-0.1-desktop; KDE/4.3.5; x86_64; ; )
Cc: devel@driverdev.osuosl.org, Matti Lammi <mattij.lammi@gmail.com>,
       gregkh@suse.de, andrea.gelmini@gelma.net, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
References: <1276164045-6003-1-git-send-email-mattij.lammi@gmail.com> <201006101521.45409.s.L-H@gmx.de>
In-Reply-To: <201006101521.45409.s.L-H@gmx.de>
MIME-Version: 1.0
Message-Id: <201006131242.41512.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday 10 June 2010 03:21:42 pm Stefan Lippers-Hollmann wrote:
> Hi
> 
> On Thursday 10 June 2010, Matti Lammi wrote:
> > Divided a comment line into two separet lines in drivers/staging/rt3070/md4.h.
> 
> Isn't drivers/staging/rt3070/ as a whole dead code by now? What about the 
> following removal patch instead (compile tested and no complaints from 
> rt30[79]0 users yet)?

Looks fine to me, FWIW:

Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

> As a side note, rt2800pci/ rt2800usb from drivers/net/wireless/rt2x00/ have
> become fully functional for rt2770, rt2860, rt2870 (and I've gotten 
> very positive feedback for rt3070/ rt3090) with 2.6.35, so the staging 
> rt2860/ rt2870 drivers could be removed soon (now?). rt35xx support is 
> rt2x00-only anyways and HT rates aren't actually achievable by staging 
> (only by newer out-of-tree vendor drivers) or rt2x00 (work is under way) 
> yet.

No idea here.  The last time I tried rt2800 drivers was in 2.6.34-rc days
and my experiences were not exactly positive back then.  Things may be
different nowadays or they may be not -- I don't have any time to spend on
this and staging drivers continue to work just fine for me at the moment.

> From: Stefan Lippers-Hollmann <s.l-h@gmx.de>
> Date: Wed, 24 Mar 2010 20:56:13 +0000
> Subject: [PATCH] rt3070: remove dead code
> 
> While merging rt30[79]0 support into rt28[67]0, drivers/staging/rt3070/md4.h 
> has been forgotten, while it isn't referenced from the remaining drivers 
> anymore; remove it.
> 
> Signed-off-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
> ---
>  drivers/staging/rt3070/md4.h |   42 ------------------------------------------
>  1 files changed, 0 insertions(+), 42 deletions(-)
>  delete mode 100644 drivers/staging/rt3070/md4.h
> 
> diff --git a/drivers/staging/rt3070/md4.h b/drivers/staging/rt3070/md4.h
> deleted file mode 100644
> index b3fb637..0000000
> --- a/drivers/staging/rt3070/md4.h
> +++ /dev/null
> @@ -1,42 +0,0 @@
> -/*
> - *************************************************************************
> - * Ralink Tech Inc.
> - * 5F., No.36, Taiyuan St., Jhubei City,
> - * Hsinchu County 302,
> - * Taiwan, R.O.C.
> - *
> - * (c) Copyright 2002-2007, Ralink Technology, Inc.
> - *
> - * This program is free software; you can redistribute it and/or modify  *
> - * it under the terms of the GNU General Public License as published by  *
> - * the Free Software Foundation; either version 2 of the License, or     *
> - * (at your option) any later version.                                   *
> - *                                                                       *
> - * This program is distributed in the hope that it will be useful,       *
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of        *
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
> - * GNU General Public License for more details.                          *
> - *                                                                       *
> - * You should have received a copy of the GNU General Public License     *
> - * along with this program; if not, write to the                         *
> - * Free Software Foundation, Inc.,                                       *
> - * 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
> - *                                                                       *
> - *************************************************************************
> - */
> -
> -#ifndef __MD4_H__
> -#define __MD4_H__
> -
> -/* MD4 context. */
> -typedef	struct	_MD4_CTX_	{
> -	unsigned long	state[4];        /* state (ABCD) */
> -	unsigned long	count[2];        /* number of bits, modulo 2^64 (lsb first) */
> -	u8	buffer[64];      /* input buffer */
> -}	MD4_CTX;
> -
> -void MD4Init(MD4_CTX *);
> -void MD4Update(MD4_CTX *, u8 *, UINT);
> -void MD4Final(u8 [16], MD4_CTX *);
> -
> -#endif /*__MD4_H__*/

--
Bartlomiej Zolnierkiewicz
