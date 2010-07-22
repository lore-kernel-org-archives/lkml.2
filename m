Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab0GVFbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 01:31:23 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40427 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab0GVFbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 01:31:18 -0400
Date: Thu, 22 Jul 2010 11:01:13 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nishimura Daisuke <d-nishimura@mtf.biglobe.ne.jp>
Subject: Re: [PATCH 1/7] memcg: sc.nr_to_reclaim should be initialized
Message-ID: <20100722053113.GL14369@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100716191006.7369.A69D9226@jp.fujitsu.com>
 <20100716191256.736C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100716191256.736C.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [2010-07-16 19:13:31]:

> Currently, mem_cgroup_shrink_node_zone() initialize sc.nr_to_reclaim as 0.
> It mean shrink_zone() only scan 32 pages and immediately return even if
> it doesn't reclaim any pages.
> 
> This patch fixes it.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  mm/vmscan.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 1691ad0..bd1d035 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1932,6 +1932,7 @@ unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
>  						struct zone *zone, int nid)
>  {
>  	struct scan_control sc = {
> +		.nr_to_reclaim = SWAP_CLUSTER_MAX,
>  		.may_writepage = !laptop_mode,
>  		.may_unmap = 1,
>  		.may_swap = !noswap,

Could you please do some additional testing on

1. How far does this push pages (in terms of when limit is hit)?
2. Did you hit a problem with the current setting or is it a review
fix?


-- 
	Three Cheers,
	Balbir
