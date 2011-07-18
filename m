Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751073Ab1GRWjv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 18:39:51 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53203 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab1GRWju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 18:39:50 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 1/3] staging: et131x: Convert et1310_tx.c function name from CamelCase
Date: Mon, 18 Jul 2011 23:38:45 +0100
Message-Id: <1311028727-4758-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested on an ET-131x device.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.h         |    3 +--
 drivers/staging/et131x/et131x_initpci.c |   12 ++----------
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/et131x/et131x.h b/drivers/staging/et131x/et131x.h
index bd5330c..9523a8b 100644
--- a/drivers/staging/et131x/et131x.h
+++ b/drivers/staging/et131x/et131x.h
@@ -52,8 +52,7 @@
 int et131x_init_eeprom(struct et131x_adapter *etdev);
 
 /* et131x_initpci.c */
-void ConfigGlobalRegs(struct et131x_adapter *pAdapter);
-void ConfigMMCRegs(struct et131x_adapter *pAdapter);
+void et131x_config_global_regs(struct et131x_adapter *pAdapter);
 void et131x_enable_interrupts(struct et131x_adapter *adapter);
 void et131x_disable_interrupts(struct et131x_adapter *adapter);
 void et131x_align_allocated_memory(struct et131x_adapter *adapter,
diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index d12610d..32a20ddaa 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -325,7 +325,7 @@ void et131x_link_detection_handler(unsigned long data)
  *
  * Used to configure the global registers on the JAGCore
  */
-void ConfigGlobalRegs(struct et131x_adapter *etdev)
+void et131x_configure_global_regs(struct et131x_adapter *etdev)
 {
 	struct global_regs __iomem *regs = &etdev->regs->global;
 
@@ -366,7 +366,6 @@ void ConfigGlobalRegs(struct et131x_adapter *etdev)
 	writel(0, &regs->watchdog_timer);
 }
 
-
 /**
  * et131x_adapter_setup - Set the adapter up as per cassini+ documentation
  * @etdev: pointer to our private adapter structure
@@ -378,7 +377,7 @@ int et131x_adapter_setup(struct et131x_adapter *etdev)
 	int status = 0;
 
 	/* Configure the JAGCore */
-	ConfigGlobalRegs(etdev);
+	et131x_configure_global_regs(etdev);
 
 	et1310_config_mac_regs1(etdev);
 
@@ -517,8 +516,6 @@ void et131x_adapter_memory_free(struct et131x_adapter *adapter)
 	et131x_rx_dma_memory_free(adapter);
 }
 
-
-
 /**
  * et131x_adapter_init
  * @etdev: pointer to the private adapter struct
@@ -527,8 +524,6 @@ void et131x_adapter_memory_free(struct et131x_adapter *adapter)
  * Initialize the data structures for the et131x_adapter object and link
  * them together with the platform provided device structures.
  */
-
-
 static struct et131x_adapter *et131x_adapter_init(struct net_device *netdev,
 		struct pci_dev *pdev)
 {
@@ -602,7 +597,6 @@ static struct et131x_adapter *et131x_adapter_init(struct net_device *netdev,
  * contained in the pci_device_id table. This routine is the equivalent to
  * a device insertion routine.
  */
-
 static int __devinit et131x_pci_setup(struct pci_dev *pdev,
 			       const struct pci_device_id *ent)
 {
@@ -774,7 +768,6 @@ err_disable:
  * PCI subsystem detects that a PCI device which matches the information
  * contained in the pci_device_id table has been removed.
  */
-
 static void __devexit et131x_pci_remove(struct pci_dev *pdev)
 {
 	struct net_device *netdev;
@@ -815,7 +808,6 @@ static struct pci_driver et131x_driver = {
 	.resume		= NULL,		/* et131x_pci_resume */
 };
 
-
 /**
  * et131x_init_module - The "main" entry point called on driver initialization
  *
-- 
1.7.4.4

