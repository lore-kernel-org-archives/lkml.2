Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab0F2JZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 05:25:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:39309 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754509Ab0F2JZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 05:25:44 -0400
Date: Tue, 29 Jun 2010 09:25:03 GMT
From: tip-bot for Michael Neuling <mikey@neuling.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, dhowells@redhat.com, tglx@linutronix.de,
       mikey@neuling.org, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peterz@infradead.org, dhowells@redhat.com, tglx@linutronix.de,
       mikey@neuling.org, mingo@elte.hu
In-Reply-To: <15249.1277776921@neuling.org>
References: <15249.1277776921@neuling.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix spelling of sibling
Message-ID: <tip-2ec57d448b2e8fcfba539a46701b43f14f037f17@git.kernel.org>
Git-Commit-ID: 2ec57d448b2e8fcfba539a46701b43f14f037f17
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 29 Jun 2010 09:25:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2ec57d448b2e8fcfba539a46701b43f14f037f17
Gitweb:     http://git.kernel.org/tip/2ec57d448b2e8fcfba539a46701b43f14f037f17
Author:     Michael Neuling <mikey@neuling.org>
AuthorDate: Tue, 29 Jun 2010 12:02:01 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 29 Jun 2010 10:44:29 +0200

sched: Fix spelling of sibling

No logic changes, only spelling.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Cc: linuxppc-dev@ozlabs.org
Cc: David Howells <dhowells@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <15249.1277776921@neuling.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/powerpc/kernel/process.c |    2 +-
 include/linux/topology.h      |    2 +-
 kernel/sched_fair.c           |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 9b41ece..22f08cb 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -1270,7 +1270,7 @@ unsigned long randomize_et_dyn(unsigned long base)
 }
 
 #ifdef CONFIG_SMP
-int arch_sd_sibiling_asym_packing(void)
+int arch_sd_sibling_asym_packing(void)
 {
 	if (cpu_has_feature(CPU_FTR_ASYM_SMT)) {
 		printk_once(KERN_INFO "Enabling Asymmetric SMT scheduling\n");
diff --git a/include/linux/topology.h b/include/linux/topology.h
index cf57f30..b572e43 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -103,7 +103,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
 				| 0*SD_PREFER_SIBLING			\
-				| arch_sd_sibiling_asym_packing()	\
+				| arch_sd_sibling_asym_packing()	\
 				,					\
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 5e8f98c..b4da534 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2567,7 +2567,7 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 	} while (sg != sd->groups);
 }
 
-int __weak arch_sd_sibiling_asym_packing(void)
+int __weak arch_sd_sibling_asym_packing(void)
 {
        return 0*SD_ASYM_PACKING;
 }
