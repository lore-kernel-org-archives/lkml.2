Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435Ab2AMP73 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 10:59:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34883 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758399Ab2AMP7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 10:59:24 -0500
Date: Fri, 13 Jan 2012 16:59:22 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcg: update the correct soft limit tree during
 migration
Message-ID: <20120113155922.GE17060@tiehlicka.suse.cz>
References: <1326469291-5642-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326469291-5642-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 13-01-12 16:41:31, Johannes Weiner wrote:
> end_migration() passes the old page instead of the new page to commit
> the charge.  This page descriptor is not used for committing itself,
> though, since we also pass the (correct) page_cgroup descriptor.  But
> it's used to find the soft limit tree through the page's zone, so the
> soft limit tree of the old page's zone is updated instead of that of
> the new page's, which might get slightly out of date until the next
> charge reaches the ratelimit point.
> 
> This glitch has been present since '5564e88 memcg: condense
> page_cgroup-to-page lookup points'.
> 
> Reported-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Well spotted.
Acked-by: Michal Hocko <mhocko@suse.cz>

Thanks
> ---
>  mm/memcontrol.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> This fixes a bug that I introduced in 2.6.38.  It's benign enough (to
> my knowledge) that we probably don't want this for stable.
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 602207b..7a292a5 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3247,7 +3247,7 @@ int mem_cgroup_prepare_migration(struct page *page,
>  		ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
>  	else
>  		ctype = MEM_CGROUP_CHARGE_TYPE_SHMEM;
> -	__mem_cgroup_commit_charge(memcg, page, 1, pc, ctype);
> +	__mem_cgroup_commit_charge(memcg, newpage, 1, pc, ctype);
>  	return ret;
>  }
>  
> -- 
> 1.7.7.5
> 

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
