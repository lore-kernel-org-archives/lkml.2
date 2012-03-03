Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab2CCBqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 20:46:46 -0500
Received: from nm20.bullet.mail.ird.yahoo.com ([77.238.189.77]:30612 "HELO
	nm20.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752020Ab2CCBqp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 20:46:45 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 656820.73720.bm@omp1036.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=4wtVuraGIWW40fJD60d94xb7GbH3DnDqMTopTruNT2TIx17ZmOYC8nlj+ijbrVGKN5WhdiV8WjjD0O6cp07mwfUjSlPKcgswGVSMXQkCb/27AyjnTsV3MdhkuBMeGIuOzMWe3oj9wycu86I2qOa5iawNbXea4r/XltzXMW8MCRw=;
X-YMail-OSG: MRKtk5MVM1k_Vh3jXiITbtOJUz2CzWOSQZ_6CXLkIEzQuq9
 AhNeKGHEd51.ekBy5FW.b5CxoCSYvj0lcquJP6rnCtsy0OhhlGwP6l4oBEh9
 4V.zwhn9rsmV1ySz_xUkt.J.hjFcrev4NltBIsix1et7LYJHhNGfSc7GiSuh
 VSu5DjYCo1CKbm_c6DJGuHKR8D.NMxysVRM1_fvuGYI.j6ryxnmiaoPlSSLr
 Ct26sH3x1eaflMmygpaYqDjFfe58kKBWaz12N63D8M9Ri2F2TCmithZK_zNz
 op7HPzadzRZJdbNoKR9w8Z1tZxeW4WBQaR_Kjr2DboGICi2GC7wDDt1haqKF
 L1V6QweJr5qoaeszuaYhLYG.QubucRcPazDzmilVIj68bkmpLybpQh_2CtJS
 1fXWXtNWp.FH_kCMtZ6Bbn6lKTTGadW8qAaesbFsKGJStpVSpeEg5T.UQ8Va
 mPFtrgQ--
X-Mailer: YahooMailClassic/15.0.5 YahooMailWebService/0.8.116.338427
Message-ID: <1330739203.95123.YahooMailClassic@web29010.mail.ird.yahoo.com>
Date: Sat, 3 Mar 2012 01:46:43 +0000 (GMT)
From: Paul Parsons <lost.distance@yahoo.com>
Subject: Re: [PATCH 1/2] pxa: magician/hx4700: Convert to gpio-regulator from bq24022
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Philipp Zabel <philipp.zabel@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        =?iso-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: linux-arm-kernel@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <201203021356.38857.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Heiko.

The hx4700 patch works for me on linux-3.3-rc5.
I'm not able to test the magician patch.

Tested-by: Paul Parsons <lost.distance@yahoo.com>

--- On Fri, 2/3/12, Heiko Stübner <heiko@sntech.de> wrote:

> From: Heiko Stübner <heiko@sntech.de>
> Subject: [PATCH 1/2] pxa: magician/hx4700: Convert to gpio-regulator from bq24022
> To: "Mark Brown" <broonie@opensource.wolfsonmicro.com>, "Liam Girdwood" <lrg@ti.com>, "Philipp Zabel" <philipp.zabel@gmail.com>, "Eric Miao" <eric.y.miao@gmail.com>, "Haojian Zhuang" <haojian.zhuang@marvell.com>, "Russell King - ARM Linux" <linux@arm.linux.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org, "LKML" <linux-kernel@vger.kernel.org>
> Date: Friday, 2 March, 2012, 12:56
> The bq24022 on these machines is a
> very simple regulator using gpios.
> One provides the on/off functionality and a second one is
> used to
> change the current between 100 and 500 mA.
> 
> This functionality can also be provided by the more generic
> gpio-regulator.
> 
> Therefore convert both machines which makes it possible to
> remove the
> bq24022 driver later on.
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> ---
>  arch/arm/configs/magician_defconfig |    2 +-
>  arch/arm/mach-pxa/hx4700.c       
>   |   33
> +++++++++++++++++++++++++++------
>  arch/arm/mach-pxa/magician.c       
> |   33 +++++++++++++++++++++++++++------
>  3 files changed, 55 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm/configs/magician_defconfig
> b/arch/arm/configs/magician_defconfig
> index 443675d..a691ef4 100644
> --- a/arch/arm/configs/magician_defconfig
> +++ b/arch/arm/configs/magician_defconfig
> @@ -101,7 +101,7 @@ CONFIG_MFD_ASIC3=y
>  CONFIG_HTC_EGPIO=y
>  CONFIG_HTC_PASIC3=y
>  CONFIG_REGULATOR=y
> -CONFIG_REGULATOR_BQ24022=y
> +CONFIG_REGULATOR_GPIO=y
>  CONFIG_FB=y
>  CONFIG_FB_PXA=y
>  CONFIG_FB_PXA_OVERLAY=y
> diff --git a/arch/arm/mach-pxa/hx4700.c
> b/arch/arm/mach-pxa/hx4700.c
> index f2c23ea..7571f0d 100644
> --- a/arch/arm/mach-pxa/hx4700.c
> +++ b/arch/arm/mach-pxa/hx4700.c
> @@ -28,7 +28,8 @@
>  #include <linux/mtd/physmap.h>
>  #include <linux/pda_power.h>
>  #include <linux/pwm_backlight.h>
> -#include <linux/regulator/bq24022.h>
> +#include <linux/regulator/driver.h>
> +#include <linux/regulator/gpio-regulator.h>
>  #include <linux/regulator/machine.h>
>  #include <linux/regulator/max1586.h>
>  #include <linux/spi/ads7846.h>
> @@ -698,14 +699,34 @@ static struct regulator_init_data
> bq24022_init_data = {
>      .consumer_supplies      =
> bq24022_consumers,
>  };
>  
> -static struct bq24022_mach_info bq24022_info = {
> -    .gpio_nce   =
> GPIO72_HX4700_BQ24022_nCHARGE_EN,
> -    .gpio_iset2 =
> GPIO96_HX4700_BQ24022_ISET2,
> -    .init_data  =
> &bq24022_init_data,
> +static struct gpio bq24022_gpios[] = {
> +    { GPIO96_HX4700_BQ24022_ISET2,
> GPIOF_OUT_INIT_LOW, "bq24022_iset2" },
> +};
> +
> +static struct gpio_regulator_state bq24022_states[] = {
> +    { .value = 100000, .gpios = (0 <<
> 0) },
> +    { .value = 500000, .gpios = (1 <<
> 0) },
> +};
> +
> +static struct gpio_regulator_config bq24022_info = {
> +    .supply_name = "bq24022",
> +
> +    .enable_gpio =
> GPIO72_HX4700_BQ24022_nCHARGE_EN,
> +    .enable_high = 0,
> +    .enabled_at_boot = 0,
> +
> +    .gpios = bq24022_gpios,
> +    .nr_gpios = ARRAY_SIZE(bq24022_gpios),
> +
> +    .states = bq24022_states,
> +    .nr_states =
> ARRAY_SIZE(bq24022_states),
> +
> +    .type = REGULATOR_CURRENT,
> +    .init_data = &bq24022_init_data,
>  };
>  
>  static struct platform_device bq24022 = {
> -    .name = "bq24022",
> +    .name = "gpio-regulator",
>      .id   = -1,
>      .dev  = {
>          .platform_data =
> &bq24022_info,
> diff --git a/arch/arm/mach-pxa/magician.c
> b/arch/arm/mach-pxa/magician.c
> index 3d6baf9..5e26f3e 100644
> --- a/arch/arm/mach-pxa/magician.c
> +++ b/arch/arm/mach-pxa/magician.c
> @@ -25,7 +25,8 @@
>  #include <linux/mtd/physmap.h>
>  #include <linux/pda_power.h>
>  #include <linux/pwm_backlight.h>
> -#include <linux/regulator/bq24022.h>
> +#include <linux/regulator/driver.h>
> +#include <linux/regulator/gpio-regulator.h>
>  #include <linux/regulator/machine.h>
>  #include <linux/usb/gpio_vbus.h>
>  #include <linux/i2c/pxa-i2c.h>
> @@ -596,14 +597,34 @@ static struct regulator_init_data
> bq24022_init_data = {
>      .consumer_supplies      =
> bq24022_consumers,
>  };
>  
> -static struct bq24022_mach_info bq24022_info = {
> -    .gpio_nce   =
> GPIO30_MAGICIAN_BQ24022_nCHARGE_EN,
> -    .gpio_iset2 =
> EGPIO_MAGICIAN_BQ24022_ISET2,
> -    .init_data  =
> &bq24022_init_data,
> +static struct gpio bq24022_gpios[] = {
> +    { EGPIO_MAGICIAN_BQ24022_ISET2,
> GPIOF_OUT_INIT_LOW, "bq24022_iset2" },
> +};
> +
> +static struct gpio_regulator_state bq24022_states[] = {
> +    { .value = 100000, .gpios = (0 <<
> 0) },
> +    { .value = 500000, .gpios = (1 <<
> 0) },
> +};
> +
> +static struct gpio_regulator_config bq24022_info = {
> +    .supply_name = "bq24022",
> +
> +    .enable_gpio =
> GPIO30_MAGICIAN_BQ24022_nCHARGE_EN,
> +    .enable_high = 0,
> +    .enabled_at_boot = 0,
> +
> +    .gpios = bq24022_gpios,
> +    .nr_gpios = ARRAY_SIZE(bq24022_gpios),
> +
> +    .states = bq24022_states,
> +    .nr_states =
> ARRAY_SIZE(bq24022_states),
> +
> +    .type = REGULATOR_CURRENT,
> +    .init_data = &bq24022_init_data,
>  };
>  
>  static struct platform_device bq24022 = {
> -    .name = "bq24022",
> +    .name = "gpio-regulator",
>      .id   = -1,
>      .dev  = {
>          .platform_data =
> &bq24022_info,
> -- 
> 1.7.5.4

