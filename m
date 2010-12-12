Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691Ab0LLIE6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 03:04:58 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40652 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab0LLIE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 03:04:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=PahfqIGVhpSgtqaykF/6U6pQcMadIDEdhLVATbAaNI6XsEqNE3sjkIf0gVwNwW3BDo
         D/SvJ5AlvJMEB0rQGNpcRNXwkcMTng22adotaeHWjLAJsvakNphjyAxgJlBVl/tEtDC+
         h3ARoG7xjxPb0R8GVXZLRPxLC6z1UZ53XHzNs=
From: Namhyung Kim <namhyung@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Martyn Welch <martyn.welch@ge.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Staging: vme_ca91cx42: use __dev{init,exit} for ->probe/remove
Date: Sun, 12 Dec 2010 17:04:27 +0900
Message-Id: <1292141068-31458-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.3.400.g93cef
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/staging/vme/bridges/vme_ca91cx42.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vme/bridges/vme_ca91cx42.c b/drivers/staging/vme/bridges/vme_ca91cx42.c
index 7db44fe32762..d1df7d12f504 100644
--- a/drivers/staging/vme/bridges/vme_ca91cx42.c
+++ b/drivers/staging/vme/bridges/vme_ca91cx42.c
@@ -35,8 +35,9 @@
 #include "vme_ca91cx42.h"
 
 static int __init ca91cx42_init(void);
-static int ca91cx42_probe(struct pci_dev *, const struct pci_device_id *);
-static void ca91cx42_remove(struct pci_dev *);
+static int __devinit ca91cx42_probe(struct pci_dev *,
+				    const struct pci_device_id *);
+static void __devexit ca91cx42_remove(struct pci_dev *);
 static void __exit ca91cx42_exit(void);
 
 /* Module parameters */
@@ -53,7 +54,7 @@ static struct pci_driver ca91cx42_driver = {
 	.name = driver_name,
 	.id_table = ca91cx42_ids,
 	.probe = ca91cx42_probe,
-	.remove = ca91cx42_remove,
+	.remove = __devexit_p(ca91cx42_remove),
 };
 
 static u32 ca91cx42_DMA_irqhandler(struct ca91cx42_driver *bridge)
@@ -1565,7 +1566,8 @@ static void ca91cx42_crcsr_exit(struct vme_bridge *ca91cx42_bridge,
 		bridge->crcsr_bus);
 }
 
-static int ca91cx42_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+static int __devinit ca91cx42_probe(struct pci_dev *pdev,
+				    const struct pci_device_id *id)
 {
 	int retval, i;
 	u32 data;
@@ -1831,7 +1833,7 @@ err_struct:
 
 }
 
-void ca91cx42_remove(struct pci_dev *pdev)
+void __devexit ca91cx42_remove(struct pci_dev *pdev)
 {
 	struct list_head *pos = NULL;
 	struct vme_master_resource *master_image;
-- 
1.7.3.3.400.g93cef

