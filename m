Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab2KDGSA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 01:18:00 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:43726 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab2KDGR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 01:17:58 -0500
MIME-Version: 1.0
In-Reply-To: <20121029213806.646766364@linuxfoundation.org>
References: <20121029213802.697479610@linuxfoundation.org>
	<20121029213806.646766364@linuxfoundation.org>
Date: Sat, 3 Nov 2012 23:17:57 -0700
Message-ID: <CAMbhsRTUWyNc5djoadOgWz_e=rPmqHw+xQUrccTN70J0E3hKiw@mail.gmail.com>
Subject: Re: [ 35/54] ARM: SAMSUNG: Add naming of s3c64xx-spi devices
From: Colin Cross <ccross@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Heiko Stuebner <heiko@sntech.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 2:40 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> 3.4-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Heiko Stuebner <heiko@sntech.de>
>
> commit 308b3afb97dc342e9c4f958d8b4c459ae0e22bd7 upstream.
>
> Commit a5238e360b71 (spi: s3c64xx: move controller information into driver
> data) introduced separate device names for the different subtypes of the
> spi controller but forgot to set these in the relevant machines.
>
> To fix this introduce a s3c64xx_spi_setname function and populate all
> Samsung arches with the correct names. The function resides in a new
> header, as the s3c64xx-spi.h contains driver platform data and should
> therefore at some later point move out of the Samsung include dir.
>
> Tested on a s3c2416-based machine.
>
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> [s.nawrocki@samsung.com: tested on mach-exynos]
> Tested-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
>  arch/arm/mach-exynos/common.c                 |    5 ++++
>  arch/arm/mach-s3c24xx/s3c2416.c               |    2 +
>  arch/arm/mach-s3c24xx/s3c2443.c               |    4 +++
>  arch/arm/mach-s5p64x0/common.c                |    3 ++
>  arch/arm/mach-s5pc100/common.c                |    3 ++
>  arch/arm/mach-s5pv210/common.c                |    3 ++
>  arch/arm/plat-samsung/include/plat/spi-core.h |   30 ++++++++++++++++++++++++++
>  7 files changed, 50 insertions(+)
>
> --- a/arch/arm/mach-exynos/common.c
> +++ b/arch/arm/mach-exynos/common.c
> @@ -44,6 +44,7 @@
>  #include <plat/fimc-core.h>
>  #include <plat/iic-core.h>
>  #include <plat/tv-core.h>
> +#include <plat/spi-core.h>
>  #include <plat/regs-serial.h>
>
>  #include "common.h"
> @@ -338,6 +339,8 @@ static void __init exynos4_map_io(void)
>
>         s5p_fb_setname(0, "exynos4-fb");
>         s5p_hdmi_setname("exynos4-hdmi");
> +
> +       s3c64xx_spi_setname("exynos4210-spi");
>  }
>
>  static void __init exynos5_map_io(void)
> @@ -358,6 +361,8 @@ static void __init exynos5_map_io(void)
>         s3c_i2c0_setname("s3c2440-i2c");
>         s3c_i2c1_setname("s3c2440-i2c");
>         s3c_i2c2_setname("s3c2440-i2c");
> +
> +       s3c64xx_spi_setname("exynos4210-spi");
>  }
>
>  static void __init exynos4_init_clocks(int xtal)
> --- a/arch/arm/mach-s3c24xx/s3c2416.c
> +++ b/arch/arm/mach-s3c24xx/s3c2416.c
> @@ -61,6 +61,7 @@
>  #include <plat/nand-core.h>
>  #include <plat/adc-core.h>
>  #include <plat/rtc-core.h>
> +#include <plat/spi-core.h>
>
>  static struct map_desc s3c2416_iodesc[] __initdata = {
>         IODESC_ENT(WATCHDOG),
> @@ -131,6 +132,7 @@ void __init s3c2416_map_io(void)
>         /* initialize device information early */
>         s3c2416_default_sdhci0();
>         s3c2416_default_sdhci1();
> +       s3c64xx_spi_setname("s3c2443-spi");
>
>         iotable_init(s3c2416_iodesc, ARRAY_SIZE(s3c2416_iodesc));
>  }
> --- a/arch/arm/mach-s3c24xx/s3c2443.c
> +++ b/arch/arm/mach-s3c24xx/s3c2443.c
> @@ -43,6 +43,7 @@
>  #include <plat/nand-core.h>
>  #include <plat/adc-core.h>
>  #include <plat/rtc-core.h>
> +#include <plat/spi-core.h>
>
>  static struct map_desc s3c2443_iodesc[] __initdata = {
>         IODESC_ENT(WATCHDOG),
> @@ -100,6 +101,9 @@ void __init s3c2443_map_io(void)
>         s3c24xx_gpiocfg_default.set_pull = s3c2443_gpio_setpull;
>         s3c24xx_gpiocfg_default.get_pull = s3c2443_gpio_getpull;
>
> +       /* initialize device information early */
> +       s3c64xx_spi_setname("s3c2443-spi");
> +
>         iotable_init(s3c2443_iodesc, ARRAY_SIZE(s3c2443_iodesc));
>  }
>
> --- a/arch/arm/mach-s5p64x0/common.c
> +++ b/arch/arm/mach-s5p64x0/common.c
> @@ -44,6 +44,7 @@
>  #include <plat/sdhci.h>
>  #include <plat/adc-core.h>
>  #include <plat/fb-core.h>
> +#include <plat/spi-core.h>
>  #include <plat/gpio-cfg.h>
>  #include <plat/regs-irqtype.h>
>  #include <plat/regs-serial.h>
> @@ -179,6 +180,7 @@ void __init s5p6440_map_io(void)
>         /* initialize any device information early */
>         s3c_adc_setname("s3c64xx-adc");
>         s3c_fb_setname("s5p64x0-fb");
> +       s3c64xx_spi_setname("s5p64x0-spi");
>
>         s5p64x0_default_sdhci0();
>         s5p64x0_default_sdhci1();
> @@ -193,6 +195,7 @@ void __init s5p6450_map_io(void)
>         /* initialize any device information early */
>         s3c_adc_setname("s3c64xx-adc");
>         s3c_fb_setname("s5p64x0-fb");
> +       s3c64xx_spi_setname("s5p64x0-spi");
>
>         s5p64x0_default_sdhci0();
>         s5p64x0_default_sdhci1();
> --- a/arch/arm/mach-s5pc100/common.c
> +++ b/arch/arm/mach-s5pc100/common.c
> @@ -45,6 +45,7 @@
>  #include <plat/fb-core.h>
>  #include <plat/iic-core.h>
>  #include <plat/onenand-core.h>
> +#include <plat/spi-core.h>
>  #include <plat/regs-serial.h>
>  #include <plat/watchdog-reset.h>
>
> @@ -165,6 +166,8 @@ void __init s5pc100_map_io(void)
>         s3c_onenand_setname("s5pc100-onenand");
>         s3c_fb_setname("s5pc100-fb");
>         s3c_cfcon_setname("s5pc100-pata");
> +
> +       s3c64xx_spi_setname("s5pc100-spi");
>  }
>
>  void __init s5pc100_init_clocks(int xtal)
> --- a/arch/arm/mach-s5pv210/common.c
> +++ b/arch/arm/mach-s5pv210/common.c
> @@ -43,6 +43,7 @@
>  #include <plat/iic-core.h>
>  #include <plat/keypad-core.h>
>  #include <plat/tv-core.h>
> +#include <plat/spi-core.h>
>  #include <plat/regs-serial.h>
>
>  #include "common.h"
> @@ -196,6 +197,8 @@ void __init s5pv210_map_io(void)
>
>         /* setup TV devices */
>         s5p_hdmi_setname("s5pv210-hdmi");
> +
> +       s3c64xx_spi_setname("s5pv210-spi");
>  }
>
>  void __init s5pv210_init_clocks(int xtal)
> --- /dev/null
> +++ b/arch/arm/plat-samsung/include/plat/spi-core.h
> @@ -0,0 +1,30 @@
> +/*
> + * Copyright (C) 2012 Heiko Stuebner <heiko@sntech.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef __PLAT_S3C_SPI_CORE_H
> +#define __PLAT_S3C_SPI_CORE_H
> +
> +/* These functions are only for use with the core support code, such as
> + * the cpu specific initialisation code
> + */
> +
> +/* re-define device name depending on support. */
> +static inline void s3c64xx_spi_setname(char *name)
> +{
> +#ifdef CONFIG_S3C64XX_DEV_SPI0
> +       s3c64xx_device_spi0.name = name;
> +#endif
> +#ifdef CONFIG_S3C64XX_DEV_SPI1
> +       s3c64xx_device_spi1.name = name;
> +#endif
> +#ifdef CONFIG_S3C64XX_DEV_SPI2
> +       s3c64xx_device_spi2.name = name;
> +#endif
> +}
> +
> +#endif /* __PLAT_S3C_SPI_CORE_H */
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

This patch breaks Exynos5 spi on 3.4.17.  The patch with the bug that
this patch was supposed to address went in to 3.6 and not 3.4, so this
patch causes a driver name mismatch when applied to 3.4.
