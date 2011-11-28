Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab1K1Uad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 15:30:33 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:45712 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065Ab1K1Uac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 15:30:32 -0500
Date: Mon, 28 Nov 2011 21:30:06 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>,
        Magnus Damm <damm@igel.co.jp>,
        Amit Chatterjee <amit.chatterjee@ti.com>,
        Pratheesh Gangadhar <pratheesh@ti.com>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] uio: convert drivers/uio/* to use
 module_platform_driver()
Message-ID: <20111128203006.GD2165@local>
References: <1322291935.20464.5.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1322291935.20464.5.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 26, 2011 at 03:18:55PM +0800, Axel Lin wrote:
> This patch converts the drivers in drivers/uio/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
> 
> Cc: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
> Cc: Magnus Damm <damm@igel.co.jp>
> Cc: Amit Chatterjee <amit.chatterjee@ti.com>
> Cc: Pratheesh Gangadhar <pratheesh@ti.com>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Looks alright to me.

Signed-off-by: Hans J. Koch <hjk@hansjkoch.de>

Thanks,
Hans

> ---
>  drivers/uio/uio_pdrv.c        |   12 +-----------
>  drivers/uio/uio_pdrv_genirq.c |   13 +------------
>  drivers/uio/uio_pruss.c       |   14 +-------------
>  3 files changed, 3 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/uio/uio_pdrv.c b/drivers/uio/uio_pdrv.c
> index ff50595..72d3646 100644
> --- a/drivers/uio/uio_pdrv.c
> +++ b/drivers/uio/uio_pdrv.c
> @@ -104,17 +104,7 @@ static struct platform_driver uio_pdrv = {
>  	},
>  };
>  
> -static int __init uio_pdrv_init(void)
> -{
> -	return platform_driver_register(&uio_pdrv);
> -}
> -
> -static void __exit uio_pdrv_exit(void)
> -{
> -	platform_driver_unregister(&uio_pdrv);
> -}
> -module_init(uio_pdrv_init);
> -module_exit(uio_pdrv_exit);
> +module_platform_driver(uio_pdrv);
>  
>  MODULE_AUTHOR("Uwe Kleine-Koenig");
>  MODULE_DESCRIPTION("Userspace I/O platform driver");
> diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
> index 25de302..b98371d 100644
> --- a/drivers/uio/uio_pdrv_genirq.c
> +++ b/drivers/uio/uio_pdrv_genirq.c
> @@ -273,18 +273,7 @@ static struct platform_driver uio_pdrv_genirq = {
>  	},
>  };
>  
> -static int __init uio_pdrv_genirq_init(void)
> -{
> -	return platform_driver_register(&uio_pdrv_genirq);
> -}
> -
> -static void __exit uio_pdrv_genirq_exit(void)
> -{
> -	platform_driver_unregister(&uio_pdrv_genirq);
> -}
> -
> -module_init(uio_pdrv_genirq_init);
> -module_exit(uio_pdrv_genirq_exit);
> +module_platform_driver(uio_pdrv_genirq);
>  
>  MODULE_AUTHOR("Magnus Damm");
>  MODULE_DESCRIPTION("Userspace I/O platform driver with generic IRQ handling");
> diff --git a/drivers/uio/uio_pruss.c b/drivers/uio/uio_pruss.c
> index e67b566..33a7a27 100644
> --- a/drivers/uio/uio_pruss.c
> +++ b/drivers/uio/uio_pruss.c
> @@ -227,19 +227,7 @@ static struct platform_driver pruss_driver = {
>  		   },
>  };
>  
> -static int __init pruss_init_module(void)
> -{
> -	return platform_driver_register(&pruss_driver);
> -}
> -
> -module_init(pruss_init_module);
> -
> -static void __exit pruss_exit_module(void)
> -{
> -	platform_driver_unregister(&pruss_driver);
> -}
> -
> -module_exit(pruss_exit_module);
> +module_platform_driver(pruss_driver);
>  
>  MODULE_LICENSE("GPL v2");
>  MODULE_VERSION(DRV_VERSION);
> -- 
> 1.7.5.4
> 
> 
> 
> 
