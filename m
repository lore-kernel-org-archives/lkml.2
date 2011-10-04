Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933742Ab1JDUkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 16:40:32 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53178 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933696Ab1JDUka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 16:40:30 -0400
Date: Tue, 4 Oct 2011 12:38:41 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        kgene.kim@samsung.com, linaro-dev@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH] gpio/samsung: Move SoC specific codes within macro
Message-ID: <20111004183840.GH2870@ponder.secretlab.ca>
References: <1317612559-8930-1-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317612559-8930-1-git-send-email-tushar.behera@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 08:59:19AM +0530, Tushar Behera wrote:
> In drivers/gpio/gpio-samsung.c, there are certain structures
> and functions which are not getting used if the particular
> CPU is not selected. These code segments are moved under CPU
> specific macros to remove compilation warnings.
> 
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> ---
> It has been build tested with s3c2410_defconfig, s3c6400_defconfig,
> s5p64x0_defconfig, s5pc100_defconfig, s5pv210_defconfig and
> exynos4_defconfig.
> 
> The patch has been rebased onto
> Commit: gpio/samsung: correct pin configuration for S5PC100/S5PC110/EXYNOS4
> 
> on git://github.com/kgene/linux-samsung.git (next/topic-gpio-samsung)
> 
>  drivers/gpio/gpio-samsung.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
> index b6be77a..33d62d1 100644
> --- a/drivers/gpio/gpio-samsung.c
> +++ b/drivers/gpio/gpio-samsung.c
> @@ -318,6 +318,7 @@ static unsigned samsung_gpio_getcfg_4bit(struct samsung_gpio_chip *chip,
>  	return S3C_GPIO_SPECIAL(con);
>  }
>  
> +#ifdef CONFIG_PLAT_S3C24XX
>  /*
>   * s3c24xx_gpio_setcfg_abank - S3C24XX style GPIO configuration (Bank A)
>   * @chip: The gpio chip that is being configured.
> @@ -379,7 +380,9 @@ static unsigned s3c24xx_gpio_getcfg_abank(struct samsung_gpio_chip *chip,
>  
>  	return S3C_GPIO_SFN(con);
>  }
> +#endif
>  
> +#if defined(CONFIG_CPU_S5P6440) || defined(CONFIG_CPU_S5P6450)
>  static int s5p64x0_gpio_setcfg_rbank(struct samsung_gpio_chip *chip,
>  				     unsigned int off, unsigned int cfg)
>  {
> @@ -417,6 +420,7 @@ static int s5p64x0_gpio_setcfg_rbank(struct samsung_gpio_chip *chip,
>  
>  	return 0;
>  }
> +#endif
>  
>  static void __init samsung_gpiolib_set_cfg(struct samsung_gpio_cfg *chipcfg,
>  					   int nr_chips)
> @@ -438,10 +442,12 @@ struct samsung_gpio_cfg s3c24xx_gpiocfg_default = {
>  	.get_config	= samsung_gpio_getcfg_2bit,
>  };
>  
> +#ifdef CONFIG_PLAT_S3C24XX
>  static struct samsung_gpio_cfg s3c24xx_gpiocfg_banka = {
>  	.set_config	= s3c24xx_gpio_setcfg_abank,
>  	.get_config	= s3c24xx_gpio_getcfg_abank,
>  };
> +#endif
>  
>  static struct samsung_gpio_cfg exynos4_gpio_cfg = {
>  	.set_pull	= exynos4_gpio_setpull,
> @@ -450,6 +456,7 @@ static struct samsung_gpio_cfg exynos4_gpio_cfg = {
>  	.get_config	= samsung_gpio_getcfg_4bit,
>  };
>  
> +#if defined(CONFIG_CPU_S5P6440) || defined(CONFIG_CPU_S5P6450)
>  static struct samsung_gpio_cfg s5p64x0_gpio_cfg_rbank = {
>  	.cfg_eint	= 0x3,
>  	.set_config	= s5p64x0_gpio_setcfg_rbank,
> @@ -457,6 +464,7 @@ static struct samsung_gpio_cfg s5p64x0_gpio_cfg_rbank = {
>  	.set_pull	= samsung_gpio_setpull_updown,
>  	.get_pull	= samsung_gpio_getpull_updown,
>  };
> +#endif
>  
>  static struct samsung_gpio_cfg samsung_gpio_cfgs[] = {
>  	{
> @@ -682,6 +690,7 @@ static int samsung_gpiolib_4bit2_output(struct gpio_chip *chip,
>  	return 0;
>  }
>  
> +#ifdef CONFIG_PLAT_S3C24XX
>  /* The next set of routines are for the case of s3c24xx bank a */
>  
>  static int s3c24xx_gpiolib_banka_input(struct gpio_chip *chip, unsigned offset)
> @@ -717,6 +726,7 @@ static int s3c24xx_gpiolib_banka_output(struct gpio_chip *chip,
>  	local_irq_restore(flags);
>  	return 0;
>  }
> +#endif
>  
>  /* The next set of routines are for the case of s5p64x0 bank r */
>  
> -- 
> 1.7.4.1
> 
