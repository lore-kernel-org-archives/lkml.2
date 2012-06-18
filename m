Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab2FRG5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 02:57:10 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:44796 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab2FRG5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 02:57:08 -0400
Subject: Re: [PATCH 3/5] acer-wmi: Use struct dev_pm_ops for power
 management
From: joeyli <jlee@suse.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: platform-driver-x86@vger.kernel.org,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Joey Lee <jlee@novell.com>
In-Reply-To: <201206172228.59364.rjw@sisk.pl>
References: <201206172226.42729.rjw@sisk.pl>
	 <201206172228.59364.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jun 2012 14:56:38 +0800
Message-ID: <1340002598.6640.7.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 日，2012-06-17 於 22:28 +0200，Rafael J. Wysocki 提到：
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Make the acer-wmi driver define its PM callbacks through
> a struct dev_pm_ops object rather than by using legacy PM hooks
> in struct platform_driver.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Patch good to me!

Tested on Acer TravelMate 4750

Tested-by: Lee, Chun-Yi <jlee@suse.com>


Thanks a lot!
Joey Lee

> ---
>  drivers/platform/x86/acer-wmi.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> Index: linux/drivers/platform/x86/acer-wmi.c
> ===================================================================
> --- linux.orig/drivers/platform/x86/acer-wmi.c
> +++ linux/drivers/platform/x86/acer-wmi.c
> @@ -1877,8 +1877,7 @@ static int acer_platform_remove(struct p
>  	return 0;
>  }
>  
> -static int acer_platform_suspend(struct platform_device *dev,
> -pm_message_t state)
> +static int acer_suspend(struct device *dev)
>  {
>  	u32 value;
>  	struct acer_data *data = &interface->data;
> @@ -1900,7 +1899,7 @@ pm_message_t state)
>  	return 0;
>  }
>  
> -static int acer_platform_resume(struct platform_device *device)
> +static int acer_resume(struct device *dev)
>  {
>  	struct acer_data *data = &interface->data;
>  
> @@ -1916,6 +1915,8 @@ static int acer_platform_resume(struct p
>  	return 0;
>  }
>  
> +static SIMPLE_DEV_PM_OPS(acer_pm, acer_suspend, acer_resume);
> +
>  static void acer_platform_shutdown(struct platform_device *device)
>  {
>  	struct acer_data *data = &interface->data;
> @@ -1931,11 +1932,10 @@ static struct platform_driver acer_platf
>  	.driver = {
>  		.name = "acer-wmi",
>  		.owner = THIS_MODULE,
> +		.pm = &acer_pm,
>  	},
>  	.probe = acer_platform_probe,
>  	.remove = acer_platform_remove,
> -	.suspend = acer_platform_suspend,
> -	.resume = acer_platform_resume,
>  	.shutdown = acer_platform_shutdown,
>  };
>  
> 
> 


