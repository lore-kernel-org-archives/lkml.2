Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340Ab0DPCsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 22:48:00 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:32922 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757035Ab0DPCr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 22:47:58 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 05/10] vmscan: Remove unnecessary temporary vars in do_try_to_free_pages
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>,
       Dave Chinner <david@fromorbit.com>, Andi Kleen <andi@firstfloor.org>,
       Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <1271352103-2280-6-git-send-email-mel@csn.ul.ie>
References: <1271352103-2280-1-git-send-email-mel@csn.ul.ie> <1271352103-2280-6-git-send-email-mel@csn.ul.ie>
Message-Id: <20100416114711.2798.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 16 Apr 2010 11:47:54 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Remove temporary variable that is only used once and does not help
> clarify code.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

> ---
>  mm/vmscan.c |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 838ac8b..1ace7c6 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1685,13 +1685,12 @@ static void shrink_zone(struct zone *zone, struct scan_control *sc)
>   */
>  static void shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
>  {
> -	enum zone_type high_zoneidx = gfp_zone(sc->gfp_mask);
>  	struct zoneref *z;
>  	struct zone *zone;
>  
>  	sc->all_unreclaimable = 1;
> -	for_each_zone_zonelist_nodemask(zone, z, zonelist, high_zoneidx,
> -					sc->nodemask) {
> +	for_each_zone_zonelist_nodemask(zone, z, zonelist,
> +				gfp_zone(sc->gfp_mask), sc->nodemask) {
>  		if (!populated_zone(zone))
>  			continue;
>  		/*
> @@ -1741,7 +1740,6 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
>  	unsigned long lru_pages = 0;
>  	struct zoneref *z;
>  	struct zone *zone;
> -	enum zone_type high_zoneidx = gfp_zone(sc->gfp_mask);
>  	unsigned long writeback_threshold;
>  
>  	delayacct_freepages_start();
> @@ -1752,7 +1750,7 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
>  	 * mem_cgroup will not do shrink_slab.
>  	 */
>  	if (scanning_global_lru(sc)) {
> -		for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
> +		for_each_zone_zonelist(zone, z, zonelist, gfp_zone(sc->gfp_mask)) {
>  
>  			if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
>  				continue;
> -- 
> 1.6.5
> 



