Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251Ab1LZGdE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 01:33:04 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39016 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab1LZGc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 01:32:56 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 26 Dec 2011 15:31:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org,
        Balbir Singh <bsingharora@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 5/6] memcg: fix broken boolen expression
Message-Id: <20111226153138.0376bd66.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1324695619-5537-5-git-send-email-kirill@shutemov.name>
References: <1324695619-5537-1-git-send-email-kirill@shutemov.name>
	<1324695619-5537-5-git-send-email-kirill@shutemov.name>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Dec 2011 05:00:18 +0200
"Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> From: "Kirill A. Shutemov" <kirill@shutemov.name>
> 
> action != CPU_DEAD || action != CPU_DEAD_FROZEN is always true.
> 
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>

maybe this should go stable..

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


> ---
>  mm/memcontrol.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b27ce0f..3833a7b 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2100,7 +2100,7 @@ static int __cpuinit memcg_cpu_hotplug_callback(struct notifier_block *nb,
>  		return NOTIFY_OK;
>  	}
>  
> -	if ((action != CPU_DEAD) || action != CPU_DEAD_FROZEN)
> +	if (action != CPU_DEAD && action != CPU_DEAD_FROZEN)
>  		return NOTIFY_OK;
>  
>  	for_each_mem_cgroup(iter)
> -- 
> 1.7.7.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

