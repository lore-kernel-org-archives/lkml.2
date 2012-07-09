Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433Ab2GIEqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 00:46:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44054 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab2GIEqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 00:46:54 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FFA61BC.4020102@jp.fujitsu.com>
Date: Mon, 09 Jul 2012 13:44:44 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Wanpeng Li <liwp.linux@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/memcg: mem_cgroup_relize_xxx_limit can guarantee memcg->res.limit
 <= memcg->memsw.limit
References: <1341544860-5634-1-git-send-email-liwp.linux@gmail.com>
In-Reply-To: <1341544860-5634-1-git-send-email-liwp.linux@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/07/06 12:21), Wanpeng Li wrote:
> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> 
> Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Could you merge all 'commentary fixes' into a patch ?


> ---
>   mm/memcontrol.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 4b64fe0..a501660 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3418,7 +3418,7 @@ static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
>   		/*
>   		 * Rather than hide all in some function, I do this in
>   		 * open coded manner. You see what this really does.
> -		 * We have to guarantee memcg->res.limit < memcg->memsw.limit.
> +		 * We have to guarantee memcg->res.limit <= memcg->memsw.limit.
>   		 */
>   		mutex_lock(&set_limit_mutex);
>   		memswlimit = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
> @@ -3479,7 +3479,7 @@ static int mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg,
>   		/*
>   		 * Rather than hide all in some function, I do this in
>   		 * open coded manner. You see what this really does.
> -		 * We have to guarantee memcg->res.limit < memcg->memsw.limit.
> +		 * We have to guarantee memcg->res.limit <= memcg->memsw.limit.
>   		 */
>   		mutex_lock(&set_limit_mutex);
>   		memlimit = res_counter_read_u64(&memcg->res, RES_LIMIT);
> 



