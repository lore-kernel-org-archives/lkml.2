Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549Ab2F1HBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 03:01:25 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38729 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab2F1HBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 03:01:24 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FEC012E.5030209@jp.fujitsu.com>
Date: Thu, 28 Jun 2012 16:01:02 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-acpi@vger.kernel.org>,
        <len.brown@intel.com>, <benh@kernel.crashing.org>, <paulus@samba.org>,
        <cl@linux.com>, <minchan.kim@gmail.com>, <akpm@linux-foundation.org>,
        <kosaki.motohiro@jp.fujitsu.com>, <wency@cn.fujitsu.com>
Subject: Re: [RFC PATCH 2/12] memory-hogplug : check memory offline in offline_pages
References: <4FEA9C88.1070800@jp.fujitsu.com> <4FEA9DB1.7010303@jp.fujitsu.com> <alpine.DEB.2.00.1206262313440.32567@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1206262313440.32567@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

2012/06/27 15:16, David Rientjes wrote:
> On Wed, 27 Jun 2012, Yasuaki Ishimatsu wrote:
>
>> Index: linux-3.5-rc4/mm/memory_hotplug.c
>> ===================================================================
>> --- linux-3.5-rc4.orig/mm/memory_hotplug.c	2012-06-26 13:28:16.743211538 +0900
>> +++ linux-3.5-rc4/mm/memory_hotplug.c	2012-06-26 13:48:38.264940468 +0900
>> @@ -887,6 +887,11 @@ static int __ref offline_pages(unsigned
>>
>>   	lock_memory_hotplug();
>>
>> +	if (memory_is_offline(start_pfn, end_pfn)) {
>> +		ret = 0;
>> +		goto out;
>> +	}
>> +
>>   	zone = page_zone(pfn_to_page(start_pfn));
>>   	node = zone_to_nid(zone);
>>   	nr_pages = end_pfn - start_pfn;
>
> Are there additional prerequisites for this patch?  Otherwise it changes
> the return value of offline_memory() which will now call
> acpi_memory_powerdown_device() in the acpi memhotplug case when disabling.
> Is that a problem?

I have understood there is a person who expects "offline_pages()" to fail
in this case by kosaki's comment. So I'll move memory_is_offline to caller
side.

Thanks,
Yasuaki Ishimatsu

>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>



