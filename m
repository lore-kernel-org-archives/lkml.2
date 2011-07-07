Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549Ab1GGTJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 15:09:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:43800 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756439Ab1GGTIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 15:08:52 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 02/10] xen/pci: Update comments and fix empty spaces.
Date: Thu,  7 Jul 2011 15:08:18 -0400
Message-Id: <1310065706-18797-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310065706-18797-1-git-send-email-konrad.wilk@oracle.com>
References: <1310065706-18797-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090206.4E160438.00D4:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
X-Greylist: IP, sender and recipient auto-whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [140.211.167.34]); Thu, 07 Jul 2011 19:08:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the out-dated comment at the beginning of the file.
Also provide the copyrights of folks who have been contributing
to this code lately.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/pci/xen.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index ba4077b..76b3980 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -1,8 +1,13 @@
 /*
- * Xen PCI Frontend Stub - puts some "dummy" functions in to the Linux
- *			   x86 PCI core to support the Xen PCI Frontend
+ * Xen PCI - handle PCI (INTx) and MSI infrastructure calls for PV, HVM and
+ * initial domain support. We also handle the DSDT _PRT callbacks for GSI's
+ * used in HVM and initial domain mode (PV does not parse ACPI, so it has no
+ * concept of GSIs). Under PV we hook under the pnbbios API for IRQs and
+ * 0xcf8 PCI configuration read/write.
  *
  *   Author: Ryan Wilson <hap9@epoch.ncsc.mil>
+ *           Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+ *           Stefano Stabellini <stefano.stabellini@eu.citrix.com>
  */
 #include <linux/module.h>
 #include <linux/init.h>
@@ -183,9 +188,6 @@ static int acpi_register_gsi_xen(struct device *dev, u32 gsi,
 struct xen_pci_frontend_ops *xen_pci_frontend;
 EXPORT_SYMBOL_GPL(xen_pci_frontend);
 
-/*
- * For MSI interrupts we have to use drivers/xen/event.s functions to
- * allocate an irq_desc and setup the right */
 static int xen_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
 	int irq, ret, i;
@@ -361,7 +363,6 @@ static void xen_teardown_msi_irq(unsigned int irq)
 
 #endif
 
-
 int __init pci_xen_init(void)
 {
 	if (!xen_pv_domain() || xen_initial_domain())
@@ -427,7 +428,7 @@ static __init void xen_setup_acpi_sci(void)
 	}
 	trigger = trigger ? ACPI_LEVEL_SENSITIVE : ACPI_EDGE_SENSITIVE;
 	polarity = polarity ? ACPI_ACTIVE_LOW : ACPI_ACTIVE_HIGH;
-	
+
 	printk(KERN_INFO "xen: sci override: global_irq=%d trigger=%d "
 			"polarity=%d\n", gsi, trigger, polarity);
 
-- 
1.7.4.1

