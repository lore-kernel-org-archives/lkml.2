Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab2AQNQG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 08:16:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53789 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578Ab2AQNQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 08:16:05 -0500
Date: Tue, 17 Jan 2012 14:16:01 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: memcg: remove checking reclaim order in soft limit
 reclaim
Message-ID: <20120117131601.GB14907@tiehlicka.suse.cz>
References: <CAJd=RBBdDriMhfetM2AWGzgxiJ1DDs-W4Ff9_1Z8DUgbyQmSkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBBdDriMhfetM2AWGzgxiJ1DDs-W4Ff9_1Z8DUgbyQmSkA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue 17-01-12 20:47:59, Hillf Danton wrote:
> If async order-O reclaim expected here, it is settled down when setting up scan
> control, with scan priority hacked to be zero. Other than that, deny of reclaim
> should be removed.

Maybe I have misunderstood you but this is not right. The check is to
protect from the _global_ reclaim with order > 0 when we prevent from
memcg soft reclaim.

> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/mm/memcontrol.c	Tue Jan 17 20:41:36 2012
> +++ b/mm/memcontrol.c	Tue Jan 17 20:47:48 2012
> @@ -3512,9 +3512,6 @@ unsigned long mem_cgroup_soft_limit_recl
>  	unsigned long long excess;
>  	unsigned long nr_scanned;
> 
> -	if (order > 0)
> -		return 0;
> -
>  	mctz = soft_limit_tree_node_zone(zone_to_nid(zone), zone_idx(zone));
>  	/*
>  	 * This loop can run a while, specially if mem_cgroup's continuously
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
