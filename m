Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290Ab2HUERi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 00:17:38 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:50396 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab2HUERf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 00:17:35 -0400
MIME-Version: 1.0
Date: Tue, 21 Aug 2012 12:17:34 +0800
Message-ID: <CAPgLHd9ASkPtFRw5gPWtGa+=KiGr93kxHJ6EaihcJVxVnPpz8A@mail.gmail.com>
Subject: [PATCH] vme: vme_ca91cx42.c: use list_for_each_safe() when delete
 list items
From: Wei Yongjun <weiyj.lk@gmail.com>
To: martyn.welch@ge.com, manohar.vanga@gmail.com, gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Since we will be removing items off the list using list_del() we need
to use a safer version of the list_for_each() macro aptly named
list_for_each_safe(). We should use the safe macro if the loop
involves deletions of items.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/vme/bridges/vme_ca91cx42.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/vme/bridges/vme_ca91cx42.c b/drivers/vme/bridges/vme_ca91cx42.c
index e0df92e..1425d22c 100644
--- a/drivers/vme/bridges/vme_ca91cx42.c
+++ b/drivers/vme/bridges/vme_ca91cx42.c
@@ -1603,7 +1603,7 @@ static int ca91cx42_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	int retval, i;
 	u32 data;
-	struct list_head *pos = NULL;
+	struct list_head *pos = NULL, *n;
 	struct vme_bridge *ca91cx42_bridge;
 	struct ca91cx42_driver *ca91cx42_device;
 	struct vme_master_resource *master_image;
@@ -1821,28 +1821,28 @@ err_reg:
 	ca91cx42_crcsr_exit(ca91cx42_bridge, pdev);
 err_lm:
 	/* resources are stored in link list */
-	list_for_each(pos, &ca91cx42_bridge->lm_resources) {
+	list_for_each_safe(pos, n, &ca91cx42_bridge->lm_resources) {
 		lm = list_entry(pos, struct vme_lm_resource, list);
 		list_del(pos);
 		kfree(lm);
 	}
 err_dma:
 	/* resources are stored in link list */
-	list_for_each(pos, &ca91cx42_bridge->dma_resources) {
+	list_for_each_safe(pos, n, &ca91cx42_bridge->dma_resources) {
 		dma_ctrlr = list_entry(pos, struct vme_dma_resource, list);
 		list_del(pos);
 		kfree(dma_ctrlr);
 	}
 err_slave:
 	/* resources are stored in link list */
-	list_for_each(pos, &ca91cx42_bridge->slave_resources) {
+	list_for_each_safe(pos, n, &ca91cx42_bridge->slave_resources) {
 		slave_image = list_entry(pos, struct vme_slave_resource, list);
 		list_del(pos);
 		kfree(slave_image);
 	}
 err_master:
 	/* resources are stored in link list */
-	list_for_each(pos, &ca91cx42_bridge->master_resources) {
+	list_for_each_safe(pos, n, &ca91cx42_bridge->master_resources) {
 		master_image = list_entry(pos, struct vme_master_resource,
 			list);
 		list_del(pos);
@@ -1868,7 +1868,7 @@ err_struct:
 
 static void ca91cx42_remove(struct pci_dev *pdev)
 {
-	struct list_head *pos = NULL;
+	struct list_head *pos = NULL, *n;
 	struct vme_master_resource *master_image;
 	struct vme_slave_resource *slave_image;
 	struct vme_dma_resource *dma_ctrlr;
@@ -1905,28 +1905,28 @@ static void ca91cx42_remove(struct pci_dev *pdev)
 	ca91cx42_crcsr_exit(ca91cx42_bridge, pdev);
 
 	/* resources are stored in link list */
-	list_for_each(pos, &ca91cx42_bridge->lm_resources) {
+	list_for_each_safe(pos, n, &ca91cx42_bridge->lm_resources) {
 		lm = list_entry(pos, struct vme_lm_resource, list);
 		list_del(pos);
 		kfree(lm);
 	}
 
 	/* resources are stored in link list */
-	list_for_each(pos, &ca91cx42_bridge->dma_resources) {
+	list_for_each_safe(pos, n, &ca91cx42_bridge->dma_resources) {
 		dma_ctrlr = list_entry(pos, struct vme_dma_resource, list);
 		list_del(pos);
 		kfree(dma_ctrlr);
 	}
 
 	/* resources are stored in link list */
-	list_for_each(pos, &ca91cx42_bridge->slave_resources) {
+	list_for_each_safe(pos, n, &ca91cx42_bridge->slave_resources) {
 		slave_image = list_entry(pos, struct vme_slave_resource, list);
 		list_del(pos);
 		kfree(slave_image);
 	}
 
 	/* resources are stored in link list */
-	list_for_each(pos, &ca91cx42_bridge->master_resources) {
+	list_for_each_safe(pos, n, &ca91cx42_bridge->master_resources) {
 		master_image = list_entry(pos, struct vme_master_resource,
 			list);
 		list_del(pos);


