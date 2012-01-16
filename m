Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab2APIrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 03:47:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39918 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509Ab2APIrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 03:47:17 -0500
Date: Mon, 16 Jan 2012 09:47:15 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-mm@kvack.org, "bsingharora@gmail.com" <bsingharora@gmail.com>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH] memcg: fix compile warning on non-numa systems
Message-ID: <20120116084715.GA1639@tiehlicka.suse.cz>
References: <4F13BE05.70505@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F13BE05.70505@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 16-01-12 14:04:53, Li Zefan wrote:
> Fix this warning:
> 
>   CC      mm/memcontrol.o
> mm/memcontrol.c: In function 'memcg_check_events':
> mm/memcontrol.c:779:22: warning: unused variable 'do_numainfo'

This has been already posted by Kirill and I didn't like the solution
(https://lkml.org/lkml/2011/12/27/86). He then reposted with a different
version (https://lkml.org/lkml/2012/1/6/281).
The later one looks better but I still think this is not worth
complicate the code just to get rid of this warning.

> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  mm/memcontrol.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 602207b..c8aeab8 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -776,14 +776,16 @@ static void memcg_check_events(struct mem_cgroup *memcg, struct page *page)
>  	/* threshold event is triggered in finer grain than soft limit */
>  	if (unlikely(mem_cgroup_event_ratelimit(memcg,
>  						MEM_CGROUP_TARGET_THRESH))) {
> -		bool do_softlimit, do_numainfo;
> -
> -		do_softlimit = mem_cgroup_event_ratelimit(memcg,
> -						MEM_CGROUP_TARGET_SOFTLIMIT);
> +		bool do_softlimit;
>  #if MAX_NUMNODES > 1
> +		bool do_numainfo;
> +
>  		do_numainfo = mem_cgroup_event_ratelimit(memcg,
>  						MEM_CGROUP_TARGET_NUMAINFO);
>  #endif
> +
> +		do_softlimit = mem_cgroup_event_ratelimit(memcg,
> +						MEM_CGROUP_TARGET_SOFTLIMIT);
>  		preempt_enable();
>  
>  		mem_cgroup_threshold(memcg);
> -- 
> 1.7.3.1
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
