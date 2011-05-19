Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab1ESBYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 21:24:39 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:40288 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab1ESBYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 21:24:38 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6350"; a="92178837"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <rmk@arm.linux.org.uk>,
        Richard Weinberger <richard@nod.at>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Kyle McMartin <kyle@mcmartin.ca>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
Subject: [PATCH] Remove unused PROC_CHANGE_PENALTY constant
Date: Wed, 18 May 2011 18:24:35 -0700
Message-Id: <1305768275-24316-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.5.1.339.gb602ed
In-Reply-To: <\>
References: <\>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This constant hasn't been used since before the git era (2.6.12)
and thus can be dropped.

Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Richard Weinberger <richard@nod.at>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/alpha/include/asm/smp.h  |    2 --
 arch/arm/include/asm/smp.h    |    6 ------
 arch/m32r/include/asm/smp.h   |    2 --
 arch/parisc/include/asm/smp.h |    9 ---------
 arch/um/include/asm/smp.h     |    1 -
 5 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/arch/alpha/include/asm/smp.h b/arch/alpha/include/asm/smp.h
index 3f390e8..c46e714 100644
--- a/arch/alpha/include/asm/smp.h
+++ b/arch/alpha/include/asm/smp.h
@@ -39,8 +39,6 @@ struct cpuinfo_alpha {
 
 extern struct cpuinfo_alpha cpu_data[NR_CPUS];
 
-#define PROC_CHANGE_PENALTY     20
-
 #define hard_smp_processor_id()	__hard_smp_processor_id()
 #define raw_smp_processor_id()	(current_thread_info()->cpu)
 
diff --git a/arch/arm/include/asm/smp.h b/arch/arm/include/asm/smp.h
index 96ed521..dfeb29c 100644
--- a/arch/arm/include/asm/smp.h
+++ b/arch/arm/include/asm/smp.h
@@ -22,12 +22,6 @@
 
 #define raw_smp_processor_id() (current_thread_info()->cpu)
 
-/*
- * at the moment, there's not a big penalty for changing CPUs
- * (the >big< penalty is running SMP in the first place)
- */
-#define PROC_CHANGE_PENALTY		15
-
 struct seq_file;
 
 /*
diff --git a/arch/m32r/include/asm/smp.h b/arch/m32r/include/asm/smp.h
index e67ded1..8accc1b 100644
--- a/arch/m32r/include/asm/smp.h
+++ b/arch/m32r/include/asm/smp.h
@@ -94,8 +94,6 @@ extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
 
 #define NO_PROC_ID (0xff)	/* No processor magic marker */
 
-#define PROC_CHANGE_PENALTY	(15)	/* Schedule penalty */
-
 /*
  * M32R-mp IPI
  */
diff --git a/arch/parisc/include/asm/smp.h b/arch/parisc/include/asm/smp.h
index 2e73623..e8f8037 100644
--- a/arch/parisc/include/asm/smp.h
+++ b/arch/parisc/include/asm/smp.h
@@ -33,15 +33,6 @@ extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
 
 #endif /* !ASSEMBLY */
 
-/*
- *	This magic constant controls our willingness to transfer
- *      a process across CPUs. Such a transfer incurs cache and tlb
- *      misses. The current value is inherited from i386. Still needs
- *      to be tuned for parisc.
- */
- 
-#define PROC_CHANGE_PENALTY	15		/* Schedule penalty */
-
 #define raw_smp_processor_id()	(current_thread_info()->cpu)
 
 #else /* CONFIG_SMP */
diff --git a/arch/um/include/asm/smp.h b/arch/um/include/asm/smp.h
index f27a963..4a4b09d 100644
--- a/arch/um/include/asm/smp.h
+++ b/arch/um/include/asm/smp.h
@@ -11,7 +11,6 @@
 
 #define cpu_logical_map(n) (n)
 #define cpu_number_map(n) (n)
-#define PROC_CHANGE_PENALTY	15 /* Pick a number, any number */
 extern int hard_smp_processor_id(void);
 #define NO_PROC_ID -1
 
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

