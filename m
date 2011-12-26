Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750857Ab1LZG0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 01:26:54 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44830 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab1LZG0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 01:26:49 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 26 Dec 2011 15:25:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org,
        Balbir Singh <bsingharora@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/6] memcg: fix unused variable warning
Message-Id: <20111226152531.e0335ec4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1324695619-5537-1-git-send-email-kirill@shutemov.name>
References: <1324695619-5537-1-git-send-email-kirill@shutemov.name>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Dec 2011 05:00:14 +0200
"Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> From: "Kirill A. Shutemov" <kirill@shutemov.name>
> 
> mm/memcontrol.c: In function ‘memcg_check_events’:
> mm/memcontrol.c:784:22: warning: unused variable ‘do_numainfo’ [-Wunused-variable]
> 
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>

Hmm ? Doesn't this fix cause a new Warning ?

mm/memcontrol.c: In function ?memcg_check_events?:
mm/memcontrol.c:789: warning: ISO C90 forbids mixed declarations and code

Thanks,
-Kame
> ---
>  mm/memcontrol.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d643bd6..a5e92bd 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -781,14 +781,15 @@ static void memcg_check_events(struct mem_cgroup *memcg, struct page *page)
>  	/* threshold event is triggered in finer grain than soft limit */
>  	if (unlikely(mem_cgroup_event_ratelimit(memcg,
>  						MEM_CGROUP_TARGET_THRESH))) {
> -		bool do_softlimit, do_numainfo;
> +		bool do_softlimit;
>  
> -		do_softlimit = mem_cgroup_event_ratelimit(memcg,
> -						MEM_CGROUP_TARGET_SOFTLIMIT);
>  #if MAX_NUMNODES > 1
> +		bool do_numainfo;
>  		do_numainfo = mem_cgroup_event_ratelimit(memcg,
>  						MEM_CGROUP_TARGET_NUMAINFO);
>  #endif
> +		do_softlimit = mem_cgroup_event_ratelimit(memcg,
> +						MEM_CGROUP_TARGET_SOFTLIMIT);
>  		preempt_enable();
>  
>  		mem_cgroup_threshold(memcg);
> -- 
> 1.7.7.3
> 

