Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933536Ab0HEPGX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 11:06:23 -0400
Received: from gir.skynet.ie ([193.1.99.77]:41374 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933496Ab0HEPGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 11:06:21 -0400
Date: Thu, 5 Aug 2010 16:06:05 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/7] vmscan: synchronous lumpy reclaim don't call
	congestion_wait()
Message-ID: <20100805150605.GF25688@csn.ul.ie>
References: <20100805150624.31B7.A69D9226@jp.fujitsu.com> <20100805151229.31BD.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100805151229.31BD.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 03:13:03PM +0900, KOSAKI Motohiro wrote:
> congestion_wait() mean "waiting quueue congestion is cleared".
> That said, if the system have plenty dirty pages and flusher thread push
> new request to IO queue conteniously, IO queue are not cleared
> congestion status for long time. thus, congestion_wait(HZ/10) become
> almostly equivalent schedule_timeout(HZ/10).
> 
> However, synchronous lumpy reclaim donesn't need this
> congestion_wait() at all. shrink_page_list(PAGEOUT_IO_SYNC) are
> using wait_on_page_writeback() and it provide sufficient waiting.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Needs rebasing for mmotm but otherwise;

Acked-by: Mel Gorman <mel@csn.ul.ie>

> ---
>  mm/vmscan.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index cf51d62..1cdc3db 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1341,7 +1341,6 @@ shrink_inactive_list(unsigned long nr_to_scan, struct zone *zone,
>  
>  	/* Check if we should syncronously wait for writeback */
>  	if (should_reclaim_stall(nr_taken, nr_reclaimed, priority, sc)) {
> -		congestion_wait(BLK_RW_ASYNC, HZ/10);
>  		/*
>  		 * The attempt at page out may have made some
>  		 * of the pages active, mark them inactive again.
> -- 
> 1.6.5.2
> 
> 
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
