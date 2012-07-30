Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab2G3DnX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 23:43:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:3889 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753903Ab2G3DnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 23:43:20 -0400
X-IronPort-AV: E=Sophos;i="4.77,676,1336320000"; 
   d="scan'208";a="5505802"
Message-ID: <501603E7.1060200@cn.fujitsu.com>
Date: Mon, 30 Jul 2012 11:47:51 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com, rientjes@google.com,
        liuj97@gmail.com, len.brown@intel.com, benh@kernel.crashing.org,
        paulus@samba.org, cl@linux.com, minchan.kim@gmail.com,
        akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com
Subject: Re: [RFC PATCH v5 19/19] memory-hotplug: remove sysfs file of node
References: <50126B83.3050201@cn.fujitsu.com> <50126F21.803@cn.fujitsu.com> <5012712E.9000005@jp.fujitsu.com>
In-Reply-To: <5012712E.9000005@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/30 11:43:25,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/30 11:43:40,
	Serialize complete at 2012/07/30 11:43:40
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 07/27/2012 06:45 PM, Yasuaki Ishimatsu Wrote:
> Hi Wen,
> 
> 2012/07/27 19:36, Wen Congyang wrote:
>> From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>>
>> The patch adds node_set_offline() and unregister_one_node() to
>> remove_memory()
>> for removing sysfs file of node.
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
>> CC: Wen Congyang <wency@cn.fujitsu.com>
>> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>> ---
>>   mm/memory_hotplug.c |    5 +++++
>>   1 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index 5ac035f..5681968 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -1267,6 +1267,11 @@ int __ref remove_memory(int nid, u64 start, u64
>> size)
>>       /* remove memmap entry */
>>       firmware_map_remove(start, start + size, "System RAM");
>>
>> +    if (!node_present_pages(nid)) {
> 
> Applying [PATCH v5 17/19], pgdat->node_spanned_pages can become 0 when
> all memory of the pgdat is removed. When pgdat->node_spanned_pages is 0,
> it means the pgdat has no memory. So I think node_spanned_pages() is
> better.

Hmm, if the node contains cpu, and the cpu is onlined, can we offline
this node?

Thanks
Wen Congyang

> 
> Thanks,
> Yasuaki Ishimatsu
> 
>> +        node_set_offline(nid);
>> +        unregister_one_node(nid);
>> +    }
>> +
>>       arch_remove_memory(start, size);
>>   out:
>>       unlock_memory_hotplug();
>>
> 
> 
> 

