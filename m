Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab2AYBx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 20:53:29 -0500
Received: from mail2.nsc.com ([12.238.8.132]:36071 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755475Ab2AYBx2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 20:53:28 -0500
X-WSS-ID: 0LYBZX1-0A-3S8-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Lars-Peter Clausen" <lars@metafoo.de>
cc: "Linus Walleij" <linus.walleij@linaro.org>,
        "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Date: Tue, 24 Jan 2012 17:53:19 -0800
Subject: RE: [PATCH] leds-lm3530: set the value of max_brightness to 127
Thread-Topic: [PATCH] leds-lm3530: set the value of max_brightness to
 127
Thread-Index: AczXotg/eVYDRrhpQcS8Q3T9JV9nLgDYQHdQ
Message-ID: <B567DBAB974C0544994013492B949F8E3812CD3E3F@EXMAIL03.scwf.nsc.com>
References: <B567DBAB974C0544994013492B949F8E3812CD3655@EXMAIL03.scwf.nsc.com>
 <4F19B4BE.9080205@metafoo.de>
In-Reply-To: <4F19B4BE.9080205@metafoo.de>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 6301BF1B1LS9908684-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated patch has been sent.

Title : [PATCH v2 1/2] leds-lm3530: set the value of max_brightness to 127

Thanks & BR
Milo -

-----Original Message-----
From: Lars-Peter Clausen [mailto:lars@metafoo.de] 
Sent: Saturday, January 21, 2012 3:39 AM
To: Kim, Milo
Cc: Linus Walleij; shreshthakumar.sahu@stericsson.com; linux-kernel@vger.kernel.org; rpurdie@rpsys.net
Subject: Re: [PATCH] leds-lm3530: set the value of max_brightness to 127

On 01/20/2012 06:34 PM, Kim, Milo wrote:
> Only 7 bits are used for the brightness. (register address : A0h)
> So the max_brightness property of lm3530 should be set to 127.
> 
> On initializing registers, maximum initial brightness is limited to 'max_brightness'.
> 
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>

Uhm, I might have suggested this, but I've definitely not yet reviewed this
patch. Please don't add tags for other people unless they have explicitly given
you that tag.

> ---
>  drivers/leds/leds-lm3530.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/leds/leds-lm3530.c b/drivers/leds/leds-lm3530.c
> index 4d7ce76..dce6c2a 100644
> --- a/drivers/leds/leds-lm3530.c
> +++ b/drivers/leds/leds-lm3530.c
> @@ -80,6 +80,9 @@
>  #define LM3530_DEF_ZT_3			(0x66)
>  #define LM3530_DEF_ZT_4			(0x7F)
>  
> +/* 7 bits are used for the brightness : LM3530_BRT_CTRL_REG */
> +#define MAX_BRIGHTNESS			(127)
> +
>  struct lm3530_mode_map {
>  	const char *mode;
>  	enum lm3530_mode mode_val;
> @@ -184,6 +187,9 @@ static int lm3530_init_registers(struct lm3530_data *drvdata)
>  	else
>  		brightness = drvdata->brightness = pltfm->brt_val;
>  
> +	if (brightness > drvdata->led_dev.max_brightness)
> +		brightness = drvdata->led_dev.max_brightness;
> +
>  	reg_val[0] = gen_config;	/* LM3530_GEN_CONFIG */
>  	reg_val[1] = als_config;	/* LM3530_ALS_CONFIG */
>  	reg_val[2] = brt_ramp;		/* LM3530_BRT_RAMP_RATE */
> @@ -340,6 +346,7 @@ static int __devinit lm3530_probe(struct i2c_client *client,
>  	drvdata->enable = false;
>  	drvdata->led_dev.name = LM3530_LED_DEV;
>  	drvdata->led_dev.brightness_set = lm3530_brightness_set;
> +	drvdata->led_dev.max_brightness = MAX_BRIGHTNESS;
>  
>  	i2c_set_clientdata(client, drvdata);
>

You should also remove the division by two. max_brightness is supposed to be
the maximum value which the brightness value can be set to.

- Lars


