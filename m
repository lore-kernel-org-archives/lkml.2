Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab1HaRbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 13:31:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736Ab1HaRbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 13:31:15 -0400
Date: Wed, 31 Aug 2011 19:30:31 +0200
From: Johannes Weiner <jweiner@redhat.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] vmscan: Do reclaim stall in case of mlocked page.
Message-ID: <20110831173031.GA21571@redhat.com>
References: <1321285043-3470-1-git-send-email-minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321285043-3470-1-git-send-email-minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 12:37:23AM +0900, Minchan Kim wrote:
> [1] made avoid unnecessary reclaim stall when second shrink_page_list(ie, synchronous
> shrink_page_list) try to reclaim page_list which has not-dirty pages.
> But it seems rather awkawrd on unevictable page.
> The unevictable page in shrink_page_list would be moved into unevictable lru from page_list.
> So it would be not on page_list when shrink_page_list returns.
> Nevertheless it skips reclaim stall.
>
> This patch fixes it so that it can do reclaim stall in case of mixing mlocked pages
> and writeback pages on page_list.
> 
> [1] 7d3579e,vmscan: narrow the scenarios in whcih lumpy reclaim uses synchrounous reclaim

Lumpy isolates physically contiguous in the hope to free a bunch of
pages that can be merged to a bigger page.  If an unevictable page is
encountered, the chance of that is gone.  Why invest the allocation
latency when we know it won't pay off anymore?
