Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab1ARRVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 12:21:33 -0500
Received: from gir.skynet.ie ([193.1.99.77]:42835 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397Ab1ARRVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 12:21:32 -0500
Date: Tue, 18 Jan 2011 17:21:09 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: compaction: prevent division-by-zero during
	user-requested compaction
Message-ID: <20110118172109.GA18984@csn.ul.ie>
References: <1295370412-2645-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1295370412-2645-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 06:06:52PM +0100, Johannes Weiner wrote:
> Up until '3e7d344 mm: vmscan: reclaim order-0 and use compaction
> instead of lumpy reclaim', compaction skipped calculating the
> fragmentation index of a zone when compaction was explicitely
> requested through the procfs knob.
> 
> However, when compaction_suitable was introduced, it did not come with
> an extra check for order == -1, set on explicit compaction requests,
> and passed this order on to the fragmentation index calculation, where
> it overshifts the number of requested pages, leading to a division by
> zero.
> 
> This patch makes sure that order == -1 is recognized as the flag it is
> rather than passing it along as valid order parameter.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

It could do with a comment saying that order == -1 is expected when
compacting via /proc/sys/vm/compact_memory but otherwise;

Reviewed-by: Mel Gorman <mel@csn.ul.ie>

> ---
>  mm/compaction.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 6d592a0..114c145 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -453,6 +453,9 @@ unsigned long compaction_suitable(struct zone *zone, int order)
>  	if (!zone_watermark_ok(zone, 0, watermark, 0, 0))
>  		return COMPACT_SKIPPED;
>  
> +	if (order == -1)
> +		return COMPACT_CONTINUE;
> +
>  	/*
>  	 * fragmentation index determines if allocation failures are due to
>  	 * low memory or external fragmentation
> -- 
> 1.7.3.4
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
