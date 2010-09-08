Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307Ab0IHGPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 02:15:42 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:34897 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671Ab0IHGPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 02:15:40 -0400
Date: Wed, 8 Sep 2010 08:15:28 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 04/10] vmscan: Synchronous lumpy reclaim should not call
 congestion_wait()
Message-ID: <20100908061528.GD20955@cmpxchg.org>
References: <1283770053-18833-1-git-send-email-mel@csn.ul.ie>
 <1283770053-18833-5-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283770053-18833-5-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 06, 2010 at 11:47:27AM +0100, Mel Gorman wrote:
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> congestion_wait() mean "waiting queue congestion is cleared".  However,
> synchronous lumpy reclaim does not need this congestion_wait() as
> shrink_page_list(PAGEOUT_IO_SYNC) uses wait_on_page_writeback()
> and it provides the necessary waiting.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

> ---
>  mm/vmscan.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index eabe987..5979850 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1341,8 +1341,6 @@ shrink_inactive_list(unsigned long nr_to_scan, struct zone *zone,
>  
>  	/* Check if we should syncronously wait for writeback */
>  	if (should_reclaim_stall(nr_taken, nr_reclaimed, priority, sc)) {
> -		wait_iff_congested(zone, BLK_RW_ASYNC, HZ/10);
> -
>  		/*
>  		 * The attempt at page out may have made some
>  		 * of the pages active, mark them inactive again.
