Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab0EPWN4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 18:13:56 -0400
Received: from mga06.intel.com ([134.134.136.21]:11725 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751962Ab0EPWNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 18:13:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,242,1272870000"; 
   d="scan'208";a="622111006"
Date: Mon, 17 May 2010 00:14:29 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] MFD: rdc321x: change resources flags to
 IORESOURCE_IO
Message-ID: <20100516221428.GC3236@sortiz.org>
References: <201005152258.28538.florian@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005152258.28538.florian@openwrt.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian,

On Sat, May 15, 2010 at 10:58:27PM +0200, Florian Fainelli wrote:
> The rdc321x southbridge PCI device has no MEM PCI resources that we could
> pass to mfd_add_devices. Since 33254dd5, mfd_add_device checks for the
> mem_base argument that we set to NULL. Changing the resources passed to
> our MFD cells from IORESOURCE_MEM to IORESOURCE_IO fixes that. Since we use
> those resources as offsets to the PCI configuration space base address of
> the southbridge device this is also more adequate.
Patch applied, many thanks.

Cheers,
Samuel.


> Signed-off-by: Florian Fainelli <florian@openwrt.org>
> ---
> diff --git a/drivers/gpio/rdc321x-gpio.c b/drivers/gpio/rdc321x-gpio.c
> index e344907..22f31dc 100644
> --- a/drivers/gpio/rdc321x-gpio.c
> +++ b/drivers/gpio/rdc321x-gpio.c
> @@ -147,7 +147,7 @@ static int __devinit rdc321x_gpio_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  	}
>  
> -	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "gpio-reg1");
> +	r = platform_get_resource_byname(pdev, IORESOURCE_IO, "gpio-reg1");
>  	if (!r) {
>  		dev_err(&pdev->dev, "failed to get gpio-reg1 resource\n");
>  		err = -ENODEV;
> @@ -159,7 +159,7 @@ static int __devinit rdc321x_gpio_probe(struct platform_device *pdev)
>  	rdc321x_gpio_dev->reg1_ctrl_base = r->start;
>  	rdc321x_gpio_dev->reg1_data_base = r->start + 0x4;
>  
> -	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "gpio-reg2");
> +	r = platform_get_resource_byname(pdev, IORESOURCE_IO, "gpio-reg2");
>  	if (!r) {
>  		dev_err(&pdev->dev, "failed to get gpio-reg2 resource\n");
>  		err = -ENODEV;
> diff --git a/drivers/mfd/rdc321x-southbridge.c b/drivers/mfd/rdc321x-southbridge.c
> index 256dd56..5092297 100644
> --- a/drivers/mfd/rdc321x-southbridge.c
> +++ b/drivers/mfd/rdc321x-southbridge.c
> @@ -34,7 +34,7 @@ static struct resource rdc321x_wdt_resource[] = {
>  		.name	= "wdt-reg",
>  		.start	= RDC321X_WDT_CTRL,
>  		.end	= RDC321X_WDT_CTRL + 0x3,
> -		.flags	= IORESOURCE_MEM,
> +		.flags	= IORESOURCE_IO,
>  	}
>  };
>  
> @@ -47,12 +47,12 @@ static struct resource rdc321x_gpio_resources[] = {
>  		.name	= "gpio-reg1",
>  		.start	= RDC321X_GPIO_CTRL_REG1,
>  		.end	= RDC321X_GPIO_CTRL_REG1 + 0x7,
> -		.flags	= IORESOURCE_MEM,
> +		.flags	= IORESOURCE_IO,
>  	}, {
>  		.name	= "gpio-reg2",
>  		.start	= RDC321X_GPIO_CTRL_REG2,
>  		.end	= RDC321X_GPIO_CTRL_REG2 + 0x7,
> -		.flags	= IORESOURCE_MEM,
> +		.flags	= IORESOURCE_IO,
>  	}
>  };
>  
> diff --git a/drivers/watchdog/rdc321x_wdt.c b/drivers/watchdog/rdc321x_wdt.c
> index 4733a99..428f8a1 100644
> --- a/drivers/watchdog/rdc321x_wdt.c
> +++ b/drivers/watchdog/rdc321x_wdt.c
> @@ -237,7 +237,7 @@ static int __devinit rdc321x_wdt_probe(struct platform_device *pdev)
>  		return -ENODEV;
>  	}
>  
> -	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "wdt-reg");
> +	r = platform_get_resource_byname(pdev, IORESOURCE_IO, "wdt-reg");
>  	if (!r) {
>  		dev_err(&pdev->dev, "failed to get wdt-reg resource\n");
>  		return -ENODEV;

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
