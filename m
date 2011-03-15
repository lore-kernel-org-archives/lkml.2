Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048Ab1COUzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 16:55:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51546 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757521Ab1COUzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 16:55:12 -0400
Date: Tue, 15 Mar 2011 21:54:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] irq changes for v2.6.39
Message-ID: <20110315205448.GA5893@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-core-for-linus

 Thanks,

	Ingo

------------------>
Ben Hutchings (1):
      genirq: Add IRQ affinity notifiers

David Daney (1):
      genirq: Call bus_lock/unlock functions in setup_irq()

Henrik Kretzschmar (5):
      x86: Move ioapic_irq_destination_types to apicdef.h
      x86: Add dummy mp_save_irq()
      x86: Rework arch_disable_smp_support() for x86
      x86: Add dummy functions for compiling without IOAPIC
      x86: Fix deps of X86_UP_IOAPIC

Jan Beulich (2):
      x86: Eliminate pointless adjustment attempts in fixup_irqs()
      genirq: Streamline kernel/irq/Kconfig

Thomas Gleixner (109):
      genirq: Fix affinity notifier fallout
      genirq: Add IRQF_FORCE_RESUME
      softirq: Avoid stack switch from ksoftirqd
      genirq: Remove dead code
      genirq: Prevent access beyond allocated_irqs bitmap
      genirq: Disable the SHIRQ_DEBUG call in request_threaded_irq for now
      genirq: Make nr_irqs runtime expandable
      genirq: Add missing buslock to set_irq_type(), set_irq_wake()
      genirq: Namespace cleanup
      genirq: Simplify affinity related code
      genirq: Rremove redundant check
      genirq: Always apply cpu online mask
      genirq: Do not copy affinity before set
      genirq: Remove redundant thread affinity setting
      genirq: Plug race in report_bad_irq()
      genirq: Warn when handler enables interrupts
      genirq: Fixup poll handling
      genirq: Do not poll disabled, percpu and timer interrupts
      genirq: spurious: Run only one poller at a time
      genirq: Mark polled irqs and defer the real handler
      genirq: Move irq thread flags to core
      genirq: Remove bogus conditional
      genirq: Consolidate startup/shutdown of interrupts
      genirq: Consolidate disable/enable
      genirq: Remove default magic
      genirq: Consolidate IRQ_DISABLED
      genirq: Do not fiddle with IRQ_MASKED in handle_edge_irq()
      genirq: Implement handle_irq_event()
      genirq: Use handle_irq_event() in handle_simple_irq()
      genirq: Use handle_irq_event() in handle_level_irq()
      genirq: Use handle_irq_event() in handle_fasteoi_irq()
      genirq: Use handle_irq_event() in handle_edge_irq()
      genirq: Use handle_perpcu_event() in handle_percpu_irq()
      genirq: Use handle_irq_event() in the spurious poll code
      genirq: Simplify handle_irq_event()
      genirq: Implement generic irq_show_interrupts()
      genirq: Fixup core code namespace fallout
      genirq: Add internal state field to irq_desc
      genirq: Protect tglx from tripping over his own feet
      genirq: Move IRQ_AUTODETECT to internal state
      genirq: Move IRQ_SPURIOUS_DISABLED to core state
      genirq: Use modify_status for set_irq_nested_thread
      genirq: Move IRQ_POLL_INPROGRESS to core
      genirq: Add IRQ_INPROGRESS to core
      genirq: Move IRQ_ONESHOT to core
      genirq: Move IRQ_REPLAY and IRQ_WAITING to core
      genirq: Move IRQ_DISABLED to core
      genirq: Move IRQ_PENDING flag to core
      genirq: Move IRQ_MASKED to core
      genirq: Move IRQ_SUSPENDED to core
      genirq: Move IRQ_WAKEUP to core
      genirq: Add state field to irq_data
      genirq: Add IRQ_MOVE_PENDING to irq_data.state
      genirq: Remove CONFIG_IRQ_PER_CPU
      genirq: Make CHECK_IRQ_PER_CPU an inline and deprecate it
      genirq: Remove CHECK_IRQ_PER_CPU from core code
      genirq: Move debug code to separate header
      genirq: Mirror IRQ_PER_CPU and IRQ_NO_BALANCING in irq_data.state
      genirq: Reuse existing can set affinty check
      genirq: Move IRQ_AFFINITY_SET to core
      genirq: Mirror irq trigger type bits in irq_data.state
      genirq: Wrap the remaning IRQ_* flags
      genirq: Force wrapped access to desc->status in core code
      genirq: Cleanup irq.h
      genirq: Add flags to irq_chip
      genirq: Add IRQCHIP_SET_TYPE_MASKED flag
      genirq: Move wakeup state to irq_data
      genirq: Reflect IRQ_MOVE_PCNTXT in irq_data state
      genirq: Remove desc->status when GENERIC_HARDIRQS_NO_COMPAT=y
      genirq: Remove real old transition functions
      genirq: Implement irq_get/put_desc_[bus]locked/unlock()
      genirq: Use irq_get/put functions
      genirq: Consolidate set_chip_handler functions
      genirq: Add preflow handler support
      genirq; Add fasteoi irq_chip quirk
      genirq: Implement irq_data based move_*_irq() versions
      genirq: Fix misplaced status update in irq_disable()
      genirq: Add missing break in __irq_set_trigger()
      genirq: Use the correct variable for note_interrupt
      x86: ioapic: Remove silly debug bloat in setup_IOAPIC_irqs()
      x86: ioapic: Split out the nested loop in setup_IO_APIC_irqs()
      x86: ioapic: Add io_apic_setup_irq_pin()
      x86: ioapic: Use new setup function in pre_init_apic_IRQ0()
      x86: ioapic: Use setup function in __io_apic_set_pci_routing()
      x86: ioapic: Use setup function in __io_apic_setup_irqs()
      x86: ioapic: Use setup function in setup_IO_APIC_irq_extra()
      x86: ioapic: Make a few functions static
      x86: ioapic: Remove useless inlines
      x86: ioapic: Implement and use io_apic_setup_irq_pin_once()
      x86: ioapic: Move trigger defines to io_apic.h
      genirq: Make warning in handle_percpu_event useful
      genirq: Prepare the handling of shared oneshot interrupts
      genirq: Allow shared oneshot interrupts
      genirq: Add IRQF_NO_THREAD
      sched: Switch wait_task_inactive to schedule_hrtimeout()
      genirq: Provide forced interrupt threading
      genirq: Fixup fasteoi handler for oneshot mode
      genirq: Add comments to Kconfig switches
      genirq: Add desc->irq_data accessor
      genirq: Add chip flag to force mask on suspend
      x86: Cleanup the genirq name space
      x86: ioapic: Simplify irq chip and handler setup
      x86: ioapic: Use irq_data->state
      x86: Use the proper accessors in fixup_irqs()
      x86: ioapic: Use new move_irq functions
      x86: ioapic: Avoid redundant lookup of irq_cfg
      x86: Use generic show_interrupts
      x86: Mark low level interrupts IRQF_NO_THREAD
      x86: Enable forced interrupt threading support

Yinghai Lu (1):
      genirq: Use IRQ_BITMAP_BITS as search size in irq_alloc_descs()


 Documentation/kernel-parameters.txt    |    4 +
 arch/x86/Kconfig                       |    4 +-
 arch/x86/include/asm/apicdef.h         |   12 +
 arch/x86/include/asm/io_apic.h         |   44 ++-
 arch/x86/kernel/apic/apic.c            |    5 +-
 arch/x86/kernel/apic/io_apic.c         |  388 +++++++++------------
 arch/x86/kernel/hpet.c                 |    2 +-
 arch/x86/kernel/i8259.c                |    2 +-
 arch/x86/kernel/irq.c                  |   82 +----
 arch/x86/kernel/irqinit.c              |    4 +-
 arch/x86/kernel/smpboot.c              |   11 +-
 arch/x86/lguest/boot.c                 |    4 +-
 arch/x86/pci/xen.c                     |    8 +-
 arch/x86/platform/uv/uv_irq.c          |    4 +-
 arch/x86/platform/visws/visws_quirks.c |    4 +-
 include/linux/interrupt.h              |   78 +++-
 include/linux/irq.h                    |  368 ++++++++++++++++----
 include/linux/irqdesc.h                |   78 ++++-
 kernel/irq/Kconfig                     |   39 ++-
 kernel/irq/autoprobe.c                 |   54 ++--
 kernel/irq/chip.c                      |  483 +++++++++++---------------
 kernel/irq/compat.h                    |   72 ++++
 kernel/irq/debug.h                     |   40 +++
 kernel/irq/handle.c                    |  144 ++++++--
 kernel/irq/internals.h                 |  173 +++++++---
 kernel/irq/irqdesc.c                   |   79 +++--
 kernel/irq/manage.c                    |  604 ++++++++++++++++++++++----------
 kernel/irq/migration.c                 |   38 ++-
 kernel/irq/pm.c                        |   30 ++-
 kernel/irq/proc.c                      |   70 ++++-
 kernel/irq/resend.c                    |   19 +-
 kernel/irq/settings.h                  |  138 ++++++++
 kernel/irq/spurious.c                  |  163 ++++++---
 kernel/sched.c                         |    5 +-
 kernel/softirq.c                       |   21 +-
 35 files changed, 2144 insertions(+), 1130 deletions(-)
 create mode 100644 kernel/irq/compat.h
 create mode 100644 kernel/irq/debug.h
 create mode 100644 kernel/irq/settings.h

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index f4a04c0..738c6fd 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2444,6 +2444,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			<deci-seconds>: poll all this frequency
 			0: no polling (default)
 
+	threadirqs	[KNL]
+			Force threading of all interrupt handlers except those
+			marked explicitely IRQF_NO_THREAD.
+
 	topology=	[S390]
 			Format: {off | on}
 			Specify if the kernel should make use of the cpu
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d5ed94d..e7ef769 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -66,6 +66,8 @@ config X86
 	select HAVE_SPARSE_IRQ
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
+	select GENERIC_IRQ_SHOW
+	select IRQ_FORCED_THREADING
 	select USE_GENERIC_SMP_HELPERS if SMP
 
 config INSTRUCTION_DECODER
@@ -811,7 +813,7 @@ config X86_LOCAL_APIC
 
 config X86_IO_APIC
 	def_bool y
-	depends on X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_APIC
+	depends on X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_IOAPIC
 
 config X86_VISWS_APIC
 	def_bool y
diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
index 47a30ff..d87988b 100644
--- a/arch/x86/include/asm/apicdef.h
+++ b/arch/x86/include/asm/apicdef.h
@@ -426,4 +426,16 @@ struct local_apic {
 #else
  #define BAD_APICID 0xFFFFu
 #endif
+
+enum ioapic_irq_destination_types {
+	dest_Fixed		= 0,
+	dest_LowestPrio		= 1,
+	dest_SMI		= 2,
+	dest__reserved_1	= 3,
+	dest_NMI		= 4,
+	dest_INIT		= 5,
+	dest__reserved_2	= 6,
+	dest_ExtINT		= 7
+};
+
 #endif /* _ASM_X86_APICDEF_H */
diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index f327d38..c4bd267 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -63,17 +63,6 @@ union IO_APIC_reg_03 {
 	} __attribute__ ((packed)) bits;
 };
 
-enum ioapic_irq_destination_types {
-	dest_Fixed = 0,
-	dest_LowestPrio = 1,
-	dest_SMI = 2,
-	dest__reserved_1 = 3,
-	dest_NMI = 4,
-	dest_INIT = 5,
-	dest__reserved_2 = 6,
-	dest_ExtINT = 7
-};
-
 struct IO_APIC_route_entry {
 	__u32	vector		:  8,
 		delivery_mode	:  3,	/* 000: FIXED
@@ -106,6 +95,10 @@ struct IR_IO_APIC_route_entry {
 		index		: 15;
 } __attribute__ ((packed));
 
+#define IOAPIC_AUTO     -1
+#define IOAPIC_EDGE     0
+#define IOAPIC_LEVEL    1
+
 #ifdef CONFIG_X86_IO_APIC
 
 /*
@@ -150,11 +143,6 @@ extern int timer_through_8259;
 #define io_apic_assign_pci_irqs \
 	(mp_irq_entries && !skip_ioapic_setup && io_apic_irqs)
 
-extern u8 io_apic_unique_id(u8 id);
-extern int io_apic_get_unique_id(int ioapic, int apic_id);
-extern int io_apic_get_version(int ioapic);
-extern int io_apic_get_redir_entries(int ioapic);
-
 struct io_apic_irq_attr;
 extern int io_apic_set_pci_routing(struct device *dev, int irq,
 		 struct io_apic_irq_attr *irq_attr);
@@ -162,6 +150,8 @@ void setup_IO_APIC_irq_extra(u32 gsi);
 extern void ioapic_and_gsi_init(void);
 extern void ioapic_insert_resources(void);
 
+int io_apic_setup_irq_pin(unsigned int irq, int node, struct io_apic_irq_attr *attr);
+
 extern struct IO_APIC_route_entry **alloc_ioapic_entries(void);
 extern void free_ioapic_entries(struct IO_APIC_route_entry **ioapic_entries);
 extern int save_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
@@ -186,6 +176,8 @@ extern void __init pre_init_apic_IRQ0(void);
 
 extern void mp_save_irq(struct mpc_intsrc *m);
 
+extern void disable_ioapic_support(void);
+
 #else  /* !CONFIG_X86_IO_APIC */
 
 #define io_apic_assign_pci_irqs 0
@@ -199,6 +191,26 @@ static inline int mp_find_ioapic(u32 gsi) { return 0; }
 struct io_apic_irq_attr;
 static inline int io_apic_set_pci_routing(struct device *dev, int irq,
 		 struct io_apic_irq_attr *irq_attr) { return 0; }
+
+static inline struct IO_APIC_route_entry **alloc_ioapic_entries(void)
+{
+	return NULL;
+}
+
+static inline void free_ioapic_entries(struct IO_APIC_route_entry **ent) { }
+static inline int save_IO_APIC_setup(struct IO_APIC_route_entry **ent)
+{
+	return -ENOMEM;
+}
+
+static inline void mask_IO_APIC_setup(struct IO_APIC_route_entry **ent) { }
+static inline int restore_IO_APIC_setup(struct IO_APIC_route_entry **ent)
+{
+	return -ENOMEM;
+}
+
+static inline void mp_save_irq(struct mpc_intsrc *m) { };
+static inline void disable_ioapic_support(void) { }
 #endif
 
 #endif /* _ASM_X86_IO_APIC_H */
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 76b96d7..f0e0798 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -43,6 +43,7 @@
 #include <asm/i8259.h>
 #include <asm/proto.h>
 #include <asm/apic.h>
+#include <asm/io_apic.h>
 #include <asm/desc.h>
 #include <asm/hpet.h>
 #include <asm/idle.h>
@@ -1209,7 +1210,7 @@ void __cpuinit setup_local_APIC(void)
 		rdtscll(tsc);
 
 	if (disable_apic) {
-		arch_disable_smp_support();
+		disable_ioapic_support();
 		return;
 	}
 
@@ -1448,7 +1449,7 @@ int __init enable_IR(void)
 void __init enable_IR_x2apic(void)
 {
 	unsigned long flags;
-	struct IO_APIC_route_entry **ioapic_entries = NULL;
+	struct IO_APIC_route_entry **ioapic_entries;
 	int ret, x2apic_enabled = 0;
 	int dmar_table_init_ret;
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index ca9e2a3..4b5ebd2 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -108,7 +108,10 @@ DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
 
 int skip_ioapic_setup;
 
-void arch_disable_smp_support(void)
+/**
+ * disable_ioapic_support() - disables ioapic support at runtime
+ */
+void disable_ioapic_support(void)
 {
 #ifdef CONFIG_PCI
 	noioapicquirk = 1;
@@ -120,11 +123,14 @@ void arch_disable_smp_support(void)
 static int __init parse_noapic(char *str)
 {
 	/* disable IO-APIC */
-	arch_disable_smp_support();
+	disable_ioapic_support();
 	return 0;
 }
 early_param("noapic", parse_noapic);
 
+static int io_apic_setup_irq_pin_once(unsigned int irq, int node,
+				      struct io_apic_irq_attr *attr);
+
 /* Will be called in mpparse/acpi/sfi codes for saving IRQ info */
 void mp_save_irq(struct mpc_intsrc *m)
 {
@@ -181,7 +187,7 @@ int __init arch_early_irq_init(void)
 	irq_reserve_irqs(0, legacy_pic->nr_legacy_irqs);
 
 	for (i = 0; i < count; i++) {
-		set_irq_chip_data(i, &cfg[i]);
+		irq_set_chip_data(i, &cfg[i]);
 		zalloc_cpumask_var_node(&cfg[i].domain, GFP_KERNEL, node);
 		zalloc_cpumask_var_node(&cfg[i].old_domain, GFP_KERNEL, node);
 		/*
@@ -200,7 +206,7 @@ int __init arch_early_irq_init(void)
 #ifdef CONFIG_SPARSE_IRQ
 static struct irq_cfg *irq_cfg(unsigned int irq)
 {
-	return get_irq_chip_data(irq);
+	return irq_get_chip_data(irq);
 }
 
 static struct irq_cfg *alloc_irq_cfg(unsigned int irq, int node)
@@ -226,7 +232,7 @@ static void free_irq_cfg(unsigned int at, struct irq_cfg *cfg)
 {
 	if (!cfg)
 		return;
-	set_irq_chip_data(at, NULL);
+	irq_set_chip_data(at, NULL);
 	free_cpumask_var(cfg->domain);
 	free_cpumask_var(cfg->old_domain);
 	kfree(cfg);
@@ -256,14 +262,14 @@ static struct irq_cfg *alloc_irq_and_cfg_at(unsigned int at, int node)
 	if (res < 0) {
 		if (res != -EEXIST)
 			return NULL;
-		cfg = get_irq_chip_data(at);
+		cfg = irq_get_chip_data(at);
 		if (cfg)
 			return cfg;
 	}
 
 	cfg = alloc_irq_cfg(at, node);
 	if (cfg)
-		set_irq_chip_data(at, cfg);
+		irq_set_chip_data(at, cfg);
 	else
 		irq_free_desc(at);
 	return cfg;
@@ -818,7 +824,7 @@ static int EISA_ELCR(unsigned int irq)
 #define default_MCA_trigger(idx)	(1)
 #define default_MCA_polarity(idx)	default_ISA_polarity(idx)
 
-static int MPBIOS_polarity(int idx)
+static int irq_polarity(int idx)
 {
 	int bus = mp_irqs[idx].srcbus;
 	int polarity;
@@ -860,7 +866,7 @@ static int MPBIOS_polarity(int idx)
 	return polarity;
 }
 
-static int MPBIOS_trigger(int idx)
+static int irq_trigger(int idx)
 {
 	int bus = mp_irqs[idx].srcbus;
 	int trigger;
@@ -932,16 +938,6 @@ static int MPBIOS_trigger(int idx)
 	return trigger;
 }
 
-static inline int irq_polarity(int idx)
-{
-	return MPBIOS_polarity(idx);
-}
-
-static inline int irq_trigger(int idx)
-{
-	return MPBIOS_trigger(idx);
-}
-
 static int pin_2_irq(int idx, int apic, int pin)
 {
 	int irq;
@@ -1189,7 +1185,7 @@ void __setup_vector_irq(int cpu)
 	raw_spin_lock(&vector_lock);
 	/* Mark the inuse vectors */
 	for_each_active_irq(irq) {
-		cfg = get_irq_chip_data(irq);
+		cfg = irq_get_chip_data(irq);
 		if (!cfg)
 			continue;
 		/*
@@ -1220,10 +1216,6 @@ void __setup_vector_irq(int cpu)
 static struct irq_chip ioapic_chip;
 static struct irq_chip ir_ioapic_chip;
 
-#define IOAPIC_AUTO     -1
-#define IOAPIC_EDGE     0
-#define IOAPIC_LEVEL    1
-
 #ifdef CONFIG_X86_32
 static inline int IO_APIC_irq_trigger(int irq)
 {
@@ -1248,35 +1240,31 @@ static inline int IO_APIC_irq_trigger(int irq)
 }
 #endif
 
-static void ioapic_register_intr(unsigned int irq, unsigned long trigger)
+static void ioapic_register_intr(unsigned int irq, struct irq_cfg *cfg,
+				 unsigned long trigger)
 {
+	struct irq_chip *chip = &ioapic_chip;
+	irq_flow_handler_t hdl;
+	bool fasteoi;
 
 	if ((trigger == IOAPIC_AUTO && IO_APIC_irq_trigger(irq)) ||
-	    trigger == IOAPIC_LEVEL)
+	    trigger == IOAPIC_LEVEL) {
 		irq_set_status_flags(irq, IRQ_LEVEL);
-	else
+		fasteoi = true;
+	} else {
 		irq_clear_status_flags(irq, IRQ_LEVEL);
+		fasteoi = false;
+	}
 
-	if (irq_remapped(get_irq_chip_data(irq))) {
+	if (irq_remapped(cfg)) {
 		irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
-		if (trigger)
-			set_irq_chip_and_handler_name(irq, &ir_ioapic_chip,
-						      handle_fasteoi_irq,
-						     "fasteoi");
-		else
-			set_irq_chip_and_handler_name(irq, &ir_ioapic_chip,
-						      handle_edge_irq, "edge");
-		return;
+		chip = &ir_ioapic_chip;
+		fasteoi = trigger != 0;
 	}
 
-	if ((trigger == IOAPIC_AUTO && IO_APIC_irq_trigger(irq)) ||
-	    trigger == IOAPIC_LEVEL)
-		set_irq_chip_and_handler_name(irq, &ioapic_chip,
-					      handle_fasteoi_irq,
-					      "fasteoi");
-	else
-		set_irq_chip_and_handler_name(irq, &ioapic_chip,
-					      handle_edge_irq, "edge");
+	hdl = fasteoi ? handle_fasteoi_irq : handle_edge_irq;
+	irq_set_chip_and_handler_name(irq, chip, hdl,
+				      fasteoi ? "fasteoi" : "edge");
 }
 
 static int setup_ioapic_entry(int apic_id, int irq,
@@ -1374,7 +1362,7 @@ static void setup_ioapic_irq(int apic_id, int pin, unsigned int irq,
 		return;
 	}
 
-	ioapic_register_intr(irq, trigger);
+	ioapic_register_intr(irq, cfg, trigger);
 	if (irq < legacy_pic->nr_legacy_irqs)
 		legacy_pic->mask(irq);
 
@@ -1385,33 +1373,26 @@ static struct {
 	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
 } mp_ioapic_routing[MAX_IO_APICS];
 
-static void __init setup_IO_APIC_irqs(void)
+static bool __init io_apic_pin_not_connected(int idx, int apic_id, int pin)
 {
-	int apic_id, pin, idx, irq, notcon = 0;
-	int node = cpu_to_node(0);
-	struct irq_cfg *cfg;
+	if (idx != -1)
+		return false;
 
-	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
+	apic_printk(APIC_VERBOSE, KERN_DEBUG " apic %d pin %d not connected\n",
+		    mp_ioapics[apic_id].apicid, pin);
+	return true;
+}
+
+static void __init __io_apic_setup_irqs(unsigned int apic_id)
+{
+	int idx, node = cpu_to_node(0);
+	struct io_apic_irq_attr attr;
+	unsigned int pin, irq;
 
-	for (apic_id = 0; apic_id < nr_ioapics; apic_id++)
 	for (pin = 0; pin < nr_ioapic_registers[apic_id]; pin++) {
 		idx = find_irq_entry(apic_id, pin, mp_INT);
-		if (idx == -1) {
-			if (!notcon) {
-				notcon = 1;
-				apic_printk(APIC_VERBOSE,
-					KERN_DEBUG " %d-%d",
-					mp_ioapics[apic_id].apicid, pin);
-			} else
-				apic_printk(APIC_VERBOSE, " %d-%d",
-					mp_ioapics[apic_id].apicid, pin);
+		if (io_apic_pin_not_connected(idx, apic_id, pin))
 			continue;
-		}
-		if (notcon) {
-			apic_printk(APIC_VERBOSE,
-				" (apicid-pin) not connected\n");
-			notcon = 0;
-		}
 
 		irq = pin_2_irq(idx, apic_id, pin);
 
@@ -1423,25 +1404,24 @@ static void __init setup_IO_APIC_irqs(void)
 		 * installed and if it returns 1:
 		 */
 		if (apic->multi_timer_check &&
-				apic->multi_timer_check(apic_id, irq))
+		    apic->multi_timer_check(apic_id, irq))
 			continue;
 
-		cfg = alloc_irq_and_cfg_at(irq, node);
-		if (!cfg)
-			continue;
+		set_io_apic_irq_attr(&attr, apic_id, pin, irq_trigger(idx),
+				     irq_polarity(idx));
 
-		add_pin_to_irq_node(cfg, node, apic_id, pin);
-		/*
-		 * don't mark it in pin_programmed, so later acpi could
-		 * set it correctly when irq < 16
-		 */
-		setup_ioapic_irq(apic_id, pin, irq, cfg, irq_trigger(idx),
-				  irq_polarity(idx));
+		io_apic_setup_irq_pin(irq, node, &attr);
 	}
+}
 
-	if (notcon)
-		apic_printk(APIC_VERBOSE,
-			" (apicid-pin) not connected\n");
+static void __init setup_IO_APIC_irqs(void)
+{
+	unsigned int apic_id;
+
+	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
+
+	for (apic_id = 0; apic_id < nr_ioapics; apic_id++)
+		__io_apic_setup_irqs(apic_id);
 }
 
 /*
@@ -1452,7 +1432,7 @@ static void __init setup_IO_APIC_irqs(void)
 void setup_IO_APIC_irq_extra(u32 gsi)
 {
 	int apic_id = 0, pin, idx, irq, node = cpu_to_node(0);
-	struct irq_cfg *cfg;
+	struct io_apic_irq_attr attr;
 
 	/*
 	 * Convert 'gsi' to 'ioapic.pin'.
@@ -1472,21 +1452,10 @@ void setup_IO_APIC_irq_extra(u32 gsi)
 	if (apic_id == 0 || irq < NR_IRQS_LEGACY)
 		return;
 
-	cfg = alloc_irq_and_cfg_at(irq, node);
-	if (!cfg)
-		return;
-
-	add_pin_to_irq_node(cfg, node, apic_id, pin);
-
-	if (test_bit(pin, mp_ioapic_routing[apic_id].pin_programmed)) {
-		pr_debug("Pin %d-%d already programmed\n",
-			 mp_ioapics[apic_id].apicid, pin);
-		return;
-	}
-	set_bit(pin, mp_ioapic_routing[apic_id].pin_programmed);
+	set_io_apic_irq_attr(&attr, apic_id, pin, irq_trigger(idx),
+			     irq_polarity(idx));
 
-	setup_ioapic_irq(apic_id, pin, irq, cfg,
-			irq_trigger(idx), irq_polarity(idx));
+	io_apic_setup_irq_pin_once(irq, node, &attr);
 }
 
 /*
@@ -1518,7 +1487,8 @@ static void __init setup_timer_IRQ0_pin(unsigned int apic_id, unsigned int pin,
 	 * The timer IRQ doesn't have to know that behind the
 	 * scene we may have a 8259A-master in AEOI mode ...
 	 */
-	set_irq_chip_and_handler_name(0, &ioapic_chip, handle_edge_irq, "edge");
+	irq_set_chip_and_handler_name(0, &ioapic_chip, handle_edge_irq,
+				      "edge");
 
 	/*
 	 * Add it to the IO-APIC irq-routing table:
@@ -1625,7 +1595,7 @@ __apicdebuginit(void) print_IO_APIC(void)
 	for_each_active_irq(irq) {
 		struct irq_pin_list *entry;
 
-		cfg = get_irq_chip_data(irq);
+		cfg = irq_get_chip_data(irq);
 		if (!cfg)
 			continue;
 		entry = cfg->irq_2_pin;
@@ -2391,7 +2361,7 @@ static void irq_complete_move(struct irq_cfg *cfg)
 
 void irq_force_complete_move(int irq)
 {
-	struct irq_cfg *cfg = get_irq_chip_data(irq);
+	struct irq_cfg *cfg = irq_get_chip_data(irq);
 
 	if (!cfg)
 		return;
@@ -2405,7 +2375,7 @@ static inline void irq_complete_move(struct irq_cfg *cfg) { }
 static void ack_apic_edge(struct irq_data *data)
 {
 	irq_complete_move(data->chip_data);
-	move_native_irq(data->irq);
+	irq_move_irq(data);
 	ack_APIC_irq();
 }
 
@@ -2462,7 +2432,7 @@ static void ack_apic_level(struct irq_data *data)
 	irq_complete_move(cfg);
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	/* If we are moving the irq we need to mask it */
-	if (unlikely(irq_to_desc(irq)->status & IRQ_MOVE_PENDING)) {
+	if (unlikely(irqd_is_setaffinity_pending(data))) {
 		do_unmask_irq = 1;
 		mask_ioapic(cfg);
 	}
@@ -2551,7 +2521,7 @@ static void ack_apic_level(struct irq_data *data)
 		 * and you can go talk to the chipset vendor about it.
 		 */
 		if (!io_apic_level_ack_pending(cfg))
-			move_masked_irq(irq);
+			irq_move_masked_irq(data);
 		unmask_ioapic(cfg);
 	}
 }
@@ -2614,7 +2584,7 @@ static inline void init_IO_APIC_traps(void)
 	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
 	 */
 	for_each_active_irq(irq) {
-		cfg = get_irq_chip_data(irq);
+		cfg = irq_get_chip_data(irq);
 		if (IO_APIC_IRQ(irq) && cfg && !cfg->vector) {
 			/*
 			 * Hmm.. We don't have an entry for this,
@@ -2625,7 +2595,7 @@ static inline void init_IO_APIC_traps(void)
 				legacy_pic->make_irq(irq);
 			else
 				/* Strange. Oh, well.. */
-				set_irq_chip(irq, &no_irq_chip);
+				irq_set_chip(irq, &no_irq_chip);
 		}
 	}
 }
@@ -2665,7 +2635,7 @@ static struct irq_chip lapic_chip __read_mostly = {
 static void lapic_register_intr(int irq)
 {
 	irq_clear_status_flags(irq, IRQ_LEVEL);
-	set_irq_chip_and_handler_name(irq, &lapic_chip, handle_edge_irq,
+	irq_set_chip_and_handler_name(irq, &lapic_chip, handle_edge_irq,
 				      "edge");
 }
 
@@ -2749,7 +2719,7 @@ int timer_through_8259 __initdata;
  */
 static inline void __init check_timer(void)
 {
-	struct irq_cfg *cfg = get_irq_chip_data(0);
+	struct irq_cfg *cfg = irq_get_chip_data(0);
 	int node = cpu_to_node(0);
 	int apic1, pin1, apic2, pin2;
 	unsigned long flags;
@@ -3060,7 +3030,7 @@ unsigned int create_irq_nr(unsigned int from, int node)
 	raw_spin_unlock_irqrestore(&vector_lock, flags);
 
 	if (ret) {
-		set_irq_chip_data(irq, cfg);
+		irq_set_chip_data(irq, cfg);
 		irq_clear_status_flags(irq, IRQ_NOREQUEST);
 	} else {
 		free_irq_at(irq, cfg);
@@ -3085,7 +3055,7 @@ int create_irq(void)
 
 void destroy_irq(unsigned int irq)
 {
-	struct irq_cfg *cfg = get_irq_chip_data(irq);
+	struct irq_cfg *cfg = irq_get_chip_data(irq);
 	unsigned long flags;
 
 	irq_set_status_flags(irq, IRQ_NOREQUEST|IRQ_NOPROBE);
@@ -3119,7 +3089,7 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
 
 	dest = apic->cpu_mask_to_apicid_and(cfg->domain, apic->target_cpus());
 
-	if (irq_remapped(get_irq_chip_data(irq))) {
+	if (irq_remapped(cfg)) {
 		struct irte irte;
 		int ir_index;
 		u16 sub_handle;
@@ -3291,6 +3261,7 @@ static int msi_alloc_irte(struct pci_dev *dev, int irq, int nvec)
 
 static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
 {
+	struct irq_chip *chip = &msi_chip;
 	struct msi_msg msg;
 	int ret;
 
@@ -3298,14 +3269,15 @@ static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
 	if (ret < 0)
 		return ret;
 
-	set_irq_msi(irq, msidesc);
+	irq_set_msi_desc(irq, msidesc);
 	write_msi_msg(irq, &msg);
 
-	if (irq_remapped(get_irq_chip_data(irq))) {
+	if (irq_remapped(irq_get_chip_data(irq))) {
 		irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
-		set_irq_chip_and_handler_name(irq, &msi_ir_chip, handle_edge_irq, "edge");
-	} else
-		set_irq_chip_and_handler_name(irq, &msi_chip, handle_edge_irq, "edge");
+		chip = &msi_ir_chip;
+	}
+
+	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
 
 	dev_printk(KERN_DEBUG, &dev->dev, "irq %d for MSI/MSI-X\n", irq);
 
@@ -3423,8 +3395,8 @@ int arch_setup_dmar_msi(unsigned int irq)
 	if (ret < 0)
 		return ret;
 	dmar_msi_write(irq, &msg);
-	set_irq_chip_and_handler_name(irq, &dmar_msi_type, handle_edge_irq,
-		"edge");
+	irq_set_chip_and_handler_name(irq, &dmar_msi_type, handle_edge_irq,
+				      "edge");
 	return 0;
 }
 #endif
@@ -3482,6 +3454,7 @@ static struct irq_chip hpet_msi_type = {
 
 int arch_setup_hpet_msi(unsigned int irq, unsigned int id)
 {
+	struct irq_chip *chip = &hpet_msi_type;
 	struct msi_msg msg;
 	int ret;
 
@@ -3501,15 +3474,12 @@ int arch_setup_hpet_msi(unsigned int irq, unsigned int id)
 	if (ret < 0)
 		return ret;
 
-	hpet_msi_write(get_irq_data(irq), &msg);
+	hpet_msi_write(irq_get_handler_data(irq), &msg);
 	irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
-	if (irq_remapped(get_irq_chip_data(irq)))
-		set_irq_chip_and_handler_name(irq, &ir_hpet_msi_type,
-					      handle_edge_irq, "edge");
-	else
-		set_irq_chip_and_handler_name(irq, &hpet_msi_type,
-					      handle_edge_irq, "edge");
+	if (irq_remapped(irq_get_chip_data(irq)))
+		chip = &ir_hpet_msi_type;
 
+	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
 	return 0;
 }
 #endif
@@ -3596,7 +3566,7 @@ int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
 
 		write_ht_irq_msg(irq, &msg);
 
-		set_irq_chip_and_handler_name(irq, &ht_irq_chip,
+		irq_set_chip_and_handler_name(irq, &ht_irq_chip,
 					      handle_edge_irq, "edge");
 
 		dev_printk(KERN_DEBUG, &dev->dev, "irq %d for HT\n", irq);
@@ -3605,7 +3575,40 @@ int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
 }
 #endif /* CONFIG_HT_IRQ */
 
-int __init io_apic_get_redir_entries (int ioapic)
+int
+io_apic_setup_irq_pin(unsigned int irq, int node, struct io_apic_irq_attr *attr)
+{
+	struct irq_cfg *cfg = alloc_irq_and_cfg_at(irq, node);
+	int ret;
+
+	if (!cfg)
+		return -EINVAL;
+	ret = __add_pin_to_irq_node(cfg, node, attr->ioapic, attr->ioapic_pin);
+	if (!ret)
+		setup_ioapic_irq(attr->ioapic, attr->ioapic_pin, irq, cfg,
+				 attr->trigger, attr->polarity);
+	return ret;
+}
+
+static int io_apic_setup_irq_pin_once(unsigned int irq, int node,
+				      struct io_apic_irq_attr *attr)
+{
+	unsigned int id = attr->ioapic, pin = attr->ioapic_pin;
+	int ret;
+
+	/* Avoid redundant programming */
+	if (test_bit(pin, mp_ioapic_routing[id].pin_programmed)) {
+		pr_debug("Pin %d-%d already programmed\n",
+			 mp_ioapics[id].apicid, pin);
+		return 0;
+	}
+	ret = io_apic_setup_irq_pin(irq, node, attr);
+	if (!ret)
+		set_bit(pin, mp_ioapic_routing[id].pin_programmed);
+	return ret;
+}
+
+static int __init io_apic_get_redir_entries(int ioapic)
 {
 	union IO_APIC_reg_01	reg_01;
 	unsigned long flags;
@@ -3659,96 +3662,24 @@ int __init arch_probe_nr_irqs(void)
 }
 #endif
 
-static int __io_apic_set_pci_routing(struct device *dev, int irq,
-				struct io_apic_irq_attr *irq_attr)
+int io_apic_set_pci_routing(struct device *dev, int irq,
+			    struct io_apic_irq_attr *irq_attr)
 {
-	struct irq_cfg *cfg;
 	int node;
-	int ioapic, pin;
-	int trigger, polarity;
 
-	ioapic = irq_attr->ioapic;
 	if (!IO_APIC_IRQ(irq)) {
 		apic_printk(APIC_QUIET,KERN_ERR "IOAPIC[%d]: Invalid reference to IRQ 0\n",
-			ioapic);
+			    irq_attr->ioapic);
 		return -EINVAL;
 	}
 
-	if (dev)
-		node = dev_to_node(dev);
-	else
-		node = cpu_to_node(0);
-
-	cfg = alloc_irq_and_cfg_at(irq, node);
-	if (!cfg)
-		return 0;
-
-	pin = irq_attr->ioapic_pin;
-	trigger = irq_attr->trigger;
-	polarity = irq_attr->polarity;
+	node = dev ? dev_to_node(dev) : cpu_to_node(0);
 
-	/*
-	 * IRQs < 16 are already in the irq_2_pin[] map
-	 */
-	if (irq >= legacy_pic->nr_legacy_irqs) {
-		if (__add_pin_to_irq_node(cfg, node, ioapic, pin)) {
-			printk(KERN_INFO "can not add pin %d for irq %d\n",
-				pin, irq);
-			return 0;
-		}
-	}
-
-	setup_ioapic_irq(ioapic, pin, irq, cfg, trigger, polarity);
-
-	return 0;
+	return io_apic_setup_irq_pin_once(irq, node, irq_attr);
 }
 
-int io_apic_set_pci_routing(struct device *dev, int irq,
-				struct io_apic_irq_attr *irq_attr)
-{
-	int ioapic, pin;
-	/*
-	 * Avoid pin reprogramming.  PRTs typically include entries
-	 * with redundant pin->gsi mappings (but unique PCI devices);
-	 * we only program the IOAPIC on the first.
-	 */
-	ioapic = irq_attr->ioapic;
-	pin = irq_attr->ioapic_pin;
-	if (test_bit(pin, mp_ioapic_routing[ioapic].pin_programmed)) {
-		pr_debug("Pin %d-%d already programmed\n",
-			 mp_ioapics[ioapic].apicid, pin);
-		return 0;
-	}
-	set_bit(pin, mp_ioapic_routing[ioapic].pin_programmed);
-
-	return __io_apic_set_pci_routing(dev, irq, irq_attr);
-}
-
-u8 __init io_apic_unique_id(u8 id)
-{
 #ifdef CONFIG_X86_32
-	if ((boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) &&
-	    !APIC_XAPIC(apic_version[boot_cpu_physical_apicid]))
-		return io_apic_get_unique_id(nr_ioapics, id);
-	else
-		return id;
-#else
-	int i;
-	DECLARE_BITMAP(used, 256);
-
-	bitmap_zero(used, 256);
-	for (i = 0; i < nr_ioapics; i++) {
-		struct mpc_ioapic *ia = &mp_ioapics[i];
-		__set_bit(ia->apicid, used);
-	}
-	if (!test_bit(id, used))
-		return id;
-	return find_first_zero_bit(used, 256);
-#endif
-}
-
-#ifdef CONFIG_X86_32
-int __init io_apic_get_unique_id(int ioapic, int apic_id)
+static int __init io_apic_get_unique_id(int ioapic, int apic_id)
 {
 	union IO_APIC_reg_00 reg_00;
 	static physid_mask_t apic_id_map = PHYSID_MASK_NONE;
@@ -3821,9 +3752,33 @@ int __init io_apic_get_unique_id(int ioapic, int apic_id)
 
 	return apic_id;
 }
+
+static u8 __init io_apic_unique_id(u8 id)
+{
+	if ((boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) &&
+	    !APIC_XAPIC(apic_version[boot_cpu_physical_apicid]))
+		return io_apic_get_unique_id(nr_ioapics, id);
+	else
+		return id;
+}
+#else
+static u8 __init io_apic_unique_id(u8 id)
+{
+	int i;
+	DECLARE_BITMAP(used, 256);
+
+	bitmap_zero(used, 256);
+	for (i = 0; i < nr_ioapics; i++) {
+		struct mpc_ioapic *ia = &mp_ioapics[i];
+		__set_bit(ia->apicid, used);
+	}
+	if (!test_bit(id, used))
+		return id;
+	return find_first_zero_bit(used, 256);
+}
 #endif
 
-int __init io_apic_get_version(int ioapic)
+static int __init io_apic_get_version(int ioapic)
 {
 	union IO_APIC_reg_01	reg_01;
 	unsigned long flags;
@@ -3868,8 +3823,8 @@ int acpi_get_override_irq(u32 gsi, int *trigger, int *polarity)
 void __init setup_ioapic_dest(void)
 {
 	int pin, ioapic, irq, irq_entry;
-	struct irq_desc *desc;
 	const struct cpumask *mask;
+	struct irq_data *idata;
 
 	if (skip_ioapic_setup == 1)
 		return;
@@ -3884,21 +3839,20 @@ void __init setup_ioapic_dest(void)
 		if ((ioapic > 0) && (irq > 16))
 			continue;
 
-		desc = irq_to_desc(irq);
+		idata = irq_get_irq_data(irq);
 
 		/*
 		 * Honour affinities which have been set in early boot
 		 */
-		if (desc->status &
-		    (IRQ_NO_BALANCING | IRQ_AFFINITY_SET))
-			mask = desc->irq_data.affinity;
+		if (!irqd_can_balance(idata) || irqd_affinity_was_set(idata))
+			mask = idata->affinity;
 		else
 			mask = apic->target_cpus();
 
 		if (intr_remapping_enabled)
-			ir_ioapic_set_affinity(&desc->irq_data, mask, false);
+			ir_ioapic_set_affinity(idata, mask, false);
 		else
-			ioapic_set_affinity(&desc->irq_data, mask, false);
+			ioapic_set_affinity(idata, mask, false);
 	}
 
 }
@@ -4026,7 +3980,7 @@ int mp_find_ioapic_pin(int ioapic, u32 gsi)
 	return gsi - mp_gsi_routing[ioapic].gsi_base;
 }
 
-static int bad_ioapic(unsigned long address)
+static __init int bad_ioapic(unsigned long address)
 {
 	if (nr_ioapics >= MAX_IO_APICS) {
 		printk(KERN_WARNING "WARING: Max # of I/O APICs (%d) exceeded "
@@ -4086,20 +4040,16 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 /* Enable IOAPIC early just for system timer */
 void __init pre_init_apic_IRQ0(void)
 {
-	struct irq_cfg *cfg;
+	struct io_apic_irq_attr attr = { 0, 0, 0, 0 };
 
 	printk(KERN_INFO "Early APIC setup for system timer0\n");
 #ifndef CONFIG_SMP
 	physid_set_mask_of_physid(boot_cpu_physical_apicid,
 					 &phys_cpu_present_map);
 #endif
-	/* Make sure the irq descriptor is set up */
-	cfg = alloc_irq_and_cfg_at(0, 0);
-
 	setup_local_APIC();
 
-	add_pin_to_irq_node(cfg, 0, 0, 0);
-	set_irq_chip_and_handler_name(0, &ioapic_chip, handle_edge_irq, "edge");
-
-	setup_ioapic_irq(0, 0, 0, cfg, 0, 0);
+	io_apic_setup_irq_pin(0, 0, &attr);
+	irq_set_chip_and_handler_name(0, &ioapic_chip, handle_edge_irq,
+				      "edge");
 }
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 4ff5968..bfe8f72 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -503,7 +503,7 @@ static int hpet_assign_irq(struct hpet_dev *dev)
 	if (!irq)
 		return -EINVAL;
 
-	set_irq_data(irq, dev);
+	irq_set_handler_data(irq, dev);
 
 	if (hpet_setup_msi_irq(irq))
 		return -EINVAL;
diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c
index 20757cb..d9ca749 100644
--- a/arch/x86/kernel/i8259.c
+++ b/arch/x86/kernel/i8259.c
@@ -112,7 +112,7 @@ static void make_8259A_irq(unsigned int irq)
 {
 	disable_irq_nosync(irq);
 	io_apic_irqs &= ~(1<<irq);
-	set_irq_chip_and_handler_name(irq, &i8259A_chip, handle_level_irq,
+	irq_set_chip_and_handler_name(irq, &i8259A_chip, handle_level_irq,
 				      i8259A_chip.name);
 	enable_irq(irq);
 }
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 387b6a0..5ee693f 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -44,9 +44,9 @@ void ack_bad_irq(unsigned int irq)
 
 #define irq_stats(x)		(&per_cpu(irq_stat, x))
 /*
- * /proc/interrupts printing:
+ * /proc/interrupts printing for arch specific interrupts
  */
-static int show_other_interrupts(struct seq_file *p, int prec)
+int arch_show_interrupts(struct seq_file *p, int prec)
 {
 	int j;
 
@@ -122,59 +122,6 @@ static int show_other_interrupts(struct seq_file *p, int prec)
 	return 0;
 }
 
-int show_interrupts(struct seq_file *p, void *v)
-{
-	unsigned long flags, any_count = 0;
-	int i = *(loff_t *) v, j, prec;
-	struct irqaction *action;
-	struct irq_desc *desc;
-
-	if (i > nr_irqs)
-		return 0;
-
-	for (prec = 3, j = 1000; prec < 10 && j <= nr_irqs; ++prec)
-		j *= 10;
-
-	if (i == nr_irqs)
-		return show_other_interrupts(p, prec);
-
-	/* print header */
-	if (i == 0) {
-		seq_printf(p, "%*s", prec + 8, "");
-		for_each_online_cpu(j)
-			seq_printf(p, "CPU%-8d", j);
-		seq_putc(p, '\n');
-	}
-
-	desc = irq_to_desc(i);
-	if (!desc)
-		return 0;
-
-	raw_spin_lock_irqsave(&desc->lock, flags);
-	for_each_online_cpu(j)
-		any_count |= kstat_irqs_cpu(i, j);
-	action = desc->action;
-	if (!action && !any_count)
-		goto out;
-
-	seq_printf(p, "%*d: ", prec, i);
-	for_each_online_cpu(j)
-		seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
-	seq_printf(p, " %8s", desc->irq_data.chip->name);
-	seq_printf(p, "-%-8s", desc->name);
-
-	if (action) {
-		seq_printf(p, "  %s", action->name);
-		while ((action = action->next) != NULL)
-			seq_printf(p, ", %s", action->name);
-	}
-
-	seq_putc(p, '\n');
-out:
-	raw_spin_unlock_irqrestore(&desc->lock, flags);
-	return 0;
-}
-
 /*
  * /proc/stat helpers
  */
@@ -293,6 +240,7 @@ void fixup_irqs(void)
 	static int warned;
 	struct irq_desc *desc;
 	struct irq_data *data;
+	struct irq_chip *chip;
 
 	for_each_irq_desc(irq, desc) {
 		int break_affinity = 0;
@@ -307,10 +255,10 @@ void fixup_irqs(void)
 		/* interrupt's are disabled at this point */
 		raw_spin_lock(&desc->lock);
 
-		data = &desc->irq_data;
+		data = irq_desc_get_irq_data(desc);
 		affinity = data->affinity;
 		if (!irq_has_action(irq) ||
-		    cpumask_equal(affinity, cpu_online_mask)) {
+		    cpumask_subset(affinity, cpu_online_mask)) {
 			raw_spin_unlock(&desc->lock);
 			continue;
 		}
@@ -327,16 +275,17 @@ void fixup_irqs(void)
 			affinity = cpu_all_mask;
 		}
 
-		if (!(desc->status & IRQ_MOVE_PCNTXT) && data->chip->irq_mask)
-			data->chip->irq_mask(data);
+		chip = irq_data_get_irq_chip(data);
+		if (!irqd_can_move_in_process_context(data) && chip->irq_mask)
+			chip->irq_mask(data);
 
-		if (data->chip->irq_set_affinity)
-			data->chip->irq_set_affinity(data, affinity, true);
+		if (chip->irq_set_affinity)
+			chip->irq_set_affinity(data, affinity, true);
 		else if (!(warned++))
 			set_affinity = 0;
 
-		if (!(desc->status & IRQ_MOVE_PCNTXT) && data->chip->irq_unmask)
-			data->chip->irq_unmask(data);
+		if (!irqd_can_move_in_process_context(data) && chip->irq_unmask)
+			chip->irq_unmask(data);
 
 		raw_spin_unlock(&desc->lock);
 
@@ -368,10 +317,11 @@ void fixup_irqs(void)
 			irq = __this_cpu_read(vector_irq[vector]);
 
 			desc = irq_to_desc(irq);
-			data = &desc->irq_data;
+			data = irq_desc_get_irq_data(desc);
+			chip = irq_data_get_irq_chip(data);
 			raw_spin_lock(&desc->lock);
-			if (data->chip->irq_retrigger)
-				data->chip->irq_retrigger(data);
+			if (chip->irq_retrigger)
+				chip->irq_retrigger(data);
 			raw_spin_unlock(&desc->lock);
 		}
 	}
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index c752e97..1cc302d 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -71,6 +71,7 @@ static irqreturn_t math_error_irq(int cpl, void *dev_id)
 static struct irqaction fpu_irq = {
 	.handler = math_error_irq,
 	.name = "fpu",
+	.flags = IRQF_NO_THREAD,
 };
 #endif
 
@@ -80,6 +81,7 @@ static struct irqaction fpu_irq = {
 static struct irqaction irq2 = {
 	.handler = no_action,
 	.name = "cascade",
+	.flags = IRQF_NO_THREAD,
 };
 
 DEFINE_PER_CPU(vector_irq_t, vector_irq) = {
@@ -110,7 +112,7 @@ void __init init_ISA_irqs(void)
 	legacy_pic->init(0);
 
 	for (i = 0; i < legacy_pic->nr_legacy_irqs; i++)
-		set_irq_chip_and_handler_name(i, chip, handle_level_irq, name);
+		irq_set_chip_and_handler_name(i, chip, handle_level_irq, name);
 }
 
 void __init init_IRQ(void)
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 08776a9..09d0172 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -64,6 +64,7 @@
 #include <asm/mtrr.h>
 #include <asm/mwait.h>
 #include <asm/apic.h>
+#include <asm/io_apic.h>
 #include <asm/setup.h>
 #include <asm/uv/uv.h>
 #include <linux/mc146818rtc.h>
@@ -945,6 +946,14 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 	return 0;
 }
 
+/**
+ * arch_disable_smp_support() - disables SMP support for x86 at runtime
+ */
+void arch_disable_smp_support(void)
+{
+	disable_ioapic_support();
+}
+
 /*
  * Fall back to non SMP mode after errors.
  *
@@ -1045,7 +1054,7 @@ static int __init smp_sanity_check(unsigned max_cpus)
 				"(tell your hw vendor)\n");
 		}
 		smpboot_clear_io_apic();
-		arch_disable_smp_support();
+		disable_ioapic_support();
 		return -1;
 	}
 
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index eba687f0..b9ec1c7 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -847,7 +847,7 @@ static void __init lguest_init_IRQ(void)
 void lguest_setup_irq(unsigned int irq)
 {
 	irq_alloc_desc_at(irq, 0);
-	set_irq_chip_and_handler_name(irq, &lguest_irq_controller,
+	irq_set_chip_and_handler_name(irq, &lguest_irq_controller,
 				      handle_level_irq, "level");
 }
 
@@ -995,7 +995,7 @@ static void lguest_time_irq(unsigned int irq, struct irq_desc *desc)
 static void lguest_time_init(void)
 {
 	/* Set up the timer interrupt (0) to go to our simple timer routine */
-	set_irq_handler(0, lguest_time_irq);
+	irq_set_handler(0, lguest_time_irq);
 
 	clocksource_register(&lguest_clock);
 
diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 25cd4a0..2bdcc36 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -104,7 +104,7 @@ static int xen_hvm_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 					"msi-x" : "msi", &irq, &pirq, XEN_ALLOC_IRQ);
 			if (irq < 0)
 				goto error;
-			ret = set_irq_msi(irq, msidesc);
+			ret = irq_set_msi_desc(irq, msidesc);
 			if (ret < 0)
 				goto error_while;
 			printk(KERN_DEBUG "xen: msi already setup: msi --> irq=%d"
@@ -117,7 +117,7 @@ static int xen_hvm_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 			goto error;
 		printk(KERN_DEBUG "xen: msi --> irq=%d, pirq=%d\n", irq, pirq);
 		xen_msi_compose_msg(dev, pirq, &msg);
-		ret = set_irq_msi(irq, msidesc);
+		ret = irq_set_msi_desc(irq, msidesc);
 		if (ret < 0)
 			goto error_while;
 		write_msi_msg(irq, &msg);
@@ -165,7 +165,7 @@ static int xen_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 			goto free;
 		}
 
-		ret = set_irq_msi(irq, msidesc);
+		ret = irq_set_msi_desc(irq, msidesc);
 		if (ret)
 			goto error_while;
 		i++;
@@ -210,7 +210,7 @@ static int xen_initdom_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 		if (irq < 0)
 			return -1;
 
-		ret = set_irq_msi(irq, msidesc);
+		ret = irq_set_msi_desc(irq, msidesc);
 		if (ret)
 			goto error;
 	}
diff --git a/arch/x86/platform/uv/uv_irq.c b/arch/x86/platform/uv/uv_irq.c
index 7b24460..374a05d 100644
--- a/arch/x86/platform/uv/uv_irq.c
+++ b/arch/x86/platform/uv/uv_irq.c
@@ -131,7 +131,7 @@ arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
 		       unsigned long mmr_offset, int limit)
 {
 	const struct cpumask *eligible_cpu = cpumask_of(cpu);
-	struct irq_cfg *cfg = get_irq_chip_data(irq);
+	struct irq_cfg *cfg = irq_get_chip_data(irq);
 	unsigned long mmr_value;
 	struct uv_IO_APIC_route_entry *entry;
 	int mmr_pnode, err;
@@ -148,7 +148,7 @@ arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
 	else
 		irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
 
-	set_irq_chip_and_handler_name(irq, &uv_irq_chip, handle_percpu_irq,
+	irq_set_chip_and_handler_name(irq, &uv_irq_chip, handle_percpu_irq,
 				      irq_name);
 
 	mmr_value = 0;
diff --git a/arch/x86/platform/visws/visws_quirks.c b/arch/x86/platform/visws/visws_quirks.c
index 6320376..fe4cf82 100644
--- a/arch/x86/platform/visws/visws_quirks.c
+++ b/arch/x86/platform/visws/visws_quirks.c
@@ -569,11 +569,13 @@ out_unlock:
 static struct irqaction master_action = {
 	.handler =	piix4_master_intr,
 	.name =		"PIIX4-8259",
+	.flags =	IRQF_NO_THREAD,
 };
 
 static struct irqaction cascade_action = {
 	.handler = 	no_action,
 	.name =		"cascade",
+	.flags =	IRQF_NO_THREAD,
 };
 
 static inline void set_piix4_virtual_irq_type(void)
@@ -606,7 +608,7 @@ static void __init visws_pre_intr_init(void)
 			chip = &cobalt_irq_type;
 
 		if (chip)
-			set_irq_chip(i, chip);
+			irq_set_chip(i, chip);
 	}
 
 	setup_irq(CO_IRQ_8259, &master_action);
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 55e0d42..f8a8af1 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -14,6 +14,8 @@
 #include <linux/smp.h>
 #include <linux/percpu.h>
 #include <linux/hrtimer.h>
+#include <linux/kref.h>
+#include <linux/workqueue.h>
 
 #include <asm/atomic.h>
 #include <asm/ptrace.h>
@@ -55,7 +57,8 @@
  *                Used by threaded interrupts which need to keep the
  *                irq line disabled until the threaded handler has been run.
  * IRQF_NO_SUSPEND - Do not disable this IRQ during suspend
- *
+ * IRQF_FORCE_RESUME - Force enable it on resume even if IRQF_NO_SUSPEND is set
+ * IRQF_NO_THREAD - Interrupt cannot be threaded
  */
 #define IRQF_DISABLED		0x00000020
 #define IRQF_SAMPLE_RANDOM	0x00000040
@@ -67,22 +70,10 @@
 #define IRQF_IRQPOLL		0x00001000
 #define IRQF_ONESHOT		0x00002000
 #define IRQF_NO_SUSPEND		0x00004000
+#define IRQF_FORCE_RESUME	0x00008000
+#define IRQF_NO_THREAD		0x00010000
 
-#define IRQF_TIMER		(__IRQF_TIMER | IRQF_NO_SUSPEND)
-
-/*
- * Bits used by threaded handlers:
- * IRQTF_RUNTHREAD - signals that the interrupt handler thread should run
- * IRQTF_DIED      - handler thread died
- * IRQTF_WARNED    - warning "IRQ_WAKE_THREAD w/o thread_fn" has been printed
- * IRQTF_AFFINITY  - irq thread is requested to adjust affinity
- */
-enum {
-	IRQTF_RUNTHREAD,
-	IRQTF_DIED,
-	IRQTF_WARNED,
-	IRQTF_AFFINITY,
-};
+#define IRQF_TIMER		(__IRQF_TIMER | IRQF_NO_SUSPEND | IRQF_NO_THREAD)
 
 /*
  * These values can be returned by request_any_context_irq() and
@@ -110,6 +101,7 @@ typedef irqreturn_t (*irq_handler_t)(int, void *);
  * @thread_fn:	interupt handler function for threaded interrupts
  * @thread:	thread pointer for threaded interrupts
  * @thread_flags:	flags related to @thread
+ * @thread_mask:	bitmask for keeping track of @thread activity
  */
 struct irqaction {
 	irq_handler_t handler;
@@ -120,6 +112,7 @@ struct irqaction {
 	irq_handler_t thread_fn;
 	struct task_struct *thread;
 	unsigned long thread_flags;
+	unsigned long thread_mask;
 	const char *name;
 	struct proc_dir_entry *dir;
 } ____cacheline_internodealigned_in_smp;
@@ -240,6 +233,35 @@ extern int irq_can_set_affinity(unsigned int irq);
 extern int irq_select_affinity(unsigned int irq);
 
 extern int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m);
+
+/**
+ * struct irq_affinity_notify - context for notification of IRQ affinity changes
+ * @irq:		Interrupt to which notification applies
+ * @kref:		Reference count, for internal use
+ * @work:		Work item, for internal use
+ * @notify:		Function to be called on change.  This will be
+ *			called in process context.
+ * @release:		Function to be called on release.  This will be
+ *			called in process context.  Once registered, the
+ *			structure must only be freed when this function is
+ *			called or later.
+ */
+struct irq_affinity_notify {
+	unsigned int irq;
+	struct kref kref;
+	struct work_struct work;
+	void (*notify)(struct irq_affinity_notify *, const cpumask_t *mask);
+	void (*release)(struct kref *ref);
+};
+
+extern int
+irq_set_affinity_notifier(unsigned int irq, struct irq_affinity_notify *notify);
+
+static inline void irq_run_affinity_notifiers(void)
+{
+	flush_scheduled_work();
+}
+
 #else /* CONFIG_SMP */
 
 static inline int irq_set_affinity(unsigned int irq, const struct cpumask *m)
@@ -255,7 +277,7 @@ static inline int irq_can_set_affinity(unsigned int irq)
 static inline int irq_select_affinity(unsigned int irq)  { return 0; }
 
 static inline int irq_set_affinity_hint(unsigned int irq,
-                                        const struct cpumask *m)
+					const struct cpumask *m)
 {
 	return -EINVAL;
 }
@@ -314,16 +336,24 @@ static inline void enable_irq_lockdep_irqrestore(unsigned int irq, unsigned long
 }
 
 /* IRQ wakeup (PM) control: */
-extern int set_irq_wake(unsigned int irq, unsigned int on);
+extern int irq_set_irq_wake(unsigned int irq, unsigned int on);
+
+#ifndef CONFIG_GENERIC_HARDIRQS_NO_COMPAT
+/* Please do not use: Use the replacement functions instead */
+static inline int set_irq_wake(unsigned int irq, unsigned int on)
+{
+	return irq_set_irq_wake(irq, on);
+}
+#endif
 
 static inline int enable_irq_wake(unsigned int irq)
 {
-	return set_irq_wake(irq, 1);
+	return irq_set_irq_wake(irq, 1);
 }
 
 static inline int disable_irq_wake(unsigned int irq)
 {
-	return set_irq_wake(irq, 0);
+	return irq_set_irq_wake(irq, 0);
 }
 
 #else /* !CONFIG_GENERIC_HARDIRQS */
@@ -353,6 +383,13 @@ static inline int disable_irq_wake(unsigned int irq)
 }
 #endif /* CONFIG_GENERIC_HARDIRQS */
 
+
+#ifdef CONFIG_IRQ_FORCED_THREADING
+extern bool force_irqthreads;
+#else
+#define force_irqthreads	(0)
+#endif
+
 #ifndef __ARCH_SET_SOFTIRQ_PENDING
 #define set_softirq_pending(x) (local_softirq_pending() = (x))
 #define or_softirq_pending(x)  (local_softirq_pending() |= (x))
@@ -645,6 +682,7 @@ static inline void init_irq_proc(void)
 
 struct seq_file;
 int show_interrupts(struct seq_file *p, void *v);
+int arch_show_interrupts(struct seq_file *p, int prec);
 
 extern int early_irq_init(void);
 extern int arch_probe_nr_irqs(void);
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 80fcb53..1d3577f 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -29,61 +29,104 @@
 #include <asm/irq_regs.h>
 
 struct irq_desc;
+struct irq_data;
 typedef	void (*irq_flow_handler_t)(unsigned int irq,
 					    struct irq_desc *desc);
-
+typedef	void (*irq_preflow_handler_t)(struct irq_data *data);
 
 /*
  * IRQ line status.
  *
- * Bits 0-7 are reserved for the IRQF_* bits in linux/interrupt.h
+ * Bits 0-7 are the same as the IRQF_* bits in linux/interrupt.h
+ *
+ * IRQ_TYPE_NONE		- default, unspecified type
+ * IRQ_TYPE_EDGE_RISING		- rising edge triggered
+ * IRQ_TYPE_EDGE_FALLING	- falling edge triggered
+ * IRQ_TYPE_EDGE_BOTH		- rising and falling edge triggered
+ * IRQ_TYPE_LEVEL_HIGH		- high level triggered
+ * IRQ_TYPE_LEVEL_LOW		- low level triggered
+ * IRQ_TYPE_LEVEL_MASK		- Mask to filter out the level bits
+ * IRQ_TYPE_SENSE_MASK		- Mask for all the above bits
+ * IRQ_TYPE_PROBE		- Special flag for probing in progress
+ *
+ * Bits which can be modified via irq_set/clear/modify_status_flags()
+ * IRQ_LEVEL			- Interrupt is level type. Will be also
+ *				  updated in the code when the above trigger
+ *				  bits are modified via set_irq_type()
+ * IRQ_PER_CPU			- Mark an interrupt PER_CPU. Will protect
+ *				  it from affinity setting
+ * IRQ_NOPROBE			- Interrupt cannot be probed by autoprobing
+ * IRQ_NOREQUEST		- Interrupt cannot be requested via
+ *				  request_irq()
+ * IRQ_NOAUTOEN			- Interrupt is not automatically enabled in
+ *				  request/setup_irq()
+ * IRQ_NO_BALANCING		- Interrupt cannot be balanced (affinity set)
+ * IRQ_MOVE_PCNTXT		- Interrupt can be migrated from process context
+ * IRQ_NESTED_TRHEAD		- Interrupt nests into another thread
+ *
+ * Deprecated bits. They are kept updated as long as
+ * CONFIG_GENERIC_HARDIRQS_NO_COMPAT is not set. Will go away soon. These bits
+ * are internal state of the core code and if you really need to acces
+ * them then talk to the genirq maintainer instead of hacking
+ * something weird.
  *
- * IRQ types
  */
-#define IRQ_TYPE_NONE		0x00000000	/* Default, unspecified type */
-#define IRQ_TYPE_EDGE_RISING	0x00000001	/* Edge rising type */
-#define IRQ_TYPE_EDGE_FALLING	0x00000002	/* Edge falling type */
-#define IRQ_TYPE_EDGE_BOTH (IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING)
-#define IRQ_TYPE_LEVEL_HIGH	0x00000004	/* Level high type */
-#define IRQ_TYPE_LEVEL_LOW	0x00000008	/* Level low type */
-#define IRQ_TYPE_SENSE_MASK	0x0000000f	/* Mask of the above */
-#define IRQ_TYPE_PROBE		0x00000010	/* Probing in progress */
-
-/* Internal flags */
-#define IRQ_INPROGRESS		0x00000100	/* IRQ handler active - do not enter! */
-#define IRQ_DISABLED		0x00000200	/* IRQ disabled - do not enter! */
-#define IRQ_PENDING		0x00000400	/* IRQ pending - replay on enable */
-#define IRQ_REPLAY		0x00000800	/* IRQ has been replayed but not acked yet */
-#define IRQ_AUTODETECT		0x00001000	/* IRQ is being autodetected */
-#define IRQ_WAITING		0x00002000	/* IRQ not yet seen - for autodetection */
-#define IRQ_LEVEL		0x00004000	/* IRQ level triggered */
-#define IRQ_MASKED		0x00008000	/* IRQ masked - shouldn't be seen again */
-#define IRQ_PER_CPU		0x00010000	/* IRQ is per CPU */
-#define IRQ_NOPROBE		0x00020000	/* IRQ is not valid for probing */
-#define IRQ_NOREQUEST		0x00040000	/* IRQ cannot be requested */
-#define IRQ_NOAUTOEN		0x00080000	/* IRQ will not be enabled on request irq */
-#define IRQ_WAKEUP		0x00100000	/* IRQ triggers system wakeup */
-#define IRQ_MOVE_PENDING	0x00200000	/* need to re-target IRQ destination */
-#define IRQ_NO_BALANCING	0x00400000	/* IRQ is excluded from balancing */
-#define IRQ_SPURIOUS_DISABLED	0x00800000	/* IRQ was disabled by the spurious trap */
-#define IRQ_MOVE_PCNTXT		0x01000000	/* IRQ migration from process context */
-#define IRQ_AFFINITY_SET	0x02000000	/* IRQ affinity was set from userspace*/
-#define IRQ_SUSPENDED		0x04000000	/* IRQ has gone through suspend sequence */
-#define IRQ_ONESHOT		0x08000000	/* IRQ is not unmasked after hardirq */
-#define IRQ_NESTED_THREAD	0x10000000	/* IRQ is nested into another, no own handler thread */
+enum {
+	IRQ_TYPE_NONE		= 0x00000000,
+	IRQ_TYPE_EDGE_RISING	= 0x00000001,
+	IRQ_TYPE_EDGE_FALLING	= 0x00000002,
+	IRQ_TYPE_EDGE_BOTH	= (IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING),
+	IRQ_TYPE_LEVEL_HIGH	= 0x00000004,
+	IRQ_TYPE_LEVEL_LOW	= 0x00000008,
+	IRQ_TYPE_LEVEL_MASK	= (IRQ_TYPE_LEVEL_LOW | IRQ_TYPE_LEVEL_HIGH),
+	IRQ_TYPE_SENSE_MASK	= 0x0000000f,
+
+	IRQ_TYPE_PROBE		= 0x00000010,
+
+	IRQ_LEVEL		= (1 <<  8),
+	IRQ_PER_CPU		= (1 <<  9),
+	IRQ_NOPROBE		= (1 << 10),
+	IRQ_NOREQUEST		= (1 << 11),
+	IRQ_NOAUTOEN		= (1 << 12),
+	IRQ_NO_BALANCING	= (1 << 13),
+	IRQ_MOVE_PCNTXT		= (1 << 14),
+	IRQ_NESTED_THREAD	= (1 << 15),
+
+#ifndef CONFIG_GENERIC_HARDIRQS_NO_COMPAT
+	IRQ_INPROGRESS		= (1 << 16),
+	IRQ_REPLAY		= (1 << 17),
+	IRQ_WAITING		= (1 << 18),
+	IRQ_DISABLED		= (1 << 19),
+	IRQ_PENDING		= (1 << 20),
+	IRQ_MASKED		= (1 << 21),
+	IRQ_MOVE_PENDING	= (1 << 22),
+	IRQ_AFFINITY_SET	= (1 << 23),
+	IRQ_WAKEUP		= (1 << 24),
+#endif
+};
 
 #define IRQF_MODIFY_MASK	\
 	(IRQ_TYPE_SENSE_MASK | IRQ_NOPROBE | IRQ_NOREQUEST | \
 	 IRQ_NOAUTOEN | IRQ_MOVE_PCNTXT | IRQ_LEVEL | IRQ_NO_BALANCING | \
-	 IRQ_PER_CPU)
+	 IRQ_PER_CPU | IRQ_NESTED_THREAD)
 
-#ifdef CONFIG_IRQ_PER_CPU
-# define CHECK_IRQ_PER_CPU(var) ((var) & IRQ_PER_CPU)
-# define IRQ_NO_BALANCING_MASK	(IRQ_PER_CPU | IRQ_NO_BALANCING)
-#else
-# define CHECK_IRQ_PER_CPU(var) 0
-# define IRQ_NO_BALANCING_MASK	IRQ_NO_BALANCING
-#endif
+#define IRQ_NO_BALANCING_MASK	(IRQ_PER_CPU | IRQ_NO_BALANCING)
+
+static inline __deprecated bool CHECK_IRQ_PER_CPU(unsigned int status)
+{
+	return status & IRQ_PER_CPU;
+}
+
+/*
+ * Return value for chip->irq_set_affinity()
+ *
+ * IRQ_SET_MASK_OK	- OK, core updates irq_data.affinity
+ * IRQ_SET_MASK_NOCPY	- OK, chip did update irq_data.affinity
+ */
+enum {
+	IRQ_SET_MASK_OK = 0,
+	IRQ_SET_MASK_OK_NOCOPY,
+};
 
 struct msi_desc;
 
@@ -91,6 +134,8 @@ struct msi_desc;
  * struct irq_data - per irq and irq chip data passed down to chip functions
  * @irq:		interrupt number
  * @node:		node index useful for balancing
+ * @state_use_accessor: status information for irq chip functions.
+ *			Use accessor functions to deal with it
  * @chip:		low level interrupt hardware access
  * @handler_data:	per-IRQ data for the irq_chip methods
  * @chip_data:		platform-specific per-chip private data for the chip
@@ -105,6 +150,7 @@ struct msi_desc;
 struct irq_data {
 	unsigned int		irq;
 	unsigned int		node;
+	unsigned int		state_use_accessors;
 	struct irq_chip		*chip;
 	void			*handler_data;
 	void			*chip_data;
@@ -114,6 +160,80 @@ struct irq_data {
 #endif
 };
 
+/*
+ * Bit masks for irq_data.state
+ *
+ * IRQD_TRIGGER_MASK		- Mask for the trigger type bits
+ * IRQD_SETAFFINITY_PENDING	- Affinity setting is pending
+ * IRQD_NO_BALANCING		- Balancing disabled for this IRQ
+ * IRQD_PER_CPU			- Interrupt is per cpu
+ * IRQD_AFFINITY_SET		- Interrupt affinity was set
+ * IRQD_LEVEL			- Interrupt is level triggered
+ * IRQD_WAKEUP_STATE		- Interrupt is configured for wakeup
+ *				  from suspend
+ * IRDQ_MOVE_PCNTXT		- Interrupt can be moved in process
+ *				  context
+ */
+enum {
+	IRQD_TRIGGER_MASK		= 0xf,
+	IRQD_SETAFFINITY_PENDING	= (1 <<  8),
+	IRQD_NO_BALANCING		= (1 << 10),
+	IRQD_PER_CPU			= (1 << 11),
+	IRQD_AFFINITY_SET		= (1 << 12),
+	IRQD_LEVEL			= (1 << 13),
+	IRQD_WAKEUP_STATE		= (1 << 14),
+	IRQD_MOVE_PCNTXT		= (1 << 15),
+};
+
+static inline bool irqd_is_setaffinity_pending(struct irq_data *d)
+{
+	return d->state_use_accessors & IRQD_SETAFFINITY_PENDING;
+}
+
+static inline bool irqd_is_per_cpu(struct irq_data *d)
+{
+	return d->state_use_accessors & IRQD_PER_CPU;
+}
+
+static inline bool irqd_can_balance(struct irq_data *d)
+{
+	return !(d->state_use_accessors & (IRQD_PER_CPU | IRQD_NO_BALANCING));
+}
+
+static inline bool irqd_affinity_was_set(struct irq_data *d)
+{
+	return d->state_use_accessors & IRQD_AFFINITY_SET;
+}
+
+static inline u32 irqd_get_trigger_type(struct irq_data *d)
+{
+	return d->state_use_accessors & IRQD_TRIGGER_MASK;
+}
+
+/*
+ * Must only be called inside irq_chip.irq_set_type() functions.
+ */
+static inline void irqd_set_trigger_type(struct irq_data *d, u32 type)
+{
+	d->state_use_accessors &= ~IRQD_TRIGGER_MASK;
+	d->state_use_accessors |= type & IRQD_TRIGGER_MASK;
+}
+
+static inline bool irqd_is_level_type(struct irq_data *d)
+{
+	return d->state_use_accessors & IRQD_LEVEL;
+}
+
+static inline bool irqd_is_wakeup_set(struct irq_data *d)
+{
+	return d->state_use_accessors & IRQD_WAKEUP_STATE;
+}
+
+static inline bool irqd_can_move_in_process_context(struct irq_data *d)
+{
+	return d->state_use_accessors & IRQD_MOVE_PCNTXT;
+}
+
 /**
  * struct irq_chip - hardware interrupt chip descriptor
  *
@@ -150,6 +270,7 @@ struct irq_data {
  * @irq_set_wake:	enable/disable power-management wake-on of an IRQ
  * @irq_bus_lock:	function to lock access to slow bus (i2c) chips
  * @irq_bus_sync_unlock:function to sync and unlock slow bus (i2c) chips
+ * @flags:		chip specific flags
  *
  * @release:		release function solely used by UML
  */
@@ -196,12 +317,27 @@ struct irq_chip {
 	void		(*irq_bus_lock)(struct irq_data *data);
 	void		(*irq_bus_sync_unlock)(struct irq_data *data);
 
+	unsigned long	flags;
+
 	/* Currently used only by UML, might disappear one day.*/
 #ifdef CONFIG_IRQ_RELEASE_METHOD
 	void		(*release)(unsigned int irq, void *dev_id);
 #endif
 };
 
+/*
+ * irq_chip specific flags
+ *
+ * IRQCHIP_SET_TYPE_MASKED:	Mask before calling chip.irq_set_type()
+ * IRQCHIP_EOI_IF_HANDLED:	Only issue irq_eoi() when irq was handled
+ * IRQCHIP_MASK_ON_SUSPEND:	Mask non wake irqs in the suspend path
+ */
+enum {
+	IRQCHIP_SET_TYPE_MASKED		= (1 <<  0),
+	IRQCHIP_EOI_IF_HANDLED		= (1 <<  1),
+	IRQCHIP_MASK_ON_SUSPEND		= (1 <<  2),
+};
+
 /* This include will go away once we isolated irq_desc usage to core code */
 #include <linux/irqdesc.h>
 
@@ -218,7 +354,7 @@ struct irq_chip {
 # define ARCH_IRQ_INIT_FLAGS	0
 #endif
 
-#define IRQ_DEFAULT_INIT_FLAGS	(IRQ_DISABLED | ARCH_IRQ_INIT_FLAGS)
+#define IRQ_DEFAULT_INIT_FLAGS	ARCH_IRQ_INIT_FLAGS
 
 struct irqaction;
 extern int setup_irq(unsigned int irq, struct irqaction *new);
@@ -229,9 +365,13 @@ extern void remove_irq(unsigned int irq, struct irqaction *act);
 #if defined(CONFIG_SMP) && defined(CONFIG_GENERIC_PENDING_IRQ)
 void move_native_irq(int irq);
 void move_masked_irq(int irq);
+void irq_move_irq(struct irq_data *data);
+void irq_move_masked_irq(struct irq_data *data);
 #else
 static inline void move_native_irq(int irq) { }
 static inline void move_masked_irq(int irq) { }
+static inline void irq_move_irq(struct irq_data *data) { }
+static inline void irq_move_masked_irq(struct irq_data *data) { }
 #endif
 
 extern int no_irq_affinity;
@@ -267,23 +407,23 @@ extern struct irq_chip no_irq_chip;
 extern struct irq_chip dummy_irq_chip;
 
 extern void
-set_irq_chip_and_handler(unsigned int irq, struct irq_chip *chip,
-			 irq_flow_handler_t handle);
-extern void
-set_irq_chip_and_handler_name(unsigned int irq, struct irq_chip *chip,
+irq_set_chip_and_handler_name(unsigned int irq, struct irq_chip *chip,
 			      irq_flow_handler_t handle, const char *name);
 
+static inline void irq_set_chip_and_handler(unsigned int irq, struct irq_chip *chip,
+					    irq_flow_handler_t handle)
+{
+	irq_set_chip_and_handler_name(irq, chip, handle, NULL);
+}
+
 extern void
-__set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
+__irq_set_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 		  const char *name);
 
-/*
- * Set a highlevel flow handler for a given IRQ:
- */
 static inline void
-set_irq_handler(unsigned int irq, irq_flow_handler_t handle)
+irq_set_handler(unsigned int irq, irq_flow_handler_t handle)
 {
-	__set_irq_handler(irq, handle, 0, NULL);
+	__irq_set_handler(irq, handle, 0, NULL);
 }
 
 /*
@@ -292,14 +432,11 @@ set_irq_handler(unsigned int irq, irq_flow_handler_t handle)
  *  IRQ_NOREQUEST and IRQ_NOPROBE)
  */
 static inline void
-set_irq_chained_handler(unsigned int irq,
-			irq_flow_handler_t handle)
+irq_set_chained_handler(unsigned int irq, irq_flow_handler_t handle)
 {
-	__set_irq_handler(irq, handle, 1, NULL);
+	__irq_set_handler(irq, handle, 1, NULL);
 }
 
-extern void set_irq_nested_thread(unsigned int irq, int nest);
-
 void irq_modify_status(unsigned int irq, unsigned long clr, unsigned long set);
 
 static inline void irq_set_status_flags(unsigned int irq, unsigned long set)
@@ -312,16 +449,24 @@ static inline void irq_clear_status_flags(unsigned int irq, unsigned long clr)
 	irq_modify_status(irq, clr, 0);
 }
 
-static inline void set_irq_noprobe(unsigned int irq)
+static inline void irq_set_noprobe(unsigned int irq)
 {
 	irq_modify_status(irq, 0, IRQ_NOPROBE);
 }
 
-static inline void set_irq_probe(unsigned int irq)
+static inline void irq_set_probe(unsigned int irq)
 {
 	irq_modify_status(irq, IRQ_NOPROBE, 0);
 }
 
+static inline void irq_set_nested_thread(unsigned int irq, bool nest)
+{
+	if (nest)
+		irq_set_status_flags(irq, IRQ_NESTED_THREAD);
+	else
+		irq_clear_status_flags(irq, IRQ_NESTED_THREAD);
+}
+
 /* Handle dynamic irq creation and destruction */
 extern unsigned int create_irq_nr(unsigned int irq_want, int node);
 extern int create_irq(void);
@@ -338,14 +483,14 @@ static inline void dynamic_irq_init(unsigned int irq)
 }
 
 /* Set/get chip/data for an IRQ: */
-extern int set_irq_chip(unsigned int irq, struct irq_chip *chip);
-extern int set_irq_data(unsigned int irq, void *data);
-extern int set_irq_chip_data(unsigned int irq, void *data);
-extern int set_irq_type(unsigned int irq, unsigned int type);
-extern int set_irq_msi(unsigned int irq, struct msi_desc *entry);
+extern int irq_set_chip(unsigned int irq, struct irq_chip *chip);
+extern int irq_set_handler_data(unsigned int irq, void *data);
+extern int irq_set_chip_data(unsigned int irq, void *data);
+extern int irq_set_irq_type(unsigned int irq, unsigned int type);
+extern int irq_set_msi_desc(unsigned int irq, struct msi_desc *entry);
 extern struct irq_data *irq_get_irq_data(unsigned int irq);
 
-static inline struct irq_chip *get_irq_chip(unsigned int irq)
+static inline struct irq_chip *irq_get_chip(unsigned int irq)
 {
 	struct irq_data *d = irq_get_irq_data(irq);
 	return d ? d->chip : NULL;
@@ -356,7 +501,7 @@ static inline struct irq_chip *irq_data_get_irq_chip(struct irq_data *d)
 	return d->chip;
 }
 
-static inline void *get_irq_chip_data(unsigned int irq)
+static inline void *irq_get_chip_data(unsigned int irq)
 {
 	struct irq_data *d = irq_get_irq_data(irq);
 	return d ? d->chip_data : NULL;
@@ -367,18 +512,18 @@ static inline void *irq_data_get_irq_chip_data(struct irq_data *d)
 	return d->chip_data;
 }
 
-static inline void *get_irq_data(unsigned int irq)
+static inline void *irq_get_handler_data(unsigned int irq)
 {
 	struct irq_data *d = irq_get_irq_data(irq);
 	return d ? d->handler_data : NULL;
 }
 
-static inline void *irq_data_get_irq_data(struct irq_data *d)
+static inline void *irq_data_get_irq_handler_data(struct irq_data *d)
 {
 	return d->handler_data;
 }
 
-static inline struct msi_desc *get_irq_msi(unsigned int irq)
+static inline struct msi_desc *irq_get_msi_desc(unsigned int irq)
 {
 	struct irq_data *d = irq_get_irq_data(irq);
 	return d ? d->msi_desc : NULL;
@@ -389,6 +534,89 @@ static inline struct msi_desc *irq_data_get_msi(struct irq_data *d)
 	return d->msi_desc;
 }
 
+#ifndef CONFIG_GENERIC_HARDIRQS_NO_COMPAT
+/* Please do not use: Use the replacement functions instead */
+static inline int set_irq_chip(unsigned int irq, struct irq_chip *chip)
+{
+	return irq_set_chip(irq, chip);
+}
+static inline int set_irq_data(unsigned int irq, void *data)
+{
+	return irq_set_handler_data(irq, data);
+}
+static inline int set_irq_chip_data(unsigned int irq, void *data)
+{
+	return irq_set_chip_data(irq, data);
+}
+static inline int set_irq_type(unsigned int irq, unsigned int type)
+{
+	return irq_set_irq_type(irq, type);
+}
+static inline int set_irq_msi(unsigned int irq, struct msi_desc *entry)
+{
+	return irq_set_msi_desc(irq, entry);
+}
+static inline struct irq_chip *get_irq_chip(unsigned int irq)
+{
+	return irq_get_chip(irq);
+}
+static inline void *get_irq_chip_data(unsigned int irq)
+{
+	return irq_get_chip_data(irq);
+}
+static inline void *get_irq_data(unsigned int irq)
+{
+	return irq_get_handler_data(irq);
+}
+static inline void *irq_data_get_irq_data(struct irq_data *d)
+{
+	return irq_data_get_irq_handler_data(d);
+}
+static inline struct msi_desc *get_irq_msi(unsigned int irq)
+{
+	return irq_get_msi_desc(irq);
+}
+static inline void set_irq_noprobe(unsigned int irq)
+{
+	irq_set_noprobe(irq);
+}
+static inline void set_irq_probe(unsigned int irq)
+{
+	irq_set_probe(irq);
+}
+static inline void set_irq_nested_thread(unsigned int irq, int nest)
+{
+	irq_set_nested_thread(irq, nest);
+}
+static inline void
+set_irq_chip_and_handler_name(unsigned int irq, struct irq_chip *chip,
+			      irq_flow_handler_t handle, const char *name)
+{
+	irq_set_chip_and_handler_name(irq, chip, handle, name);
+}
+static inline void
+set_irq_chip_and_handler(unsigned int irq, struct irq_chip *chip,
+			 irq_flow_handler_t handle)
+{
+	irq_set_chip_and_handler(irq, chip, handle);
+}
+static inline void
+__set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
+		  const char *name)
+{
+	__irq_set_handler(irq, handle, is_chained, name);
+}
+static inline void set_irq_handler(unsigned int irq, irq_flow_handler_t handle)
+{
+	irq_set_handler(irq, handle);
+}
+static inline void
+set_irq_chained_handler(unsigned int irq, irq_flow_handler_t handle)
+{
+	irq_set_chained_handler(irq, handle);
+}
+#endif
+
 int irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node);
 void irq_free_descs(unsigned int irq, unsigned int cnt);
 int irq_reserve_irqs(unsigned int from, unsigned int cnt);
diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index c1a95b7..0021837 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -8,6 +8,7 @@
  * For now it's included from <linux/irq.h>
  */
 
+struct irq_affinity_notify;
 struct proc_dir_entry;
 struct timer_rand_state;
 /**
@@ -18,13 +19,16 @@ struct timer_rand_state;
  * @handle_irq:		highlevel irq-events handler [if NULL, __do_IRQ()]
  * @action:		the irq action chain
  * @status:		status information
+ * @core_internal_state__do_not_mess_with_it: core internal status information
  * @depth:		disable-depth, for nested irq_disable() calls
  * @wake_depth:		enable depth, for multiple set_irq_wake() callers
  * @irq_count:		stats field to detect stalled irqs
  * @last_unhandled:	aging timer for unhandled count
  * @irqs_unhandled:	stats field for spurious unhandled interrupts
  * @lock:		locking for SMP
+ * @affinity_notify:	context for notification of affinity changes
  * @pending_mask:	pending rebalanced interrupts
+ * @threads_oneshot:	bitfield to handle shared oneshot threads
  * @threads_active:	number of irqaction threads currently running
  * @wait_for_threads:	wait queue for sync_irq to wait for threaded handlers
  * @dir:		/proc/irq/ procfs entry
@@ -45,6 +49,7 @@ struct irq_desc {
 		struct {
 			unsigned int		irq;
 			unsigned int		node;
+			unsigned int		pad_do_not_even_think_about_it;
 			struct irq_chip		*chip;
 			void			*handler_data;
 			void			*chip_data;
@@ -59,9 +64,16 @@ struct irq_desc {
 	struct timer_rand_state *timer_rand_state;
 	unsigned int __percpu	*kstat_irqs;
 	irq_flow_handler_t	handle_irq;
+#ifdef CONFIG_IRQ_PREFLOW_FASTEOI
+	irq_preflow_handler_t	preflow_handler;
+#endif
 	struct irqaction	*action;	/* IRQ action list */
+#ifdef CONFIG_GENERIC_HARDIRQS_NO_COMPAT
+	unsigned int		status_use_accessors;
+#else
 	unsigned int		status;		/* IRQ status */
-
+#endif
+	unsigned int		core_internal_state__do_not_mess_with_it;
 	unsigned int		depth;		/* nested irq disables */
 	unsigned int		wake_depth;	/* nested wake enables */
 	unsigned int		irq_count;	/* For detecting broken IRQs */
@@ -70,10 +82,12 @@ struct irq_desc {
 	raw_spinlock_t		lock;
 #ifdef CONFIG_SMP
 	const struct cpumask	*affinity_hint;
+	struct irq_affinity_notify *affinity_notify;
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	cpumask_var_t		pending_mask;
 #endif
 #endif
+	unsigned long		threads_oneshot;
 	atomic_t		threads_active;
 	wait_queue_head_t       wait_for_threads;
 #ifdef CONFIG_PROC_FS
@@ -95,10 +109,51 @@ static inline struct irq_desc *move_irq_desc(struct irq_desc *desc, int node)
 
 #ifdef CONFIG_GENERIC_HARDIRQS
 
-#define get_irq_desc_chip(desc)		((desc)->irq_data.chip)
-#define get_irq_desc_chip_data(desc)	((desc)->irq_data.chip_data)
-#define get_irq_desc_data(desc)		((desc)->irq_data.handler_data)
-#define get_irq_desc_msi(desc)		((desc)->irq_data.msi_desc)
+static inline struct irq_data *irq_desc_get_irq_data(struct irq_desc *desc)
+{
+	return &desc->irq_data;
+}
+
+static inline struct irq_chip *irq_desc_get_chip(struct irq_desc *desc)
+{
+	return desc->irq_data.chip;
+}
+
+static inline void *irq_desc_get_chip_data(struct irq_desc *desc)
+{
+	return desc->irq_data.chip_data;
+}
+
+static inline void *irq_desc_get_handler_data(struct irq_desc *desc)
+{
+	return desc->irq_data.handler_data;
+}
+
+static inline struct msi_desc *irq_desc_get_msi_desc(struct irq_desc *desc)
+{
+	return desc->irq_data.msi_desc;
+}
+
+#ifndef CONFIG_GENERIC_HARDIRQS_NO_COMPAT
+static inline struct irq_chip *get_irq_desc_chip(struct irq_desc *desc)
+{
+	return irq_desc_get_chip(desc);
+}
+static inline void *get_irq_desc_data(struct irq_desc *desc)
+{
+	return irq_desc_get_handler_data(desc);
+}
+
+static inline void *get_irq_desc_chip_data(struct irq_desc *desc)
+{
+	return irq_desc_get_chip_data(desc);
+}
+
+static inline struct msi_desc *get_irq_desc_msi(struct irq_desc *desc)
+{
+	return irq_desc_get_msi_desc(desc);
+}
+#endif
 
 /*
  * Architectures call this to let the generic IRQ layer
@@ -123,6 +178,7 @@ static inline int irq_has_action(unsigned int irq)
 	return desc->action != NULL;
 }
 
+#ifndef CONFIG_GENERIC_HARDIRQS_NO_COMPAT
 static inline int irq_balancing_disabled(unsigned int irq)
 {
 	struct irq_desc *desc;
@@ -130,6 +186,7 @@ static inline int irq_balancing_disabled(unsigned int irq)
 	desc = irq_to_desc(irq);
 	return desc->status & IRQ_NO_BALANCING_MASK;
 }
+#endif
 
 /* caller has locked the irq_desc and both params are valid */
 static inline void __set_irq_handler_unlocked(int irq,
@@ -140,6 +197,17 @@ static inline void __set_irq_handler_unlocked(int irq,
 	desc = irq_to_desc(irq);
 	desc->handle_irq = handler;
 }
+
+#ifdef CONFIG_IRQ_PREFLOW_FASTEOI
+static inline void
+__irq_set_preflow_handler(unsigned int irq, irq_preflow_handler_t handler)
+{
+	struct irq_desc *desc;
+
+	desc = irq_to_desc(irq);
+	desc->preflow_handler = handler;
+}
+#endif
 #endif
 
 #endif
diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
index 8e42fec..09bef82 100644
--- a/kernel/irq/Kconfig
+++ b/kernel/irq/Kconfig
@@ -1,5 +1,6 @@
+# Select this to activate the generic irq options below
 config HAVE_GENERIC_HARDIRQS
-	def_bool n
+	bool
 
 if HAVE_GENERIC_HARDIRQS
 menu "IRQ subsystem"
@@ -11,26 +12,44 @@ config GENERIC_HARDIRQS
 
 # Select this to disable the deprecated stuff
 config GENERIC_HARDIRQS_NO_DEPRECATED
-       def_bool n
+       bool
+
+config GENERIC_HARDIRQS_NO_COMPAT
+       bool
 
 # Options selectable by the architecture code
+
+# Make sparse irq Kconfig switch below available
 config HAVE_SPARSE_IRQ
-       def_bool n
+       bool
 
+# Enable the generic irq autoprobe mechanism
 config GENERIC_IRQ_PROBE
-	def_bool n
+	bool
+
+# Use the generic /proc/interrupts implementation
+config GENERIC_IRQ_SHOW
+       bool
 
+# Support for delayed migration from interrupt context
 config GENERIC_PENDING_IRQ
-	def_bool n
+	bool
 
+# Alpha specific irq affinity mechanism
 config AUTO_IRQ_AFFINITY
-       def_bool n
-
-config IRQ_PER_CPU
-       def_bool n
+       bool
 
+# Tasklet based software resend for pending interrupts on enable_irq()
 config HARDIRQS_SW_RESEND
-       def_bool n
+       bool
+
+# Preflow handler support for fasteoi (sparc64)
+config IRQ_PREFLOW_FASTEOI
+       bool
+
+# Support forced irq threading
+config IRQ_FORCED_THREADING
+       bool
 
 config SPARSE_IRQ
 	bool "Support sparse irq numbering"
diff --git a/kernel/irq/autoprobe.c b/kernel/irq/autoprobe.c
index 505798f..394784c 100644
--- a/kernel/irq/autoprobe.c
+++ b/kernel/irq/autoprobe.c
@@ -17,7 +17,7 @@
 /*
  * Autodetection depends on the fact that any interrupt that
  * comes in on to an unassigned handler will get stuck with
- * "IRQ_WAITING" cleared and the interrupt disabled.
+ * "IRQS_WAITING" cleared and the interrupt disabled.
  */
 static DEFINE_MUTEX(probing_active);
 
@@ -32,7 +32,6 @@ unsigned long probe_irq_on(void)
 {
 	struct irq_desc *desc;
 	unsigned long mask = 0;
-	unsigned int status;
 	int i;
 
 	/*
@@ -46,13 +45,7 @@ unsigned long probe_irq_on(void)
 	 */
 	for_each_irq_desc_reverse(i, desc) {
 		raw_spin_lock_irq(&desc->lock);
-		if (!desc->action && !(desc->status & IRQ_NOPROBE)) {
-			/*
-			 * An old-style architecture might still have
-			 * the handle_bad_irq handler there:
-			 */
-			compat_irq_chip_set_default_handler(desc);
-
+		if (!desc->action && irq_settings_can_probe(desc)) {
 			/*
 			 * Some chips need to know about probing in
 			 * progress:
@@ -60,7 +53,7 @@ unsigned long probe_irq_on(void)
 			if (desc->irq_data.chip->irq_set_type)
 				desc->irq_data.chip->irq_set_type(&desc->irq_data,
 							 IRQ_TYPE_PROBE);
-			desc->irq_data.chip->irq_startup(&desc->irq_data);
+			irq_startup(desc);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
@@ -75,10 +68,12 @@ unsigned long probe_irq_on(void)
 	 */
 	for_each_irq_desc_reverse(i, desc) {
 		raw_spin_lock_irq(&desc->lock);
-		if (!desc->action && !(desc->status & IRQ_NOPROBE)) {
-			desc->status |= IRQ_AUTODETECT | IRQ_WAITING;
-			if (desc->irq_data.chip->irq_startup(&desc->irq_data))
-				desc->status |= IRQ_PENDING;
+		if (!desc->action && irq_settings_can_probe(desc)) {
+			desc->istate |= IRQS_AUTODETECT | IRQS_WAITING;
+			if (irq_startup(desc)) {
+				irq_compat_set_pending(desc);
+				desc->istate |= IRQS_PENDING;
+			}
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
@@ -93,13 +88,12 @@ unsigned long probe_irq_on(void)
 	 */
 	for_each_irq_desc(i, desc) {
 		raw_spin_lock_irq(&desc->lock);
-		status = desc->status;
 
-		if (status & IRQ_AUTODETECT) {
+		if (desc->istate & IRQS_AUTODETECT) {
 			/* It triggered already - consider it spurious. */
-			if (!(status & IRQ_WAITING)) {
-				desc->status = status & ~IRQ_AUTODETECT;
-				desc->irq_data.chip->irq_shutdown(&desc->irq_data);
+			if (!(desc->istate & IRQS_WAITING)) {
+				desc->istate &= ~IRQS_AUTODETECT;
+				irq_shutdown(desc);
 			} else
 				if (i < 32)
 					mask |= 1 << i;
@@ -125,20 +119,18 @@ EXPORT_SYMBOL(probe_irq_on);
  */
 unsigned int probe_irq_mask(unsigned long val)
 {
-	unsigned int status, mask = 0;
+	unsigned int mask = 0;
 	struct irq_desc *desc;
 	int i;
 
 	for_each_irq_desc(i, desc) {
 		raw_spin_lock_irq(&desc->lock);
-		status = desc->status;
-
-		if (status & IRQ_AUTODETECT) {
-			if (i < 16 && !(status & IRQ_WAITING))
+		if (desc->istate & IRQS_AUTODETECT) {
+			if (i < 16 && !(desc->istate & IRQS_WAITING))
 				mask |= 1 << i;
 
-			desc->status = status & ~IRQ_AUTODETECT;
-			desc->irq_data.chip->irq_shutdown(&desc->irq_data);
+			desc->istate &= ~IRQS_AUTODETECT;
+			irq_shutdown(desc);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
@@ -169,20 +161,18 @@ int probe_irq_off(unsigned long val)
 {
 	int i, irq_found = 0, nr_of_irqs = 0;
 	struct irq_desc *desc;
-	unsigned int status;
 
 	for_each_irq_desc(i, desc) {
 		raw_spin_lock_irq(&desc->lock);
-		status = desc->status;
 
-		if (status & IRQ_AUTODETECT) {
-			if (!(status & IRQ_WAITING)) {
+		if (desc->istate & IRQS_AUTODETECT) {
+			if (!(desc->istate & IRQS_WAITING)) {
 				if (!nr_of_irqs)
 					irq_found = i;
 				nr_of_irqs++;
 			}
-			desc->status = status & ~IRQ_AUTODETECT;
-			desc->irq_data.chip->irq_shutdown(&desc->irq_data);
+			desc->istate &= ~IRQS_AUTODETECT;
+			irq_shutdown(desc);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index baa5c4a..c9c0601 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -19,140 +19,110 @@
 #include "internals.h"
 
 /**
- *	set_irq_chip - set the irq chip for an irq
+ *	irq_set_chip - set the irq chip for an irq
  *	@irq:	irq number
  *	@chip:	pointer to irq chip description structure
  */
-int set_irq_chip(unsigned int irq, struct irq_chip *chip)
+int irq_set_chip(unsigned int irq, struct irq_chip *chip)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
+	struct irq_desc *desc = irq_get_desc_lock(irq, &flags);
 
-	if (!desc) {
-		WARN(1, KERN_ERR "Trying to install chip for IRQ%d\n", irq);
+	if (!desc)
 		return -EINVAL;
-	}
 
 	if (!chip)
 		chip = &no_irq_chip;
 
-	raw_spin_lock_irqsave(&desc->lock, flags);
 	irq_chip_set_defaults(chip);
 	desc->irq_data.chip = chip;
-	raw_spin_unlock_irqrestore(&desc->lock, flags);
-
+	irq_put_desc_unlock(desc, flags);
 	return 0;
 }
-EXPORT_SYMBOL(set_irq_chip);
+EXPORT_SYMBOL(irq_set_chip);
 
 /**
- *	set_irq_type - set the irq trigger type for an irq
+ *	irq_set_type - set the irq trigger type for an irq
  *	@irq:	irq number
  *	@type:	IRQ_TYPE_{LEVEL,EDGE}_* value - see include/linux/irq.h
  */
-int set_irq_type(unsigned int irq, unsigned int type)
+int irq_set_irq_type(unsigned int irq, unsigned int type)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
-	int ret = -ENXIO;
+	struct irq_desc *desc = irq_get_desc_buslock(irq, &flags);
+	int ret = 0;
 
-	if (!desc) {
-		printk(KERN_ERR "Trying to set irq type for IRQ%d\n", irq);
-		return -ENODEV;
-	}
+	if (!desc)
+		return -EINVAL;
 
 	type &= IRQ_TYPE_SENSE_MASK;
-	if (type == IRQ_TYPE_NONE)
-		return 0;
-
-	raw_spin_lock_irqsave(&desc->lock, flags);
-	ret = __irq_set_trigger(desc, irq, type);
-	raw_spin_unlock_irqrestore(&desc->lock, flags);
+	if (type != IRQ_TYPE_NONE)
+		ret = __irq_set_trigger(desc, irq, type);
+	irq_put_desc_busunlock(desc, flags);
 	return ret;
 }
-EXPORT_SYMBOL(set_irq_type);
+EXPORT_SYMBOL(irq_set_irq_type);
 
 /**
- *	set_irq_data - set irq type data for an irq
+ *	irq_set_handler_data - set irq handler data for an irq
  *	@irq:	Interrupt number
  *	@data:	Pointer to interrupt specific data
  *
  *	Set the hardware irq controller data for an irq
  */
-int set_irq_data(unsigned int irq, void *data)
+int irq_set_handler_data(unsigned int irq, void *data)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
+	struct irq_desc *desc = irq_get_desc_lock(irq, &flags);
 
-	if (!desc) {
-		printk(KERN_ERR
-		       "Trying to install controller data for IRQ%d\n", irq);
+	if (!desc)
 		return -EINVAL;
-	}
-
-	raw_spin_lock_irqsave(&desc->lock, flags);
 	desc->irq_data.handler_data = data;
-	raw_spin_unlock_irqrestore(&desc->lock, flags);
+	irq_put_desc_unlock(desc, flags);
 	return 0;
 }
-EXPORT_SYMBOL(set_irq_data);
+EXPORT_SYMBOL(irq_set_handler_data);
 
 /**
- *	set_irq_msi - set MSI descriptor data for an irq
+ *	irq_set_msi_desc - set MSI descriptor data for an irq
  *	@irq:	Interrupt number
  *	@entry:	Pointer to MSI descriptor data
  *
  *	Set the MSI descriptor entry for an irq
  */
-int set_irq_msi(unsigned int irq, struct msi_desc *entry)
+int irq_set_msi_desc(unsigned int irq, struct msi_desc *entry)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
+	struct irq_desc *desc = irq_get_desc_lock(irq, &flags);
 
-	if (!desc) {
-		printk(KERN_ERR
-		       "Trying to install msi data for IRQ%d\n", irq);
+	if (!desc)
 		return -EINVAL;
-	}
-
-	raw_spin_lock_irqsave(&desc->lock, flags);
 	desc->irq_data.msi_desc = entry;
 	if (entry)
 		entry->irq = irq;
-	raw_spin_unlock_irqrestore(&desc->lock, flags);
+	irq_put_desc_unlock(desc, flags);
 	return 0;
 }
 
 /**
- *	set_irq_chip_data - set irq chip data for an irq
+ *	irq_set_chip_data - set irq chip data for an irq
  *	@irq:	Interrupt number
  *	@data:	Pointer to chip specific data
  *
  *	Set the hardware irq chip data for an irq
  */
-int set_irq_chip_data(unsigned int irq, void *data)
+int irq_set_chip_data(unsigned int irq, void *data)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
+	struct irq_desc *desc = irq_get_desc_lock(irq, &flags);
 
-	if (!desc) {
-		printk(KERN_ERR
-		       "Trying to install chip data for IRQ%d\n", irq);
-		return -EINVAL;
-	}
-
-	if (!desc->irq_data.chip) {
-		printk(KERN_ERR "BUG: bad set_irq_chip_data(IRQ#%d)\n", irq);
+	if (!desc)
 		return -EINVAL;
-	}
-
-	raw_spin_lock_irqsave(&desc->lock, flags);
 	desc->irq_data.chip_data = data;
-	raw_spin_unlock_irqrestore(&desc->lock, flags);
-
+	irq_put_desc_unlock(desc, flags);
 	return 0;
 }
-EXPORT_SYMBOL(set_irq_chip_data);
+EXPORT_SYMBOL(irq_set_chip_data);
 
 struct irq_data *irq_get_irq_data(unsigned int irq)
 {
@@ -162,72 +132,75 @@ struct irq_data *irq_get_irq_data(unsigned int irq)
 }
 EXPORT_SYMBOL_GPL(irq_get_irq_data);
 
-/**
- *	set_irq_nested_thread - Set/Reset the IRQ_NESTED_THREAD flag of an irq
- *
- *	@irq:	Interrupt number
- *	@nest:	0 to clear / 1 to set the IRQ_NESTED_THREAD flag
- *
- *	The IRQ_NESTED_THREAD flag indicates that on
- *	request_threaded_irq() no separate interrupt thread should be
- *	created for the irq as the handler are called nested in the
- *	context of a demultiplexing interrupt handler thread.
- */
-void set_irq_nested_thread(unsigned int irq, int nest)
+static void irq_state_clr_disabled(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-	unsigned long flags;
-
-	if (!desc)
-		return;
-
-	raw_spin_lock_irqsave(&desc->lock, flags);
-	if (nest)
-		desc->status |= IRQ_NESTED_THREAD;
-	else
-		desc->status &= ~IRQ_NESTED_THREAD;
-	raw_spin_unlock_irqrestore(&desc->lock, flags);
+	desc->istate &= ~IRQS_DISABLED;
+	irq_compat_clr_disabled(desc);
 }
-EXPORT_SYMBOL_GPL(set_irq_nested_thread);
 
-/*
- * default enable function
- */
-static void default_enable(struct irq_data *data)
+static void irq_state_set_disabled(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_data_to_desc(data);
+	desc->istate |= IRQS_DISABLED;
+	irq_compat_set_disabled(desc);
+}
 
-	desc->irq_data.chip->irq_unmask(&desc->irq_data);
-	desc->status &= ~IRQ_MASKED;
+static void irq_state_clr_masked(struct irq_desc *desc)
+{
+	desc->istate &= ~IRQS_MASKED;
+	irq_compat_clr_masked(desc);
 }
 
-/*
- * default disable function
- */
-static void default_disable(struct irq_data *data)
+static void irq_state_set_masked(struct irq_desc *desc)
 {
+	desc->istate |= IRQS_MASKED;
+	irq_compat_set_masked(desc);
 }
 
-/*
- * default startup function
- */
-static unsigned int default_startup(struct irq_data *data)
+int irq_startup(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_data_to_desc(data);
+	irq_state_clr_disabled(desc);
+	desc->depth = 0;
+
+	if (desc->irq_data.chip->irq_startup) {
+		int ret = desc->irq_data.chip->irq_startup(&desc->irq_data);
+		irq_state_clr_masked(desc);
+		return ret;
+	}
 
-	desc->irq_data.chip->irq_enable(data);
+	irq_enable(desc);
 	return 0;
 }
 
-/*
- * default shutdown function
- */
-static void default_shutdown(struct irq_data *data)
+void irq_shutdown(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_data_to_desc(data);
+	irq_state_set_disabled(desc);
+	desc->depth = 1;
+	if (desc->irq_data.chip->irq_shutdown)
+		desc->irq_data.chip->irq_shutdown(&desc->irq_data);
+	if (desc->irq_data.chip->irq_disable)
+		desc->irq_data.chip->irq_disable(&desc->irq_data);
+	else
+		desc->irq_data.chip->irq_mask(&desc->irq_data);
+	irq_state_set_masked(desc);
+}
 
-	desc->irq_data.chip->irq_mask(&desc->irq_data);
-	desc->status |= IRQ_MASKED;
+void irq_enable(struct irq_desc *desc)
+{
+	irq_state_clr_disabled(desc);
+	if (desc->irq_data.chip->irq_enable)
+		desc->irq_data.chip->irq_enable(&desc->irq_data);
+	else
+		desc->irq_data.chip->irq_unmask(&desc->irq_data);
+	irq_state_clr_masked(desc);
+}
+
+void irq_disable(struct irq_desc *desc)
+{
+	irq_state_set_disabled(desc);
+	if (desc->irq_data.chip->irq_disable) {
+		desc->irq_data.chip->irq_disable(&desc->irq_data);
+		irq_state_set_masked(desc);
+	}
 }
 
 #ifndef CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED
@@ -315,10 +288,6 @@ static void compat_bus_sync_unlock(struct irq_data *data)
 void irq_chip_set_defaults(struct irq_chip *chip)
 {
 #ifndef CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED
-	/*
-	 * Compat fixup functions need to be before we set the
-	 * defaults for enable/disable/startup/shutdown
-	 */
 	if (chip->enable)
 		chip->irq_enable = compat_irq_enable;
 	if (chip->disable)
@@ -327,33 +296,8 @@ void irq_chip_set_defaults(struct irq_chip *chip)
 		chip->irq_shutdown = compat_irq_shutdown;
 	if (chip->startup)
 		chip->irq_startup = compat_irq_startup;
-#endif
-	/*
-	 * The real defaults
-	 */
-	if (!chip->irq_enable)
-		chip->irq_enable = default_enable;
-	if (!chip->irq_disable)
-		chip->irq_disable = default_disable;
-	if (!chip->irq_startup)
-		chip->irq_startup = default_startup;
-	/*
-	 * We use chip->irq_disable, when the user provided its own. When
-	 * we have default_disable set for chip->irq_disable, then we need
-	 * to use default_shutdown, otherwise the irq line is not
-	 * disabled on free_irq():
-	 */
-	if (!chip->irq_shutdown)
-		chip->irq_shutdown = chip->irq_disable != default_disable ?
-			chip->irq_disable : default_shutdown;
-
-#ifndef CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED
 	if (!chip->end)
 		chip->end = dummy_irq_chip.end;
-
-	/*
-	 * Now fix up the remaining compat handlers
-	 */
 	if (chip->bus_lock)
 		chip->irq_bus_lock = compat_bus_lock;
 	if (chip->bus_sync_unlock)
@@ -388,22 +332,22 @@ static inline void mask_ack_irq(struct irq_desc *desc)
 		if (desc->irq_data.chip->irq_ack)
 			desc->irq_data.chip->irq_ack(&desc->irq_data);
 	}
-	desc->status |= IRQ_MASKED;
+	irq_state_set_masked(desc);
 }
 
-static inline void mask_irq(struct irq_desc *desc)
+void mask_irq(struct irq_desc *desc)
 {
 	if (desc->irq_data.chip->irq_mask) {
 		desc->irq_data.chip->irq_mask(&desc->irq_data);
-		desc->status |= IRQ_MASKED;
+		irq_state_set_masked(desc);
 	}
 }
 
-static inline void unmask_irq(struct irq_desc *desc)
+void unmask_irq(struct irq_desc *desc)
 {
 	if (desc->irq_data.chip->irq_unmask) {
 		desc->irq_data.chip->irq_unmask(&desc->irq_data);
-		desc->status &= ~IRQ_MASKED;
+		irq_state_clr_masked(desc);
 	}
 }
 
@@ -428,10 +372,11 @@ void handle_nested_irq(unsigned int irq)
 	kstat_incr_irqs_this_cpu(irq, desc);
 
 	action = desc->action;
-	if (unlikely(!action || (desc->status & IRQ_DISABLED)))
+	if (unlikely(!action || (desc->istate & IRQS_DISABLED)))
 		goto out_unlock;
 
-	desc->status |= IRQ_INPROGRESS;
+	irq_compat_set_progress(desc);
+	desc->istate |= IRQS_INPROGRESS;
 	raw_spin_unlock_irq(&desc->lock);
 
 	action_ret = action->thread_fn(action->irq, action->dev_id);
@@ -439,13 +384,21 @@ void handle_nested_irq(unsigned int irq)
 		note_interrupt(irq, desc, action_ret);
 
 	raw_spin_lock_irq(&desc->lock);
-	desc->status &= ~IRQ_INPROGRESS;
+	desc->istate &= ~IRQS_INPROGRESS;
+	irq_compat_clr_progress(desc);
 
 out_unlock:
 	raw_spin_unlock_irq(&desc->lock);
 }
 EXPORT_SYMBOL_GPL(handle_nested_irq);
 
+static bool irq_check_poll(struct irq_desc *desc)
+{
+	if (!(desc->istate & IRQS_POLL_INPROGRESS))
+		return false;
+	return irq_wait_for_poll(desc);
+}
+
 /**
  *	handle_simple_irq - Simple and software-decoded IRQs.
  *	@irq:	the interrupt number
@@ -461,29 +414,20 @@ EXPORT_SYMBOL_GPL(handle_nested_irq);
 void
 handle_simple_irq(unsigned int irq, struct irq_desc *desc)
 {
-	struct irqaction *action;
-	irqreturn_t action_ret;
-
 	raw_spin_lock(&desc->lock);
 
-	if (unlikely(desc->status & IRQ_INPROGRESS))
-		goto out_unlock;
-	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
+	if (unlikely(desc->istate & IRQS_INPROGRESS))
+		if (!irq_check_poll(desc))
+			goto out_unlock;
+
+	desc->istate &= ~(IRQS_REPLAY | IRQS_WAITING);
 	kstat_incr_irqs_this_cpu(irq, desc);
 
-	action = desc->action;
-	if (unlikely(!action || (desc->status & IRQ_DISABLED)))
+	if (unlikely(!desc->action || (desc->istate & IRQS_DISABLED)))
 		goto out_unlock;
 
-	desc->status |= IRQ_INPROGRESS;
-	raw_spin_unlock(&desc->lock);
+	handle_irq_event(desc);
 
-	action_ret = handle_IRQ_event(irq, action);
-	if (!noirqdebug)
-		note_interrupt(irq, desc, action_ret);
-
-	raw_spin_lock(&desc->lock);
-	desc->status &= ~IRQ_INPROGRESS;
 out_unlock:
 	raw_spin_unlock(&desc->lock);
 }
@@ -501,42 +445,42 @@ out_unlock:
 void
 handle_level_irq(unsigned int irq, struct irq_desc *desc)
 {
-	struct irqaction *action;
-	irqreturn_t action_ret;
-
 	raw_spin_lock(&desc->lock);
 	mask_ack_irq(desc);
 
-	if (unlikely(desc->status & IRQ_INPROGRESS))
-		goto out_unlock;
-	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
+	if (unlikely(desc->istate & IRQS_INPROGRESS))
+		if (!irq_check_poll(desc))
+			goto out_unlock;
+
+	desc->istate &= ~(IRQS_REPLAY | IRQS_WAITING);
 	kstat_incr_irqs_this_cpu(irq, desc);
 
 	/*
 	 * If its disabled or no action available
 	 * keep it masked and get out of here
 	 */
-	action = desc->action;
-	if (unlikely(!action || (desc->status & IRQ_DISABLED)))
+	if (unlikely(!desc->action || (desc->istate & IRQS_DISABLED)))
 		goto out_unlock;
 
-	desc->status |= IRQ_INPROGRESS;
-	raw_spin_unlock(&desc->lock);
-
-	action_ret = handle_IRQ_event(irq, action);
-	if (!noirqdebug)
-		note_interrupt(irq, desc, action_ret);
+	handle_irq_event(desc);
 
-	raw_spin_lock(&desc->lock);
-	desc->status &= ~IRQ_INPROGRESS;
-
-	if (!(desc->status & (IRQ_DISABLED | IRQ_ONESHOT)))
+	if (!(desc->istate & (IRQS_DISABLED | IRQS_ONESHOT)))
 		unmask_irq(desc);
 out_unlock:
 	raw_spin_unlock(&desc->lock);
 }
 EXPORT_SYMBOL_GPL(handle_level_irq);
 
+#ifdef CONFIG_IRQ_PREFLOW_FASTEOI
+static inline void preflow_handler(struct irq_desc *desc)
+{
+	if (desc->preflow_handler)
+		desc->preflow_handler(&desc->irq_data);
+}
+#else
+static inline void preflow_handler(struct irq_desc *desc) { }
+#endif
+
 /**
  *	handle_fasteoi_irq - irq handler for transparent controllers
  *	@irq:	the interrupt number
@@ -550,42 +494,41 @@ EXPORT_SYMBOL_GPL(handle_level_irq);
 void
 handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 {
-	struct irqaction *action;
-	irqreturn_t action_ret;
-
 	raw_spin_lock(&desc->lock);
 
-	if (unlikely(desc->status & IRQ_INPROGRESS))
-		goto out;
+	if (unlikely(desc->istate & IRQS_INPROGRESS))
+		if (!irq_check_poll(desc))
+			goto out;
 
-	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
+	desc->istate &= ~(IRQS_REPLAY | IRQS_WAITING);
 	kstat_incr_irqs_this_cpu(irq, desc);
 
 	/*
 	 * If its disabled or no action available
 	 * then mask it and get out of here:
 	 */
-	action = desc->action;
-	if (unlikely(!action || (desc->status & IRQ_DISABLED))) {
-		desc->status |= IRQ_PENDING;
+	if (unlikely(!desc->action || (desc->istate & IRQS_DISABLED))) {
+		irq_compat_set_pending(desc);
+		desc->istate |= IRQS_PENDING;
 		mask_irq(desc);
 		goto out;
 	}
 
-	desc->status |= IRQ_INPROGRESS;
-	desc->status &= ~IRQ_PENDING;
-	raw_spin_unlock(&desc->lock);
+	if (desc->istate & IRQS_ONESHOT)
+		mask_irq(desc);
 
-	action_ret = handle_IRQ_event(irq, action);
-	if (!noirqdebug)
-		note_interrupt(irq, desc, action_ret);
+	preflow_handler(desc);
+	handle_irq_event(desc);
 
-	raw_spin_lock(&desc->lock);
-	desc->status &= ~IRQ_INPROGRESS;
-out:
+out_eoi:
 	desc->irq_data.chip->irq_eoi(&desc->irq_data);
-
+out_unlock:
 	raw_spin_unlock(&desc->lock);
+	return;
+out:
+	if (!(desc->irq_data.chip->flags & IRQCHIP_EOI_IF_HANDLED))
+		goto out_eoi;
+	goto out_unlock;
 }
 
 /**
@@ -609,32 +552,28 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 {
 	raw_spin_lock(&desc->lock);
 
-	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
-
+	desc->istate &= ~(IRQS_REPLAY | IRQS_WAITING);
 	/*
 	 * If we're currently running this IRQ, or its disabled,
 	 * we shouldn't process the IRQ. Mark it pending, handle
 	 * the necessary masking and go out
 	 */
-	if (unlikely((desc->status & (IRQ_INPROGRESS | IRQ_DISABLED)) ||
-		    !desc->action)) {
-		desc->status |= (IRQ_PENDING | IRQ_MASKED);
-		mask_ack_irq(desc);
-		goto out_unlock;
+	if (unlikely((desc->istate & (IRQS_DISABLED | IRQS_INPROGRESS) ||
+		      !desc->action))) {
+		if (!irq_check_poll(desc)) {
+			irq_compat_set_pending(desc);
+			desc->istate |= IRQS_PENDING;
+			mask_ack_irq(desc);
+			goto out_unlock;
+		}
 	}
 	kstat_incr_irqs_this_cpu(irq, desc);
 
 	/* Start handling the irq */
 	desc->irq_data.chip->irq_ack(&desc->irq_data);
 
-	/* Mark the IRQ currently in progress.*/
-	desc->status |= IRQ_INPROGRESS;
-
 	do {
-		struct irqaction *action = desc->action;
-		irqreturn_t action_ret;
-
-		if (unlikely(!action)) {
+		if (unlikely(!desc->action)) {
 			mask_irq(desc);
 			goto out_unlock;
 		}
@@ -644,22 +583,17 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 		 * one, we could have masked the irq.
 		 * Renable it, if it was not disabled in meantime.
 		 */
-		if (unlikely((desc->status &
-			       (IRQ_PENDING | IRQ_MASKED | IRQ_DISABLED)) ==
-			      (IRQ_PENDING | IRQ_MASKED))) {
-			unmask_irq(desc);
+		if (unlikely(desc->istate & IRQS_PENDING)) {
+			if (!(desc->istate & IRQS_DISABLED) &&
+			    (desc->istate & IRQS_MASKED))
+				unmask_irq(desc);
 		}
 
-		desc->status &= ~IRQ_PENDING;
-		raw_spin_unlock(&desc->lock);
-		action_ret = handle_IRQ_event(irq, action);
-		if (!noirqdebug)
-			note_interrupt(irq, desc, action_ret);
-		raw_spin_lock(&desc->lock);
+		handle_irq_event(desc);
 
-	} while ((desc->status & (IRQ_PENDING | IRQ_DISABLED)) == IRQ_PENDING);
+	} while ((desc->istate & IRQS_PENDING) &&
+		 !(desc->istate & IRQS_DISABLED));
 
-	desc->status &= ~IRQ_INPROGRESS;
 out_unlock:
 	raw_spin_unlock(&desc->lock);
 }
@@ -674,103 +608,84 @@ out_unlock:
 void
 handle_percpu_irq(unsigned int irq, struct irq_desc *desc)
 {
-	irqreturn_t action_ret;
+	struct irq_chip *chip = irq_desc_get_chip(desc);
 
 	kstat_incr_irqs_this_cpu(irq, desc);
 
-	if (desc->irq_data.chip->irq_ack)
-		desc->irq_data.chip->irq_ack(&desc->irq_data);
+	if (chip->irq_ack)
+		chip->irq_ack(&desc->irq_data);
 
-	action_ret = handle_IRQ_event(irq, desc->action);
-	if (!noirqdebug)
-		note_interrupt(irq, desc, action_ret);
+	handle_irq_event_percpu(desc, desc->action);
 
-	if (desc->irq_data.chip->irq_eoi)
-		desc->irq_data.chip->irq_eoi(&desc->irq_data);
+	if (chip->irq_eoi)
+		chip->irq_eoi(&desc->irq_data);
 }
 
 void
-__set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
+__irq_set_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 		  const char *name)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
+	struct irq_desc *desc = irq_get_desc_buslock(irq, &flags);
 
-	if (!desc) {
-		printk(KERN_ERR
-		       "Trying to install type control for IRQ%d\n", irq);
+	if (!desc)
 		return;
-	}
 
-	if (!handle)
+	if (!handle) {
 		handle = handle_bad_irq;
-	else if (desc->irq_data.chip == &no_irq_chip) {
-		printk(KERN_WARNING "Trying to install %sinterrupt handler "
-		       "for IRQ%d\n", is_chained ? "chained " : "", irq);
-		/*
-		 * Some ARM implementations install a handler for really dumb
-		 * interrupt hardware without setting an irq_chip. This worked
-		 * with the ARM no_irq_chip but the check in setup_irq would
-		 * prevent us to setup the interrupt at all. Switch it to
-		 * dummy_irq_chip for easy transition.
-		 */
-		desc->irq_data.chip = &dummy_irq_chip;
+	} else {
+		if (WARN_ON(desc->irq_data.chip == &no_irq_chip))
+			goto out;
 	}
 
-	chip_bus_lock(desc);
-	raw_spin_lock_irqsave(&desc->lock, flags);
-
 	/* Uninstall? */
 	if (handle == handle_bad_irq) {
 		if (desc->irq_data.chip != &no_irq_chip)
 			mask_ack_irq(desc);
-		desc->status |= IRQ_DISABLED;
+		irq_compat_set_disabled(desc);
+		desc->istate |= IRQS_DISABLED;
 		desc->depth = 1;
 	}
 	desc->handle_irq = handle;
 	desc->name = name;
 
 	if (handle != handle_bad_irq && is_chained) {
-		desc->status &= ~IRQ_DISABLED;
-		desc->status |= IRQ_NOREQUEST | IRQ_NOPROBE;
-		desc->depth = 0;
-		desc->irq_data.chip->irq_startup(&desc->irq_data);
+		irq_settings_set_noprobe(desc);
+		irq_settings_set_norequest(desc);
+		irq_startup(desc);
 	}
-	raw_spin_unlock_irqrestore(&desc->lock, flags);
-	chip_bus_sync_unlock(desc);
-}
-EXPORT_SYMBOL_GPL(__set_irq_handler);
-
-void
-set_irq_chip_and_handler(unsigned int irq, struct irq_chip *chip,
-			 irq_flow_handler_t handle)
-{
-	set_irq_chip(irq, chip);
-	__set_irq_handler(irq, handle, 0, NULL);
+out:
+	irq_put_desc_busunlock(desc, flags);
 }
+EXPORT_SYMBOL_GPL(__irq_set_handler);
 
 void
-set_irq_chip_and_handler_name(unsigned int irq, struct irq_chip *chip,
+irq_set_chip_and_handler_name(unsigned int irq, struct irq_chip *chip,
 			      irq_flow_handler_t handle, const char *name)
 {
-	set_irq_chip(irq, chip);
-	__set_irq_handler(irq, handle, 0, name);
+	irq_set_chip(irq, chip);
+	__irq_set_handler(irq, handle, 0, name);
 }
 
 void irq_modify_status(unsigned int irq, unsigned long clr, unsigned long set)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
+	struct irq_desc *desc = irq_get_desc_lock(irq, &flags);
 
 	if (!desc)
 		return;
+	irq_settings_clr_and_set(desc, clr, set);
+
+	irqd_clear(&desc->irq_data, IRQD_NO_BALANCING | IRQD_PER_CPU |
+		   IRQD_TRIGGER_MASK | IRQD_LEVEL | IRQD_MOVE_PCNTXT);
+	if (irq_settings_has_no_balance_set(desc))
+		irqd_set(&desc->irq_data, IRQD_NO_BALANCING);
+	if (irq_settings_is_per_cpu(desc))
+		irqd_set(&desc->irq_data, IRQD_PER_CPU);
+	if (irq_settings_can_move_pcntxt(desc))
+		irqd_set(&desc->irq_data, IRQD_MOVE_PCNTXT);
 
-	/* Sanitize flags */
-	set &= IRQF_MODIFY_MASK;
-	clr &= IRQF_MODIFY_MASK;
+	irqd_set(&desc->irq_data, irq_settings_get_trigger_mask(desc));
 
-	raw_spin_lock_irqsave(&desc->lock, flags);
-	desc->status &= ~clr;
-	desc->status |= set;
-	raw_spin_unlock_irqrestore(&desc->lock, flags);
+	irq_put_desc_unlock(desc, flags);
 }
diff --git a/kernel/irq/compat.h b/kernel/irq/compat.h
new file mode 100644
index 0000000..6bbaf66
--- /dev/null
+++ b/kernel/irq/compat.h
@@ -0,0 +1,72 @@
+/*
+ * Compat layer for transition period
+ */
+#ifndef CONFIG_GENERIC_HARDIRQS_NO_COMPAT
+static inline void irq_compat_set_progress(struct irq_desc *desc)
+{
+	desc->status |= IRQ_INPROGRESS;
+}
+
+static inline void irq_compat_clr_progress(struct irq_desc *desc)
+{
+	desc->status &= ~IRQ_INPROGRESS;
+}
+static inline void irq_compat_set_disabled(struct irq_desc *desc)
+{
+	desc->status |= IRQ_DISABLED;
+}
+static inline void irq_compat_clr_disabled(struct irq_desc *desc)
+{
+	desc->status &= ~IRQ_DISABLED;
+}
+static inline void irq_compat_set_pending(struct irq_desc *desc)
+{
+	desc->status |= IRQ_PENDING;
+}
+
+static inline void irq_compat_clr_pending(struct irq_desc *desc)
+{
+	desc->status &= ~IRQ_PENDING;
+}
+static inline void irq_compat_set_masked(struct irq_desc *desc)
+{
+	desc->status |= IRQ_MASKED;
+}
+
+static inline void irq_compat_clr_masked(struct irq_desc *desc)
+{
+	desc->status &= ~IRQ_MASKED;
+}
+static inline void irq_compat_set_move_pending(struct irq_desc *desc)
+{
+	desc->status |= IRQ_MOVE_PENDING;
+}
+
+static inline void irq_compat_clr_move_pending(struct irq_desc *desc)
+{
+	desc->status &= ~IRQ_MOVE_PENDING;
+}
+static inline void irq_compat_set_affinity(struct irq_desc *desc)
+{
+	desc->status |= IRQ_AFFINITY_SET;
+}
+
+static inline void irq_compat_clr_affinity(struct irq_desc *desc)
+{
+	desc->status &= ~IRQ_AFFINITY_SET;
+}
+#else
+static inline void irq_compat_set_progress(struct irq_desc *desc) { }
+static inline void irq_compat_clr_progress(struct irq_desc *desc) { }
+static inline void irq_compat_set_disabled(struct irq_desc *desc) { }
+static inline void irq_compat_clr_disabled(struct irq_desc *desc) { }
+static inline void irq_compat_set_pending(struct irq_desc *desc) { }
+static inline void irq_compat_clr_pending(struct irq_desc *desc) { }
+static inline void irq_compat_set_masked(struct irq_desc *desc) { }
+static inline void irq_compat_clr_masked(struct irq_desc *desc) { }
+static inline void irq_compat_set_move_pending(struct irq_desc *desc) { }
+static inline void irq_compat_clr_move_pending(struct irq_desc *desc) { }
+static inline void irq_compat_set_affinity(struct irq_desc *desc) { }
+static inline void irq_compat_clr_affinity(struct irq_desc *desc) { }
+#endif
+
diff --git a/kernel/irq/debug.h b/kernel/irq/debug.h
new file mode 100644
index 0000000..d1a33b7
--- /dev/null
+++ b/kernel/irq/debug.h
@@ -0,0 +1,40 @@
+/*
+ * Debugging printout:
+ */
+
+#include <linux/kallsyms.h>
+
+#define P(f) if (desc->status & f) printk("%14s set\n", #f)
+#define PS(f) if (desc->istate & f) printk("%14s set\n", #f)
+
+static inline void print_irq_desc(unsigned int irq, struct irq_desc *desc)
+{
+	printk("irq %d, desc: %p, depth: %d, count: %d, unhandled: %d\n",
+		irq, desc, desc->depth, desc->irq_count, desc->irqs_unhandled);
+	printk("->handle_irq():  %p, ", desc->handle_irq);
+	print_symbol("%s\n", (unsigned long)desc->handle_irq);
+	printk("->irq_data.chip(): %p, ", desc->irq_data.chip);
+	print_symbol("%s\n", (unsigned long)desc->irq_data.chip);
+	printk("->action(): %p\n", desc->action);
+	if (desc->action) {
+		printk("->action->handler(): %p, ", desc->action->handler);
+		print_symbol("%s\n", (unsigned long)desc->action->handler);
+	}
+
+	P(IRQ_LEVEL);
+	P(IRQ_PER_CPU);
+	P(IRQ_NOPROBE);
+	P(IRQ_NOREQUEST);
+	P(IRQ_NOAUTOEN);
+
+	PS(IRQS_AUTODETECT);
+	PS(IRQS_INPROGRESS);
+	PS(IRQS_REPLAY);
+	PS(IRQS_WAITING);
+	PS(IRQS_DISABLED);
+	PS(IRQS_PENDING);
+	PS(IRQS_MASKED);
+}
+
+#undef P
+#undef PS
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 3540a71..517561f 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -51,30 +51,92 @@ static void warn_no_thread(unsigned int irq, struct irqaction *action)
 	       "but no thread function available.", irq, action->name);
 }
 
-/**
- * handle_IRQ_event - irq action chain handler
- * @irq:	the interrupt number
- * @action:	the interrupt action chain for this irq
- *
- * Handles the action chain of an irq event
- */
-irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
+static void irq_wake_thread(struct irq_desc *desc, struct irqaction *action)
+{
+	/*
+	 * Wake up the handler thread for this action. In case the
+	 * thread crashed and was killed we just pretend that we
+	 * handled the interrupt. The hardirq handler has disabled the
+	 * device interrupt, so no irq storm is lurking. If the
+	 * RUNTHREAD bit is already set, nothing to do.
+	 */
+	if (test_bit(IRQTF_DIED, &action->thread_flags) ||
+	    test_and_set_bit(IRQTF_RUNTHREAD, &action->thread_flags))
+		return;
+
+	/*
+	 * It's safe to OR the mask lockless here. We have only two
+	 * places which write to threads_oneshot: This code and the
+	 * irq thread.
+	 *
+	 * This code is the hard irq context and can never run on two
+	 * cpus in parallel. If it ever does we have more serious
+	 * problems than this bitmask.
+	 *
+	 * The irq threads of this irq which clear their "running" bit
+	 * in threads_oneshot are serialized via desc->lock against
+	 * each other and they are serialized against this code by
+	 * IRQS_INPROGRESS.
+	 *
+	 * Hard irq handler:
+	 *
+	 *	spin_lock(desc->lock);
+	 *	desc->state |= IRQS_INPROGRESS;
+	 *	spin_unlock(desc->lock);
+	 *	set_bit(IRQTF_RUNTHREAD, &action->thread_flags);
+	 *	desc->threads_oneshot |= mask;
+	 *	spin_lock(desc->lock);
+	 *	desc->state &= ~IRQS_INPROGRESS;
+	 *	spin_unlock(desc->lock);
+	 *
+	 * irq thread:
+	 *
+	 * again:
+	 *	spin_lock(desc->lock);
+	 *	if (desc->state & IRQS_INPROGRESS) {
+	 *		spin_unlock(desc->lock);
+	 *		while(desc->state & IRQS_INPROGRESS)
+	 *			cpu_relax();
+	 *		goto again;
+	 *	}
+	 *	if (!test_bit(IRQTF_RUNTHREAD, &action->thread_flags))
+	 *		desc->threads_oneshot &= ~mask;
+	 *	spin_unlock(desc->lock);
+	 *
+	 * So either the thread waits for us to clear IRQS_INPROGRESS
+	 * or we are waiting in the flow handler for desc->lock to be
+	 * released before we reach this point. The thread also checks
+	 * IRQTF_RUNTHREAD under desc->lock. If set it leaves
+	 * threads_oneshot untouched and runs the thread another time.
+	 */
+	desc->threads_oneshot |= action->thread_mask;
+	wake_up_process(action->thread);
+}
+
+irqreturn_t
+handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action)
 {
-	irqreturn_t ret, retval = IRQ_NONE;
-	unsigned int status = 0;
+	irqreturn_t retval = IRQ_NONE;
+	unsigned int random = 0, irq = desc->irq_data.irq;
 
 	do {
+		irqreturn_t res;
+
 		trace_irq_handler_entry(irq, action);
-		ret = action->handler(irq, action->dev_id);
-		trace_irq_handler_exit(irq, action, ret);
+		res = action->handler(irq, action->dev_id);
+		trace_irq_handler_exit(irq, action, res);
 
-		switch (ret) {
+		if (WARN_ONCE(!irqs_disabled(),"irq %u handler %pF enabled interrupts\n",
+			      irq, action->handler))
+			local_irq_disable();
+
+		switch (res) {
 		case IRQ_WAKE_THREAD:
 			/*
 			 * Set result to handled so the spurious check
 			 * does not trigger.
 			 */
-			ret = IRQ_HANDLED;
+			res = IRQ_HANDLED;
 
 			/*
 			 * Catch drivers which return WAKE_THREAD but
@@ -85,36 +147,56 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
 				break;
 			}
 
-			/*
-			 * Wake up the handler thread for this
-			 * action. In case the thread crashed and was
-			 * killed we just pretend that we handled the
-			 * interrupt. The hardirq handler above has
-			 * disabled the device interrupt, so no irq
-			 * storm is lurking.
-			 */
-			if (likely(!test_bit(IRQTF_DIED,
-					     &action->thread_flags))) {
-				set_bit(IRQTF_RUNTHREAD, &action->thread_flags);
-				wake_up_process(action->thread);
-			}
+			irq_wake_thread(desc, action);
 
 			/* Fall through to add to randomness */
 		case IRQ_HANDLED:
-			status |= action->flags;
+			random |= action->flags;
 			break;
 
 		default:
 			break;
 		}
 
-		retval |= ret;
+		retval |= res;
 		action = action->next;
 	} while (action);
 
-	if (status & IRQF_SAMPLE_RANDOM)
+	if (random & IRQF_SAMPLE_RANDOM)
 		add_interrupt_randomness(irq);
-	local_irq_disable();
 
+	if (!noirqdebug)
+		note_interrupt(irq, desc, retval);
 	return retval;
 }
+
+irqreturn_t handle_irq_event(struct irq_desc *desc)
+{
+	struct irqaction *action = desc->action;
+	irqreturn_t ret;
+
+	irq_compat_clr_pending(desc);
+	desc->istate &= ~IRQS_PENDING;
+	irq_compat_set_progress(desc);
+	desc->istate |= IRQS_INPROGRESS;
+	raw_spin_unlock(&desc->lock);
+
+	ret = handle_irq_event_percpu(desc, action);
+
+	raw_spin_lock(&desc->lock);
+	desc->istate &= ~IRQS_INPROGRESS;
+	irq_compat_clr_progress(desc);
+	return ret;
+}
+
+/**
+ * handle_IRQ_event - irq action chain handler
+ * @irq:	the interrupt number
+ * @action:	the interrupt action chain for this irq
+ *
+ * Handles the action chain of an irq event
+ */
+irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
+{
+	return handle_irq_event_percpu(irq_to_desc(irq), action);
+}
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 4571ae7..6c6ec9a 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -1,27 +1,101 @@
 /*
  * IRQ subsystem internal functions and variables:
+ *
+ * Do not ever include this file from anything else than
+ * kernel/irq/. Do not even think about using any information outside
+ * of this file for your non core code.
  */
 #include <linux/irqdesc.h>
 
+#ifdef CONFIG_SPARSE_IRQ
+# define IRQ_BITMAP_BITS	(NR_IRQS + 8196)
+#else
+# define IRQ_BITMAP_BITS	NR_IRQS
+#endif
+
+#define istate core_internal_state__do_not_mess_with_it
+
+#ifdef CONFIG_GENERIC_HARDIRQS_NO_COMPAT
+# define status status_use_accessors
+#endif
+
 extern int noirqdebug;
 
+/*
+ * Bits used by threaded handlers:
+ * IRQTF_RUNTHREAD - signals that the interrupt handler thread should run
+ * IRQTF_DIED      - handler thread died
+ * IRQTF_WARNED    - warning "IRQ_WAKE_THREAD w/o thread_fn" has been printed
+ * IRQTF_AFFINITY  - irq thread is requested to adjust affinity
+ * IRQTF_FORCED_THREAD  - irq action is force threaded
+ */
+enum {
+	IRQTF_RUNTHREAD,
+	IRQTF_DIED,
+	IRQTF_WARNED,
+	IRQTF_AFFINITY,
+	IRQTF_FORCED_THREAD,
+};
+
+/*
+ * Bit masks for desc->state
+ *
+ * IRQS_AUTODETECT		- autodetection in progress
+ * IRQS_SPURIOUS_DISABLED	- was disabled due to spurious interrupt
+ *				  detection
+ * IRQS_POLL_INPROGRESS		- polling in progress
+ * IRQS_INPROGRESS		- Interrupt in progress
+ * IRQS_ONESHOT			- irq is not unmasked in primary handler
+ * IRQS_REPLAY			- irq is replayed
+ * IRQS_WAITING			- irq is waiting
+ * IRQS_DISABLED		- irq is disabled
+ * IRQS_PENDING			- irq is pending and replayed later
+ * IRQS_MASKED			- irq is masked
+ * IRQS_SUSPENDED		- irq is suspended
+ */
+enum {
+	IRQS_AUTODETECT		= 0x00000001,
+	IRQS_SPURIOUS_DISABLED	= 0x00000002,
+	IRQS_POLL_INPROGRESS	= 0x00000008,
+	IRQS_INPROGRESS		= 0x00000010,
+	IRQS_ONESHOT		= 0x00000020,
+	IRQS_REPLAY		= 0x00000040,
+	IRQS_WAITING		= 0x00000080,
+	IRQS_DISABLED		= 0x00000100,
+	IRQS_PENDING		= 0x00000200,
+	IRQS_MASKED		= 0x00000400,
+	IRQS_SUSPENDED		= 0x00000800,
+};
+
+#include "compat.h"
+#include "debug.h"
+#include "settings.h"
+
 #define irq_data_to_desc(data)	container_of(data, struct irq_desc, irq_data)
 
 /* Set default functions for irq_chip structures: */
 extern void irq_chip_set_defaults(struct irq_chip *chip);
 
-/* Set default handler: */
-extern void compat_irq_chip_set_default_handler(struct irq_desc *desc);
-
 extern int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 		unsigned long flags);
 extern void __disable_irq(struct irq_desc *desc, unsigned int irq, bool susp);
 extern void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume);
 
+extern int irq_startup(struct irq_desc *desc);
+extern void irq_shutdown(struct irq_desc *desc);
+extern void irq_enable(struct irq_desc *desc);
+extern void irq_disable(struct irq_desc *desc);
+extern void mask_irq(struct irq_desc *desc);
+extern void unmask_irq(struct irq_desc *desc);
+
 extern void init_kstat_irqs(struct irq_desc *desc, int node, int nr);
 
+irqreturn_t handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action);
+irqreturn_t handle_irq_event(struct irq_desc *desc);
+
 /* Resending of interrupts :*/
 void check_irq_resend(struct irq_desc *desc, unsigned int irq);
+bool irq_wait_for_poll(struct irq_desc *desc);
 
 #ifdef CONFIG_PROC_FS
 extern void register_irq_proc(unsigned int irq, struct irq_desc *desc);
@@ -37,20 +111,10 @@ static inline void unregister_handler_proc(unsigned int irq,
 					   struct irqaction *action) { }
 #endif
 
-extern int irq_select_affinity_usr(unsigned int irq);
+extern int irq_select_affinity_usr(unsigned int irq, struct cpumask *mask);
 
 extern void irq_set_thread_affinity(struct irq_desc *desc);
 
-#ifndef CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED
-static inline void irq_end(unsigned int irq, struct irq_desc *desc)
-{
-	if (desc->irq_data.chip && desc->irq_data.chip->end)
-		desc->irq_data.chip->end(irq);
-}
-#else
-static inline void irq_end(unsigned int irq, struct irq_desc *desc) { }
-#endif
-
 /* Inline functions for support of irq chips on slow busses */
 static inline void chip_bus_lock(struct irq_desc *desc)
 {
@@ -64,43 +128,60 @@ static inline void chip_bus_sync_unlock(struct irq_desc *desc)
 		desc->irq_data.chip->irq_bus_sync_unlock(&desc->irq_data);
 }
 
+struct irq_desc *
+__irq_get_desc_lock(unsigned int irq, unsigned long *flags, bool bus);
+void __irq_put_desc_unlock(struct irq_desc *desc, unsigned long flags, bool bus);
+
+static inline struct irq_desc *
+irq_get_desc_buslock(unsigned int irq, unsigned long *flags)
+{
+	return __irq_get_desc_lock(irq, flags, true);
+}
+
+static inline void
+irq_put_desc_busunlock(struct irq_desc *desc, unsigned long flags)
+{
+	__irq_put_desc_unlock(desc, flags, true);
+}
+
+static inline struct irq_desc *
+irq_get_desc_lock(unsigned int irq, unsigned long *flags)
+{
+	return __irq_get_desc_lock(irq, flags, false);
+}
+
+static inline void
+irq_put_desc_unlock(struct irq_desc *desc, unsigned long flags)
+{
+	__irq_put_desc_unlock(desc, flags, false);
+}
+
 /*
- * Debugging printout:
+ * Manipulation functions for irq_data.state
  */
+static inline void irqd_set_move_pending(struct irq_data *d)
+{
+	d->state_use_accessors |= IRQD_SETAFFINITY_PENDING;
+	irq_compat_set_move_pending(irq_data_to_desc(d));
+}
 
-#include <linux/kallsyms.h>
-
-#define P(f) if (desc->status & f) printk("%14s set\n", #f)
+static inline void irqd_clr_move_pending(struct irq_data *d)
+{
+	d->state_use_accessors &= ~IRQD_SETAFFINITY_PENDING;
+	irq_compat_clr_move_pending(irq_data_to_desc(d));
+}
 
-static inline void print_irq_desc(unsigned int irq, struct irq_desc *desc)
+static inline void irqd_clear(struct irq_data *d, unsigned int mask)
 {
-	printk("irq %d, desc: %p, depth: %d, count: %d, unhandled: %d\n",
-		irq, desc, desc->depth, desc->irq_count, desc->irqs_unhandled);
-	printk("->handle_irq():  %p, ", desc->handle_irq);
-	print_symbol("%s\n", (unsigned long)desc->handle_irq);
-	printk("->irq_data.chip(): %p, ", desc->irq_data.chip);
-	print_symbol("%s\n", (unsigned long)desc->irq_data.chip);
-	printk("->action(): %p\n", desc->action);
-	if (desc->action) {
-		printk("->action->handler(): %p, ", desc->action->handler);
-		print_symbol("%s\n", (unsigned long)desc->action->handler);
-	}
-
-	P(IRQ_INPROGRESS);
-	P(IRQ_DISABLED);
-	P(IRQ_PENDING);
-	P(IRQ_REPLAY);
-	P(IRQ_AUTODETECT);
-	P(IRQ_WAITING);
-	P(IRQ_LEVEL);
-	P(IRQ_MASKED);
-#ifdef CONFIG_IRQ_PER_CPU
-	P(IRQ_PER_CPU);
-#endif
-	P(IRQ_NOPROBE);
-	P(IRQ_NOREQUEST);
-	P(IRQ_NOAUTOEN);
+	d->state_use_accessors &= ~mask;
 }
 
-#undef P
+static inline void irqd_set(struct irq_data *d, unsigned int mask)
+{
+	d->state_use_accessors |= mask;
+}
 
+static inline bool irqd_has_set(struct irq_data *d, unsigned int mask)
+{
+	return d->state_use_accessors & mask;
+}
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 282f202..dbccc79 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -79,7 +79,8 @@ static void desc_set_defaults(unsigned int irq, struct irq_desc *desc, int node)
 	desc->irq_data.chip_data = NULL;
 	desc->irq_data.handler_data = NULL;
 	desc->irq_data.msi_desc = NULL;
-	desc->status = IRQ_DEFAULT_INIT_FLAGS;
+	irq_settings_clr_and_set(desc, ~0, _IRQ_DEFAULT_INIT_FLAGS);
+	desc->istate = IRQS_DISABLED;
 	desc->handle_irq = handle_bad_irq;
 	desc->depth = 1;
 	desc->irq_count = 0;
@@ -94,7 +95,7 @@ int nr_irqs = NR_IRQS;
 EXPORT_SYMBOL_GPL(nr_irqs);
 
 static DEFINE_MUTEX(sparse_irq_lock);
-static DECLARE_BITMAP(allocated_irqs, NR_IRQS);
+static DECLARE_BITMAP(allocated_irqs, IRQ_BITMAP_BITS);
 
 #ifdef CONFIG_SPARSE_IRQ
 
@@ -206,6 +207,14 @@ struct irq_desc * __ref irq_to_desc_alloc_node(unsigned int irq, int node)
 	return NULL;
 }
 
+static int irq_expand_nr_irqs(unsigned int nr)
+{
+	if (nr > IRQ_BITMAP_BITS)
+		return -ENOMEM;
+	nr_irqs = nr;
+	return 0;
+}
+
 int __init early_irq_init(void)
 {
 	int i, initcnt, node = first_online_node;
@@ -217,6 +226,15 @@ int __init early_irq_init(void)
 	initcnt = arch_probe_nr_irqs();
 	printk(KERN_INFO "NR_IRQS:%d nr_irqs:%d %d\n", NR_IRQS, nr_irqs, initcnt);
 
+	if (WARN_ON(nr_irqs > IRQ_BITMAP_BITS))
+		nr_irqs = IRQ_BITMAP_BITS;
+
+	if (WARN_ON(initcnt > IRQ_BITMAP_BITS))
+		initcnt = IRQ_BITMAP_BITS;
+
+	if (initcnt > nr_irqs)
+		nr_irqs = initcnt;
+
 	for (i = 0; i < initcnt; i++) {
 		desc = alloc_desc(i, node);
 		set_bit(i, allocated_irqs);
@@ -229,7 +247,7 @@ int __init early_irq_init(void)
 
 struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
 	[0 ... NR_IRQS-1] = {
-		.status		= IRQ_DEFAULT_INIT_FLAGS,
+		.istate		= IRQS_DISABLED,
 		.handle_irq	= handle_bad_irq,
 		.depth		= 1,
 		.lock		= __RAW_SPIN_LOCK_UNLOCKED(irq_desc->lock),
@@ -251,8 +269,8 @@ int __init early_irq_init(void)
 	for (i = 0; i < count; i++) {
 		desc[i].irq_data.irq = i;
 		desc[i].irq_data.chip = &no_irq_chip;
-		/* TODO : do this allocation on-demand ... */
 		desc[i].kstat_irqs = alloc_percpu(unsigned int);
+		irq_settings_clr_and_set(desc, ~0, _IRQ_DEFAULT_INIT_FLAGS);
 		alloc_masks(desc + i, GFP_KERNEL, node);
 		desc_smp_init(desc + i, node);
 		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
@@ -277,24 +295,14 @@ static void free_desc(unsigned int irq)
 
 static inline int alloc_descs(unsigned int start, unsigned int cnt, int node)
 {
-#if defined(CONFIG_KSTAT_IRQS_ONDEMAND)
-	struct irq_desc *desc;
-	unsigned int i;
-
-	for (i = 0; i < cnt; i++) {
-		desc = irq_to_desc(start + i);
-		if (desc && !desc->kstat_irqs) {
-			unsigned int __percpu *stats = alloc_percpu(unsigned int);
-
-			if (!stats)
-				return -1;
-			if (cmpxchg(&desc->kstat_irqs, NULL, stats) != NULL)
-				free_percpu(stats);
-		}
-	}
-#endif
 	return start;
 }
+
+static int irq_expand_nr_irqs(unsigned int nr)
+{
+	return -ENOMEM;
+}
+
 #endif /* !CONFIG_SPARSE_IRQ */
 
 /* Dynamic interrupt handling */
@@ -338,14 +346,17 @@ irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node)
 
 	mutex_lock(&sparse_irq_lock);
 
-	start = bitmap_find_next_zero_area(allocated_irqs, nr_irqs, from, cnt, 0);
+	start = bitmap_find_next_zero_area(allocated_irqs, IRQ_BITMAP_BITS,
+					   from, cnt, 0);
 	ret = -EEXIST;
 	if (irq >=0 && start != irq)
 		goto err;
 
-	ret = -ENOMEM;
-	if (start >= nr_irqs)
-		goto err;
+	if (start + cnt > nr_irqs) {
+		ret = irq_expand_nr_irqs(start + cnt);
+		if (ret)
+			goto err;
+	}
 
 	bitmap_set(allocated_irqs, start, cnt);
 	mutex_unlock(&sparse_irq_lock);
@@ -392,6 +403,26 @@ unsigned int irq_get_next_irq(unsigned int offset)
 	return find_next_bit(allocated_irqs, nr_irqs, offset);
 }
 
+struct irq_desc *
+__irq_get_desc_lock(unsigned int irq, unsigned long *flags, bool bus)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	if (desc) {
+		if (bus)
+			chip_bus_lock(desc);
+		raw_spin_lock_irqsave(&desc->lock, *flags);
+	}
+	return desc;
+}
+
+void __irq_put_desc_unlock(struct irq_desc *desc, unsigned long flags, bool bus)
+{
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+	if (bus)
+		chip_bus_sync_unlock(desc);
+}
+
 /**
  * dynamic_irq_cleanup - cleanup a dynamically allocated irq
  * @irq:	irq number to initialize
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 0caa59f..acd599a 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -17,6 +17,17 @@
 
 #include "internals.h"
 
+#ifdef CONFIG_IRQ_FORCED_THREADING
+__read_mostly bool force_irqthreads;
+
+static int __init setup_forced_irqthreads(char *arg)
+{
+	force_irqthreads = true;
+	return 0;
+}
+early_param("threadirqs", setup_forced_irqthreads);
+#endif
+
 /**
  *	synchronize_irq - wait for pending IRQ handlers (on other CPUs)
  *	@irq: interrupt number to wait for
@@ -30,7 +41,7 @@
 void synchronize_irq(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
-	unsigned int status;
+	unsigned int state;
 
 	if (!desc)
 		return;
@@ -42,16 +53,16 @@ void synchronize_irq(unsigned int irq)
 		 * Wait until we're out of the critical section.  This might
 		 * give the wrong answer due to the lack of memory barriers.
 		 */
-		while (desc->status & IRQ_INPROGRESS)
+		while (desc->istate & IRQS_INPROGRESS)
 			cpu_relax();
 
 		/* Ok, that indicated we're done: double-check carefully. */
 		raw_spin_lock_irqsave(&desc->lock, flags);
-		status = desc->status;
+		state = desc->istate;
 		raw_spin_unlock_irqrestore(&desc->lock, flags);
 
 		/* Oops, that failed? */
-	} while (status & IRQ_INPROGRESS);
+	} while (state & IRQS_INPROGRESS);
 
 	/*
 	 * We made sure that no hardirq handler is running. Now verify
@@ -73,8 +84,8 @@ int irq_can_set_affinity(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 
-	if (CHECK_IRQ_PER_CPU(desc->status) || !desc->irq_data.chip ||
-	    !desc->irq_data.chip->irq_set_affinity)
+	if (!desc || !irqd_can_balance(&desc->irq_data) ||
+	    !desc->irq_data.chip || !desc->irq_data.chip->irq_set_affinity)
 		return 0;
 
 	return 1;
@@ -100,67 +111,169 @@ void irq_set_thread_affinity(struct irq_desc *desc)
 	}
 }
 
+#ifdef CONFIG_GENERIC_PENDING_IRQ
+static inline bool irq_can_move_pcntxt(struct irq_desc *desc)
+{
+	return irq_settings_can_move_pcntxt(desc);
+}
+static inline bool irq_move_pending(struct irq_desc *desc)
+{
+	return irqd_is_setaffinity_pending(&desc->irq_data);
+}
+static inline void
+irq_copy_pending(struct irq_desc *desc, const struct cpumask *mask)
+{
+	cpumask_copy(desc->pending_mask, mask);
+}
+static inline void
+irq_get_pending(struct cpumask *mask, struct irq_desc *desc)
+{
+	cpumask_copy(mask, desc->pending_mask);
+}
+#else
+static inline bool irq_can_move_pcntxt(struct irq_desc *desc) { return true; }
+static inline bool irq_move_pending(struct irq_desc *desc) { return false; }
+static inline void
+irq_copy_pending(struct irq_desc *desc, const struct cpumask *mask) { }
+static inline void
+irq_get_pending(struct cpumask *mask, struct irq_desc *desc) { }
+#endif
+
 /**
  *	irq_set_affinity - Set the irq affinity of a given irq
  *	@irq:		Interrupt to set affinity
  *	@cpumask:	cpumask
  *
  */
-int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask)
+int irq_set_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_chip *chip = desc->irq_data.chip;
 	unsigned long flags;
+	int ret = 0;
 
 	if (!chip->irq_set_affinity)
 		return -EINVAL;
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
 
-#ifdef CONFIG_GENERIC_PENDING_IRQ
-	if (desc->status & IRQ_MOVE_PCNTXT) {
-		if (!chip->irq_set_affinity(&desc->irq_data, cpumask, false)) {
-			cpumask_copy(desc->irq_data.affinity, cpumask);
+	if (irq_can_move_pcntxt(desc)) {
+		ret = chip->irq_set_affinity(&desc->irq_data, mask, false);
+		switch (ret) {
+		case IRQ_SET_MASK_OK:
+			cpumask_copy(desc->irq_data.affinity, mask);
+		case IRQ_SET_MASK_OK_NOCOPY:
 			irq_set_thread_affinity(desc);
+			ret = 0;
 		}
+	} else {
+		irqd_set_move_pending(&desc->irq_data);
+		irq_copy_pending(desc, mask);
 	}
-	else {
-		desc->status |= IRQ_MOVE_PENDING;
-		cpumask_copy(desc->pending_mask, cpumask);
-	}
-#else
-	if (!chip->irq_set_affinity(&desc->irq_data, cpumask, false)) {
-		cpumask_copy(desc->irq_data.affinity, cpumask);
-		irq_set_thread_affinity(desc);
+
+	if (desc->affinity_notify) {
+		kref_get(&desc->affinity_notify->kref);
+		schedule_work(&desc->affinity_notify->work);
 	}
-#endif
-	desc->status |= IRQ_AFFINITY_SET;
+	irq_compat_set_affinity(desc);
+	irqd_set(&desc->irq_data, IRQD_AFFINITY_SET);
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
-	return 0;
+	return ret;
 }
 
 int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
 {
+	unsigned long flags;
+	struct irq_desc *desc = irq_get_desc_lock(irq, &flags);
+
+	if (!desc)
+		return -EINVAL;
+	desc->affinity_hint = m;
+	irq_put_desc_unlock(desc, flags);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(irq_set_affinity_hint);
+
+static void irq_affinity_notify(struct work_struct *work)
+{
+	struct irq_affinity_notify *notify =
+		container_of(work, struct irq_affinity_notify, work);
+	struct irq_desc *desc = irq_to_desc(notify->irq);
+	cpumask_var_t cpumask;
+	unsigned long flags;
+
+	if (!desc || !alloc_cpumask_var(&cpumask, GFP_KERNEL))
+		goto out;
+
+	raw_spin_lock_irqsave(&desc->lock, flags);
+	if (irq_move_pending(desc))
+		irq_get_pending(cpumask, desc);
+	else
+		cpumask_copy(cpumask, desc->irq_data.affinity);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+
+	notify->notify(notify, cpumask);
+
+	free_cpumask_var(cpumask);
+out:
+	kref_put(&notify->kref, notify->release);
+}
+
+/**
+ *	irq_set_affinity_notifier - control notification of IRQ affinity changes
+ *	@irq:		Interrupt for which to enable/disable notification
+ *	@notify:	Context for notification, or %NULL to disable
+ *			notification.  Function pointers must be initialised;
+ *			the other fields will be initialised by this function.
+ *
+ *	Must be called in process context.  Notification may only be enabled
+ *	after the IRQ is allocated and must be disabled before the IRQ is
+ *	freed using free_irq().
+ */
+int
+irq_set_affinity_notifier(unsigned int irq, struct irq_affinity_notify *notify)
+{
 	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_affinity_notify *old_notify;
 	unsigned long flags;
 
+	/* The release function is promised process context */
+	might_sleep();
+
 	if (!desc)
 		return -EINVAL;
 
+	/* Complete initialisation of *notify */
+	if (notify) {
+		notify->irq = irq;
+		kref_init(&notify->kref);
+		INIT_WORK(&notify->work, irq_affinity_notify);
+	}
+
 	raw_spin_lock_irqsave(&desc->lock, flags);
-	desc->affinity_hint = m;
+	old_notify = desc->affinity_notify;
+	desc->affinity_notify = notify;
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 
+	if (old_notify)
+		kref_put(&old_notify->kref, old_notify->release);
+
 	return 0;
 }
-EXPORT_SYMBOL_GPL(irq_set_affinity_hint);
+EXPORT_SYMBOL_GPL(irq_set_affinity_notifier);
 
 #ifndef CONFIG_AUTO_IRQ_AFFINITY
 /*
  * Generic version of the affinity autoselector.
  */
-static int setup_affinity(unsigned int irq, struct irq_desc *desc)
+static int
+setup_affinity(unsigned int irq, struct irq_desc *desc, struct cpumask *mask)
 {
+	struct irq_chip *chip = irq_desc_get_chip(desc);
+	struct cpumask *set = irq_default_affinity;
+	int ret;
+
+	/* Excludes PER_CPU and NO_BALANCE interrupts */
 	if (!irq_can_set_affinity(irq))
 		return 0;
 
@@ -168,22 +281,29 @@ static int setup_affinity(unsigned int irq, struct irq_desc *desc)
 	 * Preserve an userspace affinity setup, but make sure that
 	 * one of the targets is online.
 	 */
-	if (desc->status & (IRQ_AFFINITY_SET | IRQ_NO_BALANCING)) {
-		if (cpumask_any_and(desc->irq_data.affinity, cpu_online_mask)
-		    < nr_cpu_ids)
-			goto set_affinity;
-		else
-			desc->status &= ~IRQ_AFFINITY_SET;
+	if (irqd_has_set(&desc->irq_data, IRQD_AFFINITY_SET)) {
+		if (cpumask_intersects(desc->irq_data.affinity,
+				       cpu_online_mask))
+			set = desc->irq_data.affinity;
+		else {
+			irq_compat_clr_affinity(desc);
+			irqd_clear(&desc->irq_data, IRQD_AFFINITY_SET);
+		}
 	}
 
-	cpumask_and(desc->irq_data.affinity, cpu_online_mask, irq_default_affinity);
-set_affinity:
-	desc->irq_data.chip->irq_set_affinity(&desc->irq_data, desc->irq_data.affinity, false);
-
+	cpumask_and(mask, cpu_online_mask, set);
+	ret = chip->irq_set_affinity(&desc->irq_data, mask, false);
+	switch (ret) {
+	case IRQ_SET_MASK_OK:
+		cpumask_copy(desc->irq_data.affinity, mask);
+	case IRQ_SET_MASK_OK_NOCOPY:
+		irq_set_thread_affinity(desc);
+	}
 	return 0;
 }
 #else
-static inline int setup_affinity(unsigned int irq, struct irq_desc *d)
+static inline int
+setup_affinity(unsigned int irq, struct irq_desc *d, struct cpumask *mask)
 {
 	return irq_select_affinity(irq);
 }
@@ -192,23 +312,21 @@ static inline int setup_affinity(unsigned int irq, struct irq_desc *d)
 /*
  * Called when affinity is set via /proc/irq
  */
-int irq_select_affinity_usr(unsigned int irq)
+int irq_select_affinity_usr(unsigned int irq, struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
 	int ret;
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
-	ret = setup_affinity(irq, desc);
-	if (!ret)
-		irq_set_thread_affinity(desc);
+	ret = setup_affinity(irq, desc, mask);
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
-
 	return ret;
 }
 
 #else
-static inline int setup_affinity(unsigned int irq, struct irq_desc *desc)
+static inline int
+setup_affinity(unsigned int irq, struct irq_desc *desc, struct cpumask *mask)
 {
 	return 0;
 }
@@ -219,13 +337,23 @@ void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
 	if (suspend) {
 		if (!desc->action || (desc->action->flags & IRQF_NO_SUSPEND))
 			return;
-		desc->status |= IRQ_SUSPENDED;
+		desc->istate |= IRQS_SUSPENDED;
 	}
 
-	if (!desc->depth++) {
-		desc->status |= IRQ_DISABLED;
-		desc->irq_data.chip->irq_disable(&desc->irq_data);
-	}
+	if (!desc->depth++)
+		irq_disable(desc);
+}
+
+static int __disable_irq_nosync(unsigned int irq)
+{
+	unsigned long flags;
+	struct irq_desc *desc = irq_get_desc_buslock(irq, &flags);
+
+	if (!desc)
+		return -EINVAL;
+	__disable_irq(desc, irq, false);
+	irq_put_desc_busunlock(desc, flags);
+	return 0;
 }
 
 /**
@@ -241,17 +369,7 @@ void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
  */
 void disable_irq_nosync(unsigned int irq)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-	unsigned long flags;
-
-	if (!desc)
-		return;
-
-	chip_bus_lock(desc);
-	raw_spin_lock_irqsave(&desc->lock, flags);
-	__disable_irq(desc, irq, false);
-	raw_spin_unlock_irqrestore(&desc->lock, flags);
-	chip_bus_sync_unlock(desc);
+	__disable_irq_nosync(irq);
 }
 EXPORT_SYMBOL(disable_irq_nosync);
 
@@ -269,21 +387,24 @@ EXPORT_SYMBOL(disable_irq_nosync);
  */
 void disable_irq(unsigned int irq)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
-	if (!desc)
-		return;
-
-	disable_irq_nosync(irq);
-	if (desc->action)
+	if (!__disable_irq_nosync(irq))
 		synchronize_irq(irq);
 }
 EXPORT_SYMBOL(disable_irq);
 
 void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume)
 {
-	if (resume)
-		desc->status &= ~IRQ_SUSPENDED;
+	if (resume) {
+		if (!(desc->istate & IRQS_SUSPENDED)) {
+			if (!desc->action)
+				return;
+			if (!(desc->action->flags & IRQF_FORCE_RESUME))
+				return;
+			/* Pretend that it got disabled ! */
+			desc->depth++;
+		}
+		desc->istate &= ~IRQS_SUSPENDED;
+	}
 
 	switch (desc->depth) {
 	case 0:
@@ -291,12 +412,11 @@ void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume)
 		WARN(1, KERN_WARNING "Unbalanced enable for IRQ %d\n", irq);
 		break;
 	case 1: {
-		unsigned int status = desc->status & ~IRQ_DISABLED;
-
-		if (desc->status & IRQ_SUSPENDED)
+		if (desc->istate & IRQS_SUSPENDED)
 			goto err_out;
 		/* Prevent probing on this irq: */
-		desc->status = status | IRQ_NOPROBE;
+		irq_settings_set_noprobe(desc);
+		irq_enable(desc);
 		check_irq_resend(desc, irq);
 		/* fall-through */
 	}
@@ -318,21 +438,18 @@ void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume)
  */
 void enable_irq(unsigned int irq)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
+	struct irq_desc *desc = irq_get_desc_buslock(irq, &flags);
 
 	if (!desc)
 		return;
+	if (WARN(!desc->irq_data.chip,
+		 KERN_ERR "enable_irq before setup/request_irq: irq %u\n", irq))
+		goto out;
 
-	if (WARN(!desc->irq_data.chip || !desc->irq_data.chip->irq_enable,
-	    KERN_ERR "enable_irq before setup/request_irq: irq %u\n", irq))
-		return;
-
-	chip_bus_lock(desc);
-	raw_spin_lock_irqsave(&desc->lock, flags);
 	__enable_irq(desc, irq, false);
-	raw_spin_unlock_irqrestore(&desc->lock, flags);
-	chip_bus_sync_unlock(desc);
+out:
+	irq_put_desc_busunlock(desc, flags);
 }
 EXPORT_SYMBOL(enable_irq);
 
@@ -348,7 +465,7 @@ static int set_irq_wake_real(unsigned int irq, unsigned int on)
 }
 
 /**
- *	set_irq_wake - control irq power management wakeup
+ *	irq_set_irq_wake - control irq power management wakeup
  *	@irq:	interrupt to control
  *	@on:	enable/disable power management wakeup
  *
@@ -359,23 +476,22 @@ static int set_irq_wake_real(unsigned int irq, unsigned int on)
  *	Wakeup mode lets this IRQ wake the system from sleep
  *	states like "suspend to RAM".
  */
-int set_irq_wake(unsigned int irq, unsigned int on)
+int irq_set_irq_wake(unsigned int irq, unsigned int on)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
+	struct irq_desc *desc = irq_get_desc_buslock(irq, &flags);
 	int ret = 0;
 
 	/* wakeup-capable irqs can be shared between drivers that
 	 * don't need to have the same sleep mode behaviors.
 	 */
-	raw_spin_lock_irqsave(&desc->lock, flags);
 	if (on) {
 		if (desc->wake_depth++ == 0) {
 			ret = set_irq_wake_real(irq, on);
 			if (ret)
 				desc->wake_depth = 0;
 			else
-				desc->status |= IRQ_WAKEUP;
+				irqd_set(&desc->irq_data, IRQD_WAKEUP_STATE);
 		}
 	} else {
 		if (desc->wake_depth == 0) {
@@ -385,14 +501,13 @@ int set_irq_wake(unsigned int irq, unsigned int on)
 			if (ret)
 				desc->wake_depth = 1;
 			else
-				desc->status &= ~IRQ_WAKEUP;
+				irqd_clear(&desc->irq_data, IRQD_WAKEUP_STATE);
 		}
 	}
-
-	raw_spin_unlock_irqrestore(&desc->lock, flags);
+	irq_put_desc_busunlock(desc, flags);
 	return ret;
 }
-EXPORT_SYMBOL(set_irq_wake);
+EXPORT_SYMBOL(irq_set_irq_wake);
 
 /*
  * Internal function that tells the architecture code whether a
@@ -401,43 +516,27 @@ EXPORT_SYMBOL(set_irq_wake);
  */
 int can_request_irq(unsigned int irq, unsigned long irqflags)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-	struct irqaction *action;
 	unsigned long flags;
+	struct irq_desc *desc = irq_get_desc_lock(irq, &flags);
+	int canrequest = 0;
 
 	if (!desc)
 		return 0;
 
-	if (desc->status & IRQ_NOREQUEST)
-		return 0;
-
-	raw_spin_lock_irqsave(&desc->lock, flags);
-	action = desc->action;
-	if (action)
-		if (irqflags & action->flags & IRQF_SHARED)
-			action = NULL;
-
-	raw_spin_unlock_irqrestore(&desc->lock, flags);
-
-	return !action;
-}
-
-void compat_irq_chip_set_default_handler(struct irq_desc *desc)
-{
-	/*
-	 * If the architecture still has not overriden
-	 * the flow handler then zap the default. This
-	 * should catch incorrect flow-type setting.
-	 */
-	if (desc->handle_irq == &handle_bad_irq)
-		desc->handle_irq = NULL;
+	if (irq_settings_can_request(desc)) {
+		if (desc->action)
+			if (irqflags & desc->action->flags & IRQF_SHARED)
+				canrequest =1;
+	}
+	irq_put_desc_unlock(desc, flags);
+	return canrequest;
 }
 
 int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 		      unsigned long flags)
 {
-	int ret;
 	struct irq_chip *chip = desc->irq_data.chip;
+	int ret, unmask = 0;
 
 	if (!chip || !chip->irq_set_type) {
 		/*
@@ -449,23 +548,43 @@ int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 		return 0;
 	}
 
+	flags &= IRQ_TYPE_SENSE_MASK;
+
+	if (chip->flags & IRQCHIP_SET_TYPE_MASKED) {
+		if (!(desc->istate & IRQS_MASKED))
+			mask_irq(desc);
+		if (!(desc->istate & IRQS_DISABLED))
+			unmask = 1;
+	}
+
 	/* caller masked out all except trigger mode flags */
 	ret = chip->irq_set_type(&desc->irq_data, flags);
 
-	if (ret)
-		pr_err("setting trigger mode %lu for irq %u failed (%pF)\n",
-		       flags, irq, chip->irq_set_type);
-	else {
-		if (flags & (IRQ_TYPE_LEVEL_LOW | IRQ_TYPE_LEVEL_HIGH))
-			flags |= IRQ_LEVEL;
-		/* note that IRQF_TRIGGER_MASK == IRQ_TYPE_SENSE_MASK */
-		desc->status &= ~(IRQ_LEVEL | IRQ_TYPE_SENSE_MASK);
-		desc->status |= flags;
+	switch (ret) {
+	case IRQ_SET_MASK_OK:
+		irqd_clear(&desc->irq_data, IRQD_TRIGGER_MASK);
+		irqd_set(&desc->irq_data, flags);
+
+	case IRQ_SET_MASK_OK_NOCOPY:
+		flags = irqd_get_trigger_type(&desc->irq_data);
+		irq_settings_set_trigger_mask(desc, flags);
+		irqd_clear(&desc->irq_data, IRQD_LEVEL);
+		irq_settings_clr_level(desc);
+		if (flags & IRQ_TYPE_LEVEL_MASK) {
+			irq_settings_set_level(desc);
+			irqd_set(&desc->irq_data, IRQD_LEVEL);
+		}
 
 		if (chip != desc->irq_data.chip)
 			irq_chip_set_defaults(desc->irq_data.chip);
+		ret = 0;
+		break;
+	default:
+		pr_err("setting trigger mode %lu for irq %u failed (%pF)\n",
+		       flags, irq, chip->irq_set_type);
 	}
-
+	if (unmask)
+		unmask_irq(desc);
 	return ret;
 }
 
@@ -509,8 +628,11 @@ static int irq_wait_for_interrupt(struct irqaction *action)
  * handler finished. unmask if the interrupt has not been disabled and
  * is marked MASKED.
  */
-static void irq_finalize_oneshot(unsigned int irq, struct irq_desc *desc)
+static void irq_finalize_oneshot(struct irq_desc *desc,
+				 struct irqaction *action, bool force)
 {
+	if (!(desc->istate & IRQS_ONESHOT))
+		return;
 again:
 	chip_bus_lock(desc);
 	raw_spin_lock_irq(&desc->lock);
@@ -522,26 +644,44 @@ again:
 	 * The thread is faster done than the hard interrupt handler
 	 * on the other CPU. If we unmask the irq line then the
 	 * interrupt can come in again and masks the line, leaves due
-	 * to IRQ_INPROGRESS and the irq line is masked forever.
+	 * to IRQS_INPROGRESS and the irq line is masked forever.
+	 *
+	 * This also serializes the state of shared oneshot handlers
+	 * versus "desc->threads_onehsot |= action->thread_mask;" in
+	 * irq_wake_thread(). See the comment there which explains the
+	 * serialization.
 	 */
-	if (unlikely(desc->status & IRQ_INPROGRESS)) {
+	if (unlikely(desc->istate & IRQS_INPROGRESS)) {
 		raw_spin_unlock_irq(&desc->lock);
 		chip_bus_sync_unlock(desc);
 		cpu_relax();
 		goto again;
 	}
 
-	if (!(desc->status & IRQ_DISABLED) && (desc->status & IRQ_MASKED)) {
-		desc->status &= ~IRQ_MASKED;
+	/*
+	 * Now check again, whether the thread should run. Otherwise
+	 * we would clear the threads_oneshot bit of this thread which
+	 * was just set.
+	 */
+	if (!force && test_bit(IRQTF_RUNTHREAD, &action->thread_flags))
+		goto out_unlock;
+
+	desc->threads_oneshot &= ~action->thread_mask;
+
+	if (!desc->threads_oneshot && !(desc->istate & IRQS_DISABLED) &&
+	    (desc->istate & IRQS_MASKED)) {
+		irq_compat_clr_masked(desc);
+		desc->istate &= ~IRQS_MASKED;
 		desc->irq_data.chip->irq_unmask(&desc->irq_data);
 	}
+out_unlock:
 	raw_spin_unlock_irq(&desc->lock);
 	chip_bus_sync_unlock(desc);
 }
 
 #ifdef CONFIG_SMP
 /*
- * Check whether we need to change the affinity of the interrupt thread.
+ * Check whether we need to chasnge the affinity of the interrupt thread.
  */
 static void
 irq_thread_check_affinity(struct irq_desc *desc, struct irqaction *action)
@@ -573,6 +713,32 @@ irq_thread_check_affinity(struct irq_desc *desc, struct irqaction *action) { }
 #endif
 
 /*
+ * Interrupts which are not explicitely requested as threaded
+ * interrupts rely on the implicit bh/preempt disable of the hard irq
+ * context. So we need to disable bh here to avoid deadlocks and other
+ * side effects.
+ */
+static void
+irq_forced_thread_fn(struct irq_desc *desc, struct irqaction *action)
+{
+	local_bh_disable();
+	action->thread_fn(action->irq, action->dev_id);
+	irq_finalize_oneshot(desc, action, false);
+	local_bh_enable();
+}
+
+/*
+ * Interrupts explicitely requested as threaded interupts want to be
+ * preemtible - many of them need to sleep and wait for slow busses to
+ * complete.
+ */
+static void irq_thread_fn(struct irq_desc *desc, struct irqaction *action)
+{
+	action->thread_fn(action->irq, action->dev_id);
+	irq_finalize_oneshot(desc, action, false);
+}
+
+/*
  * Interrupt handler thread
  */
 static int irq_thread(void *data)
@@ -582,7 +748,14 @@ static int irq_thread(void *data)
 	};
 	struct irqaction *action = data;
 	struct irq_desc *desc = irq_to_desc(action->irq);
-	int wake, oneshot = desc->status & IRQ_ONESHOT;
+	void (*handler_fn)(struct irq_desc *desc, struct irqaction *action);
+	int wake;
+
+	if (force_irqthreads & test_bit(IRQTF_FORCED_THREAD,
+					&action->thread_flags))
+		handler_fn = irq_forced_thread_fn;
+	else
+		handler_fn = irq_thread_fn;
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
 	current->irqaction = action;
@@ -594,23 +767,20 @@ static int irq_thread(void *data)
 		atomic_inc(&desc->threads_active);
 
 		raw_spin_lock_irq(&desc->lock);
-		if (unlikely(desc->status & IRQ_DISABLED)) {
+		if (unlikely(desc->istate & IRQS_DISABLED)) {
 			/*
 			 * CHECKME: We might need a dedicated
 			 * IRQ_THREAD_PENDING flag here, which
 			 * retriggers the thread in check_irq_resend()
-			 * but AFAICT IRQ_PENDING should be fine as it
+			 * but AFAICT IRQS_PENDING should be fine as it
 			 * retriggers the interrupt itself --- tglx
 			 */
-			desc->status |= IRQ_PENDING;
+			irq_compat_set_pending(desc);
+			desc->istate |= IRQS_PENDING;
 			raw_spin_unlock_irq(&desc->lock);
 		} else {
 			raw_spin_unlock_irq(&desc->lock);
-
-			action->thread_fn(action->irq, action->dev_id);
-
-			if (oneshot)
-				irq_finalize_oneshot(action->irq, desc);
+			handler_fn(desc, action);
 		}
 
 		wake = atomic_dec_and_test(&desc->threads_active);
@@ -619,6 +789,9 @@ static int irq_thread(void *data)
 			wake_up(&desc->wait_for_threads);
 	}
 
+	/* Prevent a stale desc->threads_oneshot */
+	irq_finalize_oneshot(desc, action, true);
+
 	/*
 	 * Clear irqaction. Otherwise exit_irq_thread() would make
 	 * fuzz about an active irq thread going into nirvana.
@@ -633,6 +806,7 @@ static int irq_thread(void *data)
 void exit_irq_thread(void)
 {
 	struct task_struct *tsk = current;
+	struct irq_desc *desc;
 
 	if (!tsk->irqaction)
 		return;
@@ -641,6 +815,14 @@ void exit_irq_thread(void)
 	       "exiting task \"%s\" (%d) is an active IRQ thread (irq %d)\n",
 	       tsk->comm ? tsk->comm : "", tsk->pid, tsk->irqaction->irq);
 
+	desc = irq_to_desc(tsk->irqaction->irq);
+
+	/*
+	 * Prevent a stale desc->threads_oneshot. Must be called
+	 * before setting the IRQTF_DIED flag.
+	 */
+	irq_finalize_oneshot(desc, tsk->irqaction, true);
+
 	/*
 	 * Set the THREAD DIED flag to prevent further wakeups of the
 	 * soon to be gone threaded handler.
@@ -648,6 +830,22 @@ void exit_irq_thread(void)
 	set_bit(IRQTF_DIED, &tsk->irqaction->flags);
 }
 
+static void irq_setup_forced_threading(struct irqaction *new)
+{
+	if (!force_irqthreads)
+		return;
+	if (new->flags & (IRQF_NO_THREAD | IRQF_PERCPU | IRQF_ONESHOT))
+		return;
+
+	new->flags |= IRQF_ONESHOT;
+
+	if (!new->thread_fn) {
+		set_bit(IRQTF_FORCED_THREAD, &new->thread_flags);
+		new->thread_fn = new->handler;
+		new->handler = irq_default_primary_handler;
+	}
+}
+
 /*
  * Internal function to register an irqaction - typically used to
  * allocate special interrupts that are part of the architecture.
@@ -657,9 +855,9 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 {
 	struct irqaction *old, **old_ptr;
 	const char *old_name = NULL;
-	unsigned long flags;
-	int nested, shared = 0;
-	int ret;
+	unsigned long flags, thread_mask = 0;
+	int ret, nested, shared = 0;
+	cpumask_var_t mask;
 
 	if (!desc)
 		return -EINVAL;
@@ -683,15 +881,11 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		rand_initialize_irq(irq);
 	}
 
-	/* Oneshot interrupts are not allowed with shared */
-	if ((new->flags & IRQF_ONESHOT) && (new->flags & IRQF_SHARED))
-		return -EINVAL;
-
 	/*
 	 * Check whether the interrupt nests into another interrupt
 	 * thread.
 	 */
-	nested = desc->status & IRQ_NESTED_THREAD;
+	nested = irq_settings_is_nested_thread(desc);
 	if (nested) {
 		if (!new->thread_fn)
 			return -EINVAL;
@@ -701,6 +895,8 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		 * dummy function which warns when called.
 		 */
 		new->handler = irq_nested_primary_handler;
+	} else {
+		irq_setup_forced_threading(new);
 	}
 
 	/*
@@ -724,6 +920,11 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		new->thread = t;
 	}
 
+	if (!alloc_cpumask_var(&mask, GFP_KERNEL)) {
+		ret = -ENOMEM;
+		goto out_thread;
+	}
+
 	/*
 	 * The following block of code has to be executed atomically
 	 */
@@ -735,29 +936,40 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		 * Can't share interrupts unless both agree to and are
 		 * the same type (level, edge, polarity). So both flag
 		 * fields must have IRQF_SHARED set and the bits which
-		 * set the trigger type must match.
+		 * set the trigger type must match. Also all must
+		 * agree on ONESHOT.
 		 */
 		if (!((old->flags & new->flags) & IRQF_SHARED) ||
-		    ((old->flags ^ new->flags) & IRQF_TRIGGER_MASK)) {
+		    ((old->flags ^ new->flags) & IRQF_TRIGGER_MASK) ||
+		    ((old->flags ^ new->flags) & IRQF_ONESHOT)) {
 			old_name = old->name;
 			goto mismatch;
 		}
 
-#if defined(CONFIG_IRQ_PER_CPU)
 		/* All handlers must agree on per-cpuness */
 		if ((old->flags & IRQF_PERCPU) !=
 		    (new->flags & IRQF_PERCPU))
 			goto mismatch;
-#endif
 
 		/* add new interrupt at end of irq queue */
 		do {
+			thread_mask |= old->thread_mask;
 			old_ptr = &old->next;
 			old = *old_ptr;
 		} while (old);
 		shared = 1;
 	}
 
+	/*
+	 * Setup the thread mask for this irqaction. Unlikely to have
+	 * 32 resp 64 irqs sharing one line, but who knows.
+	 */
+	if (new->flags & IRQF_ONESHOT && thread_mask == ~0UL) {
+		ret = -EBUSY;
+		goto out_mask;
+	}
+	new->thread_mask = 1 << ffz(thread_mask);
+
 	if (!shared) {
 		irq_chip_set_defaults(desc->irq_data.chip);
 
@@ -769,42 +981,44 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 					new->flags & IRQF_TRIGGER_MASK);
 
 			if (ret)
-				goto out_thread;
-		} else
-			compat_irq_chip_set_default_handler(desc);
-#if defined(CONFIG_IRQ_PER_CPU)
-		if (new->flags & IRQF_PERCPU)
-			desc->status |= IRQ_PER_CPU;
-#endif
+				goto out_mask;
+		}
 
-		desc->status &= ~(IRQ_AUTODETECT | IRQ_WAITING | IRQ_ONESHOT |
-				  IRQ_INPROGRESS | IRQ_SPURIOUS_DISABLED);
+		desc->istate &= ~(IRQS_AUTODETECT | IRQS_SPURIOUS_DISABLED | \
+				  IRQS_INPROGRESS | IRQS_ONESHOT | \
+				  IRQS_WAITING);
+
+		if (new->flags & IRQF_PERCPU) {
+			irqd_set(&desc->irq_data, IRQD_PER_CPU);
+			irq_settings_set_per_cpu(desc);
+		}
 
 		if (new->flags & IRQF_ONESHOT)
-			desc->status |= IRQ_ONESHOT;
+			desc->istate |= IRQS_ONESHOT;
 
-		if (!(desc->status & IRQ_NOAUTOEN)) {
-			desc->depth = 0;
-			desc->status &= ~IRQ_DISABLED;
-			desc->irq_data.chip->irq_startup(&desc->irq_data);
-		} else
+		if (irq_settings_can_autoenable(desc))
+			irq_startup(desc);
+		else
 			/* Undo nested disables: */
 			desc->depth = 1;
 
 		/* Exclude IRQ from balancing if requested */
-		if (new->flags & IRQF_NOBALANCING)
-			desc->status |= IRQ_NO_BALANCING;
+		if (new->flags & IRQF_NOBALANCING) {
+			irq_settings_set_no_balancing(desc);
+			irqd_set(&desc->irq_data, IRQD_NO_BALANCING);
+		}
 
 		/* Set default affinity mask once everything is setup */
-		setup_affinity(irq, desc);
-
-	} else if ((new->flags & IRQF_TRIGGER_MASK)
-			&& (new->flags & IRQF_TRIGGER_MASK)
-				!= (desc->status & IRQ_TYPE_SENSE_MASK)) {
-		/* hope the handler works with the actual trigger mode... */
-		pr_warning("IRQ %d uses trigger mode %d; requested %d\n",
-				irq, (int)(desc->status & IRQ_TYPE_SENSE_MASK),
-				(int)(new->flags & IRQF_TRIGGER_MASK));
+		setup_affinity(irq, desc, mask);
+
+	} else if (new->flags & IRQF_TRIGGER_MASK) {
+		unsigned int nmsk = new->flags & IRQF_TRIGGER_MASK;
+		unsigned int omsk = irq_settings_get_trigger_mask(desc);
+
+		if (nmsk != omsk)
+			/* hope the handler works with current  trigger mode */
+			pr_warning("IRQ %d uses trigger mode %u; requested %u\n",
+				   irq, nmsk, omsk);
 	}
 
 	new->irq = irq;
@@ -818,8 +1032,8 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 	 * Check whether we disabled the irq via the spurious handler
 	 * before. Reenable it and give it another chance.
 	 */
-	if (shared && (desc->status & IRQ_SPURIOUS_DISABLED)) {
-		desc->status &= ~IRQ_SPURIOUS_DISABLED;
+	if (shared && (desc->istate & IRQS_SPURIOUS_DISABLED)) {
+		desc->istate &= ~IRQS_SPURIOUS_DISABLED;
 		__enable_irq(desc, irq, false);
 	}
 
@@ -849,6 +1063,9 @@ mismatch:
 #endif
 	ret = -EBUSY;
 
+out_mask:
+	free_cpumask_var(mask);
+
 out_thread:
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	if (new->thread) {
@@ -871,9 +1088,14 @@ out_thread:
  */
 int setup_irq(unsigned int irq, struct irqaction *act)
 {
+	int retval;
 	struct irq_desc *desc = irq_to_desc(irq);
 
-	return __setup_irq(irq, desc, act);
+	chip_bus_lock(desc);
+	retval = __setup_irq(irq, desc, act);
+	chip_bus_sync_unlock(desc);
+
+	return retval;
 }
 EXPORT_SYMBOL_GPL(setup_irq);
 
@@ -924,13 +1146,8 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 #endif
 
 	/* If this was the last handler, shut down the IRQ line: */
-	if (!desc->action) {
-		desc->status |= IRQ_DISABLED;
-		if (desc->irq_data.chip->irq_shutdown)
-			desc->irq_data.chip->irq_shutdown(&desc->irq_data);
-		else
-			desc->irq_data.chip->irq_disable(&desc->irq_data);
-	}
+	if (!desc->action)
+		irq_shutdown(desc);
 
 #ifdef CONFIG_SMP
 	/* make sure affinity_hint is cleaned up */
@@ -1004,6 +1221,11 @@ void free_irq(unsigned int irq, void *dev_id)
 	if (!desc)
 		return;
 
+#ifdef CONFIG_SMP
+	if (WARN_ON(desc->affinity_notify))
+		desc->affinity_notify = NULL;
+#endif
+
 	chip_bus_lock(desc);
 	kfree(__free_irq(irq, dev_id));
 	chip_bus_sync_unlock(desc);
@@ -1074,7 +1296,7 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
 	if (!desc)
 		return -EINVAL;
 
-	if (desc->status & IRQ_NOREQUEST)
+	if (!irq_settings_can_request(desc))
 		return -EINVAL;
 
 	if (!handler) {
@@ -1100,7 +1322,7 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
 	if (retval)
 		kfree(action);
 
-#ifdef CONFIG_DEBUG_SHIRQ
+#ifdef CONFIG_DEBUG_SHIRQ_FIXME
 	if (!retval && (irqflags & IRQF_SHARED)) {
 		/*
 		 * It's a shared IRQ -- the driver ought to be prepared for it
@@ -1149,7 +1371,7 @@ int request_any_context_irq(unsigned int irq, irq_handler_t handler,
 	if (!desc)
 		return -EINVAL;
 
-	if (desc->status & IRQ_NESTED_THREAD) {
+	if (irq_settings_is_nested_thread(desc)) {
 		ret = request_threaded_irq(irq, NULL, handler,
 					   flags, name, dev_id);
 		return !ret ? IRQC_IS_NESTED : ret;
diff --git a/kernel/irq/migration.c b/kernel/irq/migration.c
index 441fd62..ec4806d 100644
--- a/kernel/irq/migration.c
+++ b/kernel/irq/migration.c
@@ -4,23 +4,23 @@
 
 #include "internals.h"
 
-void move_masked_irq(int irq)
+void irq_move_masked_irq(struct irq_data *idata)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-	struct irq_chip *chip = desc->irq_data.chip;
+	struct irq_desc *desc = irq_data_to_desc(idata);
+	struct irq_chip *chip = idata->chip;
 
-	if (likely(!(desc->status & IRQ_MOVE_PENDING)))
+	if (likely(!irqd_is_setaffinity_pending(&desc->irq_data)))
 		return;
 
 	/*
 	 * Paranoia: cpu-local interrupts shouldn't be calling in here anyway.
 	 */
-	if (CHECK_IRQ_PER_CPU(desc->status)) {
+	if (!irqd_can_balance(&desc->irq_data)) {
 		WARN_ON(1);
 		return;
 	}
 
-	desc->status &= ~IRQ_MOVE_PENDING;
+	irqd_clr_move_pending(&desc->irq_data);
 
 	if (unlikely(cpumask_empty(desc->pending_mask)))
 		return;
@@ -53,15 +53,20 @@ void move_masked_irq(int irq)
 	cpumask_clear(desc->pending_mask);
 }
 
-void move_native_irq(int irq)
+void move_masked_irq(int irq)
+{
+	irq_move_masked_irq(irq_get_irq_data(irq));
+}
+
+void irq_move_irq(struct irq_data *idata)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_desc *desc = irq_data_to_desc(idata);
 	bool masked;
 
-	if (likely(!(desc->status & IRQ_MOVE_PENDING)))
+	if (likely(!irqd_is_setaffinity_pending(idata)))
 		return;
 
-	if (unlikely(desc->status & IRQ_DISABLED))
+	if (unlikely(desc->istate & IRQS_DISABLED))
 		return;
 
 	/*
@@ -69,10 +74,15 @@ void move_native_irq(int irq)
 	 * threaded interrupt with ONESHOT set, we can end up with an
 	 * interrupt storm.
 	 */
-	masked = desc->status & IRQ_MASKED;
+	masked = desc->istate & IRQS_MASKED;
 	if (!masked)
-		desc->irq_data.chip->irq_mask(&desc->irq_data);
-	move_masked_irq(irq);
+		idata->chip->irq_mask(idata);
+	irq_move_masked_irq(idata);
 	if (!masked)
-		desc->irq_data.chip->irq_unmask(&desc->irq_data);
+		idata->chip->irq_unmask(idata);
+}
+
+void move_native_irq(int irq)
+{
+	irq_move_irq(irq_get_irq_data(irq));
 }
diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
index 0d4005d8..f76fc00 100644
--- a/kernel/irq/pm.c
+++ b/kernel/irq/pm.c
@@ -18,7 +18,7 @@
  * During system-wide suspend or hibernation device drivers need to be prevented
  * from receiving interrupts and this function is provided for this purpose.
  * It marks all interrupt lines in use, except for the timer ones, as disabled
- * and sets the IRQ_SUSPENDED flag for each of them.
+ * and sets the IRQS_SUSPENDED flag for each of them.
  */
 void suspend_device_irqs(void)
 {
@@ -34,7 +34,7 @@ void suspend_device_irqs(void)
 	}
 
 	for_each_irq_desc(irq, desc)
-		if (desc->status & IRQ_SUSPENDED)
+		if (desc->istate & IRQS_SUSPENDED)
 			synchronize_irq(irq);
 }
 EXPORT_SYMBOL_GPL(suspend_device_irqs);
@@ -43,7 +43,7 @@ EXPORT_SYMBOL_GPL(suspend_device_irqs);
  * resume_device_irqs - enable interrupt lines disabled by suspend_device_irqs()
  *
  * Enable all interrupt lines previously disabled by suspend_device_irqs() that
- * have the IRQ_SUSPENDED flag set.
+ * have the IRQS_SUSPENDED flag set.
  */
 void resume_device_irqs(void)
 {
@@ -53,9 +53,6 @@ void resume_device_irqs(void)
 	for_each_irq_desc(irq, desc) {
 		unsigned long flags;
 
-		if (!(desc->status & IRQ_SUSPENDED))
-			continue;
-
 		raw_spin_lock_irqsave(&desc->lock, flags);
 		__enable_irq(desc, irq, true);
 		raw_spin_unlock_irqrestore(&desc->lock, flags);
@@ -71,9 +68,24 @@ int check_wakeup_irqs(void)
 	struct irq_desc *desc;
 	int irq;
 
-	for_each_irq_desc(irq, desc)
-		if ((desc->status & IRQ_WAKEUP) && (desc->status & IRQ_PENDING))
-			return -EBUSY;
+	for_each_irq_desc(irq, desc) {
+		if (irqd_is_wakeup_set(&desc->irq_data)) {
+			if (desc->istate & IRQS_PENDING)
+				return -EBUSY;
+			continue;
+		}
+		/*
+		 * Check the non wakeup interrupts whether they need
+		 * to be masked before finally going into suspend
+		 * state. That's for hardware which has no wakeup
+		 * source configuration facility. The chip
+		 * implementation indicates that with
+		 * IRQCHIP_MASK_ON_SUSPEND.
+		 */
+		if (desc->istate & IRQS_SUSPENDED &&
+		    irq_desc_get_chip(desc)->flags & IRQCHIP_MASK_ON_SUSPEND)
+			mask_irq(desc);
+	}
 
 	return 0;
 }
diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 6c8a2a9..4cc2e5e 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -11,6 +11,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/interrupt.h>
+#include <linux/kernel_stat.h>
 
 #include "internals.h"
 
@@ -24,7 +25,7 @@ static int irq_affinity_proc_show(struct seq_file *m, void *v)
 	const struct cpumask *mask = desc->irq_data.affinity;
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
-	if (desc->status & IRQ_MOVE_PENDING)
+	if (irqd_is_setaffinity_pending(&desc->irq_data))
 		mask = desc->pending_mask;
 #endif
 	seq_cpumask(m, mask);
@@ -65,8 +66,7 @@ static ssize_t irq_affinity_proc_write(struct file *file,
 	cpumask_var_t new_value;
 	int err;
 
-	if (!irq_to_desc(irq)->irq_data.chip->irq_set_affinity || no_irq_affinity ||
-	    irq_balancing_disabled(irq))
+	if (!irq_can_set_affinity(irq) || no_irq_affinity)
 		return -EIO;
 
 	if (!alloc_cpumask_var(&new_value, GFP_KERNEL))
@@ -89,7 +89,7 @@ static ssize_t irq_affinity_proc_write(struct file *file,
 	if (!cpumask_intersects(new_value, cpu_online_mask)) {
 		/* Special case for empty set - allow the architecture
 		   code to set default SMP affinity. */
-		err = irq_select_affinity_usr(irq) ? -EINVAL : count;
+		err = irq_select_affinity_usr(irq, new_value) ? -EINVAL : count;
 	} else {
 		irq_set_affinity(irq, new_value);
 		err = count;
@@ -357,3 +357,65 @@ void init_irq_proc(void)
 	}
 }
 
+#ifdef CONFIG_GENERIC_IRQ_SHOW
+
+int __weak arch_show_interrupts(struct seq_file *p, int prec)
+{
+	return 0;
+}
+
+int show_interrupts(struct seq_file *p, void *v)
+{
+	static int prec;
+
+	unsigned long flags, any_count = 0;
+	int i = *(loff_t *) v, j;
+	struct irqaction *action;
+	struct irq_desc *desc;
+
+	if (i > nr_irqs)
+		return 0;
+
+	if (i == nr_irqs)
+		return arch_show_interrupts(p, prec);
+
+	/* print header and calculate the width of the first column */
+	if (i == 0) {
+		for (prec = 3, j = 1000; prec < 10 && j <= nr_irqs; ++prec)
+			j *= 10;
+
+		seq_printf(p, "%*s", prec + 8, "");
+		for_each_online_cpu(j)
+			seq_printf(p, "CPU%-8d", j);
+		seq_putc(p, '\n');
+	}
+
+	desc = irq_to_desc(i);
+	if (!desc)
+		return 0;
+
+	raw_spin_lock_irqsave(&desc->lock, flags);
+	for_each_online_cpu(j)
+		any_count |= kstat_irqs_cpu(i, j);
+	action = desc->action;
+	if (!action && !any_count)
+		goto out;
+
+	seq_printf(p, "%*d: ", prec, i);
+	for_each_online_cpu(j)
+		seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
+	seq_printf(p, " %8s", desc->irq_data.chip->name);
+	seq_printf(p, "-%-8s", desc->name);
+
+	if (action) {
+		seq_printf(p, "  %s", action->name);
+		while ((action = action->next) != NULL)
+			seq_printf(p, ", %s", action->name);
+	}
+
+	seq_putc(p, '\n');
+out:
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+	return 0;
+}
+#endif
diff --git a/kernel/irq/resend.c b/kernel/irq/resend.c
index 891115a..ad683a9 100644
--- a/kernel/irq/resend.c
+++ b/kernel/irq/resend.c
@@ -23,7 +23,7 @@
 #ifdef CONFIG_HARDIRQS_SW_RESEND
 
 /* Bitmap to handle software resend of interrupts: */
-static DECLARE_BITMAP(irqs_resend, NR_IRQS);
+static DECLARE_BITMAP(irqs_resend, IRQ_BITMAP_BITS);
 
 /*
  * Run software resends of IRQ's
@@ -55,20 +55,19 @@ static DECLARE_TASKLET(resend_tasklet, resend_irqs, 0);
  */
 void check_irq_resend(struct irq_desc *desc, unsigned int irq)
 {
-	unsigned int status = desc->status;
-
-	/*
-	 * Make sure the interrupt is enabled, before resending it:
-	 */
-	desc->irq_data.chip->irq_enable(&desc->irq_data);
-
 	/*
 	 * We do not resend level type interrupts. Level type
 	 * interrupts are resent by hardware when they are still
 	 * active.
 	 */
-	if ((status & (IRQ_LEVEL | IRQ_PENDING | IRQ_REPLAY)) == IRQ_PENDING) {
-		desc->status = (status & ~IRQ_PENDING) | IRQ_REPLAY;
+	if (irq_settings_is_level(desc))
+		return;
+	if (desc->istate & IRQS_REPLAY)
+		return;
+	if (desc->istate & IRQS_PENDING) {
+		irq_compat_clr_pending(desc);
+		desc->istate &= ~IRQS_PENDING;
+		desc->istate |= IRQS_REPLAY;
 
 		if (!desc->irq_data.chip->irq_retrigger ||
 		    !desc->irq_data.chip->irq_retrigger(&desc->irq_data)) {
diff --git a/kernel/irq/settings.h b/kernel/irq/settings.h
new file mode 100644
index 0000000..0227ad3
--- /dev/null
+++ b/kernel/irq/settings.h
@@ -0,0 +1,138 @@
+/*
+ * Internal header to deal with irq_desc->status which will be renamed
+ * to irq_desc->settings.
+ */
+enum {
+	_IRQ_DEFAULT_INIT_FLAGS	= IRQ_DEFAULT_INIT_FLAGS,
+	_IRQ_PER_CPU		= IRQ_PER_CPU,
+	_IRQ_LEVEL		= IRQ_LEVEL,
+	_IRQ_NOPROBE		= IRQ_NOPROBE,
+	_IRQ_NOREQUEST		= IRQ_NOREQUEST,
+	_IRQ_NOAUTOEN		= IRQ_NOAUTOEN,
+	_IRQ_MOVE_PCNTXT	= IRQ_MOVE_PCNTXT,
+	_IRQ_NO_BALANCING	= IRQ_NO_BALANCING,
+	_IRQ_NESTED_THREAD	= IRQ_NESTED_THREAD,
+	_IRQF_MODIFY_MASK	= IRQF_MODIFY_MASK,
+};
+
+#define IRQ_INPROGRESS		GOT_YOU_MORON
+#define IRQ_REPLAY		GOT_YOU_MORON
+#define IRQ_WAITING		GOT_YOU_MORON
+#define IRQ_DISABLED		GOT_YOU_MORON
+#define IRQ_PENDING		GOT_YOU_MORON
+#define IRQ_MASKED		GOT_YOU_MORON
+#define IRQ_WAKEUP		GOT_YOU_MORON
+#define IRQ_MOVE_PENDING	GOT_YOU_MORON
+#define IRQ_PER_CPU		GOT_YOU_MORON
+#define IRQ_NO_BALANCING	GOT_YOU_MORON
+#define IRQ_AFFINITY_SET	GOT_YOU_MORON
+#define IRQ_LEVEL		GOT_YOU_MORON
+#define IRQ_NOPROBE		GOT_YOU_MORON
+#define IRQ_NOREQUEST		GOT_YOU_MORON
+#define IRQ_NOAUTOEN		GOT_YOU_MORON
+#define IRQ_NESTED_THREAD	GOT_YOU_MORON
+#undef IRQF_MODIFY_MASK
+#define IRQF_MODIFY_MASK	GOT_YOU_MORON
+
+static inline void
+irq_settings_clr_and_set(struct irq_desc *desc, u32 clr, u32 set)
+{
+	desc->status &= ~(clr & _IRQF_MODIFY_MASK);
+	desc->status |= (set & _IRQF_MODIFY_MASK);
+}
+
+static inline bool irq_settings_is_per_cpu(struct irq_desc *desc)
+{
+	return desc->status & _IRQ_PER_CPU;
+}
+
+static inline void irq_settings_set_per_cpu(struct irq_desc *desc)
+{
+	desc->status |= _IRQ_PER_CPU;
+}
+
+static inline void irq_settings_set_no_balancing(struct irq_desc *desc)
+{
+	desc->status |= _IRQ_NO_BALANCING;
+}
+
+static inline bool irq_settings_has_no_balance_set(struct irq_desc *desc)
+{
+	return desc->status & _IRQ_NO_BALANCING;
+}
+
+static inline u32 irq_settings_get_trigger_mask(struct irq_desc *desc)
+{
+	return desc->status & IRQ_TYPE_SENSE_MASK;
+}
+
+static inline void
+irq_settings_set_trigger_mask(struct irq_desc *desc, u32 mask)
+{
+	desc->status &= ~IRQ_TYPE_SENSE_MASK;
+	desc->status |= mask & IRQ_TYPE_SENSE_MASK;
+}
+
+static inline bool irq_settings_is_level(struct irq_desc *desc)
+{
+	return desc->status & _IRQ_LEVEL;
+}
+
+static inline void irq_settings_clr_level(struct irq_desc *desc)
+{
+	desc->status &= ~_IRQ_LEVEL;
+}
+
+static inline void irq_settings_set_level(struct irq_desc *desc)
+{
+	desc->status |= _IRQ_LEVEL;
+}
+
+static inline bool irq_settings_can_request(struct irq_desc *desc)
+{
+	return !(desc->status & _IRQ_NOREQUEST);
+}
+
+static inline void irq_settings_clr_norequest(struct irq_desc *desc)
+{
+	desc->status &= ~_IRQ_NOREQUEST;
+}
+
+static inline void irq_settings_set_norequest(struct irq_desc *desc)
+{
+	desc->status |= _IRQ_NOREQUEST;
+}
+
+static inline bool irq_settings_can_probe(struct irq_desc *desc)
+{
+	return !(desc->status & _IRQ_NOPROBE);
+}
+
+static inline void irq_settings_clr_noprobe(struct irq_desc *desc)
+{
+	desc->status &= ~_IRQ_NOPROBE;
+}
+
+static inline void irq_settings_set_noprobe(struct irq_desc *desc)
+{
+	desc->status |= _IRQ_NOPROBE;
+}
+
+static inline bool irq_settings_can_move_pcntxt(struct irq_desc *desc)
+{
+	return desc->status & _IRQ_MOVE_PCNTXT;
+}
+
+static inline bool irq_settings_can_autoenable(struct irq_desc *desc)
+{
+	return !(desc->status & _IRQ_NOAUTOEN);
+}
+
+static inline bool irq_settings_is_nested_thread(struct irq_desc *desc)
+{
+	return desc->status & _IRQ_NESTED_THREAD;
+}
+
+/* Nothing should touch desc->status from now on */
+#undef status
+#define status		USE_THE_PROPER_WRAPPERS_YOU_MORON
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 3089d3b..dd586eb 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -21,70 +21,94 @@ static int irqfixup __read_mostly;
 #define POLL_SPURIOUS_IRQ_INTERVAL (HZ/10)
 static void poll_spurious_irqs(unsigned long dummy);
 static DEFINE_TIMER(poll_spurious_irq_timer, poll_spurious_irqs, 0, 0);
+static int irq_poll_cpu;
+static atomic_t irq_poll_active;
+
+/*
+ * We wait here for a poller to finish.
+ *
+ * If the poll runs on this CPU, then we yell loudly and return
+ * false. That will leave the interrupt line disabled in the worst
+ * case, but it should never happen.
+ *
+ * We wait until the poller is done and then recheck disabled and
+ * action (about to be disabled). Only if it's still active, we return
+ * true and let the handler run.
+ */
+bool irq_wait_for_poll(struct irq_desc *desc)
+{
+	if (WARN_ONCE(irq_poll_cpu == smp_processor_id(),
+		      "irq poll in progress on cpu %d for irq %d\n",
+		      smp_processor_id(), desc->irq_data.irq))
+		return false;
+
+#ifdef CONFIG_SMP
+	do {
+		raw_spin_unlock(&desc->lock);
+		while (desc->istate & IRQS_INPROGRESS)
+			cpu_relax();
+		raw_spin_lock(&desc->lock);
+	} while (desc->istate & IRQS_INPROGRESS);
+	/* Might have been disabled in meantime */
+	return !(desc->istate & IRQS_DISABLED) && desc->action;
+#else
+	return false;
+#endif
+}
+
 
 /*
  * Recovery handler for misrouted interrupts.
  */
-static int try_one_irq(int irq, struct irq_desc *desc)
+static int try_one_irq(int irq, struct irq_desc *desc, bool force)
 {
+	irqreturn_t ret = IRQ_NONE;
 	struct irqaction *action;
-	int ok = 0, work = 0;
 
 	raw_spin_lock(&desc->lock);
-	/* Already running on another processor */
-	if (desc->status & IRQ_INPROGRESS) {
-		/*
-		 * Already running: If it is shared get the other
-		 * CPU to go looking for our mystery interrupt too
-		 */
-		if (desc->action && (desc->action->flags & IRQF_SHARED))
-			desc->status |= IRQ_PENDING;
-		raw_spin_unlock(&desc->lock);
-		return ok;
-	}
-	/* Honour the normal IRQ locking */
-	desc->status |= IRQ_INPROGRESS;
-	action = desc->action;
-	raw_spin_unlock(&desc->lock);
 
-	while (action) {
-		/* Only shared IRQ handlers are safe to call */
-		if (action->flags & IRQF_SHARED) {
-			if (action->handler(irq, action->dev_id) ==
-				IRQ_HANDLED)
-				ok = 1;
-		}
-		action = action->next;
-	}
-	local_irq_disable();
-	/* Now clean up the flags */
-	raw_spin_lock(&desc->lock);
-	action = desc->action;
+	/* PER_CPU and nested thread interrupts are never polled */
+	if (irq_settings_is_per_cpu(desc) || irq_settings_is_nested_thread(desc))
+		goto out;
 
 	/*
-	 * While we were looking for a fixup someone queued a real
-	 * IRQ clashing with our walk:
+	 * Do not poll disabled interrupts unless the spurious
+	 * disabled poller asks explicitely.
 	 */
-	while ((desc->status & IRQ_PENDING) && action) {
+	if ((desc->istate & IRQS_DISABLED) && !force)
+		goto out;
+
+	/*
+	 * All handlers must agree on IRQF_SHARED, so we test just the
+	 * first. Check for action->next as well.
+	 */
+	action = desc->action;
+	if (!action || !(action->flags & IRQF_SHARED) ||
+	    (action->flags & __IRQF_TIMER) || !action->next)
+		goto out;
+
+	/* Already running on another processor */
+	if (desc->istate & IRQS_INPROGRESS) {
 		/*
-		 * Perform real IRQ processing for the IRQ we deferred
+		 * Already running: If it is shared get the other
+		 * CPU to go looking for our mystery interrupt too
 		 */
-		work = 1;
-		raw_spin_unlock(&desc->lock);
-		handle_IRQ_event(irq, action);
-		raw_spin_lock(&desc->lock);
-		desc->status &= ~IRQ_PENDING;
+		irq_compat_set_pending(desc);
+		desc->istate |= IRQS_PENDING;
+		goto out;
 	}
-	desc->status &= ~IRQ_INPROGRESS;
-	/*
-	 * If we did actual work for the real IRQ line we must let the
-	 * IRQ controller clean up too
-	 */
-	if (work)
-		irq_end(irq, desc);
-	raw_spin_unlock(&desc->lock);
 
-	return ok;
+	/* Mark it poll in progress */
+	desc->istate |= IRQS_POLL_INPROGRESS;
+	do {
+		if (handle_irq_event(desc) == IRQ_HANDLED)
+			ret = IRQ_HANDLED;
+		action = desc->action;
+	} while ((desc->istate & IRQS_PENDING) && action);
+	desc->istate &= ~IRQS_POLL_INPROGRESS;
+out:
+	raw_spin_unlock(&desc->lock);
+	return ret == IRQ_HANDLED;
 }
 
 static int misrouted_irq(int irq)
@@ -92,6 +116,11 @@ static int misrouted_irq(int irq)
 	struct irq_desc *desc;
 	int i, ok = 0;
 
+	if (atomic_inc_return(&irq_poll_active) == 1)
+		goto out;
+
+	irq_poll_cpu = smp_processor_id();
+
 	for_each_irq_desc(i, desc) {
 		if (!i)
 			 continue;
@@ -99,9 +128,11 @@ static int misrouted_irq(int irq)
 		if (i == irq)	/* Already tried */
 			continue;
 
-		if (try_one_irq(i, desc))
+		if (try_one_irq(i, desc, false))
 			ok = 1;
 	}
+out:
+	atomic_dec(&irq_poll_active);
 	/* So the caller can adjust the irq error counts */
 	return ok;
 }
@@ -111,23 +142,28 @@ static void poll_spurious_irqs(unsigned long dummy)
 	struct irq_desc *desc;
 	int i;
 
+	if (atomic_inc_return(&irq_poll_active) != 1)
+		goto out;
+	irq_poll_cpu = smp_processor_id();
+
 	for_each_irq_desc(i, desc) {
-		unsigned int status;
+		unsigned int state;
 
 		if (!i)
 			 continue;
 
 		/* Racy but it doesn't matter */
-		status = desc->status;
+		state = desc->istate;
 		barrier();
-		if (!(status & IRQ_SPURIOUS_DISABLED))
+		if (!(state & IRQS_SPURIOUS_DISABLED))
 			continue;
 
 		local_irq_disable();
-		try_one_irq(i, desc);
+		try_one_irq(i, desc, true);
 		local_irq_enable();
 	}
-
+out:
+	atomic_dec(&irq_poll_active);
 	mod_timer(&poll_spurious_irq_timer,
 		  jiffies + POLL_SPURIOUS_IRQ_INTERVAL);
 }
@@ -139,15 +175,13 @@ static void poll_spurious_irqs(unsigned long dummy)
  *
  * (The other 100-of-100,000 interrupts may have been a correctly
  *  functioning device sharing an IRQ with the failing one)
- *
- * Called under desc->lock
  */
-
 static void
 __report_bad_irq(unsigned int irq, struct irq_desc *desc,
 		 irqreturn_t action_ret)
 {
 	struct irqaction *action;
+	unsigned long flags;
 
 	if (action_ret != IRQ_HANDLED && action_ret != IRQ_NONE) {
 		printk(KERN_ERR "irq event %d: bogus return value %x\n",
@@ -159,6 +193,13 @@ __report_bad_irq(unsigned int irq, struct irq_desc *desc,
 	dump_stack();
 	printk(KERN_ERR "handlers:\n");
 
+	/*
+	 * We need to take desc->lock here. note_interrupt() is called
+	 * w/o desc->lock held, but IRQ_PROGRESS set. We might race
+	 * with something else removing an action. It's ok to take
+	 * desc->lock here. See synchronize_irq().
+	 */
+	raw_spin_lock_irqsave(&desc->lock, flags);
 	action = desc->action;
 	while (action) {
 		printk(KERN_ERR "[<%p>]", action->handler);
@@ -167,6 +208,7 @@ __report_bad_irq(unsigned int irq, struct irq_desc *desc,
 		printk("\n");
 		action = action->next;
 	}
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
 
 static void
@@ -218,6 +260,9 @@ try_misrouted_irq(unsigned int irq, struct irq_desc *desc,
 void note_interrupt(unsigned int irq, struct irq_desc *desc,
 		    irqreturn_t action_ret)
 {
+	if (desc->istate & IRQS_POLL_INPROGRESS)
+		return;
+
 	if (unlikely(action_ret != IRQ_HANDLED)) {
 		/*
 		 * If we are seeing only the odd spurious IRQ caused by
@@ -254,9 +299,9 @@ void note_interrupt(unsigned int irq, struct irq_desc *desc,
 		 * Now kill the IRQ
 		 */
 		printk(KERN_EMERG "Disabling IRQ #%d\n", irq);
-		desc->status |= IRQ_DISABLED | IRQ_SPURIOUS_DISABLED;
+		desc->istate |= IRQS_SPURIOUS_DISABLED;
 		desc->depth++;
-		desc->irq_data.chip->irq_disable(&desc->irq_data);
+		irq_disable(desc);
 
 		mod_timer(&poll_spurious_irq_timer,
 			  jiffies + POLL_SPURIOUS_IRQ_INTERVAL);
diff --git a/kernel/sched.c b/kernel/sched.c
index 18d38e4..66ca5d9 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2224,7 +2224,10 @@ unsigned long wait_task_inactive(struct task_struct *p, long match_state)
 		 * yield - it could be a while.
 		 */
 		if (unlikely(on_rq)) {
-			schedule_timeout_uninterruptible(1);
+			ktime_t to = ktime_set(0, NSEC_PER_SEC/HZ);
+
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			schedule_hrtimeout(&to, HRTIMER_MODE_REL);
 			continue;
 		}
 
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 68eb5ef..a33fb29 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -311,9 +311,21 @@ void irq_enter(void)
 }
 
 #ifdef __ARCH_IRQ_EXIT_IRQS_DISABLED
-# define invoke_softirq()	__do_softirq()
+static inline void invoke_softirq(void)
+{
+	if (!force_irqthreads)
+		__do_softirq();
+	else
+		wakeup_softirqd();
+}
 #else
-# define invoke_softirq()	do_softirq()
+static inline void invoke_softirq(void)
+{
+	if (!force_irqthreads)
+		do_softirq();
+	else
+		wakeup_softirqd();
+}
 #endif
 
 /*
@@ -738,7 +750,10 @@ static int run_ksoftirqd(void * __bind_cpu)
 			   don't process */
 			if (cpu_is_offline((long)__bind_cpu))
 				goto wait_to_die;
-			do_softirq();
+			local_irq_disable();
+			if (local_softirq_pending())
+				__do_softirq();
+			local_irq_enable();
 			preempt_enable_no_resched();
 			cond_resched();
 			preempt_disable();
