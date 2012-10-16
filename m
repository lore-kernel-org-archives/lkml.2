Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab2JPPqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 11:46:50 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39380 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952Ab2JPPqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 11:46:48 -0400
Message-ID: <507D8162.2080208@gmail.com>
Date: Tue, 16 Oct 2012 17:46:42 +0200
From: Kristoffer Eriksson <kristoffer.ericson@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>
Subject: Re: [PATCH 08/17] backlight: jornada720: fix checkpatch error and
 warning
References: <007101cdab6f$6c8bc030$45a34090$%han@samsung.com> <007901cdab70$0d7c28e0$28747aa0$%han@samsung.com>
In-Reply-To: <007901cdab70$0d7c28e0$28747aa0$%han@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks,

Acked-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>

Best wishes
Kristoffer Ericson

Jingoo Han skrev 2012-10-16 09:30:
> This patch fixes the checkpatch error and warning as below:
>
> WARNING: line over 80 characters
> ERROR: return is not a function, parentheses are not required
>
> Also, long comments are fixed for the preferred style.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> ---
>   drivers/video/backlight/jornada720_bl.c  |   34 ++++++++++++++++++-----------
>   drivers/video/backlight/jornada720_lcd.c |    3 +-
>   2 files changed, 23 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/video/backlight/jornada720_bl.c b/drivers/video/backlight/jornada720_bl.c
> index 16f593b..c23801c 100644
> --- a/drivers/video/backlight/jornada720_bl.c
> +++ b/drivers/video/backlight/jornada720_bl.c
> @@ -48,7 +48,7 @@ static int jornada_bl_get_brightness(struct backlight_device *bd)
>   
>   	jornada_ssp_end();
>   
> -	return (BL_MAX_BRIGHT - ret);
> +	return BL_MAX_BRIGHT - ret;
>   }
>   
>   static int jornada_bl_update_status(struct backlight_device *bd)
> @@ -58,7 +58,8 @@ static int jornada_bl_update_status(struct backlight_device *bd)
>   	jornada_ssp_start();
>   
>   	/* If backlight is off then really turn it off */
> -	if ((bd->props.power != FB_BLANK_UNBLANK) || (bd->props.fb_blank != FB_BLANK_UNBLANK)) {
> +	if ((bd->props.power != FB_BLANK_UNBLANK) ||
> +		(bd->props.fb_blank != FB_BLANK_UNBLANK)) {
>   		ret = jornada_ssp_byte(BRIGHTNESSOFF);
>   		if (ret != TXDUMMY) {
>   			pr_info("brightness off timeout\n");
> @@ -77,18 +78,23 @@ static int jornada_bl_update_status(struct backlight_device *bd)
>   			goto out;
>   		}
>   
> -		/* at this point we expect that the mcu has accepted
> -		   our command and is waiting for our new value
> -		   please note that maximum brightness is 255,
> -		   but due to physical layout it is equal to 0, so we simply
> -		   invert the value (MAX VALUE - NEW VALUE). */
> -		if (jornada_ssp_byte(BL_MAX_BRIGHT - bd->props.brightness) != TXDUMMY) {
> +		/*
> +		 * at this point we expect that the mcu has accepted
> +		 * our command and is waiting for our new value
> +		 * please note that maximum brightness is 255,
> +		 * but due to physical layout it is equal to 0, so we simply
> +		 * invert the value (MAX VALUE - NEW VALUE).
> +		 */
> +		if (jornada_ssp_byte(BL_MAX_BRIGHT - bd->props.brightness)
> +			!= TXDUMMY) {
>   			pr_err("set brightness failed\n");
>   			ret = -ETIMEDOUT;
>   		}
>   
> -		/* If infact we get an TXDUMMY as output we are happy and dont
> -		   make any further comments about it */
> +		/*
> +		 * If infact we get an TXDUMMY as output we are happy and dont
> +		 * make any further comments about it
> +		 */
>   out:
>   	jornada_ssp_end();
>   
> @@ -121,9 +127,11 @@ static int jornada_bl_probe(struct platform_device *pdev)
>   
>   	bd->props.power = FB_BLANK_UNBLANK;
>   	bd->props.brightness = BL_DEF_BRIGHT;
> -	/* note. make sure max brightness is set otherwise
> -	   you will get seemingly non-related errors when
> -	   trying to change brightness */
> +	/*
> +	 * note. make sure max brightness is set otherwise
> +	 * you will get seemingly non-related errors when
> +	 * trying to change brightness
> +	 */
>   	jornada_bl_update_status(bd);
>   
>   	platform_set_drvdata(pdev, bd);
> diff --git a/drivers/video/backlight/jornada720_lcd.c b/drivers/video/backlight/jornada720_lcd.c
> index 635b305..4b412cb 100644
> --- a/drivers/video/backlight/jornada720_lcd.c
> +++ b/drivers/video/backlight/jornada720_lcd.c
> @@ -101,7 +101,8 @@ static int jornada_lcd_probe(struct platform_device *pdev)
>   	struct lcd_device *lcd_device;
>   	int ret;
>   
> -	lcd_device = lcd_device_register(S1D_DEVICENAME, &pdev->dev, NULL, &jornada_lcd_props);
> +	lcd_device = lcd_device_register(S1D_DEVICENAME, &pdev->dev, NULL,
> +					&jornada_lcd_props);
>   
>   	if (IS_ERR(lcd_device)) {
>   		ret = PTR_ERR(lcd_device);

