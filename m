Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab2GQK4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 06:56:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34517 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754522Ab2GQK4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 06:56:44 -0400
Date: Tue, 17 Jul 2012 12:56:40 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: Re: [PATCH] mm/memcg: remove redundant checking on root memcg
Message-ID: <20120717105640.GB25435@tiehlicka.suse.cz>
References: <1342518147-10406-1-git-send-email-liwanp@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342518147-10406-1-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 17-07-12 17:42:27, Wanpeng Li wrote:
> Function __mem_cgroup_cancel_local_charge is only called by
> mem_cgroup_move_parent. For this case, root memcg has been
> checked by mem_cgroup_move_parent. So we needn't check that
> again in function __mem_cgroup_cancel_local_charge and just
> remove the check in function __mem_cgroup_cancel_local_charge.

It's true that the check is not necessary but on the other hand
__mem_cgroup_cancel_charge does check it and it would be unfortunate to
have two very similar functions with different expectations (one can be
called for the root cgroup while other one cannot).

> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> ---
>  mm/memcontrol.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6392c0a..d346347 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2404,9 +2404,6 @@ static void __mem_cgroup_cancel_local_charge(struct mem_cgroup *memcg,
>  {
>  	unsigned long bytes = nr_pages * PAGE_SIZE;
>  
> -	if (mem_cgroup_is_root(memcg))
> -		return;
> -
>  	res_counter_uncharge_until(&memcg->res, memcg->res.parent, bytes);
>  	if (do_swap_account)
>  		res_counter_uncharge_until(&memcg->memsw,
> -- 
> 1.7.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
