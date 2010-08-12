Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711Ab0HLBH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 21:07:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34623 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757571Ab0HLBHz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 21:07:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=cCCGe7J3J7joIJB+R1fOZLsZdQpAjGJNyUPThE+fYzT+8mkrnjXaKOzGFPQrXM79sG
         8+56rDZ53y/XcIqdE1IljQFDskMfOW76BpTaxtGp0+7vKIouokkWX1lxF+EdvJzB8f7C
         X/V7ehlJy2iSTZ7XeGKxq7a/20gy7KmcAKY7U=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: Greg KH <gregkh@suse.de>
Subject: Re: [60/67] mtd: gen_nand: fix support for multiple chips
Date: Thu, 12 Aug 2010 03:07:26 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34-1-amd64; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        David Woodhouse <David.Woodhouse@intel.com>
References: <20100812000618.231443032@clark.site>
In-Reply-To: <20100812000618.231443032@clark.site>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008120307.27100.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Čt 12. srpna 2010 02:06:15 Greg KH napsal(a):
> 2.6.35-stable review patch.  If anyone has any objections, please let us
> know.

It's going to break plat-qong, apparently the code there is incorrect and 
depends on this bug, I'll send a patch for it in a bit.
> 
> ------------------
> 
> From: Marek Vasut <marek.vasut@gmail.com>
> 
> commit 81cbb0b17796d81cbd92defe113cf2a7c7a21fbb upstream.
> 
> This patch corrects a problem where gen_nand driver assumed there can be
> only one chip and ignored the pdata->chip.nr_chips value.
> 
> Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
> Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/mtd/nand/plat_nand.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/mtd/nand/plat_nand.c
> +++ b/drivers/mtd/nand/plat_nand.c
> @@ -91,7 +91,7 @@ static int __devinit plat_nand_probe(str
>  	}
> 
>  	/* Scan to find existance of the device */
> -	if (nand_scan(&data->mtd, 1)) {
> +	if (nand_scan(&data->mtd, pdata->chip.nr_chips)) {
>  		err = -ENXIO;
>  		goto out;
>  	}
