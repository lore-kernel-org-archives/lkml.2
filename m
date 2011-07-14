Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584Ab1GNVjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 17:39:18 -0400
Received: from smtp-out.google.com ([74.125.121.67]:20846 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932544Ab1GNVir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 17:38:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=nvll38mowosJK6ExbV9BW6o1aOQO4Ze9KbMCHWfXQWQP/JK41hd4VAY9Xb4YPEd2n
	0aCrXcGFLk3jdhOGHeWrA==
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 6/6] trace,x86: Add platform_irq_vector_{entry|exit} trace events
Date: Thu, 14 Jul 2011 14:38:15 -0700
Message-Id: <1310679495-29104-7-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1310679495-29104-1-git-send-email-vnagarnaik@google.com>
References: <1310679495-29104-1-git-send-email-vnagarnaik@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add tracepoints to trace platform specific IRQ vectors which do not have
equivalent generic kernel handlers. Along with the IRQ number traced,
there is a symbolic mapping to the equivalent name of the IRQ.

This patch only traces the x86 and x86_64 platform vectors but other
architectures can add the tracepoints in their equivalent files to make
use of this trace event.

This is a part of overall effort to trace all the interrupts happening
in a system to figure out what time is spent in kernel space versus user
space.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 arch/x86/include/asm/irq_vectors.h       |   43 ++++++++++++++++++++++++
 arch/x86/kernel/apic/apic.c              |    4 ++
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    2 +
 arch/x86/kernel/cpu/mcheck/threshold.c   |    2 +
 arch/x86/kernel/irq.c                    |    2 +
 arch/x86/kernel/traps.c                  |    2 +
 arch/x86/mm/tlb.c                        |    2 +
 include/trace/events/irq.h               |   52 ++++++++++++++++++++++++++++++
 8 files changed, 109 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 6e976ee..e169c3c 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -182,4 +182,47 @@ static inline int invalid_vm86_irq(int irq)
 # define NR_IRQS			NR_IRQS_LEGACY
 #endif
 
+#define platform_irq_vector_mapping(x) { x, #x }
+#define invalidate_tlb_vector_mapping(x) \
+		{ INVALIDATE_TLB_VECTOR_START+x, "INVALIDATE_TLB_VECTOR" }
+#define platform_irq_vector_name					\
+		platform_irq_vector_mapping(SPURIOUS_APIC_VECTOR),	\
+		platform_irq_vector_mapping(ERROR_APIC_VECTOR),		\
+		platform_irq_vector_mapping(THERMAL_APIC_VECTOR),	\
+		platform_irq_vector_mapping(THRESHOLD_APIC_VECTOR),	\
+		platform_irq_vector_mapping(X86_PLATFORM_IPI_VECTOR),	\
+		platform_irq_vector_mapping(NMI_VECTOR),		\
+		invalidate_tlb_vector_mapping(0),			\
+		invalidate_tlb_vector_mapping(1),			\
+		invalidate_tlb_vector_mapping(2),			\
+		invalidate_tlb_vector_mapping(3),			\
+		invalidate_tlb_vector_mapping(4),			\
+		invalidate_tlb_vector_mapping(5),			\
+		invalidate_tlb_vector_mapping(6),			\
+		invalidate_tlb_vector_mapping(7),			\
+		invalidate_tlb_vector_mapping(8),			\
+		invalidate_tlb_vector_mapping(9),			\
+		invalidate_tlb_vector_mapping(10),			\
+		invalidate_tlb_vector_mapping(11),			\
+		invalidate_tlb_vector_mapping(12),			\
+		invalidate_tlb_vector_mapping(13),			\
+		invalidate_tlb_vector_mapping(14),			\
+		invalidate_tlb_vector_mapping(15),			\
+		invalidate_tlb_vector_mapping(16),			\
+		invalidate_tlb_vector_mapping(17),			\
+		invalidate_tlb_vector_mapping(18),			\
+		invalidate_tlb_vector_mapping(19),			\
+		invalidate_tlb_vector_mapping(20),			\
+		invalidate_tlb_vector_mapping(21),			\
+		invalidate_tlb_vector_mapping(22),			\
+		invalidate_tlb_vector_mapping(23),			\
+		invalidate_tlb_vector_mapping(24),			\
+		invalidate_tlb_vector_mapping(25),			\
+		invalidate_tlb_vector_mapping(26),			\
+		invalidate_tlb_vector_mapping(27),			\
+		invalidate_tlb_vector_mapping(28),			\
+		invalidate_tlb_vector_mapping(29),			\
+		invalidate_tlb_vector_mapping(30),			\
+		invalidate_tlb_vector_mapping(31)
+
 #endif /* _ASM_X86_IRQ_VECTORS_H */
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b9338b8..6062eb3 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1792,6 +1792,7 @@ void smp_spurious_interrupt(struct pt_regs *regs)
 
 	exit_idle();
 	irq_enter();
+	trace_platform_irq_vector_entry(SPURIOUS_APIC_VECTOR);
 	/*
 	 * Check if this really is a spurious interrupt and ACK it
 	 * if it is a vectored one.  Just in case...
@@ -1806,6 +1807,7 @@ void smp_spurious_interrupt(struct pt_regs *regs)
 	/* see sw-dev-man vol 3, chapter 7.4.13.5 */
 	pr_info("spurious APIC interrupt on CPU#%d, "
 		"should never happen.\n", smp_processor_id());
+	trace_platform_irq_vector_exit(SPURIOUS_APIC_VECTOR);
 	irq_exit();
 }
 
@@ -1829,6 +1831,7 @@ void smp_error_interrupt(struct pt_regs *regs)
 
 	exit_idle();
 	irq_enter();
+	trace_platform_irq_vector_entry(ERROR_APIC_VECTOR);
 	/* First tickle the hardware, only then report what went on. -- REW */
 	v0 = apic_read(APIC_ESR);
 	apic_write(APIC_ESR, 0);
@@ -1849,6 +1852,7 @@ void smp_error_interrupt(struct pt_regs *regs)
 
 	apic_printk(APIC_DEBUG, KERN_CONT "\n");
 
+	trace_platform_irq_vector_exit(ERROR_APIC_VECTOR);
 	irq_exit();
 }
 
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 27c6251..4528f26 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -398,8 +398,10 @@ asmlinkage void smp_thermal_interrupt(struct pt_regs *regs)
 {
 	exit_idle();
 	irq_enter();
+	trace_platform_irq_vector_entry(THERMAL_APIC_VECTOR);
 	inc_irq_stat(irq_thermal_count);
 	smp_thermal_vector();
+	trace_platform_irq_vector_exit(THERMAL_APIC_VECTOR);
 	irq_exit();
 	/* Ack only at the end to avoid potential reentry */
 	ack_APIC_irq();
diff --git a/arch/x86/kernel/cpu/mcheck/threshold.c b/arch/x86/kernel/cpu/mcheck/threshold.c
index d746df2..0876815 100644
--- a/arch/x86/kernel/cpu/mcheck/threshold.c
+++ b/arch/x86/kernel/cpu/mcheck/threshold.c
@@ -21,8 +21,10 @@ asmlinkage void smp_threshold_interrupt(void)
 {
 	exit_idle();
 	irq_enter();
+	trace_platform_irq_vector_entry(THRESHOLD_APIC_VECTOR);
 	inc_irq_stat(irq_threshold_count);
 	mce_threshold_vector();
+	trace_platform_irq_vector_exit(THRESHOLD_APIC_VECTOR);
 	irq_exit();
 	/* Ack only at the end to avoid potential reentry */
 	ack_APIC_irq();
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 6c0802e..0c730f4 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -211,12 +211,14 @@ void smp_x86_platform_ipi(struct pt_regs *regs)
 	exit_idle();
 
 	irq_enter();
+	trace_platform_irq_vector_entry(X86_PLATFORM_IPI_VECTOR);
 
 	inc_irq_stat(x86_platform_ipis);
 
 	if (x86_platform_ipi_callback)
 		x86_platform_ipi_callback();
 
+	trace_platform_irq_vector_exit(X86_PLATFORM_IPI_VECTOR);
 	irq_exit();
 
 	set_irq_regs(old_regs);
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index fda27eb..0834c84 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -447,12 +447,14 @@ dotraplinkage notrace __kprobes void
 do_nmi(struct pt_regs *regs, long error_code)
 {
 	nmi_enter();
+	trace_platform_irq_vector_entry(NMI_VECTOR);
 
 	inc_irq_stat(__nmi_count);
 
 	if (!ignore_nmis)
 		default_do_nmi(regs);
 
+	trace_platform_irq_vector_exit(NMI_VECTOR);
 	nmi_exit();
 }
 
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index d6c0418..5c9e766 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -141,6 +141,7 @@ void smp_invalidate_interrupt(struct pt_regs *regs)
 	sender = ~regs->orig_ax - INVALIDATE_TLB_VECTOR_START;
 	f = &flush_state[sender];
 
+	trace_platform_irq_vector_entry(sender + INVALIDATE_TLB_VECTOR_START);
 	if (!cpumask_test_cpu(cpu, to_cpumask(f->flush_cpumask)))
 		goto out;
 		/*
@@ -167,6 +168,7 @@ out:
 	cpumask_clear_cpu(cpu, to_cpumask(f->flush_cpumask));
 	smp_mb__after_clear_bit();
 	inc_irq_stat(irq_tlb_count);
+	trace_platform_irq_vector_exit(sender + INVALIDATE_TLB_VECTOR_START);
 }
 
 static void flush_tlb_others_ipi(const struct cpumask *cpumask,
diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
index 40b19f4..2a399e8 100644
--- a/include/trace/events/irq.h
+++ b/include/trace/events/irq.h
@@ -457,6 +457,58 @@ DEFINE_EVENT(call_function, call_function_single_exit,
 	TP_ARGS(ignore)
 );
 
+#include <asm/irq.h>
+
+#if !defined(platform_irq_vector_name)
+#define platform_irq_vector_name { NULL, NULL }
+#endif
+
+DECLARE_EVENT_CLASS(platform_irq_vector,
+
+	TP_PROTO(unsigned int vec_num),
+
+	TP_ARGS(vec_num),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	vec_num	)
+	),
+
+	TP_fast_assign(
+		__entry->vec_num = vec_num;
+	),
+
+	TP_printk("%u: %s", __entry->vec_num,
+		__print_symbolic(__entry->vec_num, platform_irq_vector_name))
+);
+
+/**
+ * platform_irq_vector_entry - called immediately after entering the
+ * platform vector interrupt handler
+ *
+ * When used in combination with the platform_irq_vector_exit tracepoint
+ * we can determine the platform interrupt vector handler runtime.
+ */
+DEFINE_EVENT(platform_irq_vector, platform_irq_vector_entry,
+
+	TP_PROTO(unsigned int vec_num),
+
+	TP_ARGS(vec_num)
+);
+
+/**
+ * platform_irq_vector_exit - called just before the platform vector
+ * interrupt handler returns
+ *
+ * When used in combination with the platform_irq_vector_entry tracepoint
+ * we can determine the platform interrupt vector handler runtime.
+ */
+DEFINE_EVENT(platform_irq_vector, platform_irq_vector_exit,
+
+	TP_PROTO(unsigned int vec_num),
+
+	TP_ARGS(vec_num)
+);
+
 #endif /*  _TRACE_IRQ_H */
 
 /* This part must be outside protection */
-- 
1.7.3.1

