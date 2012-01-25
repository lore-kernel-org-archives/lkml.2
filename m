Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab2AYHxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 02:53:41 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:34251 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750832Ab2AYHxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 02:53:40 -0500
Message-ID: <4F1FB4DA.2050104@metafoo.de>
Date: Wed, 25 Jan 2012 08:52:58 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: "Kim, Milo" <Milo.Kim@ti.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Subject: Re: [PATCH v2 1/2] leds-lm3530: set the value of max_brightness to
 127
References: <B567DBAB974C0544994013492B949F8E3812CD3E37@EXMAIL03.scwf.nsc.com>
In-Reply-To: <B567DBAB974C0544994013492B949F8E3812CD3E37@EXMAIL03.scwf.nsc.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2012 02:51 AM, Kim, Milo wrote:
> Only 7 bits are used for the brightness. (register address : A0h)
> So the max_brightness property of lm3530 should be set to 127.
> 
> On initializing registers, maximum initial brightness is limited to 'max_brightness'.
> 
> Division-by-two is removed on updating the value of brightness.
> This arithmetic is not necessary because the range of brightness is 0 ~ 127.
> 
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  drivers/leds/leds-lm3530.c |   22 +++++++++++-----------
>  1 files changed, 11 insertions(+), 11 deletions(-)
> 

Looks like something went wrong, this is the same patch as 2/2

> diff --git a/drivers/leds/leds-lm3530.c b/drivers/leds/leds-lm3530.c
> index a7f24f7..7005a5f 100644
> --- a/drivers/leds/leds-lm3530.c
> +++ b/drivers/leds/leds-lm3530.c
> @@ -153,11 +153,11 @@ static int lm3530_init_registers(struct lm3530_data *drvdata)
>  	u8 als_imp_sel = 0;
>  	u8 brightness;
>  	u8 reg_val[LM3530_REG_MAX];
> -	struct lm3530_platform_data *pdata = drvdata->pdata;
> +	struct lm3530_platform_data *pltfm = drvdata->pdata;
>  	struct i2c_client *client = drvdata->client;
>  
> -	gen_config = (pdata->brt_ramp_law << LM3530_RAMP_LAW_SHIFT) |
> -			((pdata->max_current & 7) << LM3530_MAX_CURR_SHIFT);
> +	gen_config = (pltfm->brt_ramp_law << LM3530_RAMP_LAW_SHIFT) |
> +			((pltfm->max_current & 7) << LM3530_MAX_CURR_SHIFT);
>  
>  	if (drvdata->mode == LM3530_BL_MODE_MANUAL ||
>  	    drvdata->mode == LM3530_BL_MODE_ALS)
> @@ -165,27 +165,27 @@ static int lm3530_init_registers(struct lm3530_data *drvdata)
>  
>  	if (drvdata->mode == LM3530_BL_MODE_ALS) {
>  		als_config =
> -			(pdata->als_avrg_time << LM3530_ALS_AVG_TIME_SHIFT) |
> +			(pltfm->als_avrg_time << LM3530_ALS_AVG_TIME_SHIFT) |
>  			(LM3530_ENABLE_ALS) |
> -			(pdata->als_input_mode << LM3530_ALS_SEL_SHIFT);
> +			(pltfm->als_input_mode << LM3530_ALS_SEL_SHIFT);
>  
>  		als_imp_sel =
> -			(pdata->als1_resistor_sel << LM3530_ALS1_IMP_SHIFT) |
> -			(pdata->als2_resistor_sel << LM3530_ALS2_IMP_SHIFT);
> +			(pltfm->als1_resistor_sel << LM3530_ALS1_IMP_SHIFT) |
> +			(pltfm->als2_resistor_sel << LM3530_ALS2_IMP_SHIFT);
>  	}
>  
>  	if (drvdata->mode == LM3530_BL_MODE_PWM)
>  		gen_config |= (LM3530_ENABLE_PWM) |
> -				(pdata->pwm_pol_hi << LM3530_PWM_POL_SHIFT) |
> +				(pltfm->pwm_pol_hi << LM3530_PWM_POL_SHIFT) |
>  				(LM3530_ENABLE_PWM_SIMPLE);
>  
> -	brt_ramp = (pdata->brt_ramp_fall << LM3530_BRT_RAMP_FALL_SHIFT) |
> -			(pdata->brt_ramp_rise << LM3530_BRT_RAMP_RISE_SHIFT);
> +	brt_ramp = (pltfm->brt_ramp_fall << LM3530_BRT_RAMP_FALL_SHIFT) |
> +			(pltfm->brt_ramp_rise << LM3530_BRT_RAMP_RISE_SHIFT);
>  
>  	if (drvdata->brightness)
>  		brightness = drvdata->brightness;
>  	else
> -		brightness = drvdata->brightness = pdata->brt_val;
> +		brightness = drvdata->brightness = pltfm->brt_val;
>  
>  	if (brightness > drvdata->led_dev.max_brightness)
>  		brightness = drvdata->led_dev.max_brightness;

