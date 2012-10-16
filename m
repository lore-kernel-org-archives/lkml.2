Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab2JPSo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 14:44:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38889 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573Ab2JPSo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 14:44:26 -0400
Date: Tue, 16 Oct 2012 11:44:24 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Sha Zhengju <handai.szj@gmail.com>
cc: linux-mm@kvack.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org,
        mhocko@suse.cz, linux-kernel@vger.kernel.org,
        Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH] oom, memcg: handle sysctl oom_kill_allocating_task while
 memcg oom happening
In-Reply-To: <1350382328-28977-1-git-send-email-handai.szj@taobao.com>
Message-ID: <alpine.DEB.2.00.1210161142390.2910@chino.kir.corp.google.com>
References: <1350382328-28977-1-git-send-email-handai.szj@taobao.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2012, Sha Zhengju wrote:

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e4e9b18..c329940 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1486,6 +1486,15 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  
>  	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, order, NULL);
>  	totalpages = mem_cgroup_get_limit(memcg) >> PAGE_SHIFT ? : 1;
> +	if (sysctl_oom_kill_allocating_task && current->mm &&
> +	    !oom_unkillable_task(current, memcg, NULL) &&
> +	    current->signal->oom_score_adj != OOM_SCORE_ADJ_MIN) {
> +		get_task_struct(current);
> +		oom_kill_process(current, gfp_mask, order, 0, totalpages, memcg, NULL,
> +				 "Memory cgroup out of memory (oom_kill_allocating_task)");
> +		return;
> +	}
> +
>  	for_each_mem_cgroup_tree(iter, memcg) {
>  		struct cgroup *cgroup = iter->css.cgroup;
>  		struct cgroup_iter it;

Please try to compile your patches and run scripts/checkpatch.pl on them 
before proposing them.

You'll also need to update Documentation/sysctl/vm.txt.
