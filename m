Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702Ab2HRRcr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 13:32:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:44596 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754965Ab2HRRae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 13:30:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,791,1336374000"; 
   d="scan'208";a="182607890"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 04/31] sections: Fix section conflicts in arch/h8300
Date: Sat, 18 Aug 2012 10:29:55 -0700
Message-Id: <1345311022-26328-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
References: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/h8300/kernel/sys_h8300.c     |    1 +
 arch/h8300/kernel/timer/itu.c     |    2 +-
 arch/h8300/kernel/timer/timer16.c |    2 +-
 arch/h8300/kernel/timer/timer8.c  |    2 +-
 arch/h8300/kernel/timer/tpu.c     |    2 +-
 arch/h8300/platform/h8300h/irq.c  |    4 ++--
 arch/h8300/platform/h8s/irq.c     |    4 ++--
 7 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/h8300/kernel/sys_h8300.c b/arch/h8300/kernel/sys_h8300.c
index aaf5e5a..4bdc731 100644
--- a/arch/h8300/kernel/sys_h8300.c
+++ b/arch/h8300/kernel/sys_h8300.c
@@ -51,6 +51,7 @@ asmlinkage void syscall_print(void *dummy,...)
  * Do a system call from kernel instead of calling sys_execve so we
  * end up with proper pt_regs.
  */
+asmlinkage
 int kernel_execve(const char *filename,
 		  const char *const argv[],
 		  const char *const envp[])
diff --git a/arch/h8300/kernel/timer/itu.c b/arch/h8300/kernel/timer/itu.c
index a2ae5e9..0a8b5cd 100644
--- a/arch/h8300/kernel/timer/itu.c
+++ b/arch/h8300/kernel/timer/itu.c
@@ -62,7 +62,7 @@ static struct irqaction itu_irq = {
 	.flags		= IRQF_DISABLED | IRQF_TIMER,
 };
 
-static const int __initdata divide_rate[] = {1, 2, 4, 8};
+static const int __initconst divide_rate[] = {1, 2, 4, 8};
 
 void __init h8300_timer_setup(void)
 {
diff --git a/arch/h8300/kernel/timer/timer16.c b/arch/h8300/kernel/timer/timer16.c
index ae0d381..462d9f58 100644
--- a/arch/h8300/kernel/timer/timer16.c
+++ b/arch/h8300/kernel/timer/timer16.c
@@ -57,7 +57,7 @@ static struct irqaction timer16_irq = {
 	.flags		= IRQF_DISABLED | IRQF_TIMER,
 };
 
-static const int __initdata divide_rate[] = {1, 2, 4, 8};
+static const int __initconst divide_rate[] = {1, 2, 4, 8};
 
 void __init h8300_timer_setup(void)
 {
diff --git a/arch/h8300/kernel/timer/timer8.c b/arch/h8300/kernel/timer/timer8.c
index 7a1533f..505f341 100644
--- a/arch/h8300/kernel/timer/timer8.c
+++ b/arch/h8300/kernel/timer/timer8.c
@@ -77,7 +77,7 @@ static struct irqaction timer8_irq = {
 	.flags		= IRQF_DISABLED | IRQF_TIMER,
 };
 
-static const int __initdata divide_rate[] = {8, 64, 8192};
+static const int __initconst divide_rate[] = {8, 64, 8192};
 
 void __init h8300_timer_setup(void)
 {
diff --git a/arch/h8300/kernel/timer/tpu.c b/arch/h8300/kernel/timer/tpu.c
index 2193a2e..0350f62 100644
--- a/arch/h8300/kernel/timer/tpu.c
+++ b/arch/h8300/kernel/timer/tpu.c
@@ -66,7 +66,7 @@ static struct irqaction tpu_irq = {
 	.flags		= IRQF_DISABLED | IRQF_TIMER,
 };
 
-static const int __initdata divide_rate[] = {
+static const int __initconst divide_rate[] = {
 #if CONFIG_H8300_TPU_CH == 0
 	1,4,16,64,0,0,0,0,
 #elif (CONFIG_H8300_TPU_CH == 1) || (CONFIG_H8300_TPU_CH == 5)
diff --git a/arch/h8300/platform/h8300h/irq.c b/arch/h8300/platform/h8300h/irq.c
index bc4f51b..0a50353 100644
--- a/arch/h8300/platform/h8300h/irq.c
+++ b/arch/h8300/platform/h8300h/irq.c
@@ -14,14 +14,14 @@
 #include <asm/gpio-internal.h>
 #include <asm/regs306x.h>
 
-const int __initdata h8300_saved_vectors[] = {
+const int __initconst h8300_saved_vectors[] = {
 #if defined(CONFIG_GDB_DEBUG)
 	TRAP3_VEC,	/* TRAPA #3 is GDB breakpoint */
 #endif
 	-1,
 };
 
-const h8300_vector __initdata h8300_trap_table[] = {
+const h8300_vector __initconst h8300_trap_table[] = {
 	0, 0, 0, 0, 0, 0, 0, 0,
 	system_call,
 	0,
diff --git a/arch/h8300/platform/h8s/irq.c b/arch/h8300/platform/h8s/irq.c
index 7b5f29f..cdf280c 100644
--- a/arch/h8300/platform/h8s/irq.c
+++ b/arch/h8300/platform/h8s/irq.c
@@ -18,7 +18,7 @@
 #include <asm/regs267x.h>
 
 /* saved vector list */
-const int __initdata h8300_saved_vectors[]={
+const int __initconst h8300_saved_vectors[]={
 #if defined(CONFIG_GDB_DEBUG)
 	TRACE_VEC,
 	TRAP3_VEC,
@@ -27,7 +27,7 @@ const int __initdata h8300_saved_vectors[]={
 };
 
 /* trap entry table */
-const H8300_VECTOR __initdata h8300_trap_table[] = {
+const H8300_VECTOR __initconst h8300_trap_table[] = {
 	0,0,0,0,0,
 	trace_break,  /* TRACE */
 	0,0,
-- 
1.7.7.6

