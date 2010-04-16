Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373Ab0DPCs5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 22:48:57 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52197 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757225Ab0DPCs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 22:48:56 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 04/10] vmscan: Remove useless loop at end of do_try_to_free_pages
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>,
       Dave Chinner <david@fromorbit.com>, Andi Kleen <andi@firstfloor.org>,
       Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <1271352103-2280-5-git-send-email-mel@csn.ul.ie>
References: <1271352103-2280-1-git-send-email-mel@csn.ul.ie> <1271352103-2280-5-git-send-email-mel@csn.ul.ie>
Message-Id: <20100416114814.279B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 16 Apr 2010 11:48:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> With the patch "vmscan: kill prev_priority completely", the loop at the
> end of do_try_to_free_pages() is now doing nothing. Delete it.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Obviously. thanks correct me.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

> ---
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 76c2b03..838ac8b 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1806,11 +1806,6 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
>  		ret = sc->nr_reclaimed;
>  
>  out:
> -	if (scanning_global_lru(sc))
> -		for_each_zone_zonelist(zone, z, zonelist, high_zoneidx)
> -			if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
> -				continue;
> -
>  	delayacct_freepages_end();
>  
>  	return ret;
> -- 
> 1.6.5
> 



