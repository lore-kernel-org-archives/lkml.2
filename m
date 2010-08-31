Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab0HaX1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 19:27:09 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43044 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab0HaX1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 19:27:07 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 1/3] mm: page allocator: Update free page counters after pages are placed on the free list
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1283276257-1793-2-git-send-email-mel@csn.ul.ie>
References: <1283276257-1793-1-git-send-email-mel@csn.ul.ie> <1283276257-1793-2-git-send-email-mel@csn.ul.ie>
Message-Id: <20100901082634.971C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  1 Sep 2010 08:27:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When allocating a page, the system uses NR_FREE_PAGES counters to determine
> if watermarks would remain intact after the allocation was made. This
> check is made without interrupts disabled or the zone lock held and so is
> race-prone by nature. Unfortunately, when pages are being freed in batch,
> the counters are updated before the pages are added on the list. During this
> window, the counters are misleading as the pages do not exist yet. When
> under significant pressure on systems with large numbers of CPUs, it's
> possible for processes to make progress even though they should have been
> stalled. This is particularly problematic if a number of the processes are
> using GFP_ATOMIC as the min watermark can be accidentally breached and in
> extreme cases, the system can livelock.
> 
> This patch updates the counters after the pages have been added to the
> list. This makes the allocator more cautious with respect to preserving
> the watermarks and mitigates livelock possibilities.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Reviewed-by: Rik van Riel <riel@redhat.com>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




