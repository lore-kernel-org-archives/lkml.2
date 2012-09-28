Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab2I1DVy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 23:21:54 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43090 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482Ab2I1DVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 23:21:49 -0400
Message-ID: <506517C1.7050909@gmail.com>
Date: Fri, 28 Sep 2012 11:21:37 +0800
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
Subject: Re: [RFC v9 PATCH 03/21] memory-hotplug: store the node id in acpi_memory_device
References: <1346837155-534-1-git-send-email-wency@cn.fujitsu.com> <1346837155-534-4-git-send-email-wency@cn.fujitsu.com>
In-Reply-To: <1346837155-534-4-git-send-email-wency@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2012 05:25 PM, wency@cn.fujitsu.com wrote:
> From: Wen Congyang <wency@cn.fujitsu.com>
>
> The memory device has only one node id. Store the node id when
> enable the memory device, and we can reuse it when removing the
> memory device.

one question:
if use numa emulation, memory device will associated to one node or ...?

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
> Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> ---
>   drivers/acpi/acpi_memhotplug.c |    4 ++++
>   1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
> index 2a7beac..7873832 100644
> --- a/drivers/acpi/acpi_memhotplug.c
> +++ b/drivers/acpi/acpi_memhotplug.c
> @@ -83,6 +83,7 @@ struct acpi_memory_info {
>   struct acpi_memory_device {
>   	struct acpi_device * device;
>   	unsigned int state;	/* State of the memory device */
> +	int nid;
>   	struct list_head res_list;
>   };
>   
> @@ -256,6 +257,9 @@ static int acpi_memory_enable_device(struct acpi_memory_device *mem_device)
>   		info->enabled = 1;
>   		num_enabled++;
>   	}
> +
> +	mem_device->nid = node;
> +
>   	if (!num_enabled) {
>   		printk(KERN_ERR PREFIX "add_memory failed\n");
>   		mem_device->state = MEMORY_INVALID_STATE;

