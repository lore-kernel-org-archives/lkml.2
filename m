Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab1FOTVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 15:21:49 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63613 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500Ab1FOTUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:20:08 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        stefano.stabellini@eu.citrix.com, Ian.Campbell@citrix.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/8] xen/pci: Update comments and fix empty spaces.
Date: Wed, 15 Jun 2011 15:19:41 -0400
Message-Id: <1308165587-24902-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308165587-24902-1-git-send-email-konrad.wilk@oracle.com>
References: <1308165587-24902-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4DF905E1.0005:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment at the beginning of the file does not
make any sense anymore - update it.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/pci/xen.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index a2a8e2e..f44446b 100644
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
@@ -19,7 +24,6 @@
 #include <xen/events.h>
 #include <asm/xen/pci.h>
 
-
 static int xen_pcifront_enable_irq(struct pci_dev *dev)
 {
 	int rc;
@@ -182,9 +186,6 @@ static int acpi_register_gsi_xen(struct device *dev, u32 gsi,
 struct xen_pci_frontend_ops *xen_pci_frontend;
 EXPORT_SYMBOL_GPL(xen_pci_frontend);
 
-/*
- * For MSI interrupts we have to use drivers/xen/event.s functions to
- * allocate an irq_desc and setup the right */
 static int xen_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
 	int irq, ret, i;
@@ -360,7 +361,6 @@ static void xen_teardown_msi_irq(unsigned int irq)
 
 #endif
 
-
 int __init pci_xen_init(void)
 {
 	if (!xen_pv_domain() || xen_initial_domain())
@@ -424,7 +424,7 @@ static __init void xen_setup_acpi_sci(void)
 	}
 	trigger = trigger ? ACPI_LEVEL_SENSITIVE : ACPI_EDGE_SENSITIVE;
 	polarity = polarity ? ACPI_ACTIVE_LOW : ACPI_ACTIVE_HIGH;
-	
+
 	printk(KERN_INFO "xen: sci override: global_irq=%d trigger=%d "
 			"polarity=%d\n", gsi, trigger, polarity);
 
-- 
1.7.4.1

