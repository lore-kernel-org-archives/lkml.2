Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846Ab1EZUcH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 16:32:07 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:63229 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560Ab1EZUcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 16:32:05 -0400
Date: Thu, 26 May 2011 14:32:03 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Kyungmin Park <kmpark@infradead.org>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, kgene.kim@samsung.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Exynos4: Move GPIO drivers to drivers/gpio
Message-ID: <20110526203203.GF29060@ponder.secretlab.ca>
References: <20110518115536.GA31059@july>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518115536.GA31059@july>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 08:55:36PM +0900, Kyungmin Park wrote:
> From: Kyungmin Park <kyungmin.park@samsung.com>
> 
> Samsung Exynos4 gpio driver moved to drivers/gpio.
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Applied, thanks
g.

> ---
> diff --git a/arch/arm/mach-exynos4/gpiolib.c b/drivers/gpio/exynos4-gpio.c
> similarity index 100%
> rename from arch/arm/mach-exynos4/gpiolib.c
> rename to drivers/gpio/exynos4-gpio.c
> diff --git a/arch/arm/mach-exynos4/Makefile b/arch/arm/mach-exynos4/Makefile
> index 9be104f..3bb3f57 100644
> --- a/arch/arm/mach-exynos4/Makefile
> +++ b/arch/arm/mach-exynos4/Makefile
> @@ -13,7 +13,7 @@ obj-				:=
>  # Core support for EXYNOS4 system
>  
>  obj-$(CONFIG_CPU_EXYNOS4210)	+= cpu.o init.o clock.o irq-combiner.o
> -obj-$(CONFIG_CPU_EXYNOS4210)	+= setup-i2c0.o gpiolib.o irq-eint.o dma.o
> +obj-$(CONFIG_CPU_EXYNOS4210)	+= setup-i2c0.o irq-eint.o dma.o
>  obj-$(CONFIG_PM)		+= pm.o sleep.o
>  obj-$(CONFIG_CPU_FREQ)		+= cpufreq.o
>  
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index d3b2953..7938449 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -75,6 +75,12 @@ config GPIO_BASIC_MMIO
>  	help
>  	  Say yes here to support basic memory-mapped GPIO controllers.
>  
> +config GPIO_EXYNOS4
> +	bool "Samsung Exynos4 GPIO support"
> +	depends on CPU_EXYNOS4210
> +	help
> +	  Say yes here to support Samsung Exynos4 GPIO controllers.
> +
>  config GPIO_IT8761E
>  	tristate "IT8761E GPIO support"
>  	depends on GPIOLIB
> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> index becef59..f2373d0 100644
> --- a/drivers/gpio/Makefile
> +++ b/drivers/gpio/Makefile
> @@ -11,6 +11,7 @@ obj-$(CONFIG_GPIOLIB)		+= gpiolib.o
>  obj-$(CONFIG_GPIO_ADP5520)	+= adp5520-gpio.o
>  obj-$(CONFIG_GPIO_ADP5588)	+= adp5588-gpio.o
>  obj-$(CONFIG_GPIO_BASIC_MMIO)	+= basic_mmio_gpio.o
> +obj-$(CONFIG_GPIO_EXYNOS4)	+= exynos4-gpio.o
>  obj-$(CONFIG_GPIO_LANGWELL)	+= langwell_gpio.o
>  obj-$(CONFIG_GPIO_MAX730X)	+= max730x.o
>  obj-$(CONFIG_GPIO_MAX7300)	+= max7300.o
