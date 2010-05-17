Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab0EQKth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 06:49:37 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:50100 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092Ab0EQKtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 06:49:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=qhxkMZx4xUTKEGoaGxjBOy31rdaPMiNV1BII9onzR8ijAFPwuXFL6/jzCJTjjUywvk
         ZEfy/1zkrgCzoGO6vvWI/oIbP2v+CdwK+WJWu3EUqz5wkwifEnSvZoNB/+k0hrN2UHy6
         2v0a1igDRv6B/2jQjIhrxKUHfYnhh0IUDNk5o=
From: Mark <reodge@gmail.com>
To: gregkh@suse.de
Cc: Mark <reodge@gmail.com>, Mithlesh Thukral <mithlesh@linsyssoft.com>,
       Bill Pemberton <wfp5p@virginia.edu>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: comedi: Fixed long line lengths in drivers.c
Date: Mon, 17 May 2010 18:48:31 +0800
Message-Id: <1274093311-6309-1-git-send-email-reodge@gmail.com>
X-Mailer: git-send-email 1.7.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch clears up some long line length warnings in drivers.c found by
checkpatch

Signed-off-by: Mark Rankilor <reodge@gmail.com>
---
 drivers/staging/comedi/drivers.c |   31 ++++++++++++++++++++++---------
 1 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index 4a29ed7..7da4625 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -117,8 +117,9 @@ int comedi_device_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	for (driv = comedi_drivers; driv; driv = driv->next) {
 		if (!try_module_get(driv->module)) {
-			printk
-			    (KERN_INFO "comedi: failed to increment module count, skipping\n");
+			printk(KERN_INFO
+			       "comedi: "
+			       "failed to increment module count, skipping\n");
 			continue;
 		}
 		if (driv->num_names) {
@@ -205,9 +206,10 @@ int comedi_driver_unregister(struct comedi_driver *driver)
 		mutex_lock(&dev->mutex);
 		if (dev->attached && dev->driver == driver) {
 			if (dev->use_count)
-				printk
-				    (KERN_WARNING "BUG! detaching device with use_count=%d\n",
-				     dev->use_count);
+				printk(KERN_WARNING
+				       "BUG! detaching device with use_count="
+				       "%d\n",
+				       dev->use_count);
 			comedi_device_detach(dev);
 		}
 		mutex_unlock(&dev->mutex);
@@ -442,7 +444,10 @@ int comedi_buf_alloc(struct comedi_device *dev, struct comedi_subdevice *s,
 		unsigned i;
 		for (i = 0; i < async->n_buf_pages; ++i) {
 			if (async->buf_page_list[i].virt_addr) {
-				clear_bit(PG_reserved, &(virt_to_page(async->buf_page_list[i].virt_addr)->flags));
+				clear_bit(PG_reserved,
+					  &(virt_to_page(async->
+							 buf_page_list[i].
+							 virt_addr)->flags));
 				if (s->async_dma_dir != DMA_NONE) {
 					dma_free_coherent(dev->hw_dev,
 							  PAGE_SIZE,
@@ -496,8 +501,12 @@ int comedi_buf_alloc(struct comedi_device *dev, struct comedi_subdevice *s,
 					break;
 
 				set_bit(PG_reserved,
-					&(virt_to_page(async->buf_page_list[i].virt_addr)->flags));
-				pages[i] = virt_to_page(async->buf_page_list[i].virt_addr);
+					&(virt_to_page(async->
+						       buf_page_list[i].
+						       virt_addr)->flags));
+				pages[i] = virt_to_page(async->
+							buf_page_list[i].
+							virt_addr);
 			}
 		}
 		if (i == n_pages) {
@@ -514,7 +523,11 @@ int comedi_buf_alloc(struct comedi_device *dev, struct comedi_subdevice *s,
 					    NULL) {
 						break;
 					}
-					clear_bit(PG_reserved, &(virt_to_page(async->buf_page_list[i].virt_addr)->flags));
+					clear_bit(PG_reserved,
+						  &(virt_to_page(async->
+								 buf_page_list
+								 [i].virt_addr)
+						    ->flags));
 					if (s->async_dma_dir != DMA_NONE) {
 						dma_free_coherent(dev->hw_dev,
 								  PAGE_SIZE,
-- 
1.7.0.5

