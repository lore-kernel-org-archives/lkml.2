Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708Ab1JEBUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 21:20:17 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:22268 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757582Ab1JEBUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 21:20:15 -0400
X-AuditID: cbfee61b-b7b7fae000005864-3b-4e8bb0c23544
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Tushar Behera'" <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
References: <1317612559-8930-1-git-send-email-tushar.behera@linaro.org>
 <20111004183840.GH2870@ponder.secretlab.ca>
In-reply-to: <20111004183840.GH2870@ponder.secretlab.ca>
Subject: RE: [PATCH] gpio/samsung: Move SoC specific codes within macro
Date: Wed, 05 Oct 2011 10:20:01 +0900
Message-id: <01f301cc82fc$e810db10$b8329130$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcyC1dy+uPOekvC0R32rCKge0AHmewAHUBcQ
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely wrote:
> 
> On Mon, Oct 03, 2011 at 08:59:19AM +0530, Tushar Behera wrote:
> > In drivers/gpio/gpio-samsung.c, there are certain structures
> > and functions which are not getting used if the particular
> > CPU is not selected. These code segments are moved under CPU
> > specific macros to remove compilation warnings.
> >
> > Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> 
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> 
When I applied, following error was happened with s5p64x0_defconfig. Others,
ok.

...
Inconsistent kallsyms data
This is a bug - please report about it
Try make KALLSYMS_EXTRA_PASS=1 as a workaround
make: *** [vmlinux] Error 1

And it seems due to add condition around the 'static unsigned
s3c24xx_gpio_getcfg_abank()'.

I need to check it in detail and if any problems, let you know.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

> > ---
> > It has been build tested with s3c2410_defconfig, s3c6400_defconfig,
> > s5p64x0_defconfig, s5pc100_defconfig, s5pv210_defconfig and
> > exynos4_defconfig.
> >
> > The patch has been rebased onto
> > Commit: gpio/samsung: correct pin configuration for
> S5PC100/S5PC110/EXYNOS4
> >
> > on git://github.com/kgene/linux-samsung.git (next/topic-gpio-samsung)
> >
> >  drivers/gpio/gpio-samsung.c |   10 ++++++++++
> >  1 files changed, 10 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
> > index b6be77a..33d62d1 100644
> > --- a/drivers/gpio/gpio-samsung.c
> > +++ b/drivers/gpio/gpio-samsung.c
> > @@ -318,6 +318,7 @@ static unsigned samsung_gpio_getcfg_4bit(struct
> samsung_gpio_chip *chip,
> >  	return S3C_GPIO_SPECIAL(con);
> >  }
> >
> > +#ifdef CONFIG_PLAT_S3C24XX
> >  /*
> >   * s3c24xx_gpio_setcfg_abank - S3C24XX style GPIO configuration (Bank
A)
> >   * @chip: The gpio chip that is being configured.
> > @@ -379,7 +380,9 @@ static unsigned s3c24xx_gpio_getcfg_abank(struct
> samsung_gpio_chip *chip,
> >
> >  	return S3C_GPIO_SFN(con);
> >  }
> > +#endif
> >
> > +#if defined(CONFIG_CPU_S5P6440) || defined(CONFIG_CPU_S5P6450)
> >  static int s5p64x0_gpio_setcfg_rbank(struct samsung_gpio_chip *chip,
> >  				     unsigned int off, unsigned int cfg)
> >  {
> > @@ -417,6 +420,7 @@ static int s5p64x0_gpio_setcfg_rbank(struct
> samsung_gpio_chip *chip,
> >
> >  	return 0;
> >  }
> > +#endif
> >
> >  static void __init samsung_gpiolib_set_cfg(struct samsung_gpio_cfg
*chipcfg,
> >  					   int nr_chips)
> > @@ -438,10 +442,12 @@ struct samsung_gpio_cfg s3c24xx_gpiocfg_default =
> {
> >  	.get_config	= samsung_gpio_getcfg_2bit,
> >  };
> >
> > +#ifdef CONFIG_PLAT_S3C24XX
> >  static struct samsung_gpio_cfg s3c24xx_gpiocfg_banka = {
> >  	.set_config	= s3c24xx_gpio_setcfg_abank,
> >  	.get_config	= s3c24xx_gpio_getcfg_abank,
> >  };
> > +#endif
> >
> >  static struct samsung_gpio_cfg exynos4_gpio_cfg = {
> >  	.set_pull	= exynos4_gpio_setpull,
> > @@ -450,6 +456,7 @@ static struct samsung_gpio_cfg exynos4_gpio_cfg = {
> >  	.get_config	= samsung_gpio_getcfg_4bit,
> >  };
> >
> > +#if defined(CONFIG_CPU_S5P6440) || defined(CONFIG_CPU_S5P6450)
> >  static struct samsung_gpio_cfg s5p64x0_gpio_cfg_rbank = {
> >  	.cfg_eint	= 0x3,
> >  	.set_config	= s5p64x0_gpio_setcfg_rbank,
> > @@ -457,6 +464,7 @@ static struct samsung_gpio_cfg
> s5p64x0_gpio_cfg_rbank = {
> >  	.set_pull	= samsung_gpio_setpull_updown,
> >  	.get_pull	= samsung_gpio_getpull_updown,
> >  };
> > +#endif
> >
> >  static struct samsung_gpio_cfg samsung_gpio_cfgs[] = {
> >  	{
> > @@ -682,6 +690,7 @@ static int samsung_gpiolib_4bit2_output(struct
gpio_chip
> *chip,
> >  	return 0;
> >  }
> >
> > +#ifdef CONFIG_PLAT_S3C24XX
> >  /* The next set of routines are for the case of s3c24xx bank a */
> >
> >  static int s3c24xx_gpiolib_banka_input(struct gpio_chip *chip, unsigned
offset)
> > @@ -717,6 +726,7 @@ static int s3c24xx_gpiolib_banka_output(struct
> gpio_chip *chip,
> >  	local_irq_restore(flags);
> >  	return 0;
> >  }
> > +#endif
> >
> >  /* The next set of routines are for the case of s5p64x0 bank r */
> >
> > --
> > 1.7.4.1
> >

