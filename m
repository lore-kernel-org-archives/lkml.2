Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab2BTIVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 03:21:43 -0500
Received: from mail2.nsc.com ([12.238.8.132]:55241 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751368Ab2BTIVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 03:21:42 -0500
X-WSS-ID: 0LZON81-0A-3G3-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Axel Lin" <axel.lin@gmail.com>
cc: "Richard Purdie" <rpurdie@rpsys.net>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 20 Feb 2012 00:21:30 -0800
Subject: RE: [PATCH] drivers/video/backlight/lp855x_bl.c: fix setting
 initial value for max_brightness and brightness
Thread-Topic: [PATCH] drivers/video/backlight/lp855x_bl.c: fix setting
 initial value for max_brightness and brightness
Thread-Index: Aczu1UszludPwLRqTXa0ybEPaFJAAwA0hNxg
Message-ID: <B567DBAB974C0544994013492B949F8E3813076468@EXMAIL03.scwf.nsc.com>
References: <1329635302.4818.1.camel@phoenix>
In-Reply-To: <1329635302.4818.1.camel@phoenix>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 635CDD041LS10489775-01-01
Content-Type: text/plain;
 charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1K8Ll75011640

Thanks for this patch.

But it would be better if max_brightness of platform data is removed.
Actually, there is no need to use max_brightness in the platform data.
All LP855x devices have 8-bit brightness control register.
Simply, value of max_brightness can be set to 255.

I'll send the patch for this.

Thanks & BR
Milo -

> -----Original Message-----
> From: Axel Lin [mailto:axel.lin@gmail.com]
> Sent: Sunday, February 19, 2012 4:08 PM
> To: linux-kernel@vger.kernel.org
> Cc: Richard Purdie; Kim, Milo; Andrew Morton
> Subject: [PATCH] drivers/video/backlight/lp855x_bl.c: fix setting
> initial value for max_brightness and brightness
> 
> Current code does not always ensure
> pdata->initial_brightness <= pdata->max_brightness <= MAX_BRIGHTNESS.
> Fix it.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/video/backlight/lp855x_bl.c |   11 ++++++++---
>  1 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/video/backlight/lp855x_bl.c
> b/drivers/video/backlight/lp855x_bl.c
> index d32c097..29a3af2 100644
> --- a/drivers/video/backlight/lp855x_bl.c
> +++ b/drivers/video/backlight/lp855x_bl.c
> @@ -24,6 +24,7 @@
> 
>  #define BUF_SIZE		(20)
>  #define DEFAULT_BL_NAME		"lcd-backlight"
> +#define MAX_BRIGHTNESS		255
> 
>  struct lp855x {
>  	const char *chipid;
> @@ -171,10 +172,14 @@ static int lp855x_backlight_register(struct
> lp855x *lp)
>  	char *name = pdata->name ? : DEFAULT_BL_NAME;
> 
>  	props.type = BACKLIGHT_PLATFORM;
> +
> +	if (pdata->max_brightness > MAX_BRIGHTNESS)
> +		pdata->max_brightness = MAX_BRIGHTNESS;
> +	props.max_brightness = pdata->max_brightness;
> +
> +	if (pdata->initial_brightness > pdata->max_brightness)
> +		pdata->initial_brightness = pdata->max_brightness;
>  	props.brightness = pdata->initial_brightness;
> -	props.max_brightness =
> -		(pdata->max_brightness < pdata->initial_brightness) ?
> -		255 : pdata->max_brightness;
> 
>  	bl = backlight_device_register(name, lp->dev, lp,
>  				       &lp855x_bl_ops, &props);
> --
> 1.7.5.4
> 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
