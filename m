Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051Ab2GFKda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:33:30 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:53519 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932546Ab2GFKd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:33:29 -0400
Date: Fri, 6 Jul 2012 12:32:55 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Dan Smith <danms@us.ibm.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC][PATCH 02/26] mm, mpol: Remove NUMA_INTERLEAVE_HIT
Message-ID: <20120706103255.GA23680@cmpxchg.org>
References: <20120316144028.036474157@chello.nl>
 <20120316144240.234456258@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120316144240.234456258@chello.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Fri, Mar 16, 2012 at 03:40:30PM +0100, Peter Zijlstra wrote:
> Since the NUMA_INTERLEAVE_HIT statistic is useless on its own; it wants
> to be compared to either a total of interleave allocations or to a miss
> count, remove it.
> 
> Fixing it would be possible, but since we've gone years without these
> statistics I figure we can continue that way.
> 
> This cleans up some of the weird MPOL_INTERLEAVE allocation exceptions.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---

> @@ -111,7 +111,6 @@ enum zone_stat_item {
>  	NUMA_HIT,		/* allocated in intended node */
>  	NUMA_MISS,		/* allocated in non intended node */
>  	NUMA_FOREIGN,		/* was intended here, hit elsewhere */
> -	NUMA_INTERLEAVE_HIT,	/* interleaver preferred this zone */
>  	NUMA_LOCAL,		/* allocation from local node */
>  	NUMA_OTHER,		/* allocation from other node */
>  #endif

Can you guys include/fold this?

---
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch] mm: fix vmstat names-values off-by-one

"mm/mpol: Remove NUMA_INTERLEAVE_HIT" removed the NUMA_INTERLEAVE_HIT
item from the zone_stat_item enum, but left the corresponding name
string for it in the vmstat_text array.  As a result, all counters
that follow it have their name offset by one from their value.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/vmstat.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 1bbbbd9..e4db312 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -717,7 +717,6 @@ const char * const vmstat_text[] = {
 	"numa_hit",
 	"numa_miss",
 	"numa_foreign",
-	"numa_interleave",
 	"numa_local",
 	"numa_other",
 #endif
-- 
1.7.7.6
