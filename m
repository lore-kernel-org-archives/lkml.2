Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab1EDSP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 14:15:26 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:52779 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150Ab1EDSPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 14:15:25 -0400
Date: Wed, 4 May 2011 20:15:18 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: konrad.wilk@oracle.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: [PATCH 1/8] arch/x86/xen/enlighten: Cleanup code/data sections definitions
Message-ID: <20110504181518.GB29218@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup code/data sections definitions
accordingly to include/linux/init.h.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
---
 arch/x86/xen/enlighten.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index e3c6a06..dd7b88f 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -235,7 +235,7 @@ static void xen_cpuid(unsigned int *ax, unsigned int *bx,
 	*dx &= maskedx;
 }
 
-static __init void xen_init_cpuid_mask(void)
+static void __init xen_init_cpuid_mask(void)
 {
 	unsigned int ax, bx, cx, dx;
 	unsigned int xsave_mask;
@@ -400,7 +400,7 @@ static void xen_load_gdt(const struct desc_ptr *dtr)
 /*
  * load_gdt for early boot, when the gdt is only mapped once
  */
-static __init void xen_load_gdt_boot(const struct desc_ptr *dtr)
+static void __init xen_load_gdt_boot(const struct desc_ptr *dtr)
 {
 	unsigned long va = dtr->address;
 	unsigned int size = dtr->size + 1;
@@ -662,7 +662,7 @@ static void xen_write_gdt_entry(struct desc_struct *dt, int entry,
  * Version of write_gdt_entry for use at early boot-time needed to
  * update an entry as simply as possible.
  */
-static __init void xen_write_gdt_entry_boot(struct desc_struct *dt, int entry,
+static void __init xen_write_gdt_entry_boot(struct desc_struct *dt, int entry,
 					    const void *desc, int type)
 {
 	switch (type) {
@@ -933,18 +933,18 @@ static unsigned xen_patch(u8 type, u16 clobbers, void *insnbuf,
 	return ret;
 }
 
-static const struct pv_info xen_info __initdata = {
+static const struct pv_info xen_info __initconst = {
 	.paravirt_enabled = 1,
 	.shared_kernel_pmd = 0,
 
 	.name = "Xen",
 };
 
-static const struct pv_init_ops xen_init_ops __initdata = {
+static const struct pv_init_ops xen_init_ops __initconst = {
 	.patch = xen_patch,
 };
 
-static const struct pv_cpu_ops xen_cpu_ops __initdata = {
+static const struct pv_cpu_ops xen_cpu_ops __initconst = {
 	.cpuid = xen_cpuid,
 
 	.set_debugreg = xen_set_debugreg,
@@ -1004,7 +1004,7 @@ static const struct pv_cpu_ops xen_cpu_ops __initdata = {
 	.end_context_switch = xen_end_context_switch,
 };
 
-static const struct pv_apic_ops xen_apic_ops __initdata = {
+static const struct pv_apic_ops xen_apic_ops __initconst = {
 #ifdef CONFIG_X86_LOCAL_APIC
 	.startup_ipi_hook = paravirt_nop,
 #endif
@@ -1055,7 +1055,7 @@ int xen_panic_handler_init(void)
 	return 0;
 }
 
-static const struct machine_ops __initdata xen_machine_ops = {
+static const struct machine_ops xen_machine_ops __initconst = {
 	.restart = xen_restart,
 	.halt = xen_machine_halt,
 	.power_off = xen_machine_halt,
@@ -1332,7 +1332,7 @@ static int __cpuinit xen_hvm_cpu_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata xen_hvm_cpu_notifier = {
+static struct notifier_block xen_hvm_cpu_notifier __cpuinitdata = {
 	.notifier_call	= xen_hvm_cpu_notify,
 };
 
@@ -1381,7 +1381,7 @@ bool xen_hvm_need_lapic(void)
 }
 EXPORT_SYMBOL_GPL(xen_hvm_need_lapic);
 
-const __refconst struct hypervisor_x86 x86_hyper_xen_hvm = {
+const struct hypervisor_x86 x86_hyper_xen_hvm __refconst = {
 	.name			= "Xen HVM",
 	.detect			= xen_hvm_platform,
 	.init_platform		= xen_hvm_guest_init,
-- 
1.5.6.5
