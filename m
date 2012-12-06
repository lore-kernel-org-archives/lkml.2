Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424131Ab2LFP6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 10:58:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:14952 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932199Ab2LFP6G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 10:58:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,230,1355126400"; 
   d="scan'208";a="258207184"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: RE: [PATCH] X86/acpi: remove redundant logic of acpi memory hotadd
Thread-Topic: [PATCH] X86/acpi: remove redundant logic of acpi memory hotadd
Thread-Index: Ac3RwEJoPVBNd0EOSNivpcZOpMzv7wCCiKLQ
Date: Thu, 6 Dec 2012 15:58:02 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923353A30A4@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC829233539DED4@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC829233539DED4@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

Thanks,
Jinsong


Liu, Jinsong wrote:
> Resend it, add Rafael and linux-acpi@vger.kernel.org
> 
> Thanks,
> Jinsong
> 
> ===============
> From 1d39279e45c54ce531691da5ffe261e7689dd92c Mon Sep 17 00:00:00 2001
> From: Liu Jinsong <jinsong.liu@intel.com>
> Date: Wed, 14 Nov 2012 18:52:06 +0800
> Subject: [PATCH] X86/acpi: remove redundant logic of acpi memory
> hotadd 
> 
> When memory hotadd, acpi_memory_enable_device has already been done
> at drv->ops.add (acpi_memory_device_add), no need to do it again
> at notify callback.
> 
> At acpi_memory_enable_device, acpi_memory_get_device_resources
> is also a redundant action, since it has been done at drv->ops.add.
> 
> Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
> ---
>  drivers/acpi/acpi_memhotplug.c |   17 -----------------
>  1 files changed, 0 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/acpi/acpi_memhotplug.c
> b/drivers/acpi/acpi_memhotplug.c 
> index 24c807f..a6489fd 100644
> --- a/drivers/acpi/acpi_memhotplug.c
> +++ b/drivers/acpi/acpi_memhotplug.c
> @@ -220,15 +220,6 @@ static int acpi_memory_enable_device(struct
>  	acpi_memory_device *mem_device) struct acpi_memory_info *info;
>  	int node;
> 
> -
> -	/* Get the range from the _CRS */
> -	result = acpi_memory_get_device_resources(mem_device);
> -	if (result) {
> -		printk(KERN_ERR PREFIX "get_device_resources failed\n");
> -		mem_device->state = MEMORY_INVALID_STATE;
> -		return result;
> -	}
> -
>  	node = acpi_get_node(mem_device->device->handle);
>  	/*
>  	 * Tell the VM there is more memory here...
> @@ -357,14 +348,6 @@ static void
>  			acpi_memory_device_notify(acpi_handle handle, u32 event, void
>  		*data) break; }
> 
> -		if (acpi_memory_check_device(mem_device))
> -			break;
> -
> -		if (acpi_memory_enable_device(mem_device)) {
> -			printk(KERN_ERR PREFIX "Cannot enable memory device\n");
> -			break;
> -		}
> -
>  		ost_code = ACPI_OST_SC_SUCCESS;
>  		break;

