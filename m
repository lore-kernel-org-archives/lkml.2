Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab1KGWWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 17:22:40 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59333 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab1KGWWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 17:22:39 -0500
Message-ID: <4EB85A29.3010604@jp.fujitsu.com>
Date: Mon, 07 Nov 2011 14:22:33 -0800
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: rientjes@google.com
CC: mhocko@suse.cz, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        oleg@redhat.com, yinghan@google.com, akpm@linux-foundation.org
Subject: Re: [PATCH] oom: do not kill tasks with oom_score_adj OOM_SCORE_ADJ_MIN
References: <20111104143145.0F93B8B45E@mx2.suse.de> <alpine.DEB.2.00.1111071353140.27419@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1111071353140.27419@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(11/7/2011 1:54 PM), David Rientjes wrote:
> On Fri, 4 Nov 2011, Michal Hocko wrote:
> 
>> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
>> index e916168..4883514 100644
>> --- a/mm/oom_kill.c
>> +++ b/mm/oom_kill.c
>> @@ -185,6 +185,9 @@ unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
>>  	if (!p)
>>  		return 0;
>>  
>> +	if (p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
>> +		return 0;
>> +
>>  	/*
>>  	 * The memory controller may have a limit of 0 bytes, so avoid a divide
>>  	 * by zero, if necessary.
> 
> This leaves p locked, you need to do task_unlock(p) first.
> 
> Once that's fixed, please add my
> 
> 	Acked-by: David Rientjes <rientjes@google.com>

Agreed.
	Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

