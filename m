Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab2BSPML (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 10:12:11 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:59064 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195Ab2BSPME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 10:12:04 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Michal Simek <monstr@monstr.eu>, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 2/5] microblaze: s/#if[!] CONFIG/#if[n]def CONFIG/
Date: Sun, 19 Feb 2012 16:11:56 +0100
Message-Id: <1329664319-3128-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1329664319-3128-1-git-send-email-geert@linux-m68k.org>
References: <1329664319-3128-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michal Simek <monstr@monstr.eu>
Cc: microblaze-uclinux@itee.uq.edu.au
---
 arch/microblaze/include/asm/exceptions.h |    2 +-
 arch/microblaze/include/asm/irqflags.h   |    2 +-
 arch/microblaze/kernel/entry-nommu.S     |    2 +-
 arch/microblaze/kernel/entry.S           |    4 ++--
 arch/microblaze/kernel/setup.c           |    4 ++--
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/microblaze/include/asm/exceptions.h b/arch/microblaze/include/asm/exceptions.h
index e6a8dde..48c197b 100644
--- a/arch/microblaze/include/asm/exceptions.h
+++ b/arch/microblaze/include/asm/exceptions.h
@@ -25,7 +25,7 @@
 /* Define MSR enable bit for HW exceptions */
 #define HWEX_MSR_BIT (1 << 8)
 
-#if CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR
+#ifdef CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR
 #define __enable_hw_exceptions()					\
 	__asm__ __volatile__ ("	msrset	r0, %0;				\
 				nop;"					\
diff --git a/arch/microblaze/include/asm/irqflags.h b/arch/microblaze/include/asm/irqflags.h
index c9a6262..3cfe473 100644
--- a/arch/microblaze/include/asm/irqflags.h
+++ b/arch/microblaze/include/asm/irqflags.h
@@ -12,7 +12,7 @@
 #include <linux/types.h>
 #include <asm/registers.h>
 
-#if CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR
+#ifdef CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR
 
 static inline notrace unsigned long arch_local_irq_save(void)
 {
diff --git a/arch/microblaze/kernel/entry-nommu.S b/arch/microblaze/kernel/entry-nommu.S
index 34b526f..84f1f87 100644
--- a/arch/microblaze/kernel/entry-nommu.S
+++ b/arch/microblaze/kernel/entry-nommu.S
@@ -18,7 +18,7 @@
 #include <asm/percpu.h>
 #include <asm/signal.h>
 
-#if CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR
+#ifdef CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR
 	.macro	disable_irq
 	msrclr r0, MSR_IE
 	.endm
diff --git a/arch/microblaze/kernel/entry.S b/arch/microblaze/kernel/entry.S
index 66e34a3..add11b5 100644
--- a/arch/microblaze/kernel/entry.S
+++ b/arch/microblaze/kernel/entry.S
@@ -49,7 +49,7 @@ syscall_debug_table:
  * This is mucky, but necessary using microblaze version that
  * allows msr ops to write to BIP
  */
-#if CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR
+#ifdef CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR
 	.macro	clear_bip
 	msrclr	r0, MSR_BIP
 	.endm
@@ -993,7 +993,7 @@ ENTRY(_reset)
 	/* These are compiled and loaded into high memory, then
 	 * copied into place in mach_early_setup */
 	.section	.init.ivt, "ax"
-#if CONFIG_MANUAL_RESET_VECTOR
+#ifdef CONFIG_MANUAL_RESET_VECTOR
 	.org	0x0
 	brai	CONFIG_MANUAL_RESET_VECTOR
 #endif
diff --git a/arch/microblaze/kernel/setup.c b/arch/microblaze/kernel/setup.c
index 604cd9d..e046199 100644
--- a/arch/microblaze/kernel/setup.c
+++ b/arch/microblaze/kernel/setup.c
@@ -164,7 +164,7 @@ void __init machine_early_init(const char *cmdline, unsigned int ram,
 	printk("New klimit: 0x%08x\n", (unsigned)klimit);
 #endif
 
-#if CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR
+#ifdef CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR
 	if (msr)
 		printk("!!!Your kernel has setup MSR instruction but "
 				"CPU don't have it %x\n", msr);
@@ -177,7 +177,7 @@ void __init machine_early_init(const char *cmdline, unsigned int ram,
 	/* Do not copy reset vectors. offset = 0x2 means skip the first
 	 * two instructions. dst is pointer to MB vectors which are placed
 	 * in block ram. If you want to copy reset vector setup offset to 0x0 */
-#if !CONFIG_MANUAL_RESET_VECTOR
+#ifndef CONFIG_MANUAL_RESET_VECTOR
 	offset = 0x2;
 #endif
 	dst = (unsigned long *) (offset * sizeof(u32));
-- 
1.7.0.4

