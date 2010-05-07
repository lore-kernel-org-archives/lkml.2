Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab0EGQH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 12:07:27 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:57480 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756906Ab0EGQHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 12:07:23 -0400
Date: Fri, 7 May 2010 18:07:16 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Oliver Neukum <oneukum@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Eric Piel <eric.piel@tremplin-utc.net>,
       Pavel Herrmann <morpheus.ibis@gmail.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [patch]hp_accel: Fix race in device removal
Message-ID: <20100507160716.GA1506@elf.ucw.cz>
References: <201005071804.20462.oneukum@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005071804.20462.oneukum@suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2010-05-07 18:04:20, Oliver Neukum wrote:
> From 505056649f5ecb1ebb086981243b9870ce961a87 Mon Sep 17 00:00:00 2001
> From: Oliver Neukum <oliver@neukum.org>
> Date: Fri, 7 May 2010 18:02:07 +0200
> Subject: [PATCH] hp_accel: Fix race in device removal
> 
> The work queue has to be flushed after the device has been made
> inaccessible.
> 
> Signed-off-by: Oliver Neukum <oneukum@suse.de>

ACK.
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

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
