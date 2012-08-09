Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab2HIFcE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 01:32:04 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:57953 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab2HIFcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 01:32:01 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-93-50234b4f69e3
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org,
        "'Tushar Behera'" <tushar.behera@linaro.org>
References: <1344430493-5304-1-git-send-email-arnd@arndb.de>
 <1344430493-5304-5-git-send-email-arnd@arndb.de>
 <0b6801cd7567$29be48b0$7d3ada10$%kim@samsung.com>
 <201208081434.56198.arnd@arndb.de>
In-reply-to: <201208081434.56198.arnd@arndb.de>
Subject: RE: [PATCH 4/6] ARM: s3c24xx: use new PWM driver
Date: Thu, 09 Aug 2012 14:31:59 +0900
Message-id: <0c3901cd75f0$4c26bb60$e4743220$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac11cv8Woj1IT25ySaCBazT1BxUV/AAer0Eg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jAV1/b+UAg8tvFS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAldGd5dJQYt+xaqLL5gbGJ+odjFyckgImEic/L+RDcIWk7hwbz2Q
	zcUhJLCIUWLFyj4WCGcek8Tkg32MIFVsAhoSh98/YwexRQSUJY6/vANWxCzQwijRef4dVPsJ
	Rolra86AzeUU0JfYc20XaxcjB4ewgKXEnQYhkDCLgKrElnnnwUp4BWwluk5PZ4SwBSV+TL7H
	AmIzC2hJrN95nAnClpfYvOYtM8gYCQF1iUd/dSFuMJLYuns5I0SJiMS+F+8YJzAKzUIyaRaS
	SbOQTJqFpGUBI8sqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOBAfia1g3Flg8UhRgEORiUe
	Xo0NSgFCrIllxZW5hxglOJiVRHh3KSkHCPGmJFZWpRblxxeV5qQWH2KU5mBREuc19v7qLySQ
	nliSmp2aWpBaBJNl4uCUamB0FL3RtSgxwOHZpq1vXzmrzGfZdTiYwWJ2ZS7Xhf2/u8Nqwnfl
	BWjI6O/RT/g/p7xl2lGRRlbxd/xnZh1eXtVUxGz4YsHP1sfVR93CHh5Ytqzave/2L8Va3wmc
	OsfdBa49lXoccej6z7PCnM//tb2tyt11oe/7AW3Jula1U8Jp4bt1LptnrY9TYinOSDTUYi4q
	TgQA7/w6rmACAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> 
> On Wednesday 08 August 2012, Kukjin Kim wrote:
> 
> > diff --git a/arch/arm/mach-s3c24xx/Kconfig b/arch/arm/mach-
> s3c24xx/Kconfig
> > index e249611..d56b0f7 100644
> > --- a/arch/arm/mach-s3c24xx/Kconfig
> > +++ b/arch/arm/mach-s3c24xx/Kconfig
> > @@ -483,7 +483,7 @@ config MACH_NEO1973_GTA02
> >  	select I2C
> >  	select POWER_SUPPLY
> >  	select MACH_NEO1973
> > -	select S3C2410_PWM
> > +	select S3C24XX_PWM
> >  	select S3C_DEV_USB_HOST
> >  	help
> >  	   Say Y here if you are using the Openmoko GTA02 / Freerunner GSM
> > Phone
> > @@ -493,7 +493,7 @@ config MACH_RX1950
> >  	select S3C24XX_DCLK
> >  	select PM_H1940 if PM
> >  	select I2C
> > -	select S3C2410_PWM
> > +	select S3C24XX_PWM
> >  	select S3C_DEV_NAND
> >  	select S3C2410_IOTIMING if S3C2440_CPUFREQ
> >  	select S3C2440_XTAL_16934400
> > diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-
> samsung/Kconfig
> > index 7aca31c..dcdfb77 100644
> > --- a/arch/arm/plat-samsung/Kconfig
> > +++ b/arch/arm/plat-samsung/Kconfig
> > @@ -403,7 +403,7 @@ config S5P_DEV_USB_EHCI
> >
> >  config S3C24XX_PWM
> >  	bool "PWM device support"
> > -	select HAVE_PWM
> > +	select PWM
> >  	help
> >  	  Support for exporting the PWM timer blocks via the pwm device
> >  	  system
> > diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> > index 8fc3808..c74d055 100644
> > --- a/drivers/pwm/Kconfig
> > +++ b/drivers/pwm/Kconfig
> > @@ -58,14 +58,12 @@ config PWM_PXA
> >  	  will be called pwm-pxa.
> >
> >  config PWM_SAMSUNG
> > -	tristate "Samsung pwm support"
> > +	bool "Samsung PWM support"
> >  	depends on PLAT_SAMSUNG
> > +	default y
> >  	help
> >  	  Generic PWM framework driver for Samsung.
> >
> > -	  To compile this driver as a module, choose M here: the module
> > -	  will be called pwm-samsung.
> > -
> >  config PWM_TEGRA
> >  	tristate "NVIDIA Tegra PWM support"
> >  	depends on ARCH_TEGRA
> 
> This approach has two disadvantages compared to mine:
> 
> * When building for the samsung platforms other than rx1950 or gta02,
>   you can no longer have the PWM driver as a loadable module, for no
>   good reason.
> 
OK I see, I'm still thinking the PWM driver can be selected in kernel
menuconfig though.

My concept is when PWM is selected on Samsung platforms by defconfig or
manually enabling, PWM_SAMSUNG is selected automatically. In addition,
current Samsung PWM driver cannot support module now because pwm_init() is
called by arch_initcall().

I think, we can remove S3C24XX_PWM and just select PWM (or using HAVE_PWM)
and PWM_SAMSUNG can be selected by enabling PWM in samsung platform next
time :-)

> * It is still possible to manually disable PWM_SAMSUNG, even on
>   rx1950 and gta02, because the Kconfig symbol is visible.
> 
Yeah you're right, makes sense.

> I've added a "Reported-by: Tushar Behera <tushar.behera@linaro.org>"
> line to my version of the patch, but I would prefer to keep that
> approach. I have also changed the patch to use the S3C24XX_PWM
> symbol because that lets everyone migrate the defconfig files.
> 
OK.

> Do you want to give this patch some more testing, or should I keep
> it in arm-soc?
> 
Looks good to me, please keep going on.

> ---
> From 438b0cf94adb2528bdeeb71314f7be16512ea5b1 Mon Sep 17 00:00:00 2001
> From: Arnd Bergmann <arnd@arndb.de>
> Date: Sat, 4 Aug 2012 07:52:19 +0000
> Subject: [PATCH] ARM: s3c24xx: use new PWM driver
> 
> The samsung PWM driver has moved to the new PWM subsystem, which
> changed the Kconfig symbol for that driver, but the rx1950 and
> gta02 boards still uses the old one.
> 
> Without this patch, building s3c2410_defconfig results in:
> 
> arch/arm/mach-s3c24xx/built-in.o: In function `rx1950_lcd_power':
> arch/arm/mach-s3c24xx/mach-rx1950.c:430: undefined reference to
> `pwm_config'
> arch/arm/mach-s3c24xx/mach-rx1950.c:431: undefined reference to
> `pwm_disable'
> arch/arm/mach-s3c24xx/mach-rx1950.c:437: undefined reference to
> `pwm_config'
> arch/arm/mach-s3c24xx/mach-rx1950.c:438: undefined reference to
> `pwm_enable'
> arch/arm/mach-s3c24xx/built-in.o: In function `rx1950_backlight_exit':
> arch/arm/mach-s3c24xx/mach-rx1950.c:504: undefined reference to `pwm_free'
> arch/arm/mach-s3c24xx/built-in.o: In function `rx1950_backlight_init':
> arch/arm/mach-s3c24xx/mach-rx1950.c:487: undefined reference to
> `pwm_request'
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Reported-by: Tushar Behera <tushar.behera@linaro.org>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> 
Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

> diff --git a/arch/arm/mach-s3c24xx/Kconfig b/arch/arm/mach-s3c24xx/Kconfig
> index e249611..d56b0f7 100644
> --- a/arch/arm/mach-s3c24xx/Kconfig
> +++ b/arch/arm/mach-s3c24xx/Kconfig
> @@ -483,7 +483,7 @@ config MACH_NEO1973_GTA02
>  	select I2C
>  	select POWER_SUPPLY
>  	select MACH_NEO1973
> -	select S3C2410_PWM
> +	select S3C24XX_PWM
>  	select S3C_DEV_USB_HOST
>  	help
>  	   Say Y here if you are using the Openmoko GTA02 / Freerunner GSM
> Phone
> @@ -493,7 +493,7 @@ config MACH_RX1950
>  	select S3C24XX_DCLK
>  	select PM_H1940 if PM
>  	select I2C
> -	select S3C2410_PWM
> +	select S3C24XX_PWM
>  	select S3C_DEV_NAND
>  	select S3C2410_IOTIMING if S3C2440_CPUFREQ
>  	select S3C2440_XTAL_16934400
> diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
> index 7aca31c..9c3b90c 100644
> --- a/arch/arm/plat-samsung/Kconfig
> +++ b/arch/arm/plat-samsung/Kconfig
> @@ -403,7 +403,8 @@ config S5P_DEV_USB_EHCI
> 
>  config S3C24XX_PWM
>  	bool "PWM device support"
> -	select HAVE_PWM
> +	select PWM
> +	select PWM_SAMSUNG
>  	help
>  	  Support for exporting the PWM timer blocks via the pwm device
>  	  system

