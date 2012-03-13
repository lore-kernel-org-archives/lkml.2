Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122Ab2CMUrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 16:47:52 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53805 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab2CMUru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 16:47:50 -0400
Date: Tue, 13 Mar 2012 13:47:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Kautuk Consul <consul.kautuk@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Tejun Heo <tj@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] page_alloc: Remove argument to
 find_zone_movable_pfns_for_nodes
In-Reply-To: <1331652803-3092-1-git-send-email-consul.kautuk@gmail.com>
Message-ID: <alpine.DEB.2.00.1203131345290.27008@chino.kir.corp.google.com>
References: <1331652803-3092-1-git-send-email-consul.kautuk@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2012, Kautuk Consul wrote:

> The find_zone_movable_pfns_for_nodes() function does not utiilize
> the argument to it.
> 

It could, though, if we made it to do so.

> Removing this argument from the function prototype as well as its
> caller, i.e. free_area_init_nodes().
> 

Not sure if we'd ever want it or not for other purposes, but 
find_zone_movable_pfns_for_nodes() could easily be made to use the passed 
in array rather than zone_movable_pfn in file scope directly.  That seems 
to be why it took an argument in the first place.

> Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
> ---
>  mm/page_alloc.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 3171f4c..a368b9b 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4509,7 +4509,7 @@ static unsigned long __init early_calculate_totalpages(void)
>   * memory. When they don't, some nodes will have more kernelcore than
>   * others
>   */
> -static void __init find_zone_movable_pfns_for_nodes(unsigned long *movable_pfn)
> +static void __init find_zone_movable_pfns_for_nodes(void)
>  {
>  	int i, nid;
>  	unsigned long usable_startpfn;
> @@ -4701,7 +4701,7 @@ void __init free_area_init_nodes(unsigned long *max_zone_pfn)
>  
>  	/* Find the PFNs that ZONE_MOVABLE begins at in each node */
>  	memset(zone_movable_pfn, 0, sizeof(zone_movable_pfn));
> -	find_zone_movable_pfns_for_nodes(zone_movable_pfn);
> +	find_zone_movable_pfns_for_nodes();
>  
>  	/* Print out the zone ranges */
>  	printk("Zone PFN ranges:\n");
