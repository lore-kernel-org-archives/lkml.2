Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146Ab0G2UZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 16:25:36 -0400
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:28706 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab0G2UZe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 16:25:34 -0400
X-Greylist: delayed 412 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Jul 2010 16:25:34 EDT
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Kulikov Vasiliy <segooon@gmail.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
CC: Chirag Kantharia <chirag.kantharia@hp.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        ISS StorageDev <iss_storagedev@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 29 Jul 2010 20:16:53 +0000
Subject: RE: [PATCH] cpqarray: check put_user() result
Thread-Topic: [PATCH] cpqarray: check put_user() result
Thread-Index: AcsvNnGdJXCKdC4nRL6G0skyEcmyUAAJHlwQ
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77887D05640118@GVW0547EXC.americas.hpqcorp.net>
References: <1280418885-5630-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1280418885-5630-1-git-send-email-segooon@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: Kulikov Vasiliy [mailto:segooon@gmail.com] 
> Sent: Thursday, July 29, 2010 10:55 AM
> To: kernel-janitors@vger.kernel.org
> Cc: Chirag Kantharia; Jens Axboe; Andrew Morton; Alexey 
> Dobriyan; Christoph Hellwig; Arnd Bergmann; ISS StorageDev; 
> linux-kernel@vger.kernel.org
> Subject: [PATCH] cpqarray: check put_user() result
> 
> put_user() may fail, if so return -EFAULT.
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> ---
>  drivers/block/cpqarray.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/block/cpqarray.c 
> b/drivers/block/cpqarray.c index 9473215..d53b029 100644
> --- a/drivers/block/cpqarray.c
> +++ b/drivers/block/cpqarray.c
> @@ -1179,7 +1179,8 @@ out_passthru:
>  		return error;
>  	case IDAGETCTLRSIG:
>  		if (!arg) return -EINVAL;
> -		put_user(host->ctlr_sig, (int __user *)arg);
> +		if (put_user(host->ctlr_sig, (int __user *)arg))
> +			return -EFAULT;
>  		return 0;
>  	case IDAREVALIDATEVOLS:
>  		if (MINOR(bdev->bd_dev) != 0)
> @@ -1187,7 +1188,8 @@ out_passthru:
>  		return revalidate_allvol(host);
>  	case IDADRIVERVERSION:
>  		if (!arg) return -EINVAL;
> -		put_user(DRIVER_VERSION, (unsigned long __user *)arg);
> +		if (put_user(DRIVER_VERSION, (unsigned long 
> __user *)arg))
> +			return -EFAULT;
>  		return 0;
>  	case IDAGETPCIINFO:
>  	{
> --
> 1.7.0.4
> 
> 
Acked-by: Mike Miller <mike.miller@hp.com>