Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912Ab1CNP1v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 11:27:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:56702 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756887Ab1CNP1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 11:27:49 -0400
Message-Id: <20110314152227.384347741@chello.nl>
User-Agent: quilt/0.48-1
Date: Mon, 14 Mar 2011 16:06:24 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 11/14] sched: Reduce some allocation pressure
References: <20110314150613.749843433@chello.nl>
Content-Disposition: inline; filename=sched-foo10.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we now allocate SD_LV_MAX * nr_cpu_ids sched_domain/sched_group
structures when rebuilding the scheduler toplogy it might make sense
to shrink that depending on the CONFIG_ options.

This is only needed until we get rid of SD_LV_* alltogether and
provide a full dynamic topology interface.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 include/linux/sched.h |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -895,12 +895,20 @@ static inline struct cpumask *sched_grou
 
 enum sched_domain_level {
 	SD_LV_NONE = 0,
+#ifdef CONFIG_SCHED_SMT
 	SD_LV_SIBLING,
+#endif
+#ifdef CONFIG_SCHED_MC
 	SD_LV_MC,
+#endif
+#ifdef CONFIG_SCHED_BOOK
 	SD_LV_BOOK,
+#endif
 	SD_LV_CPU,
+#ifdef CONFIG_NUMA
 	SD_LV_NODE,
 	SD_LV_ALLNODES,
+#endif
 	SD_LV_MAX
 };
 


