Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425Ab2DGBv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 21:51:58 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34724 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261Ab2DGBvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 21:51:51 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio: use module_pci_driver
To: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org
Cc: "Hans J. Koch" <hjk@linutronix.de>,
        "Tomoya MORINAGA tomoya.rohm"@gmail.com, Michael Buesch <m@bues.ch>,
        Linus Walleij <linus.walleij@stericsson.com>
In-Reply-To: <1333714410.17459.2.camel@phoenix>
References: <1333714410.17459.2.camel@phoenix>
Date: Fri, 06 Apr 2012 15:45:45 -0700
Message-Id: <20120406224545.989443E0DD8@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Apr 2012 20:13:30 +0800, Axel Lin <axel.lin@gmail.com> wrote:
> This patch converts the drivers in drivers/gpio/* to use module_pci_driver()
> macro which makes the code smaller and a bit simpler.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Cc: Michael Buesch <m@bues.ch>
> Cc: Hans J. Koch <hjk@linutronix.de>
> Cc: Tomoya MORINAGA tomoya.rohm@gmail.com

Applied, thanks

g.

> ---
>  drivers/gpio/gpio-bt8xx.c     |   12 +-----------
>  drivers/gpio/gpio-ml-ioh.c    |   12 +-----------
>  drivers/gpio/gpio-pch.c       |   12 +-----------
>  drivers/gpio/gpio-sodaville.c |   12 +-----------
>  4 files changed, 4 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-bt8xx.c b/drivers/gpio/gpio-bt8xx.c
> index 5ca4098..e4cc7eb 100644
> --- a/drivers/gpio/gpio-bt8xx.c
> +++ b/drivers/gpio/gpio-bt8xx.c
> @@ -328,17 +328,7 @@ static struct pci_driver bt8xxgpio_pci_driver = {
>  	.resume		= bt8xxgpio_resume,
>  };
>  
> -static int __init bt8xxgpio_init(void)
> -{
> -	return pci_register_driver(&bt8xxgpio_pci_driver);
> -}
> -module_init(bt8xxgpio_init)
> -
> -static void __exit bt8xxgpio_exit(void)
> -{
> -	pci_unregister_driver(&bt8xxgpio_pci_driver);
> -}
> -module_exit(bt8xxgpio_exit)
> +module_pci_driver(bt8xxgpio_pci_driver);
>  
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Michael Buesch");
> diff --git a/drivers/gpio/gpio-ml-ioh.c b/drivers/gpio/gpio-ml-ioh.c
> index f0febe5..db01f15 100644
> --- a/drivers/gpio/gpio-ml-ioh.c
> +++ b/drivers/gpio/gpio-ml-ioh.c
> @@ -611,17 +611,7 @@ static struct pci_driver ioh_gpio_driver = {
>  	.resume = ioh_gpio_resume
>  };
>  
> -static int __init ioh_gpio_pci_init(void)
> -{
> -	return pci_register_driver(&ioh_gpio_driver);
> -}
> -module_init(ioh_gpio_pci_init);
> -
> -static void __exit ioh_gpio_pci_exit(void)
> -{
> -	pci_unregister_driver(&ioh_gpio_driver);
> -}
> -module_exit(ioh_gpio_pci_exit);
> +module_pci_driver(ioh_gpio_driver);
>  
>  MODULE_DESCRIPTION("OKI SEMICONDUCTOR ML-IOH series GPIO Driver");
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/gpio/gpio-pch.c b/drivers/gpio/gpio-pch.c
> index e8729cc..a05fdb6 100644
> --- a/drivers/gpio/gpio-pch.c
> +++ b/drivers/gpio/gpio-pch.c
> @@ -539,17 +539,7 @@ static struct pci_driver pch_gpio_driver = {
>  	.resume = pch_gpio_resume
>  };
>  
> -static int __init pch_gpio_pci_init(void)
> -{
> -	return pci_register_driver(&pch_gpio_driver);
> -}
> -module_init(pch_gpio_pci_init);
> -
> -static void __exit pch_gpio_pci_exit(void)
> -{
> -	pci_unregister_driver(&pch_gpio_driver);
> -}
> -module_exit(pch_gpio_pci_exit);
> +module_pci_driver(pch_gpio_driver);
>  
>  MODULE_DESCRIPTION("PCH GPIO PCI Driver");
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/gpio/gpio-sodaville.c b/drivers/gpio/gpio-sodaville.c
> index 031e5d2..820209c 100644
> --- a/drivers/gpio/gpio-sodaville.c
> +++ b/drivers/gpio/gpio-sodaville.c
> @@ -282,17 +282,7 @@ static struct pci_driver sdv_gpio_driver = {
>  	.remove = sdv_gpio_remove,
>  };
>  
> -static int __init sdv_gpio_init(void)
> -{
> -	return pci_register_driver(&sdv_gpio_driver);
> -}
> -module_init(sdv_gpio_init);
> -
> -static void __exit sdv_gpio_exit(void)
> -{
> -	pci_unregister_driver(&sdv_gpio_driver);
> -}
> -module_exit(sdv_gpio_exit);
> +module_pci_driver(sdv_gpio_driver);
>  
>  MODULE_AUTHOR("Hans J. Koch <hjk@linutronix.de>");
>  MODULE_DESCRIPTION("GPIO interface for Intel Sodaville SoCs");
> -- 
> 1.7.5.4
> 
> 
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies,Ltd.
