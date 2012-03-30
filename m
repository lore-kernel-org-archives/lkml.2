Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761221Ab2C3Srw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 14:47:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:8977 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761172Ab2C3Sq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 14:46:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="135792340"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 09/10] iommu: rename intr_remapping references to irq_remapping
Date: Fri, 30 Mar 2012 11:47:07 -0700
Message-Id: <1333133228-3134-10-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1333133228-3134-1-git-send-email-suresh.b.siddha@intel.com>
References: <1333133228-3134-1-git-send-email-suresh.b.siddha@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the code consistent with the naming conventions of irq subsystem.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Alex Williamson <alex.williamson@redhat.com>
---
 arch/ia64/include/asm/intr_remapping.h |    2 +-
 arch/x86/include/asm/intr_remapping.h  |   94 ++++++++++++++++----------------
 arch/x86/kernel/apic/apic.c            |   22 ++++----
 arch/x86/kernel/apic/io_apic.c         |   41 +++++++-------
 drivers/iommu/dmar.c                   |    8 ++--
 drivers/iommu/intel-iommu.c            |    2 +-
 drivers/iommu/intel_intr_remapping.c   |   40 +++++++-------
 drivers/iommu/intr_remapping.c         |   74 +++++++++++++-------------
 drivers/iommu/intr_remapping.h         |   10 ++--
 9 files changed, 148 insertions(+), 145 deletions(-)

diff --git a/arch/ia64/include/asm/intr_remapping.h b/arch/ia64/include/asm/intr_remapping.h
index 095aa0d..a8687b1 100644
--- a/arch/ia64/include/asm/intr_remapping.h
+++ b/arch/ia64/include/asm/intr_remapping.h
@@ -1,4 +1,4 @@
 #ifndef __IA64_INTR_REMAPPING_H
 #define __IA64_INTR_REMAPPING_H
-#define intr_remapping_enabled 0
+#define irq_remapping_enabled 0
 #endif
diff --git a/arch/x86/include/asm/intr_remapping.h b/arch/x86/include/asm/intr_remapping.h
index a6afd6e..f9cbbcb 100644
--- a/arch/x86/include/asm/intr_remapping.h
+++ b/arch/x86/include/asm/intr_remapping.h
@@ -28,71 +28,73 @@ struct IO_APIC_route_entry;
 struct io_apic_irq_attr;
 struct pci_dev;
 
-extern int intr_remapping_enabled;
+extern int irq_remapping_enabled;
 
-extern void setup_intr_remapping(void);
-extern int intr_remapping_supported(void);
-extern int intr_hardware_init(void);
-extern int intr_hardware_enable(void);
-extern void intr_hardware_disable(void);
-extern int intr_hardware_reenable(int);
-extern int intr_enable_fault_handling(void);
-extern int intr_setup_ioapic_entry(int irq,
-				   struct IO_APIC_route_entry *entry,
-				   unsigned int destination, int vector,
-				   struct io_apic_irq_attr *attr);
-extern int intr_set_affinity(struct irq_data *data,
-			     const struct cpumask *mask,
-			     bool force);
-extern void intr_free_irq(int irq);
-extern void intr_compose_msi_msg(struct pci_dev *pdev,
-				 unsigned int irq, unsigned int dest,
-				 struct msi_msg *msg, u8 hpet_id);
-extern int intr_msi_alloc_irq(struct pci_dev *pdev, int irq, int nvec);
-extern int intr_msi_setup_irq(struct pci_dev *pdev, unsigned int irq,
-			      int index, int sub_handle);
-extern int intr_setup_hpet_msi(unsigned int irq, unsigned int id);
+extern void setup_irq_remapping_ops(void);
+extern int irq_remapping_supported(void);
+extern int irq_remapping_prepare(void);
+extern int irq_remapping_enable(void);
+extern void irq_remapping_disable(void);
+extern int irq_remapping_reenable(int);
+extern int irq_remap_enable_fault_handling(void);
+extern int setup_ioapic_remapped_entry(int irq,
+				       struct IO_APIC_route_entry *entry,
+				       unsigned int destination,
+				       int vector,
+				       struct io_apic_irq_attr *attr);
+extern int set_remapped_irq_affinity(struct irq_data *data,
+				     const struct cpumask *mask,
+				     bool force);
+extern void free_remapped_irq(int irq);
+extern void compose_remapped_msi_msg(struct pci_dev *pdev,
+				     unsigned int irq, unsigned int dest,
+				     struct msi_msg *msg, u8 hpet_id);
+extern int msi_alloc_remapped_irq(struct pci_dev *pdev, int irq, int nvec);
+extern int msi_setup_remapped_irq(struct pci_dev *pdev, unsigned int irq,
+				  int index, int sub_handle);
+extern int setup_hpet_msi_remapped(unsigned int irq, unsigned int id);
 
 #else  /* CONFIG_IRQ_REMAP */
 
-#define intr_remapping_enabled	0
+#define irq_remapping_enabled	0
 
-static inline void setup_intr_remapping(void) { }
-static inline int intr_remapping_supported(void) { return 0; }
-static inline int intr_hardware_init(void) { return -ENODEV; }
-static inline int intr_hardware_enable(void) { return -ENODEV; }
-static inline void intr_hardware_disable(void) { }
-static inline int intr_hardware_reenable(int eim) { return -ENODEV; }
-static inline int intr_enable_fault_handling(void) { return -ENODEV; }
-static inline int intr_setup_ioapic_entry(int irq,
-					  struct IO_APIC_route_entry *entry,
-					  unsigned int destination, int vector,
-					  struct io_apic_irq_attr *attr)
+static inline void setup_irq_remapping_ops(void) { }
+static inline int irq_remapping_supported(void) { return 0; }
+static inline int irq_remapping_prepare(void) { return -ENODEV; }
+static inline int irq_remapping_enable(void) { return -ENODEV; }
+static inline void irq_remapping_disable(void) { }
+static inline int irq_remapping_reenable(int eim) { return -ENODEV; }
+static inline int irq_remap_enable_fault_handling(void) { return -ENODEV; }
+static inline int setup_ioapic_remapped_entry(int irq,
+					      struct IO_APIC_route_entry *entry,
+					      unsigned int destination,
+					      int vector,
+					      struct io_apic_irq_attr *attr)
 {
 	return -ENODEV;
 }
-static inline int intr_set_affinity(struct irq_data *data,
-				    const struct cpumask *mask,
-				    bool force)
+static inline int set_remapped_irq_affinity(struct irq_data *data,
+					    const struct cpumask *mask,
+					    bool force)
 {
 	return 0;
 }
-static inline void intr_free_irq(int irq) { }
-static inline void intr_compose_msi_msg(struct pci_dev *pdev,
-					unsigned int irq, unsigned int dest,
-					struct msi_msg *msg, u8 hpet_id)
+static inline void free_remapped_irq(int irq) { }
+static inline void compose_remapped_msi_msg(struct pci_dev *pdev,
+					    unsigned int irq, unsigned int dest,
+					    struct msi_msg *msg, u8 hpet_id)
 {
 }
-static inline int intr_msi_alloc_irq(struct pci_dev *pdev, int irq, int nvec)
+static inline int msi_alloc_remapped_irq(struct pci_dev *pdev, int irq, int nvec)
 {
 	return -ENODEV;
 }
-static inline int intr_msi_setup_irq(struct pci_dev *pdev, unsigned int irq,
-				     int index, int sub_handle)
+static inline int msi_setup_remapped_irq(struct pci_dev *pdev, unsigned int irq,
+					 int index, int sub_handle)
 {
 	return -ENODEV;
 }
-static inline int intr_setup_hpet_msi(unsigned int irq, unsigned int id)
+static inline int setup_hpet_msi_remapped(unsigned int irq, unsigned int id)
 {
 	return -ENODEV;
 }
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 846f3b6..4246191 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1442,8 +1442,8 @@ void __init bsp_end_local_APIC_setup(void)
 	 * Now that local APIC setup is completed for BP, configure the fault
 	 * handling for interrupt remapping.
 	 */
-	if (intr_remapping_enabled)
-		intr_enable_fault_handling();
+	if (irq_remapping_enabled)
+		irq_remap_enable_fault_handling();
 
 }
 
@@ -1518,7 +1518,7 @@ void enable_x2apic(void)
 int __init enable_IR(void)
 {
 #ifdef CONFIG_IRQ_REMAP
-	if (!intr_remapping_supported()) {
+	if (!irq_remapping_supported()) {
 		pr_debug("intr-remapping not supported\n");
 		return -1;
 	}
@@ -1529,7 +1529,7 @@ int __init enable_IR(void)
 		return -1;
 	}
 
-	return intr_hardware_enable();
+	return irq_remapping_enable();
 #endif
 	return -1;
 }
@@ -1541,9 +1541,9 @@ void __init enable_IR_x2apic(void)
 	int hardware_init_ret;
 
 	/* Make sure irq_remap_ops are initialized */
-	setup_intr_remapping();
+	setup_irq_remapping_ops();
 
-	hardware_init_ret = intr_hardware_init();
+	hardware_init_ret = irq_remapping_prepare();
 	if (hardware_init_ret && !x2apic_supported())
 		return;
 
@@ -2176,8 +2176,8 @@ static int lapic_suspend(void)
 	local_irq_save(flags);
 	disable_local_APIC();
 
-	if (intr_remapping_enabled)
-		intr_hardware_disable();
+	if (irq_remapping_enabled)
+		irq_remapping_disable();
 
 	local_irq_restore(flags);
 	return 0;
@@ -2193,7 +2193,7 @@ static void lapic_resume(void)
 		return;
 
 	local_irq_save(flags);
-	if (intr_remapping_enabled) {
+	if (irq_remapping_enabled) {
 		/*
 		 * IO-APIC and PIC have their own resume routines.
 		 * We just mask them here to make sure the interrupt
@@ -2243,8 +2243,8 @@ static void lapic_resume(void)
 	apic_write(APIC_ESR, 0);
 	apic_read(APIC_ESR);
 
-	if (intr_remapping_enabled)
-		intr_hardware_reenable(x2apic_mode);
+	if (irq_remapping_enabled)
+		irq_remapping_reenable(x2apic_mode);
 
 	local_irq_restore(flags);
 }
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 073edd1..abbbcd4 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1381,9 +1381,9 @@ static int setup_ioapic_entry(int irq, struct IO_APIC_route_entry *entry,
 			       unsigned int destination, int vector,
 			       struct io_apic_irq_attr *attr)
 {
-	if (intr_remapping_enabled)
-		return intr_setup_ioapic_entry(irq, entry, destination,
-					       vector, attr);
+	if (irq_remapping_enabled)
+		return setup_ioapic_remapped_entry(irq, entry, destination,
+						   vector, attr);
 
 	memset(entry, 0, sizeof(*entry));
 
@@ -1540,7 +1540,7 @@ static void __init setup_timer_IRQ0_pin(unsigned int ioapic_idx,
 {
 	struct IO_APIC_route_entry entry;
 
-	if (intr_remapping_enabled)
+	if (irq_remapping_enabled)
 		return;
 
 	memset(&entry, 0, sizeof(entry));
@@ -1626,7 +1626,7 @@ __apicdebuginit(void) print_IO_APIC(int ioapic_idx)
 
 	printk(KERN_DEBUG ".... IRQ redirection table:\n");
 
-	if (intr_remapping_enabled) {
+	if (irq_remapping_enabled) {
 		printk(KERN_DEBUG " NR Indx Fmt Mask Trig IRR"
 			" Pol Stat Indx2 Zero Vect:\n");
 	} else {
@@ -1635,7 +1635,7 @@ __apicdebuginit(void) print_IO_APIC(int ioapic_idx)
 	}
 
 	for (i = 0; i <= reg_01.bits.entries; i++) {
-		if (intr_remapping_enabled) {
+		if (irq_remapping_enabled) {
 			struct IO_APIC_route_entry entry;
 			struct IR_IO_APIC_route_entry *ir_entry;
 
@@ -2002,7 +2002,7 @@ void disable_IO_APIC(void)
 	 * IOAPIC RTE as well as interrupt-remapping table entry).
 	 * As this gets called during crash dump, keep this simple for now.
 	 */
-	if (ioapic_i8259.pin != -1 && !intr_remapping_enabled) {
+	if (ioapic_i8259.pin != -1 && !irq_remapping_enabled) {
 		struct IO_APIC_route_entry entry;
 
 		memset(&entry, 0, sizeof(entry));
@@ -2026,7 +2026,7 @@ void disable_IO_APIC(void)
 	 * Use virtual wire A mode when interrupt remapping is enabled.
 	 */
 	if (cpu_has_apic || apic_from_smp_config())
-		disconnect_bsp_APIC(!intr_remapping_enabled &&
+		disconnect_bsp_APIC(!irq_remapping_enabled &&
 				ioapic_i8259.pin != -1);
 }
 
@@ -2586,7 +2586,7 @@ static void irq_remap_modify_chip_defaults(struct irq_chip *chip)
 	chip->irq_eoi = ir_ack_apic_level;
 
 #ifdef CONFIG_SMP
-	chip->irq_set_affinity = intr_set_affinity;
+	chip->irq_set_affinity = set_remapped_irq_affinity;
 #endif
 }
 #endif /* CONFIG_IRQ_REMAP */
@@ -2799,7 +2799,7 @@ static inline void __init check_timer(void)
 	 * 8259A.
 	 */
 	if (pin1 == -1) {
-		if (intr_remapping_enabled)
+		if (irq_remapping_enabled)
 			panic("BIOS bug: timer not connected to IO-APIC");
 		pin1 = pin2;
 		apic1 = apic2;
@@ -2832,7 +2832,7 @@ static inline void __init check_timer(void)
 				clear_IO_APIC_pin(0, pin1);
 			goto out;
 		}
-		if (intr_remapping_enabled)
+		if (irq_remapping_enabled)
 			panic("timer doesn't work through Interrupt-remapped IO-APIC");
 		local_irq_disable();
 		clear_IO_APIC_pin(apic1, pin1);
@@ -3056,7 +3056,7 @@ void destroy_irq(unsigned int irq)
 	irq_set_status_flags(irq, IRQ_NOREQUEST|IRQ_NOPROBE);
 
 	if (irq_remapped(cfg))
-		intr_free_irq(irq);
+		free_remapped_irq(irq);
 	raw_spin_lock_irqsave(&vector_lock, flags);
 	__clear_irq_vector(irq, cfg);
 	raw_spin_unlock_irqrestore(&vector_lock, flags);
@@ -3085,7 +3085,7 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
 	dest = apic->cpu_mask_to_apicid_and(cfg->domain, apic->target_cpus());
 
 	if (irq_remapped(cfg)) {
-		intr_compose_msi_msg(pdev, irq, dest, msg, hpet_id);
+		compose_remapped_msi_msg(pdev, irq, dest, msg, hpet_id);
 		return err;
 	}
 
@@ -3198,7 +3198,7 @@ int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 		if (irq == 0)
 			return -1;
 		irq_want = irq + 1;
-		if (!intr_remapping_enabled)
+		if (!irq_remapping_enabled)
 			goto no_ir;
 
 		if (!sub_handle) {
@@ -3206,13 +3206,14 @@ int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 			 * allocate the consecutive block of IRTE's
 			 * for 'nvec'
 			 */
-			index = intr_msi_alloc_irq(dev, irq, nvec);
+			index = msi_alloc_remapped_irq(dev, irq, nvec);
 			if (index < 0) {
 				ret = index;
 				goto error;
 			}
 		} else {
-			ret = intr_msi_setup_irq(dev, irq, index, sub_handle);
+			ret = msi_setup_remapped_irq(dev, irq, index,
+						     sub_handle);
 			if (ret < 0)
 				goto error;
 		}
@@ -3332,8 +3333,8 @@ int arch_setup_hpet_msi(unsigned int irq, unsigned int id)
 	struct msi_msg msg;
 	int ret;
 
-	if (intr_remapping_enabled) {
-		if (!intr_setup_hpet_msi(irq, id))
+	if (irq_remapping_enabled) {
+		if (!setup_hpet_msi_remapped(irq, id))
 			return -1;
 	}
 
@@ -3712,8 +3713,8 @@ void __init setup_ioapic_dest(void)
 		else
 			mask = apic->target_cpus();
 
-		if (intr_remapping_enabled)
-			intr_set_affinity(idata, mask, false);
+		if (irq_remapping_enabled)
+			set_remapped_irq_affinity(idata, mask, false);
 		else
 			ioapic_set_affinity(idata, mask, false);
 	}
diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 647e366..ee74f69 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -556,7 +556,7 @@ int __init detect_intel_iommu(void)
 
 		dmar = (struct acpi_table_dmar *) dmar_tbl;
 
-		if (ret && intr_remapping_enabled && cpu_has_x2apic &&
+		if (ret && irq_remapping_enabled && cpu_has_x2apic &&
 		    dmar->flags & 0x1)
 			printk(KERN_INFO
 			       "Queued invalidation will be enabled to support x2apic and Intr-remapping.\n");
@@ -1042,7 +1042,7 @@ static const char *dma_remap_fault_reasons[] =
 	"non-zero reserved fields in PTE",
 };
 
-static const char *intr_remap_fault_reasons[] =
+static const char *irq_remap_fault_reasons[] =
 {
 	"Detected reserved fields in the decoded interrupt-remapped request",
 	"Interrupt index exceeded the interrupt-remapping table size",
@@ -1058,9 +1058,9 @@ static const char *intr_remap_fault_reasons[] =
 const char *dmar_get_fault_reason(u8 fault_reason, int *fault_type)
 {
 	if (fault_reason >= 0x20 && (fault_reason <= 0x20 +
-				     ARRAY_SIZE(intr_remap_fault_reasons))) {
+				     ARRAY_SIZE(irq_remap_fault_reasons))) {
 		*fault_type = INTR_REMAP;
-		return intr_remap_fault_reasons[fault_reason - 0x20];
+		return irq_remap_fault_reasons[fault_reason - 0x20];
 	} else if (fault_reason < ARRAY_SIZE(dma_remap_fault_reasons)) {
 		*fault_type = DMA_REMAP;
 		return dma_remap_fault_reasons[fault_reason];
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 86b69cf..3c48ce2 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4082,7 +4082,7 @@ static int intel_iommu_domain_has_cap(struct iommu_domain *domain,
 	if (cap == IOMMU_CAP_CACHE_COHERENCY)
 		return dmar_domain->iommu_snooping;
 	if (cap == IOMMU_CAP_INTR_REMAP)
-		return intr_remapping_enabled;
+		return irq_remapping_enabled;
 
 	return 0;
 }
diff --git a/drivers/iommu/intel_intr_remapping.c b/drivers/iommu/intel_intr_remapping.c
index 7472634..efeb601 100644
--- a/drivers/iommu/intel_intr_remapping.c
+++ b/drivers/iommu/intel_intr_remapping.c
@@ -394,7 +394,7 @@ static int set_msi_sid(struct irte *irte, struct pci_dev *dev)
 	return 0;
 }
 
-static void iommu_set_intr_remapping(struct intel_iommu *iommu, int mode)
+static void iommu_set_irq_remapping(struct intel_iommu *iommu, int mode)
 {
 	u64 addr;
 	u32 sts;
@@ -434,7 +434,7 @@ static void iommu_set_intr_remapping(struct intel_iommu *iommu, int mode)
 }
 
 
-static int intel_setup_intr_remapping(struct intel_iommu *iommu, int mode)
+static int intel_setup_irq_remapping(struct intel_iommu *iommu, int mode)
 {
 	struct ir_table *ir_table;
 	struct page *pages;
@@ -457,14 +457,14 @@ static int intel_setup_intr_remapping(struct intel_iommu *iommu, int mode)
 
 	ir_table->base = page_address(pages);
 
-	iommu_set_intr_remapping(iommu, mode);
+	iommu_set_irq_remapping(iommu, mode);
 	return 0;
 }
 
 /*
  * Disable Interrupt Remapping.
  */
-static void iommu_disable_intr_remapping(struct intel_iommu *iommu)
+static void iommu_disable_irq_remapping(struct intel_iommu *iommu)
 {
 	unsigned long flags;
 	u32 sts;
@@ -503,11 +503,11 @@ static int __init dmar_x2apic_optout(void)
 	return dmar->flags & DMAR_X2APIC_OPT_OUT;
 }
 
-static int __init intel_intr_remapping_supported(void)
+static int __init intel_irq_remapping_supported(void)
 {
 	struct dmar_drhd_unit *drhd;
 
-	if (disable_intremap)
+	if (disable_irq_remap)
 		return 0;
 
 	if (!dmar_ir_support())
@@ -523,7 +523,7 @@ static int __init intel_intr_remapping_supported(void)
 	return 1;
 }
 
-static int __init intel_enable_intr_remapping(void)
+static int __init intel_enable_irq_remapping(void)
 {
 	struct dmar_drhd_unit *drhd;
 	int setup = 0;
@@ -561,7 +561,7 @@ static int __init intel_enable_intr_remapping(void)
 		 * Disable intr remapping and queued invalidation, if already
 		 * enabled prior to OS handover.
 		 */
-		iommu_disable_intr_remapping(iommu);
+		iommu_disable_irq_remapping(iommu);
 
 		dmar_disable_qi(iommu);
 	}
@@ -607,7 +607,7 @@ static int __init intel_enable_intr_remapping(void)
 		if (!ecap_ir_support(iommu->ecap))
 			continue;
 
-		if (intel_setup_intr_remapping(iommu, eim))
+		if (intel_setup_irq_remapping(iommu, eim))
 			goto error;
 
 		setup = 1;
@@ -616,7 +616,7 @@ static int __init intel_enable_intr_remapping(void)
 	if (!setup)
 		goto error;
 
-	intr_remapping_enabled = 1;
+	irq_remapping_enabled = 1;
 	pr_info("Enabled IRQ remapping in %s mode\n", eim ? "x2apic" : "xapic");
 
 	return eim ? IRQ_REMAP_X2APIC_MODE : IRQ_REMAP_XAPIC_MODE;
@@ -759,14 +759,14 @@ int __init parse_ioapics_under_ir(void)
 
 int __init ir_dev_scope_init(void)
 {
-	if (!intr_remapping_enabled)
+	if (!irq_remapping_enabled)
 		return 0;
 
 	return dmar_dev_scope_init();
 }
 rootfs_initcall(ir_dev_scope_init);
 
-static void disable_intr_remapping(void)
+static void disable_irq_remapping(void)
 {
 	struct dmar_drhd_unit *drhd;
 	struct intel_iommu *iommu = NULL;
@@ -778,11 +778,11 @@ static void disable_intr_remapping(void)
 		if (!ecap_ir_support(iommu->ecap))
 			continue;
 
-		iommu_disable_intr_remapping(iommu);
+		iommu_disable_irq_remapping(iommu);
 	}
 }
 
-static int reenable_intr_remapping(int eim)
+static int reenable_irq_remapping(int eim)
 {
 	struct dmar_drhd_unit *drhd;
 	int setup = 0;
@@ -800,7 +800,7 @@ static int reenable_intr_remapping(int eim)
 			continue;
 
 		/* Set up interrupt remapping for iommu.*/
-		iommu_set_intr_remapping(iommu, eim);
+		iommu_set_irq_remapping(iommu, eim);
 		setup = 1;
 	}
 
@@ -1049,11 +1049,11 @@ static int intel_setup_hpet_msi(unsigned int irq, unsigned int id)
 }
 
 struct irq_remap_ops intel_irq_remap_ops = {
-	.supported		= intel_intr_remapping_supported,
-	.hardware_init		= dmar_table_init,
-	.hardware_enable	= intel_enable_intr_remapping,
-	.hardware_disable	= disable_intr_remapping,
-	.hardware_reenable	= reenable_intr_remapping,
+	.supported		= intel_irq_remapping_supported,
+	.prepare		= dmar_table_init,
+	.enable			= intel_enable_irq_remapping,
+	.disable		= disable_irq_remapping,
+	.reenable		= reenable_irq_remapping,
 	.enable_faulting	= enable_drhd_fault_handling,
 	.setup_ioapic_entry	= intel_setup_ioapic_entry,
 	.set_affinity		= intel_ioapic_set_affinity,
diff --git a/drivers/iommu/intr_remapping.c b/drivers/iommu/intr_remapping.c
index 9dc1793..523a7b3 100644
--- a/drivers/iommu/intr_remapping.c
+++ b/drivers/iommu/intr_remapping.c
@@ -4,9 +4,9 @@
 
 #include "intr_remapping.h"
 
-int intr_remapping_enabled;
+int irq_remapping_enabled;
 
-int disable_intremap;
+int disable_irq_remap;
 int disable_sourceid_checking;
 int no_x2apic_optout;
 
@@ -14,21 +14,21 @@ static struct irq_remap_ops *remap_ops;
 
 static __init int setup_nointremap(char *str)
 {
-	disable_intremap = 1;
+	disable_irq_remap = 1;
 	return 0;
 }
 early_param("nointremap", setup_nointremap);
 
-static __init int setup_intremap(char *str)
+static __init int setup_irqremap(char *str)
 {
 	if (!str)
 		return -EINVAL;
 
 	while (*str) {
 		if (!strncmp(str, "on", 2))
-			disable_intremap = 0;
+			disable_irq_remap = 0;
 		else if (!strncmp(str, "off", 3))
-			disable_intremap = 1;
+			disable_irq_remap = 1;
 		else if (!strncmp(str, "nosid", 5))
 			disable_sourceid_checking = 1;
 		else if (!strncmp(str, "no_x2apic_optout", 16))
@@ -41,16 +41,16 @@ static __init int setup_intremap(char *str)
 
 	return 0;
 }
-early_param("intremap", setup_intremap);
+early_param("intremap", setup_irqremap);
 
-void __init setup_intr_remapping(void)
+void __init setup_irq_remapping_ops(void)
 {
 	remap_ops = &intel_irq_remap_ops;
 }
 
-int intr_remapping_supported(void)
+int irq_remapping_supported(void)
 {
-	if (disable_intremap)
+	if (disable_irq_remap)
 		return 0;
 
 	if (!remap_ops || !remap_ops->supported)
@@ -59,39 +59,39 @@ int intr_remapping_supported(void)
 	return remap_ops->supported();
 }
 
-int __init intr_hardware_init(void)
+int __init irq_remapping_prepare(void)
 {
-	if (!remap_ops || !remap_ops->hardware_init)
+	if (!remap_ops || !remap_ops->prepare)
 		return -ENODEV;
 
-	return remap_ops->hardware_init();
+	return remap_ops->prepare();
 }
 
-int __init intr_hardware_enable(void)
+int __init irq_remapping_enable(void)
 {
-	if (!remap_ops || !remap_ops->hardware_enable)
+	if (!remap_ops || !remap_ops->enable)
 		return -ENODEV;
 
-	return remap_ops->hardware_enable();
+	return remap_ops->enable();
 }
 
-void intr_hardware_disable(void)
+void irq_remapping_disable(void)
 {
-	if (!remap_ops || !remap_ops->hardware_disable)
+	if (!remap_ops || !remap_ops->disable)
 		return;
 
-	remap_ops->hardware_disable();
+	remap_ops->disable();
 }
 
-int intr_hardware_reenable(int mode)
+int irq_remapping_reenable(int mode)
 {
-	if (!remap_ops || !remap_ops->hardware_reenable)
+	if (!remap_ops || !remap_ops->reenable)
 		return 0;
 
-	return remap_ops->hardware_reenable(mode);
+	return remap_ops->reenable(mode);
 }
 
-int __init intr_enable_fault_handling(void)
+int __init irq_remap_enable_fault_handling(void)
 {
 	if (!remap_ops || !remap_ops->enable_faulting)
 		return -ENODEV;
@@ -99,10 +99,10 @@ int __init intr_enable_fault_handling(void)
 	return remap_ops->enable_faulting();
 }
 
-int intr_setup_ioapic_entry(int irq,
-			    struct IO_APIC_route_entry *entry,
-			    unsigned int destination, int vector,
-			    struct io_apic_irq_attr *attr)
+int setup_ioapic_remapped_entry(int irq,
+				struct IO_APIC_route_entry *entry,
+				unsigned int destination, int vector,
+				struct io_apic_irq_attr *attr)
 {
 	if (!remap_ops || !remap_ops->setup_ioapic_entry)
 		return -ENODEV;
@@ -111,8 +111,8 @@ int intr_setup_ioapic_entry(int irq,
 					     vector, attr);
 }
 
-int intr_set_affinity(struct irq_data *data, const struct cpumask *mask,
-		      bool force)
+int set_remapped_irq_affinity(struct irq_data *data, const struct cpumask *mask,
+			      bool force)
 {
 	if (!remap_ops || !remap_ops->set_affinity)
 		return 0;
@@ -120,7 +120,7 @@ int intr_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	return remap_ops->set_affinity(data, mask, force);
 }
 
-void intr_free_irq(int irq)
+void free_remapped_irq(int irq)
 {
 	if (!remap_ops || !remap_ops->free_irq)
 		return;
@@ -128,9 +128,9 @@ void intr_free_irq(int irq)
 	remap_ops->free_irq(irq);
 }
 
-void intr_compose_msi_msg(struct pci_dev *pdev,
-			  unsigned int irq, unsigned int dest,
-			  struct msi_msg *msg, u8 hpet_id)
+void compose_remapped_msi_msg(struct pci_dev *pdev,
+			      unsigned int irq, unsigned int dest,
+			      struct msi_msg *msg, u8 hpet_id)
 {
 	if (!remap_ops || !remap_ops->compose_msi_msg)
 		return;
@@ -138,7 +138,7 @@ void intr_compose_msi_msg(struct pci_dev *pdev,
 	remap_ops->compose_msi_msg(pdev, irq, dest, msg, hpet_id);
 }
 
-int intr_msi_alloc_irq(struct pci_dev *pdev, int irq, int nvec)
+int msi_alloc_remapped_irq(struct pci_dev *pdev, int irq, int nvec)
 {
 	if (!remap_ops || !remap_ops->msi_alloc_irq)
 		return -ENODEV;
@@ -146,8 +146,8 @@ int intr_msi_alloc_irq(struct pci_dev *pdev, int irq, int nvec)
 	return remap_ops->msi_alloc_irq(pdev, irq, nvec);
 }
 
-int intr_msi_setup_irq(struct pci_dev *pdev, unsigned int irq,
-		       int index, int sub_handle)
+int msi_setup_remapped_irq(struct pci_dev *pdev, unsigned int irq,
+			   int index, int sub_handle)
 {
 	if (!remap_ops || !remap_ops->msi_setup_irq)
 		return -ENODEV;
@@ -155,7 +155,7 @@ int intr_msi_setup_irq(struct pci_dev *pdev, unsigned int irq,
 	return remap_ops->msi_setup_irq(pdev, irq, index, sub_handle);
 }
 
-int intr_setup_hpet_msi(unsigned int irq, unsigned int id)
+int setup_hpet_msi_remapped(unsigned int irq, unsigned int id)
 {
 	if (!remap_ops || !remap_ops->setup_hpet_msi)
 		return -ENODEV;
diff --git a/drivers/iommu/intr_remapping.h b/drivers/iommu/intr_remapping.h
index 6f4ea0a..bd5d98f 100644
--- a/drivers/iommu/intr_remapping.h
+++ b/drivers/iommu/intr_remapping.h
@@ -31,7 +31,7 @@ struct cpumask;
 struct pci_dev;
 struct msi_msg;
 
-extern int disable_intremap;
+extern int disable_irq_remap;
 extern int disable_sourceid_checking;
 extern int no_x2apic_optout;
 
@@ -40,16 +40,16 @@ struct irq_remap_ops {
 	int (*supported)(void);
 
 	/* Initializes hardware and makes it ready for remapping interrupts */
-	int  (*hardware_init)(void);
+	int  (*prepare)(void);
 
 	/* Enables the remapping hardware */
-	int  (*hardware_enable)(void);
+	int  (*enable)(void);
 
 	/* Disables the remapping hardware */
-	void (*hardware_disable)(void);
+	void (*disable)(void);
 
 	/* Reenables the remapping hardware */
-	int  (*hardware_reenable)(int);
+	int  (*reenable)(int);
 
 	/* Enable fault handling */
 	int  (*enable_faulting)(void);
-- 
1.7.6.5

