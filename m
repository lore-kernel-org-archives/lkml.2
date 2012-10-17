Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab2JQB0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 21:26:48 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40849 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856Ab2JQB0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 21:26:47 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <507E0942.1080708@jp.fujitsu.com>
Date: Wed, 17 Oct 2012 10:26:26 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: <linux-acpi@vger.kernel.org>, <lenb@kernel.org>,
        <linux-kernel@vger.kernel.org>, <rjw@sisk.pl>, <liuj97@gmail.com>
Subject: Re: [PATCH 2/2] ACPI: Remove unused lockable in acpi_device_flags
References: <1350318870-5700-1-git-send-email-toshi.kani@hp.com> <1350318870-5700-2-git-send-email-toshi.kani@hp.com>
In-Reply-To: <1350318870-5700-2-git-send-email-toshi.kani@hp.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/16 1:34, Toshi Kani wrote:
> Removed lockable in struct acpi_device_flags since it is no
> longer used by any code. acpi_bus_hot_remove_device() cannot
> use this flag because acpi_bus_trim() frees up its acpi_device
> object. Furthermore, the dock driver calls _LCK method without
> using this lockable flag.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>

Looks good to me.
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

> ---
>   drivers/acpi/scan.c     | 5 -----
>   include/acpi/acpi_bus.h | 3 +--
>   2 files changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index ed87f43..19d3d4a 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -1017,11 +1017,6 @@ static int acpi_bus_get_flags(struct acpi_device *device)
>   			device->flags.ejectable = 1;
>   	}
>   
> -	/* Presence of _LCK indicates 'lockable' */
> -	status = acpi_get_handle(device->handle, "_LCK", &temp);
> -	if (ACPI_SUCCESS(status))
> -		device->flags.lockable = 1;
> -
>   	/* Power resources cannot be power manageable. */
>   	if (device->device_type == ACPI_BUS_TYPE_POWER)
>   		return 0;
> diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
> index 0daa0fb..e8b2877 100644
> --- a/include/acpi/acpi_bus.h
> +++ b/include/acpi/acpi_bus.h
> @@ -144,12 +144,11 @@ struct acpi_device_flags {
>   	u32 bus_address:1;
>   	u32 removable:1;
>   	u32 ejectable:1;
> -	u32 lockable:1;
>   	u32 suprise_removal_ok:1;
>   	u32 power_manageable:1;
>   	u32 performance_manageable:1;
>   	u32 eject_pending:1;
> -	u32 reserved:23;
> +	u32 reserved:24;
>   };
>   
>   /* File System */
> 


