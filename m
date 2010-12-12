Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867Ab0LLIFF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 03:05:05 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56527 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab0LLIE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 03:04:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BCPzZzolMFKeWJ4jRgCC8jPd4FmXtRsVopwi3TEZ1klog3ucKsKt+nCRWcsGMF4Enj
         EgMXRuBn9NlYfYvv+F4DwMcEVN3t4jpYXEIJ100BVifWlBE+e8Fy4mhpSiL6TGWYbpby
         O9sJaWLsfmU64miamL/WCfVoP9yuTgPkswGF8=
From: Namhyung Kim <namhyung@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Martyn Welch <martyn.welch@ge.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Staging: vme_tsi148: use __dev{init,exit} for ->probe/remove
Date: Sun, 12 Dec 2010 17:04:28 +0900
Message-Id: <1292141068-31458-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.3.400.g93cef
In-Reply-To: <1292141068-31458-1-git-send-email-namhyung@gmail.com>
References: <1292141068-31458-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/staging/vme/bridges/vme_tsi148.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
index 2f5b70986998..0ec9fa4768c2 100644
--- a/drivers/staging/vme/bridges/vme_tsi148.c
+++ b/drivers/staging/vme/bridges/vme_tsi148.c
@@ -35,8 +35,9 @@
 #include "vme_tsi148.h"
 
 static int __init tsi148_init(void);
-static int tsi148_probe(struct pci_dev *, const struct pci_device_id *);
-static void tsi148_remove(struct pci_dev *);
+static int __devinit tsi148_probe(struct pci_dev *,
+				  const struct pci_device_id *);
+static void __devexit tsi148_remove(struct pci_dev *);
 static void __exit tsi148_exit(void);
 
 
@@ -55,7 +56,7 @@ static struct pci_driver tsi148_driver = {
 	.name = driver_name,
 	.id_table = tsi148_ids,
 	.probe = tsi148_probe,
-	.remove = tsi148_remove,
+	.remove = __devexit_p(tsi148_remove),
 };
 
 static void reg_join(unsigned int high, unsigned int low,
@@ -2215,7 +2216,8 @@ static void tsi148_crcsr_exit(struct vme_bridge *tsi148_bridge,
 		bridge->crcsr_bus);
 }
 
-static int tsi148_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+static int __devinit tsi148_probe(struct pci_dev *pdev,
+				  const struct pci_device_id *id)
 {
 	int retval, i, master_num;
 	u32 data;
@@ -2528,7 +2530,7 @@ err_struct:
 
 }
 
-static void tsi148_remove(struct pci_dev *pdev)
+static void __devexit tsi148_remove(struct pci_dev *pdev)
 {
 	struct list_head *pos = NULL;
 	struct vme_master_resource *master_image;
-- 
1.7.3.3.400.g93cef

