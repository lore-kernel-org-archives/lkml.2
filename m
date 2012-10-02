Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab2JBAez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 20:34:55 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47191 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab2JBAew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 20:34:52 -0400
Message-ID: <506A36A1.6030709@gmail.com>
Date: Tue, 02 Oct 2012 08:34:41 +0800
From: Ni zhan Chen <nizhan.chen@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: wency@cn.fujitsu.com
CC: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com,
        sparclinux@vger.kernel.org, rientjes@google.com, liuj97@gmail.com,
        len.brown@intel.com, benh@kernel.crashing.org, paulus@samba.org,
        cl@linux.com, minchan.kim@gmail.com, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com
Subject: Re: [RFC v9 PATCH 06/21] memory-hotplug: export the function acpi_bus_remove()
References: <1346837155-534-1-git-send-email-wency@cn.fujitsu.com> <1346837155-534-7-git-send-email-wency@cn.fujitsu.com>
In-Reply-To: <1346837155-534-7-git-send-email-wency@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2012 05:25 PM, wency@cn.fujitsu.com wrote:
> From: Wen Congyang <wency@cn.fujitsu.com>
>
> The function acpi_bus_remove() can remove a acpi device from acpi device.

IIUC, s/acpi device/acpi bus

>   
> When a acpi device is removed, we need to call this function to remove
> the acpi device from acpi bus. So export this function.
>
> CC: David Rientjes <rientjes@google.com>
> CC: Jiang Liu <liuj97@gmail.com>
> CC: Len Brown <len.brown@intel.com>
> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> CC: Paul Mackerras <paulus@samba.org>
> CC: Christoph Lameter <cl@linux.com>
> Cc: Minchan Kim <minchan.kim@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> ---
>   drivers/acpi/scan.c     |    3 ++-
>   include/acpi/acpi_bus.h |    1 +
>   2 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index d1ecca2..1cefc34 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -1224,7 +1224,7 @@ static int acpi_device_set_context(struct acpi_device *device)
>   	return -ENODEV;
>   }
>   
> -static int acpi_bus_remove(struct acpi_device *dev, int rmdevice)
> +int acpi_bus_remove(struct acpi_device *dev, int rmdevice)
>   {
>   	if (!dev)
>   		return -EINVAL;
> @@ -1246,6 +1246,7 @@ static int acpi_bus_remove(struct acpi_device *dev, int rmdevice)
>   
>   	return 0;
>   }
> +EXPORT_SYMBOL(acpi_bus_remove);
>   
>   static int acpi_add_single_object(struct acpi_device **child,
>   				  acpi_handle handle, int type,
> diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
> index bde976e..2ccf109 100644
> --- a/include/acpi/acpi_bus.h
> +++ b/include/acpi/acpi_bus.h
> @@ -360,6 +360,7 @@ bool acpi_bus_power_manageable(acpi_handle handle);
>   bool acpi_bus_can_wakeup(acpi_handle handle);
>   int acpi_power_resource_register_device(struct device *dev, acpi_handle handle);
>   void acpi_power_resource_unregister_device(struct device *dev, acpi_handle handle);
> +int acpi_bus_remove(struct acpi_device *dev, int rmdevice);
>   #ifdef CONFIG_ACPI_PROC_EVENT
>   int acpi_bus_generate_proc_event(struct acpi_device *device, u8 type, int data);
>   int acpi_bus_generate_proc_event4(const char *class, const char *bid, u8 type, int data);

