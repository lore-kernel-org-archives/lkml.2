Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475Ab0ICUos (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 16:44:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47620 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742Ab0ICUor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 16:44:47 -0400
Date: Fri, 3 Sep 2010 16:44:46 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] flexcop: kill a WARN_ON in xlate_proc_name
Message-ID: <20100903204446.GJ2684@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@redhat.com>

The flexcop driver is currently trying to register DRIVER_NAME for its
irq name. Use a less braindead name (the module name) to
 1) avoid a warning in xlate_proc_name
 2) have a nice entry in /proc/irq/$n/

(https://bugzilla.redhat.com/show_bug.cgi?id=575873)

Signed-off-by: Kyle McMartin <kyle@redhat.com>
---
diff --git a/drivers/media/dvb/b2c2/flexcop-pci.c b/drivers/media/dvb/b2c2/flexcop-pci.c
index 227c020..7465308 100644
--- a/drivers/media/dvb/b2c2/flexcop-pci.c
+++ b/drivers/media/dvb/b2c2/flexcop-pci.c
@@ -39,6 +39,7 @@ MODULE_PARM_DESC(debug,
 
 #define DRIVER_VERSION "0.1"
 #define DRIVER_NAME "Technisat/B2C2 FlexCop II/IIb/III Digital TV PCI Driver"
+#define FLEXCOP_MODULE_NAME "b2c2-flexcop"
 #define DRIVER_AUTHOR "Patrick Boettcher <patrick.boettcher@desy.de>"
 
 struct flexcop_pci {
@@ -299,7 +300,7 @@ static int flexcop_pci_init(struct flexcop_pci *fc_pci)
 		return ret;
 	pci_set_master(fc_pci->pdev);
 
-	if ((ret = pci_request_regions(fc_pci->pdev, DRIVER_NAME)) != 0)
+	if ((ret = pci_request_regions(fc_pci->pdev, FLEXCOP_MODULE_NAME)) != 0)
 		goto err_pci_disable_device;
 
 	fc_pci->io_mem = pci_iomap(fc_pci->pdev, 0, 0x800);
@@ -313,7 +314,7 @@ static int flexcop_pci_init(struct flexcop_pci *fc_pci)
 	pci_set_drvdata(fc_pci->pdev, fc_pci);
 	spin_lock_init(&fc_pci->irq_lock);
 	if ((ret = request_irq(fc_pci->pdev->irq, flexcop_pci_isr,
-					IRQF_SHARED, DRIVER_NAME, fc_pci)) != 0)
+					IRQF_SHARED, FLEXCOP_MODULE_NAME, fc_pci)) != 0)
 		goto err_pci_iounmap;
 
 	fc_pci->init_state |= FC_PCI_INIT;
