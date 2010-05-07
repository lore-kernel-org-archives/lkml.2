Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab0EGPyI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 11:54:08 -0400
Received: from poutre.nerim.net ([62.4.16.124]:57771 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755408Ab0EGPyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 11:54:06 -0400
Date: Fri, 7 May 2010 17:54:01 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Oliver Neukum <oneukum@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Eric Piel <eric.piel@tremplin-utc.net>,
       Pavel Herrmann <morpheus.ibis@gmail.com>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org, Pavel Machek <pavel@ucw.cz>,
       stable@kernel.org
Subject: Re: [lm-sensors] [patch]hp_accel: Fix race in device removal
Message-ID: <20100507175401.3099fdef@hyperion.delvare>
In-Reply-To: <201005071747.40801.oneukum@suse.de>
References: <201005071747.40801.oneukum@suse.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver,

On Fri, 7 May 2010 17:47:40 +0200, Oliver Neukum wrote:
> From 64a9e0d8e585c65526248e6cf1659a13fb01a93a Mon Sep 17 00:00:00 2001
> From: Oliver Neukum <oliver@neukum.org>
> Date: Fri, 7 May 2010 17:41:59 +0200
> Subject: [PATCH] hp_accel: Fix race in device removal
> 
> The work queue has to be flushed after the device has been made
> inaccessible.
> 
> Signed-off-by: Oliver Neukum <oneukum@suse.de>
> ---
>  drivers/hwmon/hp_accel.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hwmon/hp_accel.c b/drivers/hwmon/hp_accel.c
> index c8ab505..6f6e05d 100644
> --- a/drivers/hwmon/hp_accel.c
> +++ b/drivers/hwmon/hp_accel.c
> @@ -328,9 +328,9 @@ static int lis3lv02d_remove(struct acpi_device *device, int type)
>  	lis3lv02d_joystick_disable();
>  	lis3lv02d_poweroff(&lis3_dev);
>  
> -	flush_work(&hpled_led.work);
>  	led_classdev_unregister(&hpled_led.led_classdev);
> -
> +	flush_work(&hpled_led.work);
> +	
>  	return lis3lv02d_remove_fs(&lis3_dev);
>  }
>  

You are adding trailing white space. Please don't. Use
scripts/checkpatch.pl to check your patches before you send them.

-- 
Jean Delvare
