Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751233Ab2F1Eup (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 00:50:45 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50476 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab2F1Eun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 00:50:43 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FEBE280.4060107@jp.fujitsu.com>
Date: Thu, 28 Jun 2012 13:50:08 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: <rientjes@google.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-acpi@vger.kernel.org>, <len.brown@intel.com>,
        <benh@kernel.crashing.org>, <paulus@samba.org>, <cl@linux.com>,
        <minchan.kim@gmail.com>, <akpm@linux-foundation.org>,
        <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC PATCH 1/12] memory-hotplug : rename remove_memory to offline_memory
References: <4FEA9C88.1070800@jp.fujitsu.com> <4FEA9D5C.1080508@jp.fujitsu.com> <4FEAB2E1.3090200@cn.fujitsu.com> <4FEAC891.7030808@cn.fujitsu.com> <4FEBC8EE.7040207@jp.fujitsu.com> <4FEBCE9C.7030904@cn.fujitsu.com>
In-Reply-To: <4FEBCE9C.7030904@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wen,

2012/06/28 12:25, Wen Congyang wrote:
> At 06/28/2012 11:01 AM, Yasuaki Ishimatsu Wrote:
>> Hi David and Wen,
>>
>> Thank you for reviewing my patch.
>>
>> 2012/06/27 17:47, Wen Congyang wrote:
>>> At 06/27/2012 03:14 PM, Wen Congyang Wrote:
>>>> At 06/27/2012 01:42 PM, Yasuaki Ishimatsu Wrote:
>>>>> remove_memory() does not remove memory but just offlines memory. The patch
>>>>> changes name of it to offline_memory().
>>>>
>>>> There are 3 functions in the kernel:
>>>> 1. add_memory()
>>>> 2. online_pages()
>>>> 3. remove_memory()
>>>>
>>>> So I think offline_pages() is better than offline_memory().
>>>
>>> There is already a function named offline_pages(). So we
>>> should call offline_pages() instead of remove_memory() in
>>> memory_block_action(), and there is no need to rename
>>> remove_memory().
>>
>> As Wen says, Linux has 4 functions for memory hotplug already.
>> In my recognition, these functions are prepared for following purpose.
>>
>> 1. add_memory     : add physical memory
>> 2. online_pages   : online logical memory
>> 3. remove_memory  : offline logical memory
>> 4. offline_pages  : offline logical memory
>>
>> add_memory() is used for adding physical memory. I think remove_memory()
>> would rather be used for removing physical memory than be used for removing
>> logical memory. So I renamed remove_memory() to offline_memory().
>> How do you think?
> 
> Hmm, remove_memory() will revert all things we do in add_memory(), so I think

I think so too.

add_memory() prepares to use physical memory. It prepares some structures
(pgdat, page table, node, etc) for using the physical memory at the system.
But it does not online the meomory. For onlining the memory, we use
online_pages().

So I think that remove_memory() should remove these structures which are
prepared by add_memory() not offline memory. But current remove_memory() code
only calls offline_pages() and offlines memory.

The patch series recreates remove_memory() for removing these structures
after [RFC PATCH 3/12]. The reason to change the name of remove_memory() is a
preparation to recreate it.

Thanks,
Yasuaki Ishimatsu

> there is no need to rename it. If we rename it to offline_memory(), we should
> also rename add_memory() to online_memory().
> 
> Thanks
> Wen Congyang
> 
>>
>> Regards,
>> Yasuaki Ishimatsu
>>
>>>
>>> Thanks
>>> Wen Congyang
>>>
>>>>
>>>> Thanks
>>>> Wen Congyang
>>>>>



