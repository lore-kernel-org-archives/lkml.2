Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308Ab1DGMkv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 08:40:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60206 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab1DGMkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 08:40:49 -0400
Message-Id: <20110407122942.406226449@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 07 Apr 2011 14:09:53 +0200
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
Subject: [PATCH 12/23] sched: Reduce some allocation pressure
References: <20110407120941.400629539@chello.nl>
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
 


