Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541Ab2HGT7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:59:49 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:36546 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475Ab2HGT7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:59:44 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        J Freyensee <james_p_freyensee@linux.intel.com>
Subject: [PATCH 07/41] misc: pti, move ->remove to the PCI code
Date: Tue,  7 Aug 2012 21:47:32 +0200
Message-Id: <1344368886-24033-8-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
References: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function is lost somewhere in the forest. Move it to have it along
with probe and other pci_driver stuff.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: J Freyensee <james_p_freyensee@linux.intel.com>
---
 drivers/misc/pti.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/misc/pti.c b/drivers/misc/pti.c
index 3bfc8e3..4a24421 100644
--- a/drivers/misc/pti.c
+++ b/drivers/misc/pti.c
@@ -393,22 +393,6 @@ void pti_writedata(struct pti_masterchannel *mc, u8 *buf, int count)
 }
 EXPORT_SYMBOL_GPL(pti_writedata);
 
-/**
- * pti_pci_remove()- Driver exit method to remove PTI from
- *		   PCI bus.
- * @pdev: variable containing pci info of PTI.
- */
-static void __devexit pti_pci_remove(struct pci_dev *pdev)
-{
-	struct pti_dev *drv_data = pci_get_drvdata(pdev);
-
-	iounmap(drv_data->pti_ioaddr);
-	pci_set_drvdata(pdev, NULL);
-	kfree(drv_data);
-	pci_release_region(pdev, 1);
-	pci_disable_device(pdev);
-}
-
 /*
  * for the tty_driver_*() basic function descriptions, see tty_driver.h.
  * Specific header comments made for PTI-related specifics.
@@ -881,6 +865,22 @@ static int __devinit pti_pci_probe(struct pci_dev *pdev,
 	return retval;
 }
 
+/**
+ * pti_pci_remove()- Driver exit method to remove PTI from
+ *		   PCI bus.
+ * @pdev: variable containing pci info of PTI.
+ */
+static void __devexit pti_pci_remove(struct pci_dev *pdev)
+{
+	struct pti_dev *drv_data = pci_get_drvdata(pdev);
+
+	iounmap(drv_data->pti_ioaddr);
+	pci_set_drvdata(pdev, NULL);
+	kfree(drv_data);
+	pci_release_region(pdev, 1);
+	pci_disable_device(pdev);
+}
+
 static struct pci_driver pti_pci_driver = {
 	.name		= PCINAME,
 	.id_table	= pci_ids,
-- 
1.7.10.4


