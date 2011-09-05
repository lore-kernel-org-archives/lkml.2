Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab1IER4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 13:56:05 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54946 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab1IER4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 13:56:00 -0400
From: Florian Fainelli <f.fainelli@gmail.com>
To: Johan Hovold <jhovold@gmail.com>
Subject: Re: [PATCH] leds: ledtrig-timer: fix broken sysfs delay handling
Date: Mon, 5 Sep 2011 19:55:43 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38-11-server; KDE/4.6.2; x86_64; ; )
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Johannes Berg <johannes.berg@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@kernel.org
References: <1315236783-513-1-git-send-email-jhovold@gmail.com>
In-Reply-To: <1315236783-513-1-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109051955.43420.f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 September 2011 17:33:03 Johan Hovold wrote:
> Fix regression introduced by commit
> 5ada28bf76752e33dce3d807bf0dfbe6d1b943ad (led-class: always implement
> blinking) which broke sysfs delay handling by not storing the updated
> value. Consequently it was only possible to set one of the delays
> through the sysfs interface as the other delay was automatically
> restored to it's default value. Reading the parameters always gave the
> defaults.
> 
> Cc: stable@kernel.org
> Signed-off-by: Johan Hovold <jhovold@gmail.com>

Acked-by: Florian Fainelli <florian@openwrt.org>

> ---
>  drivers/leds/ledtrig-timer.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/leds/ledtrig-timer.c b/drivers/leds/ledtrig-timer.c
> index d87c9d0..328c64c 100644
> --- a/drivers/leds/ledtrig-timer.c
> +++ b/drivers/leds/ledtrig-timer.c
> @@ -41,6 +41,7 @@ static ssize_t led_delay_on_store(struct device *dev,
> 
>  	if (count == size) {
>  		led_blink_set(led_cdev, &state, &led_cdev->blink_delay_off);
> +		led_cdev->blink_delay_on = state;
>  		ret = count;
>  	}
> 
> @@ -69,6 +70,7 @@ static ssize_t led_delay_off_store(struct device *dev,
> 
>  	if (count == size) {
>  		led_blink_set(led_cdev, &led_cdev->blink_delay_on, &state);
> +		led_cdev->blink_delay_off = state;
>  		ret = count;
>  	}

-- 
Florian
