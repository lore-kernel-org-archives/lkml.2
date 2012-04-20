Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573Ab2DTIoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 04:44:15 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45210 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761Ab2DTIoL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 04:44:11 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 20 Apr 2012 01:44:06 -0700
Subject: RE: [PATCH 1/2] leds-lm3530: comment correction about the range of
 brightness
Thread-Topic: [PATCH 1/2] leds-lm3530: comment correction about the range of
 brightness
Thread-Index: Ac0d91aE61uKSG1fTRa0ziODJqgpzAAz8gZwAAIA82A=
Message-ID: <DD6B9D658496A2488636C8C75B9C0CB601CD382F@EXMAIL04.scwf.nsc.com>
References: <DD6B9D658496A2488636C8C75B9C0CB601CD3224@EXMAIL04.scwf.nsc.com>
 <2E48302EED53D048A7BA72B0A307FB511FB8D43B52@EXDCVYMBSTM005.EQ1STM.local>
In-Reply-To: <2E48302EED53D048A7BA72B0A307FB511FB8D43B52@EXDCVYMBSTM005.EQ1STM.local>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In the previous patch, max brightness was limited to 127 because only 7 bits are used in the brightness register.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=bbe6453204c568723679212f6d0653b92b3d6244

With this patch, 128 ~ 255 is invalid range of brightness, so comment needs to be corrected.
(Even if the brt_val is greater than 127, the brightness will be set as max_brightness - 127)

Thanks & BR
Milo -

> -----Original Message-----
> From: Shreshtha Kumar SAHU [mailto:shreshthakumar.sahu@stericsson.com]
> Sent: Friday, April 20, 2012 4:29 PM
> To: Kim, Milo
> Cc: linus.walleij@linaro.org; Richard Purdie; linux-
> kernel@vger.kernel.org; Andrew Morton
> Subject: RE: [PATCH 1/2] leds-lm3530: comment correction about the
> range of brightness
> 
> I feel driver should take care of range provided by hardware by
> scaling the value provided by user, instead of limiting the max
> brightness to user.
> 
> For .e.g. here it can be something like this -
>                 err = i2c_smbus_write_byte_data(drvdata->client,
>                                 LM3530_BRT_CTRL_REG, brt_val / 2);
> 
> I am not sure if application really use/check max brightness in before
> calculating/setting new brightness values.
> 
> -----Original Message-----
> From: Kim, Milo [mailto:Milo.Kim@ti.com]
> Sent: Thursday, April 19, 2012 12:11 PM
> To: Andrew Morton
> Cc: Shreshtha Kumar SAHU; linus.walleij@linaro.org; Richard Purdie;
> linux-kernel@vger.kernel.org
> Subject: [PATCH 1/2] leds-lm3530: comment correction about the range of
> brightness
> 
> max brightness is 127, so the range of brt_val should be from 0 to 127
> 
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  include/linux/led-lm3530.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/led-lm3530.h b/include/linux/led-lm3530.h
> index eeae6e7..4b13347 100644
> --- a/include/linux/led-lm3530.h
> +++ b/include/linux/led-lm3530.h
> @@ -92,7 +92,7 @@ struct lm3530_pwm_data {
>   * @als2_resistor_sel: internal resistance from ALS2 input to ground
>   * @als_vmin: als input voltage calibrated for max brightness in mV
>   * @als_vmax: als input voltage calibrated for min brightness in mV
> - * @brt_val: brightness value (0-255)
> + * @brt_val: brightness value (0-127)
>   * @pwm_data: PWM control functions (only valid when the mode is PWM)
>   */
>  struct lm3530_platform_data {
> --
> 1.7.4.1
> 
> 
> Best Regards,
> Milo (Woogyom) Kim
> 

