Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab2EYGL6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 02:11:58 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65467 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab2EYGL5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 02:11:57 -0400
MIME-Version: 1.0
In-Reply-To: <4FBF1167.6010607@jp.fujitsu.com>
References: <1336588657.26723.23.camel@andre> <4FAB8EB5.8080901@jp.fujitsu.com>
 <CAC8teKXWuzANxCVuV1c+A4Qyh5i7Ws=H5=f-oph72Di_XJFdAQ@mail.gmail.com> <4FBF1167.6010607@jp.fujitsu.com>
From: Zhu Yanhai <zhu.yanhai@gmail.com>
Date: Fri, 25 May 2012 14:11:26 +0800
Message-ID: <CAC8teKXAEoZtD9690myPOVTHCetSQMmKOxEtL_oLL3Af0b1E8w@mail.gmail.com>
Subject: Re: About cgroup memory limits
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andre Nathan <andre@digirati.com.br>, linux-kernel@vger.kernel.org,
        balbir@linux.vnet.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/5/25 Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>:
> (2012/05/25 13:16), Zhu Yanhai wrote:
>>
>> 2012/5/10 KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>:
>>>
>>> (2012/05/10 3:37), Andre Nathan wrote:
>>>
>>>> Hello
>>>>
>>>> I'm doing some tests with LXC and how it interacts with the memory
>>>> cgroup limits, more specifically the memory.limit_in_bytes control file.
>>>>
>>>> Am I correct in my understanding of the memory cgroup documentation[1]
>>>> that the limit set in memory.limit_in_bytes is applied to the sum of the
>>>> fields 'cache', 'rss' and 'mapped_file' in the memory.stat file?
>>>>
>>>
>>> cache includes mapped_file. Then,
>>
>>
>> Excuse me, but it does read:
>>
>>        switch (ctype) {
>>        case MEM_CGROUP_CHARGE_TYPE_CACHE:
>>        case MEM_CGROUP_CHARGE_TYPE_SHMEM:
>>                SetPageCgroupCache(pc);
>>                SetPageCgroupUsed(pc);
>>                break;
>>        case MEM_CGROUP_CHARGE_TYPE_MAPPED:
>>                ClearPageCgroupCache(pc);
>>                SetPageCgroupUsed(pc);
>>                break;
>>        default:
>>                break;
>>        }
>>        mem_cgroup_charge_statistics(mem, pc, page_size);
>>
>> And then, in    mem_cgroup_charge_statistics() we have :
>>
>>        if (PageCgroupCache(pc))
>>                __mem_cgroup_stat_add_safe(cpustat,
>>                        MEM_CGROUP_STAT_CACHE, numpages);
>>        else
>>                __mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_RSS,
>>                        numpages);
>>
>> So it seems that rss includes mapped_file, not cache?
>>
> Why you think so ? mapped_file is mapped file cache. All file caches
> are accountned as STAT_CACHE.
>
>
> TYPE_MAPPDED doesn't mean mapped_file.
> In above, TYPE_MAPPED is called via anonymous page fault.
> It represents anonymous page, counted as RSS.
> I wonder it may be better to rename these macros.

Got it, really get confused by the name! Thanks.
>
>
> Thanks,
> -Kame
>
>
