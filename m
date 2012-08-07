Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340Ab2HGTyG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:54:06 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:49820 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756300Ab2HGTyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:54:04 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        J Freyensee <james_p_freyensee@linux.intel.com>
Subject: [PATCH 05/41] misc: pti, pci drvdata cannot be NULL in ->remove
Date: Tue,  7 Aug 2012 21:47:30 +0200
Message-Id: <1344368886-24033-6-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
References: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we set drvdata unconditionally in ->probe, we need not check if it
is NULL. Let us remove the check.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: J Freyensee <james_p_freyensee@linux.intel.com>
---
 drivers/misc/pti.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/misc/pti.c b/drivers/misc/pti.c
index 5cb61f7..88da085e 100644
--- a/drivers/misc/pti.c
+++ b/drivers/misc/pti.c
@@ -400,16 +400,13 @@ EXPORT_SYMBOL_GPL(pti_writedata);
  */
 static void __devexit pti_pci_remove(struct pci_dev *pdev)
 {
-	struct pti_dev *drv_data;
+	struct pti_dev *drv_data = pci_get_drvdata(pdev);
 
-	drv_data = pci_get_drvdata(pdev);
-	if (drv_data != NULL) {
-		pci_iounmap(pdev, drv_data->pti_ioaddr);
-		pci_set_drvdata(pdev, NULL);
-		kfree(drv_data);
-		pci_release_region(pdev, 1);
-		pci_disable_device(pdev);
-	}
+	pci_iounmap(pdev, drv_data->pti_ioaddr);
+	pci_set_drvdata(pdev, NULL);
+	kfree(drv_data);
+	pci_release_region(pdev, 1);
+	pci_disable_device(pdev);
 }
 
 /*
-- 
1.7.10.4


