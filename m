Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab0LCWSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 17:18:09 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51967 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab0LCWSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 17:18:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ulVG0rfLFvz/5lPlMcrgHPyMac5b0roa2JGxyGgzJzB61rgCpvsL0KbqXtSOpn11yy
         snZyYr0fP1IepHTOmgayARY51zjwMHJdM+ED2A80U3tnnol89uo98ssYDc6MaQ+o9Sbe
         SWqiUuNj6LtWlSGfBOhI1T86RxBCNzy9ZnH6c=
From: Xenofon Foukas <foukas.xenofon@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Xenofon Foukas <foukas.xenofon@gmail.com>
Subject: [PATCH] Fix coding style issues in drivers.c
Date: Sat,  4 Dec 2010 00:17:55 +0200
Message-Id: <1291414675-17730-1-git-send-email-foukas.xenofon@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes line over 80 characters warning issues found
in file drivers.c
Signed-off-by: Xenofon Foukas <foukas.xenofon@gmail.com>
---
 drivers/staging/comedi/drivers.c |   26 +++++++++++++++-----------
 1 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index 4a29ed7..afdb391 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -117,8 +117,7 @@ int comedi_device_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	for (driv = comedi_drivers; driv; driv = driv->next) {
 		if (!try_module_get(driv->module)) {
-			printk
-			    (KERN_INFO "comedi: failed to increment module count, skipping\n");
+			printk(KERN_INFO "comedi: failed to increment module count, skipping\n");
 			continue;
 		}
 		if (driv->num_names) {
@@ -205,9 +204,8 @@ int comedi_driver_unregister(struct comedi_driver *driver)
 		mutex_lock(&dev->mutex);
 		if (dev->attached && dev->driver == driver) {
 			if (dev->use_count)
-				printk
-				    (KERN_WARNING "BUG! detaching device with use_count=%d\n",
-				     dev->use_count);
+				printk(KERN_WARNING "BUG! detaching device with use_count=%d\n",
+						dev->use_count);
 			comedi_device_detach(dev);
 		}
 		mutex_unlock(&dev->mutex);
@@ -442,7 +440,9 @@ int comedi_buf_alloc(struct comedi_device *dev, struct comedi_subdevice *s,
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
@@ -496,8 +496,10 @@ int comedi_buf_alloc(struct comedi_device *dev, struct comedi_subdevice *s,
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
@@ -514,7 +516,10 @@ int comedi_buf_alloc(struct comedi_device *dev, struct comedi_subdevice *s,
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
@@ -646,8 +651,7 @@ unsigned comedi_buf_write_free(struct comedi_async *async, unsigned int nbytes)
 {
 	if ((int)(async->buf_write_count + nbytes -
 		  async->buf_write_alloc_count) > 0) {
-		printk
-		    (KERN_INFO "comedi: attempted to write-free more bytes than have been write-allocated.\n");
+		printk(KERN_INFO "comedi: attempted to write-free more bytes than have been write-allocated.\n");
 		nbytes = async->buf_write_alloc_count - async->buf_write_count;
 	}
 	async->buf_write_count += nbytes;
-- 
1.7.3.2

