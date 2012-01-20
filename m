Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab2ATIbB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 03:31:01 -0500
Received: from smtp-out-119.synserver.de ([212.40.185.119]:1059 "EHLO
	smtp-out-117.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752432Ab2ATIbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 03:31:00 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 14966
Message-ID: <4F19267C.7010307@metafoo.de>
Date: Fri, 20 Jan 2012 09:31:56 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Iceowl/1.0b2 Icedove/3.1.16
MIME-Version: 1.0
To: "Kim, Milo" <Milo.Kim@ti.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Subject: Re: [PATCH 7/7] leds-lm3530: enhanced arithmetic operation
References: <B567DBAB974C0544994013492B949F8E3812C6D0D7@EXMAIL03.scwf.nsc.com>
In-Reply-To: <B567DBAB974C0544994013492B949F8E3812C6D0D7@EXMAIL03.scwf.nsc.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2012 02:52 AM, Kim, Milo wrote:
> Use shift operation rather than 'divide-by-2'.

The compiler will already take of this for you.

But why is the divide by two necessary anyway? This sort of looks like
max_brightness is not set properly and the code compensates for it by
ignoring the lsb.

> 
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> 
> diff --git a/drivers/leds/leds-lm3530.c b/drivers/leds/leds-lm3530.c
> index 51c1f6c..e0b1ba8 100644
> --- a/drivers/leds/leds-lm3530.c
> +++ b/drivers/leds/leds-lm3530.c
> @@ -249,12 +249,12 @@ static void lm3530_brightness_set(struct led_classdev *led_cdev,
>  
>  		/* set the brightness in brightness control register*/
>  		err = i2c_smbus_write_byte_data(drvdata->client,
> -				LM3530_BRT_CTRL_REG, brt_val / 2);
> +				LM3530_BRT_CTRL_REG, brt_val >> 1);
>  		if (err)
>  			dev_err(&drvdata->client->dev,
>  				"Unable to set brightness: %d\n", err);
>  		else
> -			drvdata->brightness = brt_val / 2;
> +			drvdata->brightness = brt_val >> 1;
>  
>  		if (brt_val == 0 && !pdata->is_vin_always_on) {
>  			err = regulator_disable(drvdata->regulator);

