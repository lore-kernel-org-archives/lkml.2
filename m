Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab1GGTIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 15:08:48 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:57821 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716Ab1GGTIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 15:08:47 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 08/10] xen/pci: Retire unnecessary #ifdef CONFIG_ACPI
Date: Thu,  7 Jul 2011 15:08:24 -0400
Message-Id: <1310065706-18797-9-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310065706-18797-1-git-send-email-konrad.wilk@oracle.com>
References: <1310065706-18797-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4E160437.014F:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the code paths that are guarded by CONFIG_XEN_DOM0 already depend
on CONFIG_ACPI so the extra #ifdef is not required. The earlier
patch that added them in had done its job.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/pci/xen.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index e585bf5..6eddc52 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -381,7 +381,6 @@ int __init pci_xen_hvm_init(void)
 }
 
 #ifdef CONFIG_XEN_DOM0
-#ifdef CONFIG_ACPI
 static __init void xen_setup_acpi_sci(void)
 {
 	int rc;
@@ -428,7 +427,6 @@ static __init void xen_setup_acpi_sci(void)
 
 	return;
 }
-#endif
 
 int __init pci_xen_initial_domain(void)
 {
@@ -438,7 +436,6 @@ int __init pci_xen_initial_domain(void)
 	x86_msi.setup_msi_irqs = xen_initdom_setup_msi_irqs;
 	x86_msi.teardown_msi_irq = xen_teardown_msi_irq;
 #endif
-#ifdef CONFIG_ACPI
 	xen_setup_acpi_sci();
 	__acpi_register_gsi = acpi_register_gsi_xen;
 	/* Pre-allocate legacy irqs */
@@ -452,7 +449,6 @@ int __init pci_xen_initial_domain(void)
 			trigger ? ACPI_LEVEL_SENSITIVE : ACPI_EDGE_SENSITIVE,
 			true /* allocate IRQ */);
 	}
-#endif
 	if (0 == nr_ioapics) {
 		for (irq = 0; irq < NR_IRQS_LEGACY; irq++) {
 			pirq = xen_allocate_pirq_gsi(irq);
-- 
1.7.4.1

