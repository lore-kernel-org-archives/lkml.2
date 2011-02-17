Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270Ab1BQQMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 11:12:23 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36479 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab1BQQMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 11:12:22 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 18 Feb 2011 01:06:03 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Barrett <damentz@liquorix.net>,
        Ben Gamari <bgamari.foss@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 3/4] Reclaim invalidated page ASAP
Message-Id: <20110218010603.46152945.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <973e9f9bf2006923b600be0c28cedce777a2cf2a.1297940291.git.minchan.kim@gmail.com>
References: <cover.1297940291.git.minchan.kim@gmail.com>
	<973e9f9bf2006923b600be0c28cedce777a2cf2a.1297940291.git.minchan.kim@gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Feb 2011 00:08:21 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> invalidate_mapping_pages is very big hint to reclaimer.
> It means user doesn't want to use the page any more.
> So in order to prevent working set page eviction, this patch
> move the page into tail of inactive list by PG_reclaim.
> 
> Please, remember that pages in inactive list are working set
> as well as active list. If we don't move pages into inactive list's
> tail, pages near by tail of inactive list can be evicted although
> we have a big clue about useless pages. It's totally bad.
> 
> Now PG_readahead/PG_reclaim is shared.
> fe3cba17 added ClearPageReclaim into clear_page_dirty_for_io for
> preventing fast reclaiming readahead marker page.
> 
> In this series, PG_reclaim is used by invalidated page, too.
> If VM find the page is invalidated and it's dirty, it sets PG_reclaim
> to reclaim asap. Then, when the dirty page will be writeback,
> clear_page_dirty_for_io will clear PG_reclaim unconditionally.
> It disturbs this serie's goal.
> 
> I think it's okay to clear PG_readahead when the page is dirty, not
> writeback time. So this patch moves ClearPageReadahead.
> In v4, ClearPageReadahead in set_page_dirty has a problem which is reported
> by Steven Barrett. It's due to compound page. Some driver(ex, audio) calls 
> set_page_dirty with compound page which isn't on LRU. but my patch does 
> ClearPageRelcaim on compound page. In non-CONFIG_PAGEFLAGS_EXTENDED, it breaks
> PageTail flag.
> 
> I think it doesn't affect THP and pass my test with THP enabling 
> but Cced Andrea for double check.
> 
> Reported-by: Steven Barrett <damentz@liquorix.net>
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Rik van Riel <riel@redhat.com>
> Acked-by: Mel Gorman <mel@csn.ul.ie>
> Cc: Wu Fengguang <fengguang.wu@intel.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Nick Piggin <npiggin@kernel.dk>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

