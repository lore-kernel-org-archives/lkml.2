Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab2ADJBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 04:01:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57814 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754373Ab2ADJBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 04:01:04 -0500
Date: Wed, 4 Jan 2012 10:01:03 +0100
From: Michal Hocko <mhocko@suse.cz>
To: kosaki.motohiro@gmail.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org
Subject: Re: [PATCH 2/2] memcg: mark rcu protected member as __rcu
Message-ID: <20120104090102.GB12581@tiehlicka.suse.cz>
References: <1325633632-9978-1-git-send-email-kosaki.motohiro@gmail.com>
 <1325633632-9978-2-git-send-email-kosaki.motohiro@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325633632-9978-2-git-send-email-kosaki.motohiro@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 03-01-12 18:33:52, kosaki.motohiro@gmail.com wrote:
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> Currently "make C=2 mm/memcontrol.o" makes following warnings. fix it.
> 
> mm/memcontrol.c:4243:21: error: incompatible types in comparison expression (different address spaces)
> mm/memcontrol.c:4245:21: error: incompatible types in comparison expression (different address spaces)
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: cgroups@vger.kernel.org

Looks correct.

Acked-by: Michal Hocko <mhocko@suse.cz>

Thanks

> ---
>  mm/memcontrol.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6adeeec..138be2b 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -195,7 +195,7 @@ struct mem_cgroup_threshold_ary {
>  
>  struct mem_cgroup_thresholds {
>  	/* Primary thresholds array */
> -	struct mem_cgroup_threshold_ary *primary;
> +	struct mem_cgroup_threshold_ary __rcu *primary;
>  	/*
>  	 * Spare threshold array.
>  	 * This is needed to make mem_cgroup_unregister_event() "never fail".
> -- 
> 1.7.1
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
