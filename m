Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335Ab2HUETF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 00:19:05 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:36807 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab2HUETD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 00:19:03 -0400
MIME-Version: 1.0
Date: Tue, 21 Aug 2012 12:19:01 +0800
Message-ID: <CAPgLHd8jKLn1mQApsC3N4uW+4oj+mAW=xsYp8gXW2Ue+ueNDTQ@mail.gmail.com>
Subject: [PATCH] vme: vme_tsi148.c: fix to use list_for_each_safe() when
 delete list items
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
list_for_each_safe(). 

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/vme/bridges/vme_tsi148.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/vme/bridges/vme_tsi148.c b/drivers/vme/bridges/vme_tsi148.c
index 880d924..5fbd08f 100644
--- a/drivers/vme/bridges/vme_tsi148.c
+++ b/drivers/vme/bridges/vme_tsi148.c
@@ -2350,7 +2350,7 @@ static int tsi148_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	int retval, i, master_num;
 	u32 data;
-	struct list_head *pos = NULL;
+	struct list_head *pos = NULL, *n;
 	struct vme_bridge *tsi148_bridge;
 	struct tsi148_driver *tsi148_device;
 	struct vme_master_resource *master_image;
@@ -2615,28 +2615,28 @@ err_reg:
 err_crcsr:
 err_lm:
 	/* resources are stored in link list */
-	list_for_each(pos, &tsi148_bridge->lm_resources) {
+	list_for_each_safe(pos, n, &tsi148_bridge->lm_resources) {
 		lm = list_entry(pos, struct vme_lm_resource, list);
 		list_del(pos);
 		kfree(lm);
 	}
 err_dma:
 	/* resources are stored in link list */
-	list_for_each(pos, &tsi148_bridge->dma_resources) {
+	list_for_each_safe(pos, n, &tsi148_bridge->dma_resources) {
 		dma_ctrlr = list_entry(pos, struct vme_dma_resource, list);
 		list_del(pos);
 		kfree(dma_ctrlr);
 	}
 err_slave:
 	/* resources are stored in link list */
-	list_for_each(pos, &tsi148_bridge->slave_resources) {
+	list_for_each_safe(pos, n, &tsi148_bridge->slave_resources) {
 		slave_image = list_entry(pos, struct vme_slave_resource, list);
 		list_del(pos);
 		kfree(slave_image);
 	}
 err_master:
 	/* resources are stored in link list */
-	list_for_each(pos, &tsi148_bridge->master_resources) {
+	list_for_each_safe(pos, n, &tsi148_bridge->master_resources) {
 		master_image = list_entry(pos, struct vme_master_resource,
 			list);
 		list_del(pos);


