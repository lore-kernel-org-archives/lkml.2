Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab0LIPOK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 10:14:10 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60372 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344Ab0LIPOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 10:14:08 -0500
Date: Thu, 9 Dec 2010 16:14:04 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Yong Shen <yong.shen@linaro.org>
Cc: List Linux Arm Kernel <linux-arm-kernel@lists.infradead.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Uwe =?iso-8859-15?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Change the register name definitions for mc13783
Message-ID: <20101209151404.GP6017@pengutronix.de>
References: <AANLkTinA-rNzSjGZQSmGUdOt8j0RWddfNo5m=fP2oQx8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinA-rNzSjGZQSmGUdOt8j0RWddfNo5m=fP2oQx8@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:13:01 up 159 days,  6:23, 48 users,  load average: 0.75, 0.48,
	0.36
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 07:18:53PM +0800, Yong Shen wrote:
> Hi there,
> 
> Please comment inline and use attached file for patch or test.

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

I can confirm that this patch also applies to my i.MX branch without
merge conflicts, so it can go via the regulator tree.

Sascha

> 
> Thanks
> Yong
> 
> From e112153c6f03b49c229a8e3913a0c0459245df20 Mon Sep 17 00:00:00 2001
> From: Yong Shen <yong.shen@linaro.org>
> Date: Thu, 2 Dec 2010 14:17:02 +0800
> Subject: [PATCH 1/2] Change the register name definitions for mc13783
> 
> To make mc13783 and mc13892 share code, the register names should be
> changed to fit the new macro definitions in the comming patch.
> 
> Signed-off-by: Yong Shen <yong.shen@linaro.org>
> ---
>  arch/arm/mach-imx/mach-pcm038.c       |    4 +-
>  arch/arm/mach-mx3/mach-mx31_3ds.c     |    4 +-
>  arch/arm/mach-mx3/mach-mx31moboard.c  |    4 +-
>  drivers/regulator/mc13783-regulator.c |   30 +++++++-------
>  include/linux/mfd/mc13783.h           |   67 +++++++++++++++++----------------
>  5 files changed, 55 insertions(+), 54 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/mach-pcm038.c b/arch/arm/mach-imx/mach-pcm038.c
> index f667a26..5056148 100644
> --- a/arch/arm/mach-imx/mach-pcm038.c
> +++ b/arch/arm/mach-imx/mach-pcm038.c
> @@ -254,10 +254,10 @@ static struct regulator_init_data cam_data = {
> 
>  static struct mc13783_regulator_init_data pcm038_regulators[] = {
>  	{
> -		.id = MC13783_REGU_VCAM,
> +		.id = MC13783_REG_VCAM,
>  		.init_data = &cam_data,
>  	}, {
> -		.id = MC13783_REGU_VMMC1,
> +		.id = MC13783_REG_VMMC1,
>  		.init_data = &sdhc1_data,
>  	},
>  };
> diff --git a/arch/arm/mach-mx3/mach-mx31_3ds.c
> b/arch/arm/mach-mx3/mach-mx31_3ds.c
> index e4efbfe..ed2db94 100644
> --- a/arch/arm/mach-mx3/mach-mx31_3ds.c
> +++ b/arch/arm/mach-mx3/mach-mx31_3ds.c
> @@ -115,10 +115,10 @@ static struct regulator_init_data pwgtx_init = {
> 
>  static struct mc13783_regulator_init_data mx31_3ds_regulators[] = {
>  	{
> -		.id = MC13783_REGU_PWGT1SPI, /* Power Gate for ARM core. */
> +		.id = MC13783_REG_PWGT1SPI, /* Power Gate for ARM core. */
>  		.init_data = &pwgtx_init,
>  	}, {
> -		.id = MC13783_REGU_PWGT2SPI, /* Power Gate for L2 Cache. */
> +		.id = MC13783_REG_PWGT2SPI, /* Power Gate for L2 Cache. */
>  		.init_data = &pwgtx_init,
>  	},
>  };
> diff --git a/arch/arm/mach-mx3/mach-mx31moboard.c
> b/arch/arm/mach-mx3/mach-mx31moboard.c
> index 203d21a..1aa8d65 100644
> --- a/arch/arm/mach-mx3/mach-mx31moboard.c
> +++ b/arch/arm/mach-mx3/mach-mx31moboard.c
> @@ -216,11 +216,11 @@ static struct regulator_init_data cam_vreg_data = {
> 
>  static struct mc13783_regulator_init_data moboard_regulators[] = {
>  	{
> -		.id = MC13783_REGU_VMMC1,
> +		.id = MC13783_REG_VMMC1,
>  		.init_data = &sdhc_vreg_data,
>  	},
>  	{
> -		.id = MC13783_REGU_VCAM,
> +		.id = MC13783_REG_VCAM,
>  		.init_data = &cam_vreg_data,
>  	},
>  };
> diff --git a/drivers/regulator/mc13783-regulator.c
> b/drivers/regulator/mc13783-regulator.c
> index 4597d50..e4f2787 100644
> --- a/drivers/regulator/mc13783-regulator.c
> +++ b/drivers/regulator/mc13783-regulator.c
> @@ -228,15 +228,15 @@ static struct regulator_ops mc13783_gpo_regulator_ops;
>  	}
> 
>  #define MC13783_DEFINE_SW(_name, _reg, _vsel_reg, _voltages)		\
> -	MC13783_DEFINE(SW, _name, _reg, _vsel_reg, _voltages)
> +	MC13783_DEFINE(REG, _name, _reg, _vsel_reg, _voltages)
>  #define MC13783_DEFINE_REGU(_name, _reg, _vsel_reg, _voltages)		\
> -	MC13783_DEFINE(REGU, _name, _reg, _vsel_reg, _voltages)
> +	MC13783_DEFINE(REG, _name, _reg, _vsel_reg, _voltages)
> 
>  static struct mc13783_regulator mc13783_regulators[] = {
>  	MC13783_DEFINE_SW(SW3, SWITCHERS5, SWITCHERS5, mc13783_sw3_val),
> 
> -	MC13783_FIXED_DEFINE(REGU, VAUDIO, REGULATORMODE0, mc13783_vaudio_val),
> -	MC13783_FIXED_DEFINE(REGU, VIOHI, REGULATORMODE0, mc13783_viohi_val),
> +	MC13783_FIXED_DEFINE(REG, VAUDIO, REGULATORMODE0, mc13783_vaudio_val),
> +	MC13783_FIXED_DEFINE(REG, VIOHI, REGULATORMODE0, mc13783_viohi_val),
>  	MC13783_DEFINE_REGU(VIOLO, REGULATORMODE0, REGULATORSETTING0,	\
>  			    mc13783_violo_val),
>  	MC13783_DEFINE_REGU(VDIG, REGULATORMODE0, REGULATORSETTING0,	\
> @@ -255,7 +255,7 @@ static struct mc13783_regulator mc13783_regulators[] = {
>  			    mc13783_vesim_val),
>  	MC13783_DEFINE_REGU(VCAM, REGULATORMODE1, REGULATORSETTING0,	\
>  			    mc13783_vcam_val),
> -	MC13783_FIXED_DEFINE(REGU, VRFBG, REGULATORMODE1, mc13783_vrfbg_val),
> +	MC13783_FIXED_DEFINE(REG, VRFBG, REGULATORMODE1, mc13783_vrfbg_val),
>  	MC13783_DEFINE_REGU(VVIB, REGULATORMODE1, REGULATORSETTING1,	\
>  			    mc13783_vvib_val),
>  	MC13783_DEFINE_REGU(VRF1, REGULATORMODE1, REGULATORSETTING1,	\
> @@ -266,12 +266,12 @@ static struct mc13783_regulator mc13783_regulators[] = {
>  			    mc13783_vmmc_val),
>  	MC13783_DEFINE_REGU(VMMC2, REGULATORMODE1, REGULATORSETTING1,	\
>  			    mc13783_vmmc_val),
> -	MC13783_GPO_DEFINE(REGU, GPO1, POWERMISC, mc13783_gpo_val),
> -	MC13783_GPO_DEFINE(REGU, GPO2, POWERMISC, mc13783_gpo_val),
> -	MC13783_GPO_DEFINE(REGU, GPO3, POWERMISC, mc13783_gpo_val),
> -	MC13783_GPO_DEFINE(REGU, GPO4, POWERMISC, mc13783_gpo_val),
> -	MC13783_GPO_DEFINE(REGU, PWGT1SPI, POWERMISC, mc13783_pwgtdrv_val),
> -	MC13783_GPO_DEFINE(REGU, PWGT2SPI, POWERMISC, mc13783_pwgtdrv_val),
> +	MC13783_GPO_DEFINE(REG, GPO1, POWERMISC, mc13783_gpo_val),
> +	MC13783_GPO_DEFINE(REG, GPO2, POWERMISC, mc13783_gpo_val),
> +	MC13783_GPO_DEFINE(REG, GPO3, POWERMISC, mc13783_gpo_val),
> +	MC13783_GPO_DEFINE(REG, GPO4, POWERMISC, mc13783_gpo_val),
> +	MC13783_GPO_DEFINE(REG, PWGT1SPI, POWERMISC, mc13783_pwgtdrv_val),
> +	MC13783_GPO_DEFINE(REG, PWGT2SPI, POWERMISC, mc13783_pwgtdrv_val),
>  };
> 
>  struct mc13783_regulator_priv {
> @@ -502,8 +502,8 @@ static int mc13783_gpo_regulator_enable(struct
> regulator_dev *rdev)
>  	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
> 
>  	/* Power Gate enable value is 0 */
> -	if (id == MC13783_REGU_PWGT1SPI ||
> -	    id == MC13783_REGU_PWGT2SPI)
> +	if (id == MC13783_REG_PWGT1SPI ||
> +	    id == MC13783_REG_PWGT2SPI)
>  		en_val = 0;
> 
>  	mc13783_lock(priv->mc13783);
> @@ -524,8 +524,8 @@ static int mc13783_gpo_regulator_disable(struct
> regulator_dev *rdev)
>  	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
> 
>  	/* Power Gate disable value is 1 */
> -	if (id == MC13783_REGU_PWGT1SPI ||
> -	    id == MC13783_REGU_PWGT2SPI)
> +	if (id == MC13783_REG_PWGT1SPI ||
> +	    id == MC13783_REG_PWGT2SPI)
>  		dis_val = mc13783_regulators[id].enable_bit;
> 
>  	mc13783_lock(priv->mc13783);
> diff --git a/include/linux/mfd/mc13783.h b/include/linux/mfd/mc13783.h
> index b4c741e..7d0f3d6 100644
> --- a/include/linux/mfd/mc13783.h
> +++ b/include/linux/mfd/mc13783.h
> @@ -1,4 +1,5 @@
>  /*
> + * Copyright 2010 Yong Shen <yong.shen@linaro.org>
>   * Copyright 2009-2010 Pengutronix
>   * Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
>   *
> @@ -122,39 +123,39 @@ int mc13783_adc_do_conversion(struct mc13783
> *mc13783, unsigned int mode,
>  		unsigned int channel, unsigned int *sample);
> 
> 
> -#define	MC13783_SW_SW1A		0
> -#define	MC13783_SW_SW1B		1
> -#define	MC13783_SW_SW2A		2
> -#define	MC13783_SW_SW2B		3
> -#define	MC13783_SW_SW3		4
> -#define	MC13783_SW_PLL		5
> -#define	MC13783_REGU_VAUDIO	6
> -#define	MC13783_REGU_VIOHI	7
> -#define	MC13783_REGU_VIOLO	8
> -#define	MC13783_REGU_VDIG	9
> -#define	MC13783_REGU_VGEN	10
> -#define	MC13783_REGU_VRFDIG	11
> -#define	MC13783_REGU_VRFREF	12
> -#define	MC13783_REGU_VRFCP	13
> -#define	MC13783_REGU_VSIM	14
> -#define	MC13783_REGU_VESIM	15
> -#define	MC13783_REGU_VCAM	16
> -#define	MC13783_REGU_VRFBG	17
> -#define	MC13783_REGU_VVIB	18
> -#define	MC13783_REGU_VRF1	19
> -#define	MC13783_REGU_VRF2	20
> -#define	MC13783_REGU_VMMC1	21
> -#define	MC13783_REGU_VMMC2	22
> -#define	MC13783_REGU_GPO1	23
> -#define	MC13783_REGU_GPO2	24
> -#define	MC13783_REGU_GPO3	25
> -#define	MC13783_REGU_GPO4	26
> -#define	MC13783_REGU_V1		27
> -#define	MC13783_REGU_V2		28
> -#define	MC13783_REGU_V3		29
> -#define	MC13783_REGU_V4		30
> -#define	MC13783_REGU_PWGT1SPI	31
> -#define	MC13783_REGU_PWGT2SPI	32
> +#define	MC13783_REG_SW1A		0
> +#define	MC13783_REG_SW1B		1
> +#define	MC13783_REG_SW2A		2
> +#define	MC13783_REG_SW2B		3
> +#define	MC13783_REG_SW3		4
> +#define	MC13783_REG_PLL		5
> +#define	MC13783_REG_VAUDIO	6
> +#define	MC13783_REG_VIOHI	7
> +#define	MC13783_REG_VIOLO	8
> +#define	MC13783_REG_VDIG	9
> +#define	MC13783_REG_VGEN	10
> +#define	MC13783_REG_VRFDIG	11
> +#define	MC13783_REG_VRFREF	12
> +#define	MC13783_REG_VRFCP	13
> +#define	MC13783_REG_VSIM	14
> +#define	MC13783_REG_VESIM	15
> +#define	MC13783_REG_VCAM	16
> +#define	MC13783_REG_VRFBG	17
> +#define	MC13783_REG_VVIB	18
> +#define	MC13783_REG_VRF1	19
> +#define	MC13783_REG_VRF2	20
> +#define	MC13783_REG_VMMC1	21
> +#define	MC13783_REG_VMMC2	22
> +#define	MC13783_REG_GPO1	23
> +#define	MC13783_REG_GPO2	24
> +#define	MC13783_REG_GPO3	25
> +#define	MC13783_REG_GPO4	26
> +#define	MC13783_REG_V1		27
> +#define	MC13783_REG_V2		28
> +#define	MC13783_REG_V3		29
> +#define	MC13783_REG_V4		30
> +#define	MC13783_REG_PWGT1SPI	31
> +#define	MC13783_REG_PWGT2SPI	32
> 
>  #define MC13783_IRQ_ADCDONE	MC13XXX_IRQ_ADCDONE
>  #define MC13783_IRQ_ADCBISDONE	MC13XXX_IRQ_ADCBISDONE
> -- 
> 1.7.0.4



-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
