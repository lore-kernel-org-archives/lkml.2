Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab1BDAFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 19:05:20 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34195 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab1BDAFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 19:05:19 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 4 Feb 2011 08:59:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch rfc] memcg: remove NULL check from lookup_page_cgroup()
 result
Message-Id: <20110204085913.1b4780df.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110203141230.GG2286@cmpxchg.org>
References: <20110203141230.GG2286@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Feb 2011 15:12:30 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> The page_cgroup array is set up before even fork is initialized.  I
> seriously doubt that this code executes before the array is alloc'd.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

I don't have solid answer to this. If some module use radix-tree and enter pages
to it, mem_cgroup may see it. But..

For my opinion, tring this is good.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> ---
>  mm/memcontrol.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a145c9e..6abaa10 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2343,10 +2343,7 @@ static int mem_cgroup_charge_common(struct page *page, struct mm_struct *mm,
>  	}
>  
>  	pc = lookup_page_cgroup(page);
> -	/* can happen at boot */
> -	if (unlikely(!pc))
> -		return 0;
> -	prefetchw(pc);
> +	BUG_ON(!pc); /* XXX: remove this and move pc lookup into commit */
>  
>  	ret = __mem_cgroup_try_charge(mm, gfp_mask, &mem, oom, page_size);
>  	if (ret || !mem)
> -- 
> 1.7.4
> 

