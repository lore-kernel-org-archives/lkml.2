Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762Ab0LFQtf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 11:49:35 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:41750 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab0LFQte convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Mon, 6 Dec 2010 11:49:34 -0500
Message-Id: <4CFD222A02000078000262A9@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 06 Dec 2010 16:49:30 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: miscellaneous section annotation adjustments
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/acpi/boot.c  |    3 ++-
 arch/x86/kernel/tsc.c        |    2 +-
 arch/x86/pci/common.c        |   20 ++++++++++----------
 arch/x86/pci/early.c         |   18 +++++++++---------
 drivers/pci/intr_remapping.c |   12 ++++++------
 5 files changed, 28 insertions(+), 27 deletions(-)

--- linux-2.6.37-rc4/arch/x86/kernel/acpi/boot.c
+++ 2.6.37-rc4-x86-sections/arch/x86/kernel/acpi/boot.c
@@ -575,7 +575,8 @@ void __init acpi_set_irq_model_ioapic(vo
 #ifdef CONFIG_ACPI_HOTPLUG_CPU
 #include <acpi/processor.h>
 
-static void acpi_map_cpu2node(acpi_handle handle, int cpu, int physid)
+static void __cpuinit acpi_map_cpu2node(acpi_handle handle, int cpu,
+					int physid)
 {
 #ifdef CONFIG_ACPI_NUMA
 	int nid;
--- linux-2.6.37-rc4/arch/x86/kernel/tsc.c
+++ 2.6.37-rc4-x86-sections/arch/x86/kernel/tsc.c
@@ -36,7 +36,7 @@ static int __read_mostly tsc_unstable;
    erroneous rdtsc usage on !cpu_has_tsc processors */
 static int __read_mostly tsc_disabled = -1;
 
-static int tsc_clocksource_reliable;
+static int __initdata tsc_clocksource_reliable;
 /*
  * Scheduler clock - returns current time in nanosec units.
  */
--- linux-2.6.37-rc4/arch/x86/pci/common.c
+++ 2.6.37-rc4-x86-sections/arch/x86/pci/common.c
@@ -20,9 +20,9 @@
 unsigned int pci_probe = PCI_PROBE_BIOS | PCI_PROBE_CONF1 | PCI_PROBE_CONF2 |
 				PCI_PROBE_MMCONF;
 
-unsigned int pci_early_dump_regs;
-static int pci_bf_sort;
-int pci_routeirq;
+unsigned int __initdata pci_early_dump_regs;
+static int __initdata pci_bf_sort;
+int __initdata pci_routeirq;
 int noioapicquirk;
 #ifdef CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS
 int noioapicreroute = 0;
@@ -30,7 +30,7 @@ int noioapicreroute = 0;
 int noioapicreroute = 1;
 #endif
 int pcibios_last_bus = -1;
-unsigned long pirq_table_addr;
+unsigned long __initdata pirq_table_addr;
 struct pci_bus *pci_root_bus;
 struct pci_raw_ops *raw_pci_ops;
 struct pci_raw_ops *raw_pci_ext_ops;
@@ -78,14 +78,14 @@ struct pci_ops pci_root_ops = {
  */
 DEFINE_RAW_SPINLOCK(pci_config_lock);
 
-static int __devinit can_skip_ioresource_align(const struct dmi_system_id *d)
+static int __init can_skip_ioresource_align(const struct dmi_system_id *d)
 {
 	pci_probe |= PCI_CAN_SKIP_ISA_ALIGN;
 	printk(KERN_INFO "PCI: %s detected, can skip ISA alignment\n", d->ident);
 	return 0;
 }
 
-static const struct dmi_system_id can_skip_pciprobe_dmi_table[] __devinitconst = {
+static const struct dmi_system_id can_skip_pciprobe_dmi_table[] __initconst = {
 /*
  * Systems where PCI IO resource ISA alignment can be skipped
  * when the ISA enable bit in the bridge control is not set
@@ -176,7 +176,7 @@ void __devinit pcibios_fixup_bus(struct 
  * on the kernel command line (which was parsed earlier).
  */
 
-static int __devinit set_bf_sort(const struct dmi_system_id *d)
+static int __init set_bf_sort(const struct dmi_system_id *d)
 {
 	if (pci_bf_sort == pci_bf_sort_default) {
 		pci_bf_sort = pci_dmi_bf;
@@ -189,7 +189,7 @@ static int __devinit set_bf_sort(const s
  * Enable renumbering of PCI bus# ranges to reach all PCI busses (Cardbus)
  */
 #ifdef __i386__
-static int __devinit assign_all_busses(const struct dmi_system_id *d)
+static int __init assign_all_busses(const struct dmi_system_id *d)
 {
 	pci_probe |= PCI_ASSIGN_ALL_BUSSES;
 	printk(KERN_INFO "%s detected: enabling PCI bus# renumbering"
@@ -198,7 +198,7 @@ static int __devinit assign_all_busses(c
 }
 #endif
 
-static const struct dmi_system_id __devinitconst pciprobe_dmi_table[] = {
+static const struct dmi_system_id __initconst pciprobe_dmi_table[] = {
 #ifdef __i386__
 /*
  * Laptops which need pci=assign-busses to see Cardbus cards
@@ -456,7 +456,7 @@ int __init pcibios_init(void)
 	return 0;
 }
 
-char * __devinit  pcibios_setup(char *str)
+char *__init pcibios_setup(char *str)
 {
 	if (!strcmp(str, "off")) {
 		pci_probe = 0;
--- linux-2.6.37-rc4/arch/x86/pci/early.c
+++ 2.6.37-rc4-x86-sections/arch/x86/pci/early.c
@@ -7,7 +7,7 @@
 /* Direct PCI access. This is used for PCI accesses in early boot before
    the PCI subsystem works. */
 
-u32 read_pci_config(u8 bus, u8 slot, u8 func, u8 offset)
+u32 __cpuinit read_pci_config(u8 bus, u8 slot, u8 func, u8 offset)
 {
 	u32 v;
 	outl(0x80000000 | (bus<<16) | (slot<<11) | (func<<8) | offset, 0xcf8);
@@ -15,7 +15,7 @@ u32 read_pci_config(u8 bus, u8 slot, u8 
 	return v;
 }
 
-u8 read_pci_config_byte(u8 bus, u8 slot, u8 func, u8 offset)
+u8 __cpuinit read_pci_config_byte(u8 bus, u8 slot, u8 func, u8 offset)
 {
 	u8 v;
 	outl(0x80000000 | (bus<<16) | (slot<<11) | (func<<8) | offset, 0xcf8);
@@ -23,7 +23,7 @@ u8 read_pci_config_byte(u8 bus, u8 slot,
 	return v;
 }
 
-u16 read_pci_config_16(u8 bus, u8 slot, u8 func, u8 offset)
+u16 __cpuinit read_pci_config_16(u8 bus, u8 slot, u8 func, u8 offset)
 {
 	u16 v;
 	outl(0x80000000 | (bus<<16) | (slot<<11) | (func<<8) | offset, 0xcf8);
@@ -31,32 +31,32 @@ u16 read_pci_config_16(u8 bus, u8 slot, 
 	return v;
 }
 
-void write_pci_config(u8 bus, u8 slot, u8 func, u8 offset,
+void __init write_pci_config(u8 bus, u8 slot, u8 func, u8 offset,
 				    u32 val)
 {
 	outl(0x80000000 | (bus<<16) | (slot<<11) | (func<<8) | offset, 0xcf8);
 	outl(val, 0xcfc);
 }
 
-void write_pci_config_byte(u8 bus, u8 slot, u8 func, u8 offset, u8 val)
+void __init write_pci_config_byte(u8 bus, u8 slot, u8 func, u8 offset, u8 val)
 {
 	outl(0x80000000 | (bus<<16) | (slot<<11) | (func<<8) | offset, 0xcf8);
 	outb(val, 0xcfc + (offset&3));
 }
 
-void write_pci_config_16(u8 bus, u8 slot, u8 func, u8 offset, u16 val)
+void __init write_pci_config_16(u8 bus, u8 slot, u8 func, u8 offset, u16 val)
 {
 	outl(0x80000000 | (bus<<16) | (slot<<11) | (func<<8) | offset, 0xcf8);
 	outw(val, 0xcfc + (offset&2));
 }
 
-int early_pci_allowed(void)
+int __cpuinit early_pci_allowed(void)
 {
 	return (pci_probe & (PCI_PROBE_CONF1|PCI_PROBE_NOEARLY)) ==
 			PCI_PROBE_CONF1;
 }
 
-void early_dump_pci_device(u8 bus, u8 slot, u8 func)
+void __init early_dump_pci_device(u8 bus, u8 slot, u8 func)
 {
 	int i;
 	int j;
@@ -78,7 +78,7 @@ void early_dump_pci_device(u8 bus, u8 sl
 	printk("\n");
 }
 
-void early_dump_pci_devices(void)
+void __init early_dump_pci_devices(void)
 {
 	unsigned bus, slot, func;
 
--- linux-2.6.37-rc4/drivers/pci/intr_remapping.c
+++ 2.6.37-rc4-x86-sections/drivers/pci/intr_remapping.c
@@ -617,8 +617,8 @@ error:
 	return -1;
 }
 
-static void ir_parse_one_hpet_scope(struct acpi_dmar_device_scope *scope,
-				      struct intel_iommu *iommu)
+static void __init ir_parse_one_hpet_scope(struct acpi_dmar_device_scope *scope,
+					   struct intel_iommu *iommu)
 {
 	struct acpi_dmar_pci_path *path;
 	u8 bus;
@@ -645,8 +645,8 @@ static void ir_parse_one_hpet_scope(stru
 	ir_hpet_num++;
 }
 
-static void ir_parse_one_ioapic_scope(struct acpi_dmar_device_scope *scope,
-				      struct intel_iommu *iommu)
+static void __init ir_parse_one_ioapic_scope(struct acpi_dmar_device_scope *scope,
+					     struct intel_iommu *iommu)
 {
 	struct acpi_dmar_pci_path *path;
 	u8 bus;
@@ -674,8 +674,8 @@ static void ir_parse_one_ioapic_scope(st
 	ir_ioapic_num++;
 }
 
-static int ir_parse_ioapic_hpet_scope(struct acpi_dmar_header *header,
-				      struct intel_iommu *iommu)
+static int __init ir_parse_ioapic_hpet_scope(struct acpi_dmar_header *header,
+					     struct intel_iommu *iommu)
 {
 	struct acpi_dmar_hardware_unit *drhd;
 	struct acpi_dmar_device_scope *scope;


