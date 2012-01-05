Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab2AEMpR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 07:45:17 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51621 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab2AEMpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 07:45:15 -0500
From: hamo.by@gmail.com
To: linux@arm.linux.org.uk, will.deacon@arm.com, marc.zyngier@arm.com,
        sboyd@codeaurora.org, akpm@linux-foundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Yang Bai <hamo.by@gmail.com>
Subject: [PATCH RFC] arm: Define cpu_logical_map when CONFIG_SMP is not set
Date: Thu,  5 Jan 2012 20:44:46 +0800
Message-Id: <1325767486-6392-1-git-send-email-hamo.by@gmail.com>
X-Mailer: git-send-email 1.7.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yang Bai <hamo.by@gmail.com>

If CONFIG_SMP is not set, define cpu_logical_map(cpu) as
(cpu), this fixes the problem described in this mail:
https://lkml.org/lkml/2012/1/2/142

Signed-off-by: Yang Bai <hamo.by@gmail.com>
---
 arch/arm/include/asm/smp.h |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/smp.h b/arch/arm/include/asm/smp.h
index 1e5717a..0a06ead 100644
--- a/arch/arm/include/asm/smp.h
+++ b/arch/arm/include/asm/smp.h
@@ -10,14 +10,12 @@
 #ifndef __ASM_ARM_SMP_H
 #define __ASM_ARM_SMP_H
 
+#ifdef CONFIG_SMP
+
 #include <linux/threads.h>
 #include <linux/cpumask.h>
 #include <linux/thread_info.h>
 
-#ifndef CONFIG_SMP
-# error "<asm/smp.h> included in non-SMP build"
-#endif
-
 #define raw_smp_processor_id() (current_thread_info()->cpu)
 
 struct seq_file;
@@ -99,4 +97,10 @@ extern void platform_cpu_enable(unsigned int cpu);
 extern void arch_send_call_function_single_ipi(int cpu);
 extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
 
+#else
+
+#define cpu_logical_map(cpu)	(cpu)
+
+#endif /* CONFIG_SMP */
+
 #endif /* ifndef __ASM_ARM_SMP_H */
-- 
1.7.8.2

