Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab0DEASL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 20:18:11 -0400
Received: from vms173007pub.verizon.net ([206.46.173.7]:14474 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab0DEASE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 20:18:04 -0400
Date: Sun, 04 Apr 2010 20:17:43 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>, Greg KH <gregkh@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH] Fix key f70f4b50 not in .data in thermal_sys V2
In-reply-to: <20100322144503.GD3388@swordfish.minsk.epam.com>
Message-id: <alpine.LFD.2.00.1004042017400.4155@localhost.localdomain>
References: <20100309102754.GA3316@swordfish.minsk.epam.com>
 <20100309141826.GC28606@suse.de>
 <20100322135235.GA3388@swordfish.minsk.epam.com>
 <20100322140713.GB1076@pengutronix.de>
 <20100322144503.GD3388@swordfish.minsk.epam.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied

thanks,
Len Brown, Intel Open Source Technology Center

On Mon, 22 Mar 2010, Sergey Senozhatsky wrote:

> 
> Initialize sysfs attributes before device_create_file call.
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> ---
> 
> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> index 5066de5..ecb181d 100644
> --- a/drivers/thermal/thermal_sys.c
> +++ b/drivers/thermal/thermal_sys.c
> @@ -505,6 +505,7 @@ thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
>  	tz->temp_input.attr.attr.name = tz->temp_input.name;
>  	tz->temp_input.attr.attr.mode = 0444;
>  	tz->temp_input.attr.show = temp_input_show;
> +	sysfs_attr_init(&tz->temp_input.attr.attr);
>  	result = device_create_file(hwmon->device, &tz->temp_input.attr);
>  	if (result)
>  		goto unregister_hwmon_device;
> @@ -517,6 +518,7 @@ thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
>  			tz->temp_crit.attr.attr.name = tz->temp_crit.name;
>  			tz->temp_crit.attr.attr.mode = 0444;
>  			tz->temp_crit.attr.show = temp_crit_show;
> +			sysfs_attr_init(&tz->temp_crit.attr.attr);
>  			result = device_create_file(hwmon->device,
>  						    &tz->temp_crit.attr);
>  			if (result)
> @@ -725,6 +727,7 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
>  		goto release_idr;
>  
>  	sprintf(dev->attr_name, "cdev%d_trip_point", dev->id);
> +	sysfs_attr_init(&dev->attr.attr);
>  	dev->attr.attr.name = dev->attr_name;
>  	dev->attr.attr.mode = 0444;
>  	dev->attr.show = thermal_cooling_device_trip_point_show;
> 
> 
