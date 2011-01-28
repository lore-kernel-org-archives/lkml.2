Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab1A1ICT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 03:02:19 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:53199 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754386Ab1A1ICR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 03:02:17 -0500
Date: Fri, 28 Jan 2011 09:02:13 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [BUGFIX][PATCH 3/4] mecg: fix oom flag at THP charge
Message-ID: <20110128080213.GC2213@cmpxchg.org>
References: <20110128122229.6a4c74a2.kamezawa.hiroyu@jp.fujitsu.com>
 <20110128122729.1f1c613e.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110128122729.1f1c613e.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 28, 2011 at 12:27:29PM +0900, KAMEZAWA Hiroyuki wrote:
> 
> Thanks to Johanns and Daisuke for suggestion.
> =
> Hugepage allocation shouldn't trigger oom.
> Allocation failure is not fatal.
> 
> Orignal-patch-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  mm/memcontrol.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Index: mmotm-0125/mm/memcontrol.c
> ===================================================================
> --- mmotm-0125.orig/mm/memcontrol.c
> +++ mmotm-0125/mm/memcontrol.c
> @@ -2369,11 +2369,14 @@ static int mem_cgroup_charge_common(stru
>  	struct page_cgroup *pc;
>  	int ret;
>  	int page_size = PAGE_SIZE;
> +	bool oom;
>  
>  	if (PageTransHuge(page)) {
>  		page_size <<= compound_order(page);
>  		VM_BUG_ON(!PageTransHuge(page));
> -	}
> +		oom = false;
> +	} else
> +		oom = true;

That needs a comment.  You can take the one from my patch if you like.
