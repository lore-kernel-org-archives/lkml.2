Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761819Ab2FVM2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 08:28:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55177 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755630Ab2FVM2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 08:28:10 -0400
Date: Fri, 22 Jun 2012 14:28:07 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Han Ying <yinghan@google.com>, Glauber Costa <glommer@parallels.com>,
        Tejun Heo <tj@kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] memcg: use existing function to judge root mem cgroup
Message-ID: <20120622122807.GC4814@tiehlicka.suse.cz>
References: <1340366243-28104-1-git-send-email-liwp.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340366243-28104-1-git-send-email-liwp.linux@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 22-06-12 19:57:22, Wanpeng Li wrote:
> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> 
> Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
> ---
>  mm/memcontrol.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index f72b5e5..776fc57 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4873,7 +4873,7 @@ mem_cgroup_create(struct cgroup *cont)
>  			goto free_out;
>  
>  	/* root ? */
> -	if (cont->parent == NULL) {
> +	if (!(mem_cgroup_is_root(cont))) {

This is not correct. mem_cgroup_is_root takes mem_cgroup and you are
giving it cgroup, see?

>  		int cpu;
>  		enable_swap_cgroup();
>  		parent = NULL;
> -- 
> 1.7.9.5
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
