Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab2A3Crg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 21:47:36 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64436 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752240Ab2A3Cre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 21:47:34 -0500
Message-ID: <4F2604C5.7050900@cn.fujitsu.com>
Date: Mon, 30 Jan 2012 10:47:33 +0800
From: Peng Haitao <penght@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: how to make memory.memsw.failcnt is nonzero
References: <4EFADFF8.5020703@cn.fujitsu.com> <20120103160411.GD3891@tiehlicka.suse.cz> <4F06C31E.4010904@cn.fujitsu.com> <20120106101219.GB10292@tiehlicka.suse.cz>
In-Reply-To: <20120106101219.GB10292@tiehlicka.suse.cz>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-30 10:46:12,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-30 10:46:14,
	Serialize complete at 2012-01-30 10:46:14
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Michal Hocko said the following on 2012-1-6 18:12:
>> If there is something wrong, I think the bug will be in mem_cgroup_do_charge()
>> of mm/memcontrol.c
>>
>> 2210         ret = res_counter_charge(&memcg->res, csize, &fail_res);
>> 2211 
>> 2212         if (likely(!ret)) {
...
>> 2221                 flags |= MEM_CGROUP_RECLAIM_NOSWAP;
>> 2222         } else
>> 2223                 mem_over_limit = mem_cgroup_from_res_counter(fail_res, res);
>>
>> When hit memory.limit_in_bytes, res_counter_charge() will return -ENOMEM,
>> this will execute line 2222: } else.
>> But I think when hit memory.limit_in_bytes, the function should determine further
>> to memory.memsw.limit_in_bytes.
>> This think is OK?
> 
> I don't think so. We have an invariant (hard limit is "stronger" than
> memsw limit) memory.limit_in_bytes <= memory.memsw.limit_in_bytes so
> when we hit the hard limit we do not have to consider memsw because
> resource counter:
>  a) we already have to do reclaim for hard limit
>  b) we check whether we might swap out later on in
>  mem_cgroup_hierarchical_reclaim (root_memcg->memsw_is_minimum) so we
>  will not end up swapping just to make hard limit ok and go over memsw
>  limit.
> 
> Please also note that we will retry charging after reclaim if there is a
> chance to meet the limit.
> Makes sense?

Yeah.

But I want to test memory.memsw.failcnt is nonzero, how steps?
Thanks.

-- 
Best Regards,
Peng

