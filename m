Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab2HJIsD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 04:48:03 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:47028 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab2HJIr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 04:47:58 -0400
X-AuditID: 9c930197-b7bb2ae0000011d9-52-5024cabc3654
Date: Fri, 10 Aug 2012 17:49:34 +0900
From: Minchan Kim <minchan@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>,
        Jim Schutt <jaschut@sandia.gov>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] mm: vmscan: Scale number of pages reclaimed by
 reclaim/compaction based on failures
Message-ID: <20120810084934.GG21033@bbox>
References: <1344520165-24419-1-git-send-email-mgorman@suse.de>
 <1344520165-24419-3-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344520165-24419-3-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 02:49:22PM +0100, Mel Gorman wrote:
> If allocation fails after compaction then compaction may be deferred for
> a number of allocation attempts. If there are subsequent failures,
> compact_defer_shift is increased to defer for longer periods. This patch
> uses that information to scale the number of pages reclaimed with
> compact_defer_shift until allocations succeed again. The rationale is
> that reclaiming the normal number of pages still allowed compaction to
> fail and its success depends on the number of pages. If it's failing,
> reclaim more pages until it succeeds again.
> 
> Note that this is not implying that VM reclaim is not reclaiming enough
> pages or that its logic is broken. try_to_free_pages() always asks for
> SWAP_CLUSTER_MAX pages to be reclaimed regardless of order and that is
> what it does. Direct reclaim stops normally with this check.
> 
> 	if (sc->nr_reclaimed >= sc->nr_to_reclaim)
> 		goto out;
> 
> should_continue_reclaim delays when that check is made until a minimum number
> of pages for reclaim/compaction are reclaimed. It is possible that this patch
> could instead set nr_to_reclaim in try_to_free_pages() and drive it from
> there but that's behaves differently and not necessarily for the better. If
> driven from do_try_to_free_pages(), it is also possible that priorities
> will rise. When they reach DEF_PRIORITY-2, it will also start stalling
> and setting pages for immediate reclaim which is more disruptive than not
> desirable in this case. That is a more wide-reaching change that could
> cause another regression related to THP requests causing interactive jitter.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
