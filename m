Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab0FQHAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 03:00:23 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:2586 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab0FQHAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 03:00:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=vxt/TVULGbdXmU+8UaOpwGr85uodFr3jgNZsr5IaVDVwAJpXK2OJ5ksxqZUCbu6kgA
         BOKJvRMe7X7yBwP8bvj+kamsqRRpFFOmyrMpeFWDmqIvXrRJKsXgOzXATmLcUavWiUxY
         HtJj0IZY5UPx3F+ffVjlz81k8WCvmqUpjFq2I=
From: Matti Lammi <mattij.lammi@gmail.com>
To: gregkh@suse.de, mithlesh@linsyssoft.com, wfp5p@virginia.edu,
       reodge@gmail.com, andrea.gelmini@gelma.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Matti Lammi <mattij.lammi@gmail.com>
Subject: [PATCH] Staging: Commedi: Fixed some warnings reported by checkpatch.pl tool
Date: Thu, 17 Jun 2010 10:00:11 +0300
Message-Id: <1276758011-7054-1-git-send-email-mattij.lammi@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a few "line over 80 characters" warnings. One of those lines were an
actual code line and I don't know if my corresction is sufficent with that
part. This is my third patch.

Signed-off-by: Matti Lammi <mattij.lammi@gmail.com>
---
 drivers/staging/comedi/drivers.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index 4a29ed7..9dcc5ef 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -118,7 +118,8 @@ int comedi_device_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	for (driv = comedi_drivers; driv; driv = driv->next) {
 		if (!try_module_get(driv->module)) {
 			printk
-			    (KERN_INFO "comedi: failed to increment module count, skipping\n");
+			    (KERN_INFO "comedi: failed to increment "
+			     "module count, skipping\n");
 			continue;
 		}
 		if (driv->num_names) {
@@ -206,8 +207,8 @@ int comedi_driver_unregister(struct comedi_driver *driver)
 		if (dev->attached && dev->driver == driver) {
 			if (dev->use_count)
 				printk
-				    (KERN_WARNING "BUG! detaching device with use_count=%d\n",
-				     dev->use_count);
+				    (KERN_WARNING "BUG! detaching device "
+				     "with use_count=%d\n", dev->use_count);
 			comedi_device_detach(dev);
 		}
 		mutex_unlock(&dev->mutex);
@@ -442,7 +443,9 @@ int comedi_buf_alloc(struct comedi_device *dev, struct comedi_subdevice *s,
 		unsigned i;
 		for (i = 0; i < async->n_buf_pages; ++i) {
 			if (async->buf_page_list[i].virt_addr) {
-				clear_bit(PG_reserved, &(virt_to_page(async->buf_page_list[i].virt_addr)->flags));
+				clear_bit(PG_reserved,
+				&(virt_to_page(async->buf_page_list[i].
+					       virt_addr)->flags));
 				if (s->async_dma_dir != DMA_NONE) {
 					dma_free_coherent(dev->hw_dev,
 							  PAGE_SIZE,
@@ -647,7 +650,8 @@ unsigned comedi_buf_write_free(struct comedi_async *async, unsigned int nbytes)
 	if ((int)(async->buf_write_count + nbytes -
 		  async->buf_write_alloc_count) > 0) {
 		printk
-		    (KERN_INFO "comedi: attempted to write-free more bytes than have been write-allocated.\n");
+		    (KERN_INFO "comedi: attempted to write-free more "
+		     "bytes than have been write-allocated.\n");
 		nbytes = async->buf_write_alloc_count - async->buf_write_count;
 	}
 	async->buf_write_count += nbytes;
@@ -684,7 +688,8 @@ unsigned comedi_buf_read_free(struct comedi_async *async, unsigned int nbytes)
 	if ((int)(async->buf_read_count + nbytes -
 		  async->buf_read_alloc_count) > 0) {
 		printk(KERN_INFO
-		       "comedi: attempted to read-free more bytes than have been read-allocated.\n");
+		       "comedi: attempted to read-free more bytes "
+		       "than have been read-allocated.\n");
 		nbytes = async->buf_read_alloc_count - async->buf_read_count;
 	}
 	async->buf_read_count += nbytes;
-- 
1.6.0.4

