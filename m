Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab2FWJkW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 05:40:22 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:52388 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471Ab2FWJkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 05:40:21 -0400
Date: Sat, 23 Jun 2012 11:39:34 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: Re: [PATCH 5/6] memcg: optimize memcg_get_hierarchical_limit
Message-ID: <20120623093934.GN27816@cmpxchg.org>
References: <1340432297-5362-1-git-send-email-liwp.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340432297-5362-1-git-send-email-liwp.linux@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2012 at 02:18:17PM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> 
> Optimize memcg_get_hierarchical_limit to save cpu cycle.
> 
> Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>

I really would have thought the compiler would detect it, but this
patch actually does switch around move and jump.

But this is miniscule and anything but a fastpath...

> ---
>  mm/memcontrol.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index c821e36..1ca79e2 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3917,9 +3917,9 @@ static void memcg_get_hierarchical_limit(struct mem_cgroup *memcg,
>  
>  	min_limit = res_counter_read_u64(&memcg->res, RES_LIMIT);
>  	min_memsw_limit = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
> -	cgroup = memcg->css.cgroup;
>  	if (!memcg->use_hierarchy)
>  		goto out;
> +	cgroup = memcg->css.cgroup;
>  
>  	while (cgroup->parent) {
>  		cgroup = cgroup->parent;
> -- 
> 1.7.9.5
> 
