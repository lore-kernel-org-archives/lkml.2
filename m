Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab2GFHvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 03:51:35 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:45949 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab2GFHvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 03:51:33 -0400
Subject: Re: [PATCH 2/2] msi-laptop: Use struct dev_pm_ops for power
 management
From: joeyli <jlee@suse.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: platform-driver-x86@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Frank Seidel <frank@f-seidel.de>, "Lee, Chun-Yi" <jlee@novell.com>
In-Reply-To: <201206302357.43405.rjw@sisk.pl>
References: <201206302356.11014.rjw@sisk.pl>
	 <201206302357.43405.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Jul 2012 15:24:40 +0800
Message-ID: <1341559480.4823.176.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 六，2012-06-30 於 23:57 +0200，Rafael J. Wysocki 提到：
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Make the msi-laptop driver define its PM callbacks through
> a struct dev_pm_ops object rather than by using legacy PM hooks
> in struct platform_driver.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>


This patch good to me.

Acked-by: Lee, Chun-Yi <jlee@suse.com>


Thanks a lot!
Joey Lee

> ---
>  drivers/platform/x86/msi-laptop.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> Index: linux/drivers/platform/x86/msi-laptop.c
> ===================================================================
> --- linux.orig/drivers/platform/x86/msi-laptop.c
> +++ linux/drivers/platform/x86/msi-laptop.c
> @@ -85,7 +85,8 @@
>  #define MSI_STANDARD_EC_TOUCHPAD_ADDRESS	0xe4
>  #define MSI_STANDARD_EC_TOUCHPAD_MASK		(1 << 4)
>  
> -static int msi_laptop_resume(struct platform_device *device);
> +static int msi_laptop_resume(struct device *device);
> +static SIMPLE_DEV_PM_OPS(msi_laptop_pm, NULL, msi_laptop_resume);
>  
>  #define MSI_STANDARD_EC_DEVICES_EXISTS_ADDRESS	0x2f
>  
> @@ -437,8 +438,8 @@ static struct platform_driver msipf_driv
>  	.driver = {
>  		.name = "msi-laptop-pf",
>  		.owner = THIS_MODULE,
> +		.pm = &msi_laptop_pm,
>  	},
> -	.resume = msi_laptop_resume,
>  };
>  
>  static struct platform_device *msipf_device;
> @@ -752,7 +753,7 @@ err_bluetooth:
>  	return retval;
>  }
>  
> -static int msi_laptop_resume(struct platform_device *device)
> +static int msi_laptop_resume(struct device *device)
>  {
>  	u8 data;
>  	int result;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


