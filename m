Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab1LFRbg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 12:31:36 -0500
Received: from casper.infradead.org ([85.118.1.10]:54244 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab1LFRbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 12:31:35 -0500
Message-Id: <20111206172803.473155622@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 06 Dec 2011 18:15:36 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/3] sched: Fix compile error for UP,!NOHZ
References: <20111206171534.429636558@chello.nl>
Content-Disposition: inline; filename=sched-fix-split-fallout.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 69e1e811 ("sched, nohz: Track nr_busy_cpus in the
sched_group_power") messed up the static inline function definition.

Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -277,7 +277,7 @@ extern void set_cpu_sd_state_idle(void);
 extern int get_nohz_timer_target(void);
 #else
 static inline void select_nohz_load_balancer(int stop_tick) { }
-static inline void set_cpu_sd_state_idle(void);
+static inline void set_cpu_sd_state_idle(void) { }
 #endif
 
 /*


