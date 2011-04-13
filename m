Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995Ab1DMDgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 23:36:32 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:36782 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780Ab1DMDgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 23:36:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NPK3c8gVISPhUT3SA1Otr70wKzpoR1aTzHDcClAEoPpxT4iLXrxcLAGYy+YvN2vVOu
         Z3URKOouE4u+rLaA28VOqsHlA2wlOiycHzP7cytMC/q8V3u6m5Qsm70RYf81U8dDnhrY
         R4cb+k621nWeUgYlvv0V9YkZ4qAvTh4FFVvUg=
Subject: Re: [PATCH] nand: Fix S3C NAND clock stop
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Jiri Pinkava <jiri.pinkava@vscht.cz>
Cc: ben-linux@fluff.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org
In-Reply-To: <1302533304-6795-1-git-send-email-jiri.pinkava@vscht.cz>
References: <4DA27245.6@vscht.cz>
	 <1302533304-6795-1-git-send-email-jiri.pinkava@vscht.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 06:36:24 +0300
Message-ID: <1302665784.14691.5.camel@koala>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-11 at 16:48 +0200, Jiri Pinkava wrote:
> Current implementation of s3c2410_nand_select_chip call
> clk_disable every time when chip = -1 (de-select). This happend
> multiple times even if chip was already de-selected. This causes
> disabling clock even if they are already disabled and due to
> nature of clock subsytem implementation this causes nand clock
> to be disabled and newer enabled again.
> 
> Signed-off-by: Jiri Pinkava <jiri.pinkava@vscht.cz>
> ---
>  drivers/mtd/nand/s3c2410.c |   59 ++++++++++++++++++++++++++++++++------------
>  1 files changed, 43 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/mtd/nand/s3c2410.c b/drivers/mtd/nand/s3c2410.c
> index 33d832d..cea775a 100644
> --- a/drivers/mtd/nand/s3c2410.c
> +++ b/drivers/mtd/nand/s3c2410.c
> @@ -55,7 +55,7 @@ static int hardware_ecc = 0;
>  #endif
>  
>  #ifdef CONFIG_MTD_NAND_S3C2410_CLKSTOP
> -static int clock_stop = 1;
> +static const int clock_stop = 1;
>  #else
>  static const int clock_stop = 0;
>  #endif

Please, kill clock_stop variable completely in a separate patch.

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

