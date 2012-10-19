Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030266Ab2JSKJj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 06:09:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:18165 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758155Ab2JSKJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 06:09:37 -0400
X-IronPort-AV: E=Sophos;i="4.80,612,1344182400"; 
   d="scan'208";a="6031089"
Message-ID: <50812830.8080904@cn.fujitsu.com>
Date: Fri, 19 Oct 2012 18:15:12 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org, rientjes@google.com,
        liuj97@gmail.com, len.brown@intel.com, benh@kernel.crashing.org,
        paulus@samba.org, minchan.kim@gmail.com, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH v3 0/9] bugfix for memory hotplug
References: <1350629202-9664-1-git-send-email-wency@cn.fujitsu.com> <508109F2.1080402@jp.fujitsu.com> <50810D14.8020609@jp.fujitsu.com> <50811336.7070704@cn.fujitsu.com> <50811FE1.4080606@jp.fujitsu.com>
In-Reply-To: <50811FE1.4080606@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/19 18:09:10,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/19 18:09:12,
	Serialize complete at 2012/10/19 18:09:12
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 10/19/2012 05:39 PM, Yasuaki Ishimatsu Wrote:
> 2012/10/19 17:45, Wen Congyang wrote:
>> At 10/19/2012 04:19 PM, Yasuaki Ishimatsu Wrote:
>>> 2012/10/19 17:06, Yasuaki Ishimatsu wrote:
>>>> Hi Wen,
>>>>
>>>> Some bug fix patches have been merged into linux-next.
>>>> So the patches confuse me.
>>
>> Sorry, I don't check linux-next tree.
>>
>>>
>>> The following patches have been already merged into linux-next
>>> and mm-tree as long as I know.
>>>
>>>>> Wen Congyang (6):
>>>>>      clear the memory to store struct page
>>>
>>>
>>>>>      memory-hotplug: skip HWPoisoned page when offlining pages
>>>
>>> mm-tree
>>
>> Hmm, I don't find this patch in this URL:
>> http://www.ozlabs.org/~akpm/mmotm/broken-out/
>>
>> Do I miss something?
> 
> But Andrew announced that the patch was merged in mm-tree.
> And you received the announcement.

I search my mail, and don't find such announcement. Maybe I miss
it.

Thanks
Wen Congyang

> 
>>>
>>>>>      memory-hotplug: update mce_bad_pages when removing the memory
>>>
>>>>>      memory-hotplug: auto offline page_cgroup when onlining memory block
>>>>>        failed
>>>
>>> mm-tree
>>>
>>>>>      memory-hotplug: fix NR_FREE_PAGES mismatch
>>>
>>> mm-tree
>>>
>>>>>      memory-hotplug: allocate zone's pcp before onlining pages
>>>
>>> mm-tree
>>>
>>>>>
>>>>> Yasuaki Ishimatsu (3):
>>>>>      suppress "Device memoryX does not have a release() function" warning
>>>
>>> linux-next
>>>
>>>>>      suppress "Device nodeX does not have a release() function" warning
>>>>>      memory-hotplug: flush the work for the node when the node is offlined
>>>
>>> linux-next
>>
>> I split this patch to two patches according to kosaki's comment.
> 
> Yeah, I know. But is the patch really need now?
> 
> Thanks,
> Yasuaki Ishimatsu
> 
>>
>> Thanks
>> Wen Congyang
>>
>>>
>>> Thanks,
>>> Yasuaki Ishimatsu
>>>
>>>> Why did you send same patches again?
>>>>
>>>> Thanks,
>>>> Yasuaki Ishimatsu
>>>>
>>>> 2012/10/19 15:46, wency@cn.fujitsu.com wrote:
>>>>> From: Wen Congyang <wency@cn.fujitsu.com>
>>>>>
>>>>> Changes from v2 to v3:
>>>>>      Merge the bug fix from ishimatsu to this patchset(Patch 1-3)
>>>>>      Patch 3: split it from patch as it fixes another bug.
>>>>>      Patch 4: new patch, and fix bad-page state when hotadding a memory
>>>>>               device after hotremoving it. I forgot to post this patch in v2.
>>>>>      Patch 6: update it according to Dave Hansen's comment.
>>>>>
>>>>> Changes from v1 to v2:
>>>>>      Patch 1: updated according to kosaki's suggestion
>>>>>
>>>>>      Patch 2: new patch, and update mce_bad_pages when removing memory.
>>>>>
>>>>>      Patch 4: new patch, and fix a NR_FREE_PAGES mismatch, and this bug
>>>>>               cause oom in my test.
>>>>>
>>>>>      Patch 5: new patch, and fix a new bug. When repeating to online/offline
>>>>>               pages, the free pages will continue to decrease.
>>>>>
>>>>> Wen Congyang (6):
>>>>>      clear the memory to store struct page
>>>>>      memory-hotplug: skip HWPoisoned page when offlining pages
>>>>>      memory-hotplug: update mce_bad_pages when removing the memory
>>>>>      memory-hotplug: auto offline page_cgroup when onlining memory block
>>>>>        failed
>>>>>      memory-hotplug: fix NR_FREE_PAGES mismatch
>>>>>      memory-hotplug: allocate zone's pcp before onlining pages
>>>>>
>>>>> Yasuaki Ishimatsu (3):
>>>>>      suppress "Device memoryX does not have a release() function" warning
>>>>>      suppress "Device nodeX does not have a release() function" warning
>>>>>      memory-hotplug: flush the work for the node when the node is offlined
>>>>>
>>>>>     drivers/base/memory.c          |    9 ++++++++-
>>>>>     drivers/base/node.c            |   11 +++++++++++
>>>>>     include/linux/page-isolation.h |   10 ++++++----
>>>>>     mm/memory-failure.c            |    2 +-
>>>>>     mm/memory_hotplug.c            |   14 ++++++++------
>>>>>     mm/page_alloc.c                |   37 ++++++++++++++++++++++++++++---------
>>>>>     mm/page_cgroup.c               |    3 +++
>>>>>     mm/page_isolation.c            |   27 ++++++++++++++++++++-------
>>>>>     mm/sparse.c                    |   22 +++++++++++++++++++++-
>>>>>     9 files changed, 106 insertions(+), 29 deletions(-)
>>>>>
>>>>
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>>
>>>
>>>
>>>
>>
> 
> 
> 

