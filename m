Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab2KZVjg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 16:39:36 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46968 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563Ab2KZVje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 16:39:34 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] clk: Make the generic clock API available by default
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Ralf Baechle <ralf@linux-mips.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1350986048-15309-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1350986048-15309-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Mon, 26 Nov 2012 21:39:27 +0000
Message-Id: <20121126213927.CF37A3E08B7@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2012 10:54:08 +0100, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> Rather than requiring platforms to select the generic clock API to make
> it available make the API available as a user selectable option unless the
> user either selects HAVE_CUSTOM_CLK (if they have their own implementation)
> or selects COMMON_CLK (if they depend on the generic implementation).
> 
> All current architectures that HAVE_CLK but don't use the common clock
> framework have selects of HAVE_CUSTOM_CLK added.
> 
> This allows drivers to use the generic API on platforms which have no need
> for the clock API at platform level.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
> Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Looks reasonable to me.

Acked-by: Grant Likely <grant.likely@secretlab.ca>

g.

> ---
>  arch/arm/Kconfig           |   12 ++++++++++++
>  arch/avr32/Kconfig         |    1 +
>  arch/mips/Kconfig          |    4 ++++
>  arch/mips/loongson/Kconfig |    1 +
>  arch/mips/txx9/Kconfig     |    1 +
>  arch/powerpc/Kconfig       |    1 +
>  arch/unicore32/Kconfig     |    1 +
>  drivers/clk/Kconfig        |   13 ++++++++++---
>  8 files changed, 31 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index fe90e60..ec7baca 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -314,6 +314,7 @@ config ARCH_VERSATILE
>  	select CLKDEV_LOOKUP
>  	select GENERIC_CLOCKEVENTS
>  	select HAVE_MACH_CLKDEV
> +	select HAVE_CUSTOM_CLK
>  	select ICST
>  	select PLAT_VERSATILE
>  	select PLAT_VERSATILE_CLCD
> @@ -327,6 +328,7 @@ config ARCH_AT91
>  	select ARCH_REQUIRE_GPIOLIB
>  	select CLKDEV_LOOKUP
>  	select HAVE_CLK
> +	select HAVE_CUSTOM_CLK
>  	select IRQ_DOMAIN
>  	select NEED_MACH_GPIO_H
>  	select NEED_MACH_IO_H if PCCARD
> @@ -666,6 +668,7 @@ config ARCH_MSM
>  	select CLKDEV_LOOKUP
>  	select GENERIC_CLOCKEVENTS
>  	select HAVE_CLK
> +	select HAVE_CUSTOM_CLK
>  	help
>  	  Support for Qualcomm MSM/QSD based systems.  This runs on the
>  	  apps processor of the MSM/QSD and depends on a shared memory
> @@ -678,6 +681,7 @@ config ARCH_SHMOBILE
>  	select CLKDEV_LOOKUP
>  	select GENERIC_CLOCKEVENTS
>  	select HAVE_CLK
> +	select HAVE_CUSTOM_CLK
>  	select HAVE_MACH_CLKDEV
>  	select HAVE_SMP
>  	select MIGHT_HAVE_CACHE_L2X0
> @@ -728,10 +732,12 @@ config ARCH_SA1100
>  config ARCH_S3C24XX
>  	bool "Samsung S3C24XX SoCs"
>  	select ARCH_HAS_CPUFREQ
> +	select CLKDEV_LOOKUP
>  	select ARCH_USES_GETTIMEOFFSET
>  	select CLKDEV_LOOKUP
>  	select GENERIC_GPIO
>  	select HAVE_CLK
> +	select HAVE_CUSTOM_CLK
>  	select HAVE_S3C2410_I2C if I2C
>  	select HAVE_S3C2410_WATCHDOG if WATCHDOG
>  	select HAVE_S3C_RTC if RTC_CLASS
> @@ -752,6 +758,7 @@ config ARCH_S3C64XX
>  	select CLKDEV_LOOKUP
>  	select CPU_V6
>  	select HAVE_CLK
> +	select HAVE_CUSTOM_CLK
>  	select HAVE_S3C2410_I2C if I2C
>  	select HAVE_S3C2410_WATCHDOG if WATCHDOG
>  	select HAVE_TCM
> @@ -775,6 +782,7 @@ config ARCH_S5P64X0
>  	select GENERIC_CLOCKEVENTS
>  	select GENERIC_GPIO
>  	select HAVE_CLK
> +	select HAVE_CUSTOM_CLK
>  	select HAVE_S3C2410_I2C if I2C
>  	select HAVE_S3C2410_WATCHDOG if WATCHDOG
>  	select HAVE_S3C_RTC if RTC_CLASS
> @@ -790,6 +798,7 @@ config ARCH_S5PC100
>  	select CPU_V7
>  	select GENERIC_GPIO
>  	select HAVE_CLK
> +	select HAVE_CUSTOM_CLK
>  	select HAVE_S3C2410_I2C if I2C
>  	select HAVE_S3C2410_WATCHDOG if WATCHDOG
>  	select HAVE_S3C_RTC if RTC_CLASS
> @@ -808,6 +817,7 @@ config ARCH_S5PV210
>  	select GENERIC_CLOCKEVENTS
>  	select GENERIC_GPIO
>  	select HAVE_CLK
> +	select HAVE_CUSTOM_CLK
>  	select HAVE_S3C2410_I2C if I2C
>  	select HAVE_S3C2410_WATCHDOG if WATCHDOG
>  	select HAVE_S3C_RTC if RTC_CLASS
> @@ -826,6 +836,7 @@ config ARCH_EXYNOS
>  	select GENERIC_CLOCKEVENTS
>  	select GENERIC_GPIO
>  	select HAVE_CLK
> +	select HAVE_CUSTOM_CLK
>  	select HAVE_S3C2410_I2C if I2C
>  	select HAVE_S3C2410_WATCHDOG if WATCHDOG
>  	select HAVE_S3C_RTC if RTC_CLASS
> @@ -928,6 +939,7 @@ config ARCH_OMAP
>  	select CLKSRC_MMIO
>  	select GENERIC_CLOCKEVENTS
>  	select HAVE_CLK
> +	select HAVE_CUSTOM_CLK
>  	select NEED_MACH_GPIO_H
>  	help
>  	  Support for TI's OMAP platform (OMAP1/2/3/4).
> diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
> index 06e73bf..bfeb9cc 100644
> --- a/arch/avr32/Kconfig
> +++ b/arch/avr32/Kconfig
> @@ -4,6 +4,7 @@ config AVR32
>  	# that we usually don't need on AVR32.
>  	select EXPERT
>  	select HAVE_CLK
> +	select HAVE_CUSTOM_CLK
>  	select HAVE_OPROFILE
>  	select HAVE_KPROBES
>  	select HAVE_GENERIC_HARDIRQS
> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
> index ce6c9a6..e0be02f 100644
> --- a/arch/mips/Kconfig
> +++ b/arch/mips/Kconfig
> @@ -85,6 +85,7 @@ config AR7
>  	select ARCH_REQUIRE_GPIOLIB
>  	select VLYNQ
>  	select HAVE_CLK
> +	select HAVE_CUSTOM_CLK
>  	help
>  	  Support for the Texas Instruments AR7 System-on-a-Chip
>  	  family: TNETD7100, 7200 and 7300.
> @@ -97,6 +98,7 @@ config ATH79
>  	select CSRC_R4K
>  	select DMA_NONCOHERENT
>  	select HAVE_CLK
> +	select HAVE_CUSTOM_CLK
>  	select IRQ_CPU
>  	select MIPS_MACHINE
>  	select SYS_HAS_CPU_MIPS32_R2
> @@ -134,6 +136,7 @@ config BCM63XX
>  	select SWAP_IO_SPACE
>  	select ARCH_REQUIRE_GPIOLIB
>  	select HAVE_CLK
> +	select HAVE_CUSTOM_CLK
>  	help
>  	 Support for BCM63XX based boards
>  
> @@ -229,6 +232,7 @@ config MACH_JZ4740
>  	select SYS_HAS_EARLY_PRINTK
>  	select HAVE_PWM
>  	select HAVE_CLK
> +	select HAVE_CUSTOM_CLK
>  	select GENERIC_IRQ_CHIP
>  
>  config LANTIQ
> diff --git a/arch/mips/loongson/Kconfig b/arch/mips/loongson/Kconfig
> index 263beb9..ed42be1 100644
> --- a/arch/mips/loongson/Kconfig
> +++ b/arch/mips/loongson/Kconfig
> @@ -42,6 +42,7 @@ config LEMOTE_MACH2F
>  	select DMA_NONCOHERENT
>  	select GENERIC_ISA_DMA_SUPPORT_BROKEN
>  	select HAVE_CLK
> +	select HAVE_CUSTOM_CLK
>  	select HW_HAS_PCI
>  	select I8259
>  	select IRQ_CPU
> diff --git a/arch/mips/txx9/Kconfig b/arch/mips/txx9/Kconfig
> index 6d40bc7..04e3cdb 100644
> --- a/arch/mips/txx9/Kconfig
> +++ b/arch/mips/txx9/Kconfig
> @@ -21,6 +21,7 @@ config MACH_TXX9
>  	select SYS_SUPPORTS_LITTLE_ENDIAN
>  	select SYS_SUPPORTS_BIG_ENDIAN
>  	select HAVE_CLK
> +	select HAVE_CUSTOM_CLK
>  
>  config TOSHIBA_JMR3927
>  	bool "Toshiba JMR-TX3927 board"
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index 5af5aa7..da4ea6c 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -1028,6 +1028,7 @@ config PPC_CLOCK
>  	bool
>  	default n
>  	select HAVE_CLK
> +	select HAVE_CUSTOM_CLK
>  
>  config PPC_LIB_RHEAP
>  	bool
> diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
> index fda37c9..8247d69 100644
> --- a/arch/unicore32/Kconfig
> +++ b/arch/unicore32/Kconfig
> @@ -89,6 +89,7 @@ config ARCH_PUV3
>  	select CPU_UCV2
>  	select GENERIC_CLOCKEVENTS
>  	select HAVE_CLK
> +	select HAVE_CUSTOM_CLK
>  	select ARCH_REQUIRE_GPIOLIB
>  	select ARCH_HAS_CPUFREQ
>  
> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
> index bace9e9..8dc8391 100644
> --- a/drivers/clk/Kconfig
> +++ b/drivers/clk/Kconfig
> @@ -9,16 +9,23 @@ config HAVE_CLK_PREPARE
>  config HAVE_MACH_CLKDEV
>  	bool
>  
> -config COMMON_CLK
> +config HAVE_CUSTOM_CLK
>  	bool
> +	---help---
> +	  Architectures which provide a custom clk API should select
> +	  this to disable the common clock API.
> +
> +config COMMON_CLK
> +	bool "Common clock framework"
> +	depends on !HAVE_CUSTOM_CLK
>  	select HAVE_CLK_PREPARE
>  	select CLKDEV_LOOKUP
>  	---help---
>  	  The common clock framework is a single definition of struct
>  	  clk, useful across many platforms, as well as an
>  	  implementation of the clock API in include/linux/clk.h.
> -	  Architectures utilizing the common struct clk should select
> -	  this option.
> +	  This provides a generic way for drivers to provide and use
> +	  clocks without hard coded relationships in the drivers.
>  
>  menu "Common Clock Framework"
>  	depends on COMMON_CLK
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
