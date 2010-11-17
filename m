Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935613Ab0KQWYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 17:24:13 -0500
Received: from canuck.infradead.org ([134.117.69.58]:46097 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935456Ab0KQWYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 17:24:10 -0500
Message-Id: <20101117222056.206992649@chello.nl>
User-Agent: quilt/0.47-1
Date: Wed, 17 Nov 2010 23:17:35 +0100
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
Subject: [RFC][PATCH 5/8] init: Initialized IRD earlier
References: <20101117221730.002627458@chello.nl>
Content-Disposition: inline; filename=init-earlier-idx.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf_event_init() wants to start using IDR trees, its needs in turn
are satisfied by mm_init().

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c
+++ linux-2.6/init/main.c
@@ -605,6 +605,7 @@ asmlinkage void __init start_kernel(void
 				"enabled *very* early, fixing it\n");
 		local_irq_disable();
 	}
+	idr_init_cache();
 	perf_event_init();
 	rcu_init();
 	radix_tree_init();
@@ -661,7 +662,6 @@ asmlinkage void __init start_kernel(void
 	enable_debug_pagealloc();
 	kmemleak_init();
 	debug_objects_mem_init();
-	idr_init_cache();
 	setup_per_cpu_pageset();
 	numa_policy_init();
 	if (late_time_init)


