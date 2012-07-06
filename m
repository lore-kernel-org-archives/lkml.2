Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382Ab2GFT5k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 15:57:40 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:56868 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717Ab2GFT5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 15:57:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: [PATCH] PM / IPMI: Remove empty legacy PCI PM callbacks
Date: Fri, 6 Jul 2012 22:02:39 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Corey Minyard <minyard@acm.org>,
        openipmi-developer@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207062202.39202.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The legacy PM callbacks provided by the IPMI PCI driver are
empty routines returning 0, so they can be safely dropped.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/char/ipmi/ipmi_si_intf.c |   16 ----------------
 1 file changed, 16 deletions(-)

Index: linux/drivers/char/ipmi/ipmi_si_intf.c
===================================================================
--- linux.orig/drivers/char/ipmi/ipmi_si_intf.c
+++ linux/drivers/char/ipmi/ipmi_si_intf.c
@@ -2503,18 +2503,6 @@ static void __devexit ipmi_pci_remove(st
 	cleanup_one_si(info);
 }
 
-#ifdef CONFIG_PM
-static int ipmi_pci_suspend(struct pci_dev *pdev, pm_message_t state)
-{
-	return 0;
-}
-
-static int ipmi_pci_resume(struct pci_dev *pdev)
-{
-	return 0;
-}
-#endif
-
 static struct pci_device_id ipmi_pci_devices[] = {
 	{ PCI_DEVICE(PCI_HP_VENDOR_ID, PCI_MMC_DEVICE_ID) },
 	{ PCI_DEVICE_CLASS(PCI_ERMC_CLASSCODE, PCI_ERMC_CLASSCODE_MASK) },
@@ -2527,10 +2515,6 @@ static struct pci_driver ipmi_pci_driver
 	.id_table =     ipmi_pci_devices,
 	.probe =        ipmi_pci_probe,
 	.remove =       __devexit_p(ipmi_pci_remove),
-#ifdef CONFIG_PM
-	.suspend =      ipmi_pci_suspend,
-	.resume =       ipmi_pci_resume,
-#endif
 };
 #endif /* CONFIG_PCI */
 
