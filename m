Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab0LPMcp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 07:32:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:36363 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab0LPMcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 07:32:43 -0500
Date: Thu, 16 Dec 2010 12:32:13 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101117222056.093629821@chello.nl>
References: <20101117222056.093629821@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Move perf_event_init() into main.c
Message-ID: <tip-24a24bb6ff3dc3a09bb131241be920ecc3f0e519@git.kernel.org>
Git-Commit-ID: 24a24bb6ff3dc3a09bb131241be920ecc3f0e519
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Dec 2010 12:32:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  24a24bb6ff3dc3a09bb131241be920ecc3f0e519
Gitweb:     http://git.kernel.org/tip/24a24bb6ff3dc3a09bb131241be920ecc3f0e519
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 17 Nov 2010 23:17:33 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 16 Dec 2010 11:36:42 +0100

perf: Move perf_event_init() into main.c

Currently we call perf_event_init() from sched_init(). In order to
make it more obvious move it to the cannnonical location.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20101117222056.093629821@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 init/main.c    |    2 ++
 kernel/sched.c |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/main.c b/init/main.c
index 261ad7b..559e862 100644
--- a/init/main.c
+++ b/init/main.c
@@ -67,6 +67,7 @@
 #include <linux/sfi.h>
 #include <linux/shmem_fs.h>
 #include <linux/slab.h>
+#include <linux/perf_event.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -603,6 +604,7 @@ asmlinkage void __init start_kernel(void)
 				"enabled *very* early, fixing it\n");
 		local_irq_disable();
 	}
+	perf_event_init();
 	rcu_init();
 	radix_tree_init();
 	/* init some links before init_ISA_irqs() */
diff --git a/kernel/sched.c b/kernel/sched.c
index dc91a4d..605ab1b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8108,8 +8108,6 @@ void __init sched_init(void)
 		zalloc_cpumask_var(&cpu_isolated_map, GFP_NOWAIT);
 #endif /* SMP */
 
-	perf_event_init();
-
 	scheduler_running = 1;
 }
 
