Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab2FYKon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 06:44:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42447 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729Ab2FYKol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 06:44:41 -0400
Date: Mon, 25 Jun 2012 18:43:57 +0800
From: Wanpeng Li <liwp.linux@gmail.com>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>, Arun Sharma <asharma@fb.com>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Wanpeng Li <liwp.linux@gmail.com>
Subject: Re: [PATCH v3 3/4] memcg: optimize memcg_get_hierarchical_limit
Message-ID: <20120625104357.GB12148@kernel>
Reply-To: Wanpeng Li <liwp.linux@gmail.com>
References: <1340613872-9581-1-git-send-email-liwp.linux@gmail.com>
 <4FE834D9.8070903@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE834D9.8070903@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 06:52:25PM +0900, Kamezawa Hiroyuki wrote:
>(2012/06/25 17:44), Wanpeng Li wrote:
>> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
>> 
>> Optimize memcg_get_hierarchical_limit to save cpu cycle.
>> 
>> Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
>
>I can't understand the benefit of this patch to the real world...
>
>So, if you wrote the patch description as "clean up" rather than optimize,
>ok, I'll agree.
OK, I will change to "Cleanup". Thank you Kame.

Best Regards,
Wanpeng Li

>
>Thanks,
>-Kame
>
>> ---
>>   mm/memcontrol.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 2e81328..4520b57 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -3917,9 +3917,9 @@ static void memcg_get_hierarchical_limit(struct mem_cgroup *memcg,
>>   
>>   	min_limit = res_counter_read_u64(&memcg->res, RES_LIMIT);
>>   	min_memsw_limit = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
>> -	cgroup = memcg->css.cgroup;
>>   	if (!memcg->use_hierarchy)
>>   		goto out;
>> +	cgroup = memcg->css.cgroup;
>>   
>>   	while (cgroup->parent) {
>>   		cgroup = cgroup->parent;
>> 
>
>
>
