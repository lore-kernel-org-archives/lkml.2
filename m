Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab1EIPv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 11:51:26 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:35276 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752105Ab1EIPvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 11:51:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Y5dUSAV7AWe7YnQcxWHVXbZlmmT4v7xRxKW7UywqbGBACPZKin13RAebMO2yumBXkMEfsuEbkAMyrypfAQ+UYw72rTu39BxzZcNlyEvYXpz9F8tYjkedVSP4JYy6w5Bf;
Date: Mon, 9 May 2011 08:51:22 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Esben Haabendal <eha@doredevelopment.dk>
Cc: akpm@linux-foundation.org, Richard Purdie <rpurdie@rpsys.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds: fix build with CONFIG_LEDS_TRIGGERS disabled
Message-Id: <20110509085122.cc5ec6e5.rdunlap@xenotime.net>
In-Reply-To: <1304932578-14501-1-git-send-email-eha@doredevelopment.dk>
References: <20110506182341.d2cd8a19.rdunlap@xenotime.net>
	<1304932578-14501-1-git-send-email-eha@doredevelopment.dk>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  9 May 2011 11:16:18 +0200 Esben Haabendal wrote:

> Add led_get_trigger_data() function for stubbing out access to trigger_data
> when CONFIG_LEDS_TRIGGERS is disabled.  This fixes builds with
> CONFIG_LEDS_CLASS enabled, which were broken by
> leds-support-automatic-start-of-blinking-with-ledtrig-timer.patch
> 
> Signed-off-by: Esben Haabendal <eha@doredevelopment.dk>

Acked-by: Randy Dunlap <rdunlap@xenotime.net>


Thanks.


> ---
>  drivers/leds/led-class.c |    2 +-
>  drivers/leds/leds.h      |    7 +++++++
>  2 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
> index d7bdef8..dc3d3d8 100644
> --- a/drivers/leds/led-class.c
> +++ b/drivers/leds/led-class.c
> @@ -131,7 +131,7 @@ static void led_set_software_blink(struct led_classdev *led_cdev,
>  	if (!led_cdev->blink_brightness)
>  		led_cdev->blink_brightness = led_cdev->max_brightness;
>  
> -	if (led_cdev->trigger_data &&
> +	if (led_get_trigger_data(led_cdev) &&
>  	    delay_on == led_cdev->blink_delay_on &&
>  	    delay_off == led_cdev->blink_delay_off)
>  		return;
> diff --git a/drivers/leds/leds.h b/drivers/leds/leds.h
> index 2dd8ecb..e77c7f8 100644
> --- a/drivers/leds/leds.h
> +++ b/drivers/leds/leds.h
> @@ -40,10 +40,17 @@ void led_trigger_set_default(struct led_classdev *led_cdev);
>  void led_trigger_set(struct led_classdev *led_cdev,
>  			struct led_trigger *trigger);
>  void led_trigger_remove(struct led_classdev *led_cdev);
> +
> +static inline void *led_get_trigger_data(struct led_classdev *led_cdev)
> +{
> +	return led_cdev->trigger_data;
> +}
> +
>  #else
>  #define led_trigger_set_default(x) do {} while (0)
>  #define led_trigger_set(x, y) do {} while (0)
>  #define led_trigger_remove(x) do {} while (0)
> +#define led_get_trigger_data(x) (NULL)
>  #endif
>  
>  ssize_t led_trigger_store(struct device *dev, struct device_attribute *attr,
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
