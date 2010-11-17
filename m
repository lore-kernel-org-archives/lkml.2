Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935602Ab0KQWYH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 17:24:07 -0500
Received: from canuck.infradead.org ([134.117.69.58]:46046 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935456Ab0KQWYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 17:24:03 -0500
Message-Id: <20101117222056.093629821@chello.nl>
User-Agent: quilt/0.47-1
Date: Wed, 17 Nov 2010 23:17:33 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        Stephane Eranian <eranian@google.com>,
        "robert.richter" <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        fweisbec <fweisbec@gmail.com>, paulus <paulus@samba.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Kyle Moffett <kyle@moffetthome.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 3/8] perf: Move perf_event_init() into main.c
References: <20101117221730.002627458@chello.nl>
Content-Disposition: inline; filename=perf-fix-init.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we call perf_event_init() from sched_init(). In order to
make it more obvious move it to the cannnonical location.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 init/main.c    |    2 ++
 kernel/sched.c |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c
+++ linux-2.6/init/main.c
@@ -68,6 +68,7 @@
 #include <linux/sfi.h>
 #include <linux/shmem_fs.h>
 #include <linux/slab.h>
+#include <linux/perf_event.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -604,6 +605,7 @@ asmlinkage void __init start_kernel(void
 				"enabled *very* early, fixing it\n");
 		local_irq_disable();
 	}
+	perf_event_init();
 	rcu_init();
 	radix_tree_init();
 	/* init some links before init_ISA_irqs() */
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -7876,8 +7876,6 @@ void __init sched_init(void)
 		zalloc_cpumask_var(&cpu_isolated_map, GFP_NOWAIT);
 #endif /* SMP */
 
-	perf_event_init();
-
 	scheduler_running = 1;
 }
 


