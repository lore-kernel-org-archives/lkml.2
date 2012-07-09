Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab2GIPVB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 11:21:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44854 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753909Ab2GIPU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 11:20:59 -0400
Date: Mon, 9 Jul 2012 17:20:58 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 08/11] mm: memcg: remove needless !mm fixup to init_mm
 when charging
Message-ID: <20120709152058.GK4627@tiehlicka.suse.cz>
References: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org>
 <1341449103-1986-9-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341449103-1986-9-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 05-07-12 02:45:00, Johannes Weiner wrote:
> It does not matter to __mem_cgroup_try_charge() if the passed mm is
> NULL or init_mm, it will charge the root memcg in either case.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 418b47d..6fe4101 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2766,8 +2766,6 @@ int mem_cgroup_try_charge_swapin(struct mm_struct *mm,
>  		ret = 0;
>  	return ret;
>  charge_cur_mm:
> -	if (unlikely(!mm))
> -		mm = &init_mm;
>  	ret = __mem_cgroup_try_charge(mm, mask, 1, memcgp, true);
>  	if (ret == -EINTR)
>  		ret = 0;
> @@ -2832,9 +2830,6 @@ int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
>  	if (PageCompound(page))
>  		return 0;
>  
> -	if (unlikely(!mm))
> -		mm = &init_mm;
> -
>  	if (!PageSwapCache(page))
>  		ret = mem_cgroup_charge_common(page, mm, gfp_mask, type);
>  	else { /* page is swapcache/shmem */
> -- 
> 1.7.7.6
> 

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
