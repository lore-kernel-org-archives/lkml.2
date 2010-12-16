Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab0LPNHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 08:07:31 -0500
Received: from smtp.nokia.com ([147.243.1.48]:59349 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454Ab0LPNHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 08:07:30 -0500
Subject: Re: [PATCH] leds-lp5521: modify the way of setting led device name
From: Onkalo Samu <samu.p.onkalo@nokia.com>
Reply-To: samu.p.onkalo@nokia.com
To: ext Arun Murthy <arun.murthy@stericsson.com>
Cc: akpm@linux-foundation.org, rpurdie@rpsys.net, linus.walleij@stericsson.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <1292414108-2445-1-git-send-email-arun.murthy@stericsson.com>
References: <1292414108-2445-1-git-send-email-arun.murthy@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia Oyj
Date: Thu, 16 Dec 2010 15:07:16 +0200
Message-ID: <1292504836.7561.3.camel@kolo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-15 at 17:25 +0530, ext Arun Murthy wrote:
> Currently the led device name is fetched from the device_type in
> I2C_BOARD_INFO which comes from the platform data. This name is in turn
> used to create an entry in sysfs.
> 
> If there exists two or more lp5521 on a particular platform, the
> device_type in I2C_BOARD_INFO has to be the same, else lp5521 driver
> probe wont be called and if used so, results in run time warning "cannot
> create sysfs with same name" and hence a failure.
> 
> The name that is used to create sysfs entry is to be passed by the
> struct led_platform_data. Hence adding an element of type const char *
> and change in lp5521 driver to use this name in creating the led device
> if present else use the name obtained by I2C_BOARD_INFO.
> 
> Signed-off-by: Arun Murthy <arun.murthy@stericsson.com>

Looks ok.

I'll make similar patch for lp5523 at some point.

Acked-by: Samu Onkalo <samu.p.onkalo@nokia.com>

> ---
>  drivers/leds/leds-lp5521.c  |    3 ++-
>  include/linux/leds-lp5521.h |    1 +
>  2 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
> index 33facd0..745ad99 100644
> --- a/drivers/leds/leds-lp5521.c
> +++ b/drivers/leds/leds-lp5521.c
> @@ -651,7 +651,8 @@ static int __init lp5521_init_led(struct lp5521_led *led,
>  		return -EINVAL;
>  	}
>  
> -	snprintf(name, sizeof(name), "%s:channel%d", client->name, chan);
> +	snprintf(name, sizeof(name), "%s:channel%d",
> +			pdata->label ?: client->name, chan);
>  	led->cdev.brightness_set = lp5521_set_brightness;
>  	led->cdev.name = name;
>  	res = led_classdev_register(dev, &led->cdev);
> diff --git a/include/linux/leds-lp5521.h b/include/linux/leds-lp5521.h
> index 38368d7..fd548d2 100644
> --- a/include/linux/leds-lp5521.h
> +++ b/include/linux/leds-lp5521.h
> @@ -42,6 +42,7 @@ struct lp5521_platform_data {
>  	int	(*setup_resources)(void);
>  	void	(*release_resources)(void);
>  	void	(*enable)(bool state);
> +	const char *label;
>  };
>  
>  #endif /* __LINUX_LP5521_H */


