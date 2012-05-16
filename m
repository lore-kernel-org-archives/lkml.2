Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965708Ab2EPUGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 16:06:23 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36981 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965355Ab2EPUGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 16:06:21 -0400
Message-ID: <4FB408B6.6010100@gmail.com>
Date: Wed, 16 May 2012 22:06:14 +0200
From: Kristoffer Eriksson <kristoffer.ericson@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>
Subject: Re: [PATCH 5/7] backlight: jornada720: use pr_err/info instead of
 printk
References: <001001cd3270$1d000940$57001bc0$%han@samsung.com>
In-Reply-To: <001001cd3270$1d000940$57001bc0$%han@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jingoo Han skrev 2012-05-15 09:55:
> This patch uses pr_err/info instead of printk to allow dynamic debugging.
> It also fixes checkpatch warnings as below:
>
> WARNING: Prefer pr_err(... to printk(KERN_ERR, ...
> WARNING: Prefer pr_info(... to printk(KERN_INFO, ...
>
> Cc: Kristoffer Ericson<kristoffer.ericson@gmail.com>
> Cc: Richard Purdie<rpurdie@rpsys.net>
> Signed-off-by: Jingoo Han<jg1.han@samsung.com>
> ---
Sorry this mail fell didnt fall out in my mail filter settings.
Acked and Thx.

Acked-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>





>   drivers/video/backlight/jornada720_bl.c  |   12 ++++++------
>   drivers/video/backlight/jornada720_lcd.c |    6 +++---
>   2 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/video/backlight/jornada720_bl.c b/drivers/video/backlight/jornada720_bl.c
> index 2f8af5d..a3c5c0e 100644
> --- a/drivers/video/backlight/jornada720_bl.c
> +++ b/drivers/video/backlight/jornada720_bl.c
> @@ -38,7 +38,7 @@ static int jornada_bl_get_brightness(struct backlight_device *bd)
>   	ret = jornada_ssp_byte(GETBRIGHTNESS);
>
>   	if (jornada_ssp_byte(GETBRIGHTNESS) != TXDUMMY) {
> -		printk(KERN_ERR "bl : get brightness timeout\n");
> +		pr_err("bl : get brightness timeout\n");
>   		jornada_ssp_end();
>   		return -ETIMEDOUT;
>   	} else /* exchange txdummy for value */
> @@ -59,7 +59,7 @@ static int jornada_bl_update_status(struct backlight_device *bd)
>   	if ((bd->props.power != FB_BLANK_UNBLANK) || (bd->props.fb_blank != FB_BLANK_UNBLANK)) {
>   		ret = jornada_ssp_byte(BRIGHTNESSOFF);
>   		if (ret != TXDUMMY) {
> -			printk(KERN_INFO "bl : brightness off timeout\n");
> +			pr_info("bl : brightness off timeout\n");
>   			/* turn off backlight */
>   			PPSR&= ~PPC_LDD1;
>   			PPDR |= PPC_LDD1;
> @@ -70,7 +70,7 @@ static int jornada_bl_update_status(struct backlight_device *bd)
>
>   		/* send command to our mcu */
>   		if (jornada_ssp_byte(SETBRIGHTNESS) != TXDUMMY) {
> -			printk(KERN_INFO "bl : failed to set brightness\n");
> +			pr_info("bl : failed to set brightness\n");
>   			ret = -ETIMEDOUT;
>   			goto out;
>   		}
> @@ -81,7 +81,7 @@ static int jornada_bl_update_status(struct backlight_device *bd)
>   		   but due to physical layout it is equal to 0, so we simply
>   		   invert the value (MAX VALUE - NEW VALUE). */
>   		if (jornada_ssp_byte(BL_MAX_BRIGHT - bd->props.brightness) != TXDUMMY) {
> -			printk(KERN_ERR "bl : set brightness failed\n");
> +			pr_err("bl : set brightness failed\n");
>   			ret = -ETIMEDOUT;
>   		}
>
> @@ -113,7 +113,7 @@ static int jornada_bl_probe(struct platform_device *pdev)
>
>   	if (IS_ERR(bd)) {
>   		ret = PTR_ERR(bd);
> -		printk(KERN_ERR "bl : failed to register device, err=%x\n", ret);
> +		pr_err("bl : failed to register device, err=%x\n", ret);
>   		return ret;
>   	}
>
> @@ -125,7 +125,7 @@ static int jornada_bl_probe(struct platform_device *pdev)
>   	jornada_bl_update_status(bd);
>
>   	platform_set_drvdata(pdev, bd);
> -	printk(KERN_INFO "HP Jornada 700 series backlight driver\n");
> +	pr_info("HP Jornada 700 series backlight driver\n");
>
>   	return 0;
>   }
> diff --git a/drivers/video/backlight/jornada720_lcd.c b/drivers/video/backlight/jornada720_lcd.c
> index 22d231a..b8f2115 100644
> --- a/drivers/video/backlight/jornada720_lcd.c
> +++ b/drivers/video/backlight/jornada720_lcd.c
> @@ -44,7 +44,7 @@ static int jornada_lcd_get_contrast(struct lcd_device *dev)
>   	jornada_ssp_start();
>
>   	if (jornada_ssp_byte(GETCONTRAST) != TXDUMMY) {
> -		printk(KERN_ERR "lcd: get contrast failed\n");
> +		pr_err("lcd: get contrast failed\n");
>   		jornada_ssp_end();
>   		return -ETIMEDOUT;
>   	} else {
> @@ -65,7 +65,7 @@ static int jornada_lcd_set_contrast(struct lcd_device *dev, int value)
>
>   	/* push the new value */
>   	if (jornada_ssp_byte(value) != TXDUMMY) {
> -		printk(KERN_ERR "lcd : set contrast failed\n");
> +		pr_err("lcd : set contrast failed\n");
>   		jornada_ssp_end();
>   		return -ETIMEDOUT;
>   	}
> @@ -103,7 +103,7 @@ static int jornada_lcd_probe(struct platform_device *pdev)
>
>   	if (IS_ERR(lcd_device)) {
>   		ret = PTR_ERR(lcd_device);
> -		printk(KERN_ERR "lcd : failed to register device\n");
> +		pr_err("lcd : failed to register device\n");
>   		return ret;
>   	}
>

