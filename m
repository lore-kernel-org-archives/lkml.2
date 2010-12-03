Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab0LCVbi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 16:31:38 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:40304 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab0LCVbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 16:31:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=SpMZ6qj6IzUmh2jo+lQynxBz6tzICCGUn0eVOZngXFXIFHx4ATKM+gF4Q3dXuyiO47
         WQ9RTFDHKHtHTCxiGJJ+KWInORUlogfTnhrUUgYU0VHixCqBs+0zUDIVPpWHk0n+1NHV
         LgZ7rMzxPn7CfUhi8OCk7TvVfsvk4sf+dKAGE=
From: Xenofon Foukas <foukas.xenofon@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Xenofon Foukas <foukas.xenofon@gmail.com>
Subject: [PATCH] Fix coding style issues in drivers.c
Date: Fri,  3 Dec 2010 23:31:17 +0200
Message-Id: <1291411877-15579-1-git-send-email-foukas.xenofon@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes line over 80 characters warning issues found
in file drivers.c
Signed-off-by: Xenofon Foukas <foukas.xenofon@gmail.com>
---
 drivers/staging/comedi/drivers.c |   26 ++++++++++++++++++--------
 1 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index 4a29ed7..840b7e0 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -118,7 +118,8 @@ int comedi_device_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	for (driv = comedi_drivers; driv; driv = driv->next) {
 		if (!try_module_get(driv->module)) {
 			printk
-			    (KERN_INFO "comedi: failed to increment module count, skipping\n");
+			     (KERN_INFO "comedi: failed to increment "
+						"module count, skipping\n");
 			continue;
 		}
 		if (driv->num_names) {
@@ -206,8 +207,9 @@ int comedi_driver_unregister(struct comedi_driver *driver)
 		if (dev->attached && dev->driver == driver) {
 			if (dev->use_count)
 				printk
-				    (KERN_WARNING "BUG! detaching device with use_count=%d\n",
-				     dev->use_count);
+				    (KERN_WARNING "BUG! detaching device "
+						"with use_count=%d\n",
+						dev->use_count);
 			comedi_device_detach(dev);
 		}
 		mutex_unlock(&dev->mutex);
@@ -442,7 +444,9 @@ int comedi_buf_alloc(struct comedi_device *dev, struct comedi_subdevice *s,
 		unsigned i;
 		for (i = 0; i < async->n_buf_pages; ++i) {
 			if (async->buf_page_list[i].virt_addr) {
-				clear_bit(PG_reserved, &(virt_to_page(async->buf_page_list[i].virt_addr)->flags));
+				clear_bit(PG_reserved,
+					&(virt_to_page(async->buf_page_list[i].
+							virt_addr)->flags));
 				if (s->async_dma_dir != DMA_NONE) {
 					dma_free_coherent(dev->hw_dev,
 							  PAGE_SIZE,
@@ -496,8 +500,10 @@ int comedi_buf_alloc(struct comedi_device *dev, struct comedi_subdevice *s,
 					break;
 
 				set_bit(PG_reserved,
-					&(virt_to_page(async->buf_page_list[i].virt_addr)->flags));
-				pages[i] = virt_to_page(async->buf_page_list[i].virt_addr);
+					&(virt_to_page(async->buf_page_list[i].
+							virt_addr)->flags));
+				pages[i] = virt_to_page(async->buf_page_list[i].
+								virt_addr);
 			}
 		}
 		if (i == n_pages) {
@@ -514,7 +520,10 @@ int comedi_buf_alloc(struct comedi_device *dev, struct comedi_subdevice *s,
 					    NULL) {
 						break;
 					}
-					clear_bit(PG_reserved, &(virt_to_page(async->buf_page_list[i].virt_addr)->flags));
+					clear_bit(PG_reserved,
+						&(virt_to_page(async->
+							buf_page_list[i].
+							virt_addr)->flags));
 					if (s->async_dma_dir != DMA_NONE) {
 						dma_free_coherent(dev->hw_dev,
 								  PAGE_SIZE,
@@ -647,7 +656,8 @@ unsigned comedi_buf_write_free(struct comedi_async *async, unsigned int nbytes)
 	if ((int)(async->buf_write_count + nbytes -
 		  async->buf_write_alloc_count) > 0) {
 		printk
-		    (KERN_INFO "comedi: attempted to write-free more bytes than have been write-allocated.\n");
+		    (KERN_INFO "comedi: attempted to write-free more bytes "
+					"than have been write-allocated.\n");
 		nbytes = async->buf_write_alloc_count - async->buf_write_count;
 	}
 	async->buf_write_count += nbytes;
-- 
1.7.3.2

