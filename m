Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096Ab2FRKeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 06:34:18 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:52029 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757822Ab2FRKeQ convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Mon, 18 Jun 2012 06:34:16 -0400
Message-Id: <4FDF2044020000780008A66F@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 18 Jun 2012 11:34:12 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/PCI: adjust section annotations
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMI tables referenced from __init code only can be __initconst, and as
a result the functions referenced from there can become __init.

pcibios_setup() can be __init as being a command line parsing function
only.

A few other variables can then also have their attributes adjusted.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/pci/common.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- 3.5-rc3/arch/x86/pci/common.c
+++ 3.5-rc3-x86-pci-common-sections/arch/x86/pci/common.c
@@ -21,10 +21,10 @@
 unsigned int pci_probe = PCI_PROBE_BIOS | PCI_PROBE_CONF1 | PCI_PROBE_CONF2 |
 				PCI_PROBE_MMCONF;
 
-unsigned int pci_early_dump_regs;
-static int pci_bf_sort;
-static int smbios_type_b1_flag;
-int pci_routeirq;
+unsigned int __initdata pci_early_dump_regs;
+static int __devinitdata pci_bf_sort;
+static int __devinitdata smbios_type_b1_flag;
+int __initdata pci_routeirq;
 int noioapicquirk;
 #ifdef CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS
 int noioapicreroute = 0;
@@ -32,7 +32,7 @@ int noioapicreroute = 0;
 int noioapicreroute = 1;
 #endif
 int pcibios_last_bus = -1;
-unsigned long pirq_table_addr;
+unsigned long __initdata pirq_table_addr;
 struct pci_bus *pci_root_bus;
 const struct pci_raw_ops *__read_mostly raw_pci_ops;
 const struct pci_raw_ops *__read_mostly raw_pci_ext_ops;
@@ -80,14 +80,14 @@ struct pci_ops pci_root_ops = {
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
@@ -221,7 +221,7 @@ static int __devinit find_sort_method(co
  * Enable renumbering of PCI bus# ranges to reach all PCI busses (Cardbus)
  */
 #ifdef __i386__
-static int __devinit assign_all_busses(const struct dmi_system_id *d)
+static int __init assign_all_busses(const struct dmi_system_id *d)
 {
 	pci_probe |= PCI_ASSIGN_ALL_BUSSES;
 	printk(KERN_INFO "%s detected: enabling PCI bus# renumbering"
@@ -230,7 +230,7 @@ static int __devinit assign_all_busses(c
 }
 #endif
 
-static int __devinit set_scan_all(const struct dmi_system_id *d)
+static int __init set_scan_all(const struct dmi_system_id *d)
 {
 	printk(KERN_INFO "PCI: %s detected, enabling pci=pcie_scan_all\n",
 	       d->ident);
@@ -238,7 +238,7 @@ static int __devinit set_scan_all(const
 	return 0;
 }
 
-static const struct dmi_system_id __devinitconst pciprobe_dmi_table[] = {
+static const struct dmi_system_id __initconst pciprobe_dmi_table[] = {
 #ifdef __i386__
 /*
  * Laptops which need pci=assign-busses to see Cardbus cards
@@ -494,7 +494,7 @@ int __init pcibios_init(void)
 	return 0;
 }
 
-char * __devinit  pcibios_setup(char *str)
+char *__init pcibios_setup(char *str)
 {
 	if (!strcmp(str, "off")) {
 		pci_probe = 0;



