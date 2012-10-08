Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab2JHGka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 02:40:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63513 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab2JHGk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 02:40:27 -0400
X-IronPort-AV: E=Sophos;i="4.80,551,1344182400"; 
   d="scan'208";a="5959534"
Message-ID: <507276A7.8070503@cn.fujitsu.com>
Date: Mon, 08 Oct 2012 14:45:59 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, rientjes@google.com, liuj97@gmail.com,
        len.brown@intel.com, cl@linux.com, minchan.kim@gmail.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH 2/4] acpi,memory-hotplug : rename remove_memory() to offline_memory()
References: <506C0AE8.40702@jp.fujitsu.com> <506C0D45.3050909@jp.fujitsu.com> <CAHGf_=pdVLEkGDvbMC7vjd0F8Y_YFdKX85YcLwR+gCQ8Tf2Mcw@mail.gmail.com>
In-Reply-To: <CAHGf_=pdVLEkGDvbMC7vjd0F8Y_YFdKX85YcLwR+gCQ8Tf2Mcw@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/08 14:40:18,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/08 14:40:19,
	Serialize complete at 2012/10/08 14:40:19
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 10/05/2012 05:31 AM, KOSAKI Motohiro Wrote:
> On Wed, Oct 3, 2012 at 6:02 AM, Yasuaki Ishimatsu
> <isimatu.yasuaki@jp.fujitsu.com> wrote:
>> From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>>
>> add_memory() hot adds a physical memory. But remove_memory does not
>> hot remove a phsical memory. It only offlines memory. The name
>> confuse us.
>>
>> So the patch renames remove_memory() to offline_memory(). We will
>> use rename_memory() for hot removing memory.
>>
>> CC: David Rientjes <rientjes@google.com>
>> CC: Jiang Liu <liuj97@gmail.com>
>> CC: Len Brown <len.brown@intel.com>
>> CC: Christoph Lameter <cl@linux.com>
>> Cc: Minchan Kim <minchan.kim@gmail.com>
>> CC: Andrew Morton <akpm@linux-foundation.org>
>> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
>> ---
>>  drivers/acpi/acpi_memhotplug.c |    2 +-
>>  include/linux/memory_hotplug.h |    2 +-
>>  mm/memory_hotplug.c            |    6 +++---
>>  3 files changed, 5 insertions(+), 5 deletions(-)
> 
> Probably, the better way is to just remove remove_memory() and use
> offline_pages().

we don't notify the userspace that the memory is offlined in offline_pages().
We reimplement offline_memory(), but ishimatsu doesn't include that patch to
this series.

Thanks
Wen Congyang

> 
> btw, current remove_memory() pfn calculation is just buggy.
> 
> 
>> int remove_memory(u64 start, u64 size)
>> {
>> 	unsigned long start_pfn, end_pfn;
>>
>> 	start_pfn = PFN_DOWN(start);
>> 	end_pfn = start_pfn + PFN_DOWN(size);
> 
> It should be:
> 
> 	start_pfn = PFN_DOWN(start);
> 	end_pfn = PFN_UP(start + size)
> 
> or
> 
> 	start_pfn = PFN_UP(start);
> 	end_pfn = PFN_DOWN(start + size)
> 

