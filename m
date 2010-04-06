Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab0DFRue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 13:50:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47954 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757093Ab0DFRu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 13:50:27 -0400
Date: Tue, 6 Apr 2010 19:49:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?unknown-8bit?B?RnLDqWTDqXJpYw==?= Weisbecker 
	<fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20100406174955.GA26468@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (1):
      perf kmem: Fix breakage introduced by 5a0e3ad slab.h script

Vince Weaver (1):
      perf, x86: Enable Nehalem-EX support


 arch/x86/kernel/cpu/perf_event_intel.c |    1 +
 tools/perf/builtin-kmem.c              |    1 -
 2 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 84bfde6..9c794ac 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -936,6 +936,7 @@ static __init int intel_pmu_init(void)
 
 	case 26: /* 45 nm nehalem, "Bloomfield" */
 	case 30: /* 45 nm nehalem, "Lynnfield" */
+	case 46: /* 45 nm nehalem-ex, "Beckton" */
 		memcpy(hw_cache_event_ids, nehalem_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 7d9e3a7..924a951 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -14,7 +14,6 @@
 #include "util/debug.h"
 
 #include <linux/rbtree.h>
-#include <linux/slab.h>
 
 struct alloc_stat;
 typedef int (*sort_fn_t)(struct alloc_stat *, struct alloc_stat *);
