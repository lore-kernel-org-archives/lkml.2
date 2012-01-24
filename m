Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab2AXXja (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 18:39:30 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:16875 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322Ab2AXXj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 18:39:28 -0500
Date: Wed, 25 Jan 2012 00:39:32 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Joe Perches <joe@perches.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Len Brown <len.brown@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] thermal_sys: Kernel style cleanups
In-Reply-To: <a46c632553c17d7499e6f3d4a5d5daf76fdc49ca.1327447797.git.joe@perches.com>
Message-ID: <alpine.LNX.2.00.1201250038070.27508@swampdragon.chaosbits.net>
References: <cover.1327447797.git.joe@perches.com> <a46c632553c17d7499e6f3d4a5d5daf76fdc49ca.1327447797.git.joe@perches.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jan 2012, Joe Perches wrote:

> Just a few tidies to make it more like most
> kernel sources.
> 
> A couple of long lines still remain.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/thermal/thermal_sys.c |   30 +++++++++++++-----------------
>  1 files changed, 13 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> index 1c87167..68df616 100644
> --- a/drivers/thermal/thermal_sys.c
> +++ b/drivers/thermal/thermal_sys.c
> @@ -66,7 +66,7 @@ static int get_idr(struct idr *idr, struct mutex *lock, int *id)
>  {
>  	int err;
>  
> -      again:
> +again:
>  	if (unlikely(idr_pre_get(idr, GFP_KERNEL) == 0))
>  		return -ENOMEM;
>  
> @@ -818,15 +818,14 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
>  		return 0;
>  
>  	device_remove_file(&tz->device, &dev->attr);
> -      remove_symbol_link:
> +remove_symbol_link:
>  	sysfs_remove_link(&tz->device.kobj, dev->name);
> -      release_idr:
> +release_idr:
>  	release_idr(&tz->idr, &tz->lock, dev->id);
> -      free_mem:
> +free_mem:
>  	kfree(dev);
>  	return result;
>  }
> -
>  EXPORT_SYMBOL(thermal_zone_bind_cooling_device);
>  
>  /**
> @@ -856,14 +855,13 @@ int thermal_zone_unbind_cooling_device(struct thermal_zone_device *tz,
>  
>  	return -ENODEV;
>  
> -      unbind:
> +unbind:
>  	device_remove_file(&tz->device, &pos->attr);
>  	sysfs_remove_link(&tz->device.kobj, pos->name);
>  	release_idr(&tz->idr, &tz->lock, pos->id);
>  	kfree(pos);
>  	return 0;
>  }
> -
>  EXPORT_SYMBOL(thermal_zone_unbind_cooling_device);
>  
>  static void thermal_release(struct device *dev)
> @@ -871,7 +869,8 @@ static void thermal_release(struct device *dev)
>  	struct thermal_zone_device *tz;
>  	struct thermal_cooling_device *cdev;
>  
> -	if (!strncmp(dev_name(dev), "thermal_zone", sizeof "thermal_zone" - 1)) {
> +	if (!strncmp(dev_name(dev), "thermal_zone",
> +		     sizeof("thermal_zone") - 1)) {
>  		tz = to_thermal_zone(dev);
>  		kfree(tz);
>  	} else {
> @@ -891,8 +890,9 @@ static struct class thermal_class = {
>   * @devdata:	device private data.
>   * @ops:		standard thermal cooling devices callbacks.
>   */
> -struct thermal_cooling_device *thermal_cooling_device_register(
> -     char *type, void *devdata, const struct thermal_cooling_device_ops *ops)
> +struct thermal_cooling_device *
> +thermal_cooling_device_register(char *type, void *devdata,
> +				const struct thermal_cooling_device_ops *ops)
>  {
>  	struct thermal_cooling_device *cdev;
>  	struct thermal_zone_device *pos;
> @@ -957,12 +957,11 @@ struct thermal_cooling_device *thermal_cooling_device_register(
>  	if (!result)
>  		return cdev;
>  
> -      unregister:
> +unregister:
>  	release_idr(&thermal_cdev_idr, &thermal_idr_lock, cdev->id);
>  	device_unregister(&cdev->device);
>  	return ERR_PTR(result);
>  }
> -
>  EXPORT_SYMBOL(thermal_cooling_device_register);
>  
>  /**
> @@ -1007,7 +1006,6 @@ void thermal_cooling_device_unregister(struct
>  	device_unregister(&cdev->device);
>  	return;
>  }
> -
>  EXPORT_SYMBOL(thermal_cooling_device_unregister);
>  
>  /**
> @@ -1083,7 +1081,7 @@ void thermal_zone_device_update(struct thermal_zone_device *tz)
>  
>  	tz->last_temperature = temp;
>  
> -      leave:
> +leave:
>  	if (tz->passive)
>  		thermal_zone_device_set_polling(tz, tz->passive_delay);
>  	else if (tz->polling_delay)
> @@ -1223,12 +1221,11 @@ struct thermal_zone_device *thermal_zone_device_register(char *type,
>  	if (!result)
>  		return tz;
>  
> -      unregister:
> +unregister:
>  	release_idr(&thermal_tz_idr, &thermal_idr_lock, tz->id);
>  	device_unregister(&tz->device);
>  	return ERR_PTR(result);
>  }
> -
>  EXPORT_SYMBOL(thermal_zone_device_register);
>  
>  /**
> @@ -1280,7 +1277,6 @@ void thermal_zone_device_unregister(struct thermal_zone_device *tz)
>  	device_unregister(&tz->device);
>  	return;
>  }
> -
>  EXPORT_SYMBOL(thermal_zone_device_unregister);
>  
>  #ifdef CONFIG_NET
> 

Looks like a sane set of changes to me.
Reviewed-by: Jesper Juhl <jj@chaosbits.net>


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

