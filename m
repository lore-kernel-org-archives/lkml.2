Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759571Ab2JYNLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 09:11:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:51782 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759559Ab2JYNLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 09:11:01 -0400
Message-Id: <20121025124834.091119747@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 25 Oct 2012 14:16:38 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 21/31] sched, numa, mm: Introduce sched_feat_numa()
References: <20121025121617.617683848@chello.nl>
Content-Disposition: inline; filename=0021-sched-numa-mm-Introduce-sched_feat_numa.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid a few #ifdef's later on.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/sched.h |    6 ++++++
 1 file changed, 6 insertions(+)

Index: tip/kernel/sched/sched.h
===================================================================
--- tip.orig/kernel/sched/sched.h
+++ tip/kernel/sched/sched.h
@@ -648,6 +648,12 @@ extern struct static_key sched_feat_keys
 #define sched_feat(x) (sysctl_sched_features & (1UL << __SCHED_FEAT_##x))
 #endif /* SCHED_DEBUG && HAVE_JUMP_LABEL */
 
+#ifdef CONFIG_SCHED_NUMA
+#define sched_feat_numa(x) sched_feat(x)
+#else
+#define sched_feat_numa(x) (0)
+#endif
+
 static inline u64 global_rt_period(void)
 {
 	return (u64)sysctl_sched_rt_period * NSEC_PER_USEC;


