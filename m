Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357Ab2BCNkE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 08:40:04 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:60702 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756168Ab2BCNkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 08:40:03 -0500
Date: Fri, 3 Feb 2012 14:39:50 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Geunsik Lim <geunsik.lim@gmail.com>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] Handling of unused variable 'do-numainfo on compilation
 time
Message-ID: <20120203133950.GA1690@cmpxchg.org>
References: <1328258627-2241-1-git-send-email-geunsik.lim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328258627-2241-1-git-send-email-geunsik.lim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal, this keeps coming up, please decide between the proposed
solutions ;-)

On Fri, Feb 03, 2012 at 05:43:47PM +0900, Geunsik Lim wrote:
> Actually, Usage of the variable 'do_numainfo'is not suitable for gcc compiler.
> Declare the variable 'do_numainfo' if the number of NUMA nodes > 1.
> 
> Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
> ---
>  mm/memcontrol.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 556859f..4e17ac5 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -776,7 +776,10 @@ static void memcg_check_events(struct mem_cgroup *memcg, struct page *page)
>  	/* threshold event is triggered in finer grain than soft limit */
>  	if (unlikely(mem_cgroup_event_ratelimit(memcg,
>  						MEM_CGROUP_TARGET_THRESH))) {
> -		bool do_softlimit, do_numainfo;
> +		bool do_softlimit;
> +#if MAX_NUMNODES > 1
> +                bool do_numainfo;
> +#endif
>  
>  		do_softlimit = mem_cgroup_event_ratelimit(memcg,
>  						MEM_CGROUP_TARGET_SOFTLIMIT);
> -- 
> 1.7.8.1
> 
