Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab2FYJyy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 05:54:54 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42696 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053Ab2FYJyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 05:54:53 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FE834D9.8070903@jp.fujitsu.com>
Date: Mon, 25 Jun 2012 18:52:25 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Wanpeng Li <liwp.linux@gmail.com>
CC: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>, Arun Sharma <asharma@fb.com>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v3 3/4] memcg: optimize memcg_get_hierarchical_limit
References: <1340613872-9581-1-git-send-email-liwp.linux@gmail.com>
In-Reply-To: <1340613872-9581-1-git-send-email-liwp.linux@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/25 17:44), Wanpeng Li wrote:
> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> 
> Optimize memcg_get_hierarchical_limit to save cpu cycle.
> 
> Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>

I can't understand the benefit of this patch to the real world...

So, if you wrote the patch description as "clean up" rather than optimize,
ok, I'll agree.

Thanks,
-Kame

> ---
>   mm/memcontrol.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 2e81328..4520b57 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3917,9 +3917,9 @@ static void memcg_get_hierarchical_limit(struct mem_cgroup *memcg,
>   
>   	min_limit = res_counter_read_u64(&memcg->res, RES_LIMIT);
>   	min_memsw_limit = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
> -	cgroup = memcg->css.cgroup;
>   	if (!memcg->use_hierarchy)
>   		goto out;
> +	cgroup = memcg->css.cgroup;
>   
>   	while (cgroup->parent) {
>   		cgroup = cgroup->parent;
> 



