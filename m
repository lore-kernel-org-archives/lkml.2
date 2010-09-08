Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab0IHDOf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 23:14:35 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37832 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741Ab0IHDOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 23:14:33 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 0/9] Reduce latencies and improve overall reclaim efficiency v1
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1283770053-18833-1-git-send-email-mel@csn.ul.ie>
References: <1283770053-18833-1-git-send-email-mel@csn.ul.ie>
Message-Id: <20100908115807.C916.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  8 Sep 2010 12:14:29 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There have been numerous reports of stalls that pointed at the problem being
> somewhere in the VM. There are multiple roots to the problems which means
> dealing with any of the root problems in isolation is tricky to justify on
> their own and they would still need integration testing. This patch series
> gathers together three different patch sets which in combination should
> tackle some of the root causes of latency problems being reported.
> 
> The first patch improves vmscan latency by tracking when pages get reclaimed
> by shrink_inactive_list. For this series, the most important results is
> being able to calculate the scanning/reclaim ratio as a measure of the
> amount of work being done by page reclaim.
> 
> Patches 2 and 3 account for the time spent in congestion_wait() and avoids
> calling going to sleep on congestion when it is unnecessary. This is expected
> to reduce stalls in situations where the system is under memory pressure
> but not due to congestion.
> 
> Patches 4-8 were originally developed by Kosaki Motohiro but reworked for
> this series. It has been noted that lumpy reclaim is far too aggressive and
> trashes the system somewhat. As SLUB uses high-order allocations, a large
> cost incurred by lumpy reclaim will be noticeable. It was also reported
> during transparent hugepage support testing that lumpy reclaim was trashing
> the system and these patches should mitigate that problem without disabling
> lumpy reclaim.

Wow, I'm sorry my lazyness bother you. I'll join to test this patch series
ASAP and take a feedback soon.




