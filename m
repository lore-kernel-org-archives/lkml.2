Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab0LJOoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 09:44:24 -0500
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:58180 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab0LJOoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 09:44:23 -0500
Subject: Re: [PATCH] LEDs: fix check for return value of blink_set callback
From: Richard Purdie <rpurdie@linux.intel.com>
To: Vasily Khoruzhick <anarsoul@gmail.com>, akpm <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1291975133-25671-1-git-send-email-anarsoul@gmail.com>
References: <1291975133-25671-1-git-send-email-anarsoul@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Dec 2010 14:43:56 +0000
Message-ID: <1291992236.14420.3.camel@rex>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-10 at 11:58 +0200, Vasily Khoruzhick wrote:
> blink_set callback should return 0 on success, but check in
> led-class.c is invalid. It results in software fallback even if
> hw support is available.
> 
> Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>

Acked-by: Richard Purdie <rpurdie@linux.intel.com>

> ---
>  drivers/leds/led-class.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
> index 211e21f..d5a4ade 100644
> --- a/drivers/leds/led-class.c
> +++ b/drivers/leds/led-class.c
> @@ -267,7 +267,7 @@ void led_blink_set(struct led_classdev *led_cdev,
>  		   unsigned long *delay_off)
>  {
>  	if (led_cdev->blink_set &&
> -	    led_cdev->blink_set(led_cdev, delay_on, delay_off))
> +	    !led_cdev->blink_set(led_cdev, delay_on, delay_off))
>  		return;
>  
>  	/* blink with 1 Hz as default if nothing specified */


