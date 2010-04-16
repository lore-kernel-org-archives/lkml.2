Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab0DPCvb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 22:51:31 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46331 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757282Ab0DPCv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 22:51:29 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 07/10] vmscan: Remove unnecessary temporary variables in shrink_zone()
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>,
       Dave Chinner <david@fromorbit.com>, Andi Kleen <andi@firstfloor.org>,
       Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <1271352103-2280-8-git-send-email-mel@csn.ul.ie>
References: <1271352103-2280-1-git-send-email-mel@csn.ul.ie> <1271352103-2280-8-git-send-email-mel@csn.ul.ie>
Message-Id: <20100416115053.27A1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 16 Apr 2010 11:51:26 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Two variables are declared that are unnecessary in shrink_zone() as they
> already exist int the scan_control. Remove them
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

ok.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


> ---
>  mm/vmscan.c |    8 ++------
>  1 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index a374879..a232ad6 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1633,8 +1633,6 @@ static void shrink_zone(struct zone *zone, struct scan_control *sc)
>  {
>  	unsigned long nr[NR_LRU_LISTS];
>  	unsigned long nr_to_scan;
> -	unsigned long nr_reclaimed = sc->nr_reclaimed;
> -	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
>  	enum lru_list l;
>  
>  	calc_scan_trybatch(zone, sc, nr);
> @@ -1647,7 +1645,7 @@ static void shrink_zone(struct zone *zone, struct scan_control *sc)
>  						   nr[l], SWAP_CLUSTER_MAX);
>  				nr[l] -= nr_to_scan;
>  
> -				nr_reclaimed += shrink_list(l, nr_to_scan,
> +				sc->nr_reclaimed += shrink_list(l, nr_to_scan,
>  							    zone, sc);
>  			}
>  		}
> @@ -1659,13 +1657,11 @@ static void shrink_zone(struct zone *zone, struct scan_control *sc)
>  		 * with multiple processes reclaiming pages, the total
>  		 * freeing target can get unreasonably large.
>  		 */
> -		if (nr_reclaimed >= nr_to_reclaim &&
> +		if (sc->nr_reclaimed >= sc->nr_to_reclaim &&
>  		    sc->priority < DEF_PRIORITY)
>  			break;
>  	}
>  
> -	sc->nr_reclaimed = nr_reclaimed;
> -
>  	/*
>  	 * Even if we did not try to evict anon pages at all, we want to
>  	 * rebalance the anon lru active/inactive ratio.
> -- 
> 1.6.5
> 



