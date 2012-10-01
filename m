Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab2JAHj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 03:39:27 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47335 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab2JAHjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 03:39:24 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <50694884.7090706@jp.fujitsu.com>
Date: Mon, 1 Oct 2012 16:38:44 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Ni zhan Chen <nizhan.chen@gmail.com>
CC: <wency@cn.fujitsu.com>, <x86@kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-acpi@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-sh@vger.kernel.org>, <linux-ia64@vger.kernel.org>,
        <cmetcalf@tilera.com>, <sparclinux@vger.kernel.org>,
        <rientjes@google.com>, <liuj97@gmail.com>, <len.brown@intel.com>,
        <benh@kernel.crashing.org>, <paulus@samba.org>, <cl@linux.com>,
        <minchan.kim@gmail.com>, <akpm@linux-foundation.org>,
        <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC v9 PATCH 03/21] memory-hotplug: store the node id in acpi_memory_device
References: <1346837155-534-1-git-send-email-wency@cn.fujitsu.com> <1346837155-534-4-git-send-email-wency@cn.fujitsu.com> <506517C1.7050909@gmail.com>
In-Reply-To: <506517C1.7050909@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chen,

2012/09/28 12:21, Ni zhan Chen wrote:
> On 09/05/2012 05:25 PM, wency@cn.fujitsu.com wrote:
>> From: Wen Congyang <wency@cn.fujitsu.com>
>>
>> The memory device has only one node id. Store the node id when
>> enable the memory device, and we can reuse it when removing the
>> memory device.
>
> one question:
> if use numa emulation, memory device will associated to one node or ...?

Memory device has only one node, even if you use numa emulation.

Thanks,
Yasuaki Ishimatsu

>
>>
>> CC: David Rientjes <rientjes@google.com>
>> CC: Jiang Liu <liuj97@gmail.com>
>> CC: Len Brown <len.brown@intel.com>
>> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> CC: Paul Mackerras <paulus@samba.org>
>> CC: Christoph Lameter <cl@linux.com>
>> Cc: Minchan Kim <minchan.kim@gmail.com>
>> CC: Andrew Morton <akpm@linux-foundation.org>
>> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
>> Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>> ---
>>   drivers/acpi/acpi_memhotplug.c |    4 ++++
>>   1 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
>> index 2a7beac..7873832 100644
>> --- a/drivers/acpi/acpi_memhotplug.c
>> +++ b/drivers/acpi/acpi_memhotplug.c
>> @@ -83,6 +83,7 @@ struct acpi_memory_info {
>>   struct acpi_memory_device {
>>       struct acpi_device * device;
>>       unsigned int state;    /* State of the memory device */
>> +    int nid;
>>       struct list_head res_list;
>>   };
>> @@ -256,6 +257,9 @@ static int acpi_memory_enable_device(struct acpi_memory_device *mem_device)
>>           info->enabled = 1;
>>           num_enabled++;
>>       }
>> +
>> +    mem_device->nid = node;
>> +
>>       if (!num_enabled) {
>>           printk(KERN_ERR PREFIX "add_memory failed\n");
>>           mem_device->state = MEMORY_INVALID_STATE;
>


