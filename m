Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194Ab1DGXeb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 19:34:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50764 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753038Ab1DGXea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 19:34:30 -0400
Date: Thu, 7 Apr 2011 16:34:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: eha@doredevelopment.dk
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH] leds: Support automatic start of blinking with
 ledtrig-timer
Message-Id: <20110407163415.0eb0f545.akpm@linux-foundation.org>
In-Reply-To: <1300446199-3234-1-git-send-email-eha@doredevelopment.dk>
References: <1300446199-3234-1-git-send-email-eha@doredevelopment.dk>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Mar 2011 12:03:19 +0100
eha@doredevelopment.dk wrote:

> From: Esben Haabendal <eha@doredevelopment.dk>
> 
> By setting initial values blink_delay_on and blink_delay_off in a
> led_classdev struct, this change starts the blinking when the led
> is initialized.
> 
> Signed-off-by: Esben Haabendal <eha@doredevelopment.dk>
> ---
>  drivers/leds/led-class.c     |    3 ++-
>  drivers/leds/ledtrig-timer.c |    3 +++
>  2 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
> index d5a4ade..d7bdef8 100644
> --- a/drivers/leds/led-class.c
> +++ b/drivers/leds/led-class.c
> @@ -131,7 +131,8 @@ static void led_set_software_blink(struct led_classdev *led_cdev,
>  	if (!led_cdev->blink_brightness)
>  		led_cdev->blink_brightness = led_cdev->max_brightness;
>  
> -	if (delay_on == led_cdev->blink_delay_on &&
> +	if (led_cdev->trigger_data &&
> +	    delay_on == led_cdev->blink_delay_on &&
>  	    delay_off == led_cdev->blink_delay_off)
>  		return;
>  
> diff --git a/drivers/leds/ledtrig-timer.c b/drivers/leds/ledtrig-timer.c
> index b09bcbe..d87c9d0 100644
> --- a/drivers/leds/ledtrig-timer.c
> +++ b/drivers/leds/ledtrig-timer.c
> @@ -91,6 +91,9 @@ static void timer_trig_activate(struct led_classdev *led_cdev)
>  	if (rc)
>  		goto err_out_delayon;
>  
> +	led_blink_set(led_cdev, &led_cdev->blink_delay_on,
> +		      &led_cdev->blink_delay_off);
> +
>  	led_cdev->trigger_data = (void *)1;
>  
>  	return;

It's unclear (to me) exactly what this patch does.  Could you please
send a more complete description of the user-visible change in
behaviour?

Thanks.
