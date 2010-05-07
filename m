Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab0EGQKJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 12:10:09 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:57466 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab0EGQKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 12:10:03 -0400
X-Spam-Flag: NO
X-Spam-Score: -24.389
Message-ID: <4BE43B53.9060502@tremplin-utc.net>
Date: Fri, 07 May 2010 18:09:55 +0200
From: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100422 Mandriva/3.0.4-6mdv2010.1 (2010.1) Thunderbird/3.0.4
MIME-Version: 1.0
To: Oliver Neukum <oneukum@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       Pavel Herrmann <morpheus.ibis@gmail.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [patch]hp_accel: Fix race in device removal
References: <201005071804.20462.oneukum@suse.de>
In-Reply-To: <201005071804.20462.oneukum@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 07-05-10 18:04, Oliver Neukum schreef:
> From 505056649f5ecb1ebb086981243b9870ce961a87 Mon Sep 17 00:00:00 2001
> From: Oliver Neukum <oliver@neukum.org>
> Date: Fri, 7 May 2010 18:02:07 +0200
> Subject: [PATCH] hp_accel: Fix race in device removal
> 
> The work queue has to be flushed after the device has been made
> inaccessible.
> 
> Signed-off-by: Oliver Neukum <oneukum@suse.de>
Ah, flushing the work before unregistering the device seemed more
logical... but now that you mention it, I understand the race.

Thanks

Acked-by: Eric Piel <eric.piel@tremplin-utc.net>


> ---
>  drivers/hwmon/hp_accel.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hwmon/hp_accel.c b/drivers/hwmon/hp_accel.c
> index c8ab505..7580f55 100644
> --- a/drivers/hwmon/hp_accel.c
> +++ b/drivers/hwmon/hp_accel.c
> @@ -328,8 +328,8 @@ static int lis3lv02d_remove(struct acpi_device *device, int type)
>  	lis3lv02d_joystick_disable();
>  	lis3lv02d_poweroff(&lis3_dev);
>  
> -	flush_work(&hpled_led.work);
>  	led_classdev_unregister(&hpled_led.led_classdev);
> +	flush_work(&hpled_led.work);
>  
>  	return lis3lv02d_remove_fs(&lis3_dev);
>  }

