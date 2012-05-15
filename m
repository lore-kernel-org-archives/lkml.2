Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058Ab2EOOOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 10:14:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51412 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754626Ab2EOOOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 10:14:50 -0400
Date: Tue, 15 May 2012 16:14:48 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/6] mm: memcg: remove obsolete statistics array boundary
 enum item
Message-ID: <20120515141447.GE11346@tiehlicka.suse.cz>
References: <1337018451-27359-1-git-send-email-hannes@cmpxchg.org>
 <1337018451-27359-2-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337018451-27359-2-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 14-05-12 20:00:46, Johannes Weiner wrote:
> MEM_CGROUP_STAT_DATA is a leftover from when item counters were living
> in the same array as ever-increasing event counters.  It's no longer
> needed, use MEM_CGROUP_STAT_NSTATS to iterate over the stat array.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 9520ee9..aef89c1 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -99,7 +99,6 @@ enum mem_cgroup_stat_index {
>  	MEM_CGROUP_STAT_FILE_MAPPED,  /* # of pages charged as file rss */
>  	MEM_CGROUP_STAT_MLOCK, /* # of pages charged as mlock()ed */
>  	MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
> -	MEM_CGROUP_STAT_DATA, /* end of data requires synchronization */
>  	MEM_CGROUP_STAT_NSTATS,
>  };
>  
> @@ -2158,7 +2157,7 @@ static void mem_cgroup_drain_pcp_counter(struct mem_cgroup *memcg, int cpu)
>  	int i;
>  
>  	spin_lock(&memcg->pcp_counter_lock);
> -	for (i = 0; i < MEM_CGROUP_STAT_DATA; i++) {
> +	for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
>  		long x = per_cpu(memcg->stat->count[i], cpu);
>  
>  		per_cpu(memcg->stat->count[i], cpu) = 0;
> -- 
> 1.7.10.1
> 

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
