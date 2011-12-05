Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab1LEEAF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 23:00:05 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:43944 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab1LEEAD (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Sun, 4 Dec 2011 23:00:03 -0500
Subject: Re: [PATCH 1/2] acer-wmi: Message logging neatening
From: joeyli <jlee@suse.com>
To: Joe Perches <joe@perches.com>
Cc: Joey Lee <jlee@novell.com>, Matthew Garrett <mjg@redhat.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <9be2717594eec36bdcc072a90d81b044500270e4.1322593277.git.joe@perches.com>
References: <9be2717594eec36bdcc072a90d81b044500270e4.1322593277.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Dec 2011 11:57:28 +0800
Message-ID: <1323057448.6046.81.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe, 

於 二，2011-11-29 於 11:04 -0800，Joe Perches 提到：
> Use pr_warn not pr_warning.
> Coalesce formats.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/platform/x86/acer-wmi.c |   29 ++++++++++++++---------------
>  1 files changed, 14 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
> index b848277..ea48346 100644
> --- a/drivers/platform/x86/acer-wmi.c
> +++ b/drivers/platform/x86/acer-wmi.c
> @@ -978,7 +978,7 @@ static acpi_status wmid3_set_device_status(u32 value, u16 device)
>  		return AE_ERROR;
>  	}
>  	if (obj->buffer.length != 8) {
> -		pr_warning("Unknown buffer length %d\n", obj->buffer.length);
> +		pr_warn("Unknown buffer length %d\n", obj->buffer.length);
>  		kfree(obj);
>  		return AE_ERROR;
>  	}
> @@ -987,8 +987,8 @@ static acpi_status wmid3_set_device_status(u32 value, u16 device)
>  	kfree(obj);
>  
>  	if (return_value.error_code || return_value.ec_return_value) {
> -		pr_warning("Get Current Device Status failed: "
> -			"0x%x - 0x%x\n", return_value.error_code,
> +		pr_warn("Get Current Device Status failed: 0x%x - 0x%x\n",
> +			return_value.error_code,
>  			return_value.ec_return_value);
>  		return status;
>  	}
> @@ -1011,7 +1011,7 @@ static acpi_status wmid3_set_device_status(u32 value, u16 device)
>  		return AE_ERROR;
>  	}
>  	if (obj->buffer.length != 4) {
> -		pr_warning("Unknown buffer length %d\n", obj->buffer.length);
> +		pr_warn("Unknown buffer length %d\n", obj->buffer.length);
>  		kfree(obj);
>  		return AE_ERROR;
>  	}
> @@ -1020,8 +1020,8 @@ static acpi_status wmid3_set_device_status(u32 value, u16 device)
>  	kfree(obj);
>  
>  	if (return_value.error_code || return_value.ec_return_value)
> -		pr_warning("Set Device Status failed: "
> -			"0x%x - 0x%x\n", return_value.error_code,
> +		pr_warn("Set Device Status failed: 0x%x - 0x%x\n",
> +			return_value.error_code,
>  			return_value.ec_return_value);
>  
>  	return status;
> @@ -1460,8 +1460,8 @@ static ssize_t show_bool_threeg(struct device *dev,
>  	u32 result; \
>  	acpi_status status;
>  
> -	pr_info("This threeg sysfs will be removed in 2012"
> -		" - used by: %s\n", current->comm);
> +	pr_info("This threeg sysfs will be removed in 2012 - used by: %s\n",
> +		current->comm);
>  	status = get_u32(&result, ACER_CAP_THREEG);
>  	if (ACPI_SUCCESS(status))
>  		return sprintf(buf, "%u\n", result);
> @@ -1473,8 +1473,8 @@ static ssize_t set_bool_threeg(struct device *dev,
>  {
>  	u32 tmp = simple_strtoul(buf, NULL, 10);
>  	acpi_status status = set_u32(tmp, ACER_CAP_THREEG);
> -	pr_info("This threeg sysfs will be removed in 2012"
> -		" - used by: %s\n", current->comm);
> +	pr_info("This threeg sysfs will be removed in 2012 - used by: %s\n",
> +		current->comm);
>  	if (ACPI_FAILURE(status))
>  		return -EINVAL;
>  	return count;
> @@ -1485,8 +1485,8 @@ static DEVICE_ATTR(threeg, S_IRUGO | S_IWUSR, show_bool_threeg,
>  static ssize_t show_interface(struct device *dev, struct device_attribute *attr,
>  	char *buf)
>  {
> -	pr_info("This interface sysfs will be removed in 2012"
> -		" - used by: %s\n", current->comm);
> +	pr_info("This interface sysfs will be removed in 2012 - used by: %s\n",
> +		current->comm);
>  	switch (interface->type) {
>  	case ACER_AMW0:
>  		return sprintf(buf, "AMW0\n");
> @@ -1954,8 +1954,7 @@ static int __init acer_wmi_init(void)
>  
>  	if (acpi_video_backlight_support()) {
>  		interface->capability &= ~ACER_CAP_BRIGHTNESS;
> -		pr_info("Brightness must be controlled by "
> -		       "generic video driver\n");
> +		pr_info("Brightness must be controlled by generic video driver\n");
>  	}
>  
>  	if (wmi_has_guid(WMID_GUID3)) {
> @@ -1980,7 +1979,7 @@ static int __init acer_wmi_init(void)
>  
>  	err = platform_driver_register(&acer_platform_driver);
>  	if (err) {
> -		pr_err("Unable to register platform driver.\n");
> +		pr_err("Unable to register platform driver\n");
>  		goto error_platform_register;
>  	}
>  

Patch good to me.

Signed-off-by: Lee, Chun-Yi <jlee@suse.com>


Thanks
Joey Lee

