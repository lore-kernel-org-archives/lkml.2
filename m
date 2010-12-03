Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758509Ab0LCMMM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 07:12:12 -0500
Received: from gir.skynet.ie ([193.1.99.77]:58094 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757401Ab0LCMMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 07:12:10 -0500
Date: Fri, 3 Dec 2010 12:11:53 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Shaohua Li <shaohua.li@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] vmscan: make kswapd use a correct order
Message-ID: <20101203121153.GB13268@csn.ul.ie>
References: <1291305649-2405-1-git-send-email-minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1291305649-2405-1-git-send-email-minchan.kim@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 03, 2010 at 01:00:49AM +0900, Minchan Kim wrote:
> If we wake up prematurely, it means we should keep going on
> reclaiming not new order page but at old order page.
> Sometime new order can be smaller than old order by below
> race so it could make failure of old order page reclaiming.
> 
> T0: Task 1 wakes up kswapd with order-3
> T1: So, kswapd starts to reclaim pages using balance_pgdat
> T2: Task 2 wakes up kswapd with order-2 because pages reclaimed
> 	by T1 are consumed quickly.
> T3: kswapd exits balance_pgdat and will do following:
> T4-1: In beginning of kswapd's loop, pgdat->kswapd_max_order will
> 	be reset with zero.
> T4-2: 'order' will be set to pgdat->kswapd_max_order(0), since it
>         enters the false branch of 'if (order (3) < new_order (2))'
> T4-3: If previous balance_pgdat can't meet requirement of order-2
> 	free pages by high watermark, it will start reclaiming again.
>         So balance_pgdat will use order-0 to do reclaim while it
> 	really should use order-2 at the moment.
> T4-4: At last, Task 1 can't get the any page if it wanted with
> 	GFP_ATOMIC.
> 
> Reported-by: Shaohua Li <shaohua.li@intel.com>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Reviewed-by: Shaohua Li <shaohua.li@intel.com>
> Cc: Mel Gorman <mel@csn.ul.ie>

Acked-by: Mel Gorman <mel@csn.ul.ie>

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
