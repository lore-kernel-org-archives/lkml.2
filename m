Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab0HWNDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 09:03:33 -0400
Received: from gir.skynet.ie ([193.1.99.77]:34509 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964Ab0HWND3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 09:03:29 -0400
Date: Mon, 23 Aug 2010 14:03:16 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 2/3] mm: page allocator: Calculate a better estimate of
	NR_FREE_PAGES when memory is low and kswapd is awake
Message-ID: <20100823130315.GQ19797@csn.ul.ie>
References: <1282550442-15193-1-git-send-email-mel@csn.ul.ie> <1282550442-15193-3-git-send-email-mel@csn.ul.ie> <alpine.DEB.2.00.1008230750380.4094@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008230750380.4094@router.home>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 07:56:40AM -0500, Christoph Lameter wrote:
> On Mon, 23 Aug 2010, Mel Gorman wrote:
> 
> > This patch introduces zone_nr_free_pages() to take a slightly more accurate
> > estimate of NR_FREE_PAGES while kswapd is awake. The estimate is not perfect
> > and may result in cache line bounces but is expected to be lighter than the
> > IPI calls necessary to continually drain the per-cpu counters while kswapd
> > is awake.
> 
> The delta of the counters could also be reduced to increase accuracy.
> See refresh_zone_stat_thresholds().
> 

True, but I thought that would introduce a constant performance penalty
for a corner case which I didn't like.

> Also would it be possible to add the summation function to vmstat? It may
> be useful elsewhere.
> 
> A new function like
> 
> 	zone_page_state_snapshot()
> 
> or so?
> 

We could if there is another counter that results in bad system
behaviour due to counter drift. As NR_FREE_PAGES seemed to be the only
one, zone_nr_free_pages() seemed adequate. If such a helper did exist,
zone_nr_free_pages() would be a simple wrapper around it. The
indirection didn't seem necessary at this point though.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
