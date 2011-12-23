Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072Ab1LWNRJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 08:17:09 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:60716 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757017Ab1LWNRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 08:17:08 -0500
Date: Fri, 23 Dec 2011 09:17:01 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Brown, Len" <len.brown@intel.com>,
        "jeremy.fitzhardinge@citrix.com" <jeremy.fitzhardinge@citrix.com>,
        "Jiang, Yunhong" <yunhong.jiang@intel.com>,
        "Shan, Haitao" <haitao.shan@intel.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "Zhao, Yakui" <yakui.zhao@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH 05/10] xen/acpi: Move acpi_memory_info definition to public
Message-ID: <20111223131701.GD25286@andromeda.dapyr.net>
References: <DE8DF0795D48FD4CA783C40EC829233596F0@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC829233596F0@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 23, 2011 at 10:27:19AM +0000, Liu, Jinsong wrote:
> >From 0172b1ce6a2ba70e739f968622d78ac1796813f9 Mon Sep 17 00:00:00 2001
> From: Liu Jinsong <jinsong.liu@intel.com>
> Date: Sun, 11 Dec 2011 17:25:35 +0800
> Subject: [PATCH 05/10] xen/acpi: Move acpi_memory_info definition to public

Take out the 'xen'. this patch touches the generic code, not the Xen
code.
> 
> This patch rebased from Jeremy's pvops commit
> 359e747e6260f105f750657917e1dc75f6427602

Not sure what relevance that has actually..
> 
> Move this definition to header file so that it can be used by dom0
> memory hotadd logic also.

And include the name of the patch that uses this so when somebody is
using 'gitk' or 'git gui blame' they can at least search for the patch
that leverages this.

> 
> Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
> Signed-off-by: Jiang, Yunhong <yunhong.jiang@intel.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  drivers/acpi/acpi_memhotplug.c |   15 ---------------
>  include/acpi/acpi_drivers.h    |   21 +++++++++++++++++++++
>  2 files changed, 21 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
> index d985713..e28e64d 100644
> --- a/drivers/acpi/acpi_memhotplug.c
> +++ b/drivers/acpi/acpi_memhotplug.c
> @@ -71,21 +71,6 @@ static struct acpi_driver acpi_memory_device_driver = {
>  		},
>  };
>  
> -struct acpi_memory_info {
> -	struct list_head list;
> -	u64 start_addr;		/* Memory Range start physical addr */
> -	u64 length;		/* Memory Range length */
> -	unsigned short caching;	/* memory cache attribute */
> -	unsigned short write_protect;	/* memory read/write attribute */
> -	unsigned int enabled:1;
> -};
> -
> -struct acpi_memory_device {
> -	struct acpi_device * device;
> -	unsigned int state;	/* State of the memory device */
> -	struct list_head res_list;
> -};
> -
>  static int acpi_hotmem_initialized;
>  
>  static acpi_status
> diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
> index e49c36d..833de75 100644
> --- a/include/acpi/acpi_drivers.h
> +++ b/include/acpi/acpi_drivers.h
> @@ -154,4 +154,25 @@ static inline void unregister_hotplug_dock_device(acpi_handle handle)
>  }
>  #endif
>  
> +/*--------------------------------------------------------------------------
> +                                Memory
> +  -------------------------------------------------------------------------- */
> +#if defined(CONFIG_ACPI_HOTPLUG_MEMORY) || \
> +        defined(CONFIG_ACPI_HOTPLUG_MEMORY_MODULE)
> +struct acpi_memory_info {
> +        struct list_head list;
> +        u64 start_addr;         /* Memory Range start physical addr */
> +        u64 length;             /* Memory Range length */
> +        unsigned short caching; /* memory cache attribute */
> +        unsigned short write_protect;   /* memory read/write attribute */
> +        unsigned int enabled:1;
> +};
> +
> +struct acpi_memory_device {
> +        struct acpi_device *device;
> +        unsigned int state;     /* State of the memory device */
> +        struct list_head res_list;
> +};
> +#endif
> +
>  #endif /*__ACPI_DRIVERS_H__*/
> -- 
> 1.6.5.6


> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel

