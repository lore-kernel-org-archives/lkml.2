Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760044Ab2JLSJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 14:09:46 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37825 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759935Ab2JLSJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 14:09:44 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [RFC PATCH 1/5] irq_work: Move irq_work_raise() declaration/default definition to arch headers
Date: Fri, 12 Oct 2012 20:09:32 +0200
Message-Id: <1350065376-23353-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1350065376-23353-1-git-send-email-fweisbec@gmail.com>
References: <1350065376-23353-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This optimization doesn't matter much. But this prepares the
arch headers that we need to add a new API in order to detect
when the arch hooks on the tick to implement the irq work.

This is necessary later to make printk working in nohz CPUs.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 arch/alpha/include/asm/irq_work.h    |    6 ++++++
 arch/arm/include/asm/irq_work.h      |    1 +
 arch/arm64/include/asm/irq_work.h    |    1 +
 arch/blackfin/include/asm/irq_work.h |    1 +
 arch/frv/include/asm/irq_work.h      |    1 +
 arch/hexagon/include/asm/irq_work.h  |    1 +
 arch/mips/include/asm/irq_work.h     |    1 +
 arch/parisc/include/asm/irq_work.h   |    1 +
 arch/powerpc/include/asm/irq_work.h  |    6 ++++++
 arch/s390/include/asm/irq_work.h     |    1 +
 arch/sh/include/asm/irq_work.h       |    1 +
 arch/sparc/include/asm/irq_work.h    |    6 ++++++
 arch/x86/include/asm/irq_work.h      |   10 ++++++++++
 arch/x86/kernel/irq_work.c           |    4 ++--
 include/asm-generic/irq_work.h       |    9 +++++++++
 include/linux/irq_work.h             |    1 +
 kernel/irq_work.c                    |    7 -------
 17 files changed, 49 insertions(+), 9 deletions(-)
 create mode 100644 arch/alpha/include/asm/irq_work.h
 create mode 100644 arch/arm/include/asm/irq_work.h
 create mode 100644 arch/arm64/include/asm/irq_work.h
 create mode 100644 arch/blackfin/include/asm/irq_work.h
 create mode 100644 arch/frv/include/asm/irq_work.h
 create mode 100644 arch/hexagon/include/asm/irq_work.h
 create mode 100644 arch/mips/include/asm/irq_work.h
 create mode 100644 arch/parisc/include/asm/irq_work.h
 create mode 100644 arch/powerpc/include/asm/irq_work.h
 create mode 100644 arch/s390/include/asm/irq_work.h
 create mode 100644 arch/sh/include/asm/irq_work.h
 create mode 100644 arch/sparc/include/asm/irq_work.h
 create mode 100644 arch/x86/include/asm/irq_work.h
 create mode 100644 include/asm-generic/irq_work.h

diff --git a/arch/alpha/include/asm/irq_work.h b/arch/alpha/include/asm/irq_work.h
new file mode 100644
index 0000000..814ff3d
--- /dev/null
+++ b/arch/alpha/include/asm/irq_work.h
@@ -0,0 +1,6 @@
+#ifndef _ALPHA_IRQ_WORK_H
+#define _ALPHA_IRQ_WORK_H
+
+extern void arch_irq_work_raise(void);
+
+#endif
diff --git a/arch/arm/include/asm/irq_work.h b/arch/arm/include/asm/irq_work.h
new file mode 100644
index 0000000..f1bffa2
--- /dev/null
+++ b/arch/arm/include/asm/irq_work.h
@@ -0,0 +1 @@
+#include <asm-generic/irq_work.h>
diff --git a/arch/arm64/include/asm/irq_work.h b/arch/arm64/include/asm/irq_work.h
new file mode 100644
index 0000000..f1bffa2
--- /dev/null
+++ b/arch/arm64/include/asm/irq_work.h
@@ -0,0 +1 @@
+#include <asm-generic/irq_work.h>
diff --git a/arch/blackfin/include/asm/irq_work.h b/arch/blackfin/include/asm/irq_work.h
new file mode 100644
index 0000000..f1bffa2
--- /dev/null
+++ b/arch/blackfin/include/asm/irq_work.h
@@ -0,0 +1 @@
+#include <asm-generic/irq_work.h>
diff --git a/arch/frv/include/asm/irq_work.h b/arch/frv/include/asm/irq_work.h
new file mode 100644
index 0000000..f1bffa2
--- /dev/null
+++ b/arch/frv/include/asm/irq_work.h
@@ -0,0 +1 @@
+#include <asm-generic/irq_work.h>
diff --git a/arch/hexagon/include/asm/irq_work.h b/arch/hexagon/include/asm/irq_work.h
new file mode 100644
index 0000000..f1bffa2
--- /dev/null
+++ b/arch/hexagon/include/asm/irq_work.h
@@ -0,0 +1 @@
+#include <asm-generic/irq_work.h>
diff --git a/arch/mips/include/asm/irq_work.h b/arch/mips/include/asm/irq_work.h
new file mode 100644
index 0000000..f1bffa2
--- /dev/null
+++ b/arch/mips/include/asm/irq_work.h
@@ -0,0 +1 @@
+#include <asm-generic/irq_work.h>
diff --git a/arch/parisc/include/asm/irq_work.h b/arch/parisc/include/asm/irq_work.h
new file mode 100644
index 0000000..f1bffa2
--- /dev/null
+++ b/arch/parisc/include/asm/irq_work.h
@@ -0,0 +1 @@
+#include <asm-generic/irq_work.h>
diff --git a/arch/powerpc/include/asm/irq_work.h b/arch/powerpc/include/asm/irq_work.h
new file mode 100644
index 0000000..8b9927f
--- /dev/null
+++ b/arch/powerpc/include/asm/irq_work.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_POWERPC_IRQ_WORK_H
+#define _ASM_POWERPC_IRQ_WORK_H
+
+extern void arch_irq_work_raise(void);
+
+#endif
diff --git a/arch/s390/include/asm/irq_work.h b/arch/s390/include/asm/irq_work.h
new file mode 100644
index 0000000..f1bffa2
--- /dev/null
+++ b/arch/s390/include/asm/irq_work.h
@@ -0,0 +1 @@
+#include <asm-generic/irq_work.h>
diff --git a/arch/sh/include/asm/irq_work.h b/arch/sh/include/asm/irq_work.h
new file mode 100644
index 0000000..f1bffa2
--- /dev/null
+++ b/arch/sh/include/asm/irq_work.h
@@ -0,0 +1 @@
+#include <asm-generic/irq_work.h>
diff --git a/arch/sparc/include/asm/irq_work.h b/arch/sparc/include/asm/irq_work.h
new file mode 100644
index 0000000..1d062a6
--- /dev/null
+++ b/arch/sparc/include/asm/irq_work.h
@@ -0,0 +1,6 @@
+#ifndef ___ASM_SPARC_IRQ_H
+#define ___ASM_SPARC_IRQ_H
+
+extern void arch_irq_work_raise(void);
+
+#endif
diff --git a/arch/x86/include/asm/irq_work.h b/arch/x86/include/asm/irq_work.h
new file mode 100644
index 0000000..38eed96
--- /dev/null
+++ b/arch/x86/include/asm/irq_work.h
@@ -0,0 +1,10 @@
+#ifndef _ASM_X86_IRQ_WORK_H
+#define _ASM_X86_IRQ_WORK_H
+
+#ifndef CONFIG_X86_LOCAL_APIC
+#include <asm-generic/irq_work.h>
+# else
+extern void arch_irq_work_raise(void);
+#endif
+
+#endif
diff --git a/arch/x86/kernel/irq_work.c b/arch/x86/kernel/irq_work.c
index ca8f703..95f5d4e 100644
--- a/arch/x86/kernel/irq_work.c
+++ b/arch/x86/kernel/irq_work.c
@@ -18,13 +18,13 @@ void smp_irq_work_interrupt(struct pt_regs *regs)
 	irq_exit();
 }
 
+#ifdef CONFIG_X86_LOCAL_APIC
 void arch_irq_work_raise(void)
 {
-#ifdef CONFIG_X86_LOCAL_APIC
 	if (!cpu_has_apic)
 		return;
 
 	apic->send_IPI_self(IRQ_WORK_VECTOR);
 	apic_wait_icr_idle();
-#endif
 }
+#endif
diff --git a/include/asm-generic/irq_work.h b/include/asm-generic/irq_work.h
new file mode 100644
index 0000000..a2d4108
--- /dev/null
+++ b/include/asm-generic/irq_work.h
@@ -0,0 +1,9 @@
+#ifndef __ASM_GENERIC_ATOMIC_H
+#define __ASM_GENERIC_ATOMIC_H
+
+/*
+ * Lame architectures will get the timer tick callback
+ */
+static inline void arch_irq_work_raise(void) { }
+
+#endif
diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
index 6a9e8f5..b39ea0b 100644
--- a/include/linux/irq_work.h
+++ b/include/linux/irq_work.h
@@ -2,6 +2,7 @@
 #define _LINUX_IRQ_WORK_H
 
 #include <linux/llist.h>
+#include <asm/irq_work.h>
 
 struct irq_work {
 	unsigned long flags;
diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index 1588e3b..44a5b19 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -49,13 +49,6 @@ static bool irq_work_claim(struct irq_work *work)
 	return true;
 }
 
-void __weak arch_irq_work_raise(void)
-{
-	/*
-	 * Lame architectures will get the timer tick callback
-	 */
-}
-
 /*
  * Queue the entry and raise the IPI if needed.
  */
-- 
1.7.5.4

