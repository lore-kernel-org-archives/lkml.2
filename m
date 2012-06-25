Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab2FYIce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 04:32:34 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43525 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab2FYIcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 04:32:33 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FE82193.1070307@jp.fujitsu.com>
Date: Mon, 25 Jun 2012 17:30:11 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Wanpeng Li <liwp.linux@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>, Arun Sharma <asharma@fb.com>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 1/5 v2] memcg: replace unsigned long by u64 to avoid overflow
References: <1340604266-7937-1-git-send-email-liwp.linux@gmail.com> <20120625075215.GW27816@cmpxchg.org>
In-Reply-To: <20120625075215.GW27816@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/25 16:52), Johannes Weiner wrote:
> On Mon, Jun 25, 2012 at 02:04:20PM +0800, Wanpeng Li wrote:
>> Changlog:
>>
>> V2 -> V1:
>> * fix zone_page_state()::/include/linux/vmstat.h returns 'unsigned long'
>>
>> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
>>
>> Since the return value variable in mem_cgroup_zone_nr_lru_pages and
>> mem_cgroup_node_nr_lru_pages functions are u64, so replace the return
>> value of funtions by u64 to avoid overflow.
>>
>> Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
>> ---
>>   include/linux/vmstat.h |    2 +-
>>   mm/memcontrol.c        |    5 ++---
>>   2 files changed, 3 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
>> index 65efb92..6a14291 100644
>> --- a/include/linux/vmstat.h
>> +++ b/include/linux/vmstat.h
>> @@ -106,7 +106,7 @@ static inline unsigned long global_page_state(enum zone_stat_item item)
>>   	return x;
>>   }
>>
>> -static inline unsigned long zone_page_state(struct zone *zone,
>> +static inline u64 zone_page_state(struct zone *zone,
>>   					enum zone_stat_item item)
>>   {
>>   	long x = atomic_long_read(&zone->vm_stat[item]);
>
> We established that there is no known reason to use ulong for page
> counters and that IF YOU HAD ONE, you should obviously say so and then
> do a wholesale conversion.  But I don't think you have one.
>
> This patch makes absolutely no sense.
>
I agree. Then, Nack from me.

Thanks,
-Kame


