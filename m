Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933742Ab0KOUOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 15:14:45 -0500
Received: from mail.perches.com ([173.55.12.10]:1359 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933699Ab0KOUOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 15:14:12 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/11] drivers/staging: Remove unnecessary casts of pci_get_drvdata
Date: Mon, 15 Nov 2010 12:14:00 -0800
Message-Id: <c15fc4fc3882ce8f11157b846f6d772b29c6891f.1289851770.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289851770.git.joe@perches.com>
References: <cover.1289851770.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/crystalhd/crystalhd_lnx.c |    6 +++---
 drivers/staging/et131x/et131x_initpci.c   |    2 +-
 drivers/staging/wlags49_h2/wl_pci.c       |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
index 28c6b8c..719e70b 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.c
+++ b/drivers/staging/crystalhd/crystalhd_lnx.c
@@ -516,7 +516,7 @@ static void __devexit chd_dec_pci_remove(struct pci_dev *pdev)
 
 	BCMLOG_ENTER;
 
-	pinfo = (struct crystalhd_adp *) pci_get_drvdata(pdev);
+	pinfo = pci_get_drvdata(pdev);
 	if (!pinfo) {
 		BCMLOG_ERR("could not get adp\n");
 		return;
@@ -626,7 +626,7 @@ int chd_dec_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	struct crystalhd_ioctl_data *temp;
 	enum BC_STATUS sts = BC_STS_SUCCESS;
 
-	adp = (struct crystalhd_adp *)pci_get_drvdata(pdev);
+	adp = pci_get_drvdata(pdev);
 	if (!adp) {
 		BCMLOG_ERR("could not get adp\n");
 		return -ENODEV;
@@ -660,7 +660,7 @@ int chd_dec_pci_resume(struct pci_dev *pdev)
 	enum BC_STATUS sts = BC_STS_SUCCESS;
 	int rc;
 
-	adp = (struct crystalhd_adp *)pci_get_drvdata(pdev);
+	adp = pci_get_drvdata(pdev);
 	if (!adp) {
 		BCMLOG_ERR("could not get adp\n");
 		return -ENODEV;
diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index 10bcb45..f62ba7a 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -783,7 +783,7 @@ static void __devexit et131x_pci_remove(struct pci_dev *pdev)
 	/* Retrieve the net_device pointer from the pci_dev struct, as well
 	 * as the private adapter struct
 	 */
-	netdev = (struct net_device *) pci_get_drvdata(pdev);
+	netdev = pci_get_drvdata(pdev);
 	adapter = netdev_priv(netdev);
 
 	/* Perform device cleanup */
diff --git a/drivers/staging/wlags49_h2/wl_pci.c b/drivers/staging/wlags49_h2/wl_pci.c
index 020b17a..28ae9dd 100644
--- a/drivers/staging/wlags49_h2/wl_pci.c
+++ b/drivers/staging/wlags49_h2/wl_pci.c
@@ -458,7 +458,7 @@ void __devexit wl_pci_remove(struct pci_dev *pdev)
         return;
     }
 
-    dev = (struct net_device *)pci_get_drvdata( pdev );
+    dev = pci_get_drvdata( pdev );
     if( dev == NULL ) {
         DBG_ERROR( DbgInfo, "Could not retrieve net_device structure\n" );
         return;
-- 
1.7.3.1.g432b3.dirty

