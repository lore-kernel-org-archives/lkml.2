Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab0DBMFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 08:05:24 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:59628 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756631Ab0DBMFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 08:05:15 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 2 Apr 2010 14:05:02 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/3] firewire: ohci: function names cleanup
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.4957c3a08e7013b1@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ohci_ prefix is only used in function names of fw_card_driver hooks.
There are two exceptions which I carelessly added.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/ohci.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

Index: b/drivers/firewire/ohci.c
===================================================================
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -2299,7 +2299,7 @@ static const struct fw_card_driver ohci_
 };
 
 #ifdef CONFIG_PPC_PMAC
-static void ohci_pmac_on(struct pci_dev *dev)
+static void pmac_ohci_on(struct pci_dev *dev)
 {
 	if (machine_is(powermac)) {
 		struct device_node *ofn = pci_device_to_OF_node(dev);
@@ -2311,7 +2311,7 @@ static void ohci_pmac_on(struct pci_dev 
 	}
 }
 
-static void ohci_pmac_off(struct pci_dev *dev)
+static void pmac_ohci_off(struct pci_dev *dev)
 {
 	if (machine_is(powermac)) {
 		struct device_node *ofn = pci_device_to_OF_node(dev);
@@ -2323,8 +2323,8 @@ static void ohci_pmac_off(struct pci_dev
 	}
 }
 #else
-#define ohci_pmac_on(dev)
-#define ohci_pmac_off(dev)
+#define pmac_ohci_on(dev)
+#define pmac_ohci_off(dev)
 #endif /* CONFIG_PPC_PMAC */
 
 static int __devinit pci_probe(struct pci_dev *dev,
@@ -2344,7 +2344,7 @@ static int __devinit pci_probe(struct pc
 
 	fw_card_initialize(&ohci->card, &ohci_driver, &dev->dev);
 
-	ohci_pmac_on(dev);
+	pmac_ohci_on(dev);
 
 	err = pci_enable_device(dev);
 	if (err) {
@@ -2461,7 +2461,7 @@ static int __devinit pci_probe(struct pc
 	pci_disable_device(dev);
  fail_free:
 	kfree(&ohci->card);
-	ohci_pmac_off(dev);
+	pmac_ohci_off(dev);
  fail:
 	if (err == -ENOMEM)
 		fw_error("Out of memory\n");
@@ -2504,7 +2504,7 @@ static void pci_remove(struct pci_dev *d
 	pci_release_region(dev, 0);
 	pci_disable_device(dev);
 	kfree(&ohci->card);
-	ohci_pmac_off(dev);
+	pmac_ohci_off(dev);
 
 	fw_notify("Removed fw-ohci device.\n");
 }
@@ -2525,7 +2525,7 @@ static int pci_suspend(struct pci_dev *d
 	err = pci_set_power_state(dev, pci_choose_state(dev, state));
 	if (err)
 		fw_error("pci_set_power_state failed with %d\n", err);
-	ohci_pmac_off(dev);
+	pmac_ohci_off(dev);
 
 	return 0;
 }
@@ -2535,7 +2535,7 @@ static int pci_resume(struct pci_dev *de
 	struct fw_ohci *ohci = pci_get_drvdata(dev);
 	int err;
 
-	ohci_pmac_on(dev);
+	pmac_ohci_on(dev);
 	pci_set_power_state(dev, PCI_D0);
 	pci_restore_state(dev);
 	err = pci_enable_device(dev);

-- 
Stefan Richter
-=====-==-=- -=-- ---=-
http://arcgraph.de/sr/

