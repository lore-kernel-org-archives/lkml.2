Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626Ab2FZQBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 12:01:18 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:39948 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757003Ab2FZQBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 12:01:16 -0400
Date: Tue, 26 Jun 2012 11:53:17 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH 6/8] bind the memory device when the driver is being
 loaded
Message-ID: <20120626155317.GB21579@phenom.dumpdata.com>
References: <4FE97DD5.6030205@cn.fujitsu.com>
 <4FE97F34.9090209@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE97F34.9090209@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 05:21:56PM +0800, Wen Congyang wrote:
> We introduce acpi_hotmem_initialized to avoid strange add_memory fail message.

We had

> The stranged add_memory fail message is printed in register_memory_resource().

The strange

> We have removed this message in the previous patch, so we can remove

Don't say previous patch as it is unclear in the git tree which one that
is. Instead say "remove this message in 'don't print message if request_resource() failed'
patch.

> it(it is very useful to the next patch).

And ditto on the 'next patch' - it is not clear in git what is the next patch.

> 
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> ---
>  drivers/acpi/acpi_memhotplug.c |   12 ------------
>  1 files changed, 0 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
> index 2e5d5ab..148c88a 100644
> --- a/drivers/acpi/acpi_memhotplug.c
> +++ b/drivers/acpi/acpi_memhotplug.c
> @@ -87,8 +87,6 @@ struct acpi_memory_device {
>  	struct list_head res_list;
>  };
>  
> -static int acpi_hotmem_initialized;
> -
>  static acpi_status
>  acpi_memory_get_resource(struct acpi_resource *resource, void *context)
>  {
> @@ -463,15 +461,6 @@ static int acpi_memory_device_add(struct acpi_device *device)
>  
>  	printk(KERN_DEBUG "%s \n", acpi_device_name(device));
>  
> -	/*
> -	 * Early boot code has recognized memory area by EFI/E820.
> -	 * If DSDT shows these memory devices on boot, hotplug is not necessary
> -	 * for them. So, it just returns until completion of this driver's
> -	 * start up.
> -	 */
> -	if (!acpi_hotmem_initialized)
> -		return 0;
> -
>  	if (!acpi_memory_check_device(mem_device)) {
>  		/* call add_memory func */
>  		result = acpi_memory_enable_device(mem_device);
> @@ -578,7 +567,6 @@ static int __init acpi_memory_device_init(void)
>  		return -ENODEV;
>  	}
>  
> -	acpi_hotmem_initialized = 1;
>  	return 0;
>  }
>  
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
