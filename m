Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab0FLUOy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 16:14:54 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:42252 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab0FLUOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 16:14:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=EE4nhgF1OGBo5MdnpaX8MRj33KDko/CMaoH1XHJ61ZpMI589R9A+FuqIFz9MoJys3G
         +6R5/CejTtvILR41LAYRU/DffvF/YCqzUR9vhXm7cNUOCIirdatQLEQX54NabCGm8EmZ
         clwGSWS7fldQEoEPJ1rW2DXwUeZXlcBHTnU3I=
From: =?UTF-8?q?Henri=20H=C3=A4kkinen?= <henuxd@gmail.com>
To: gregkh@suse.de, mithlesh@linsyssoft.com, wfp5p@virginia.edu,
       reodge@gmail.com, andrea.gelmini@gelma.net, henuxd@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging:comedi: Fixed coding convention issues.
Date: Sat, 12 Jun 2010 13:14:41 +0300
Message-Id: <1276337681-4327-1-git-send-email-henuxd@gmail.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleaned up and fixed coding convention issues as reporteed by
checkpatch.pl tool on the file `drivers.c'.

Signed-off-by: Henri Häkkinen <henuxd@gmail.com>
---
 drivers/staging/comedi/drivers.c |   85 +++++++++++++++++++------------------
 1 files changed, 44 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index 4a29ed7..55521d5 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -117,8 +117,8 @@ int comedi_device_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	for (driv = comedi_drivers; driv; driv = driv->next) {
 		if (!try_module_get(driv->module)) {
-			printk
-			    (KERN_INFO "comedi: failed to increment module count, skipping\n");
+			printk(KERN_INFO "comedi: failed to increment module "
+			       "count, skipping\n");
 			continue;
 		}
 		if (driv->num_names) {
@@ -205,9 +205,8 @@ int comedi_driver_unregister(struct comedi_driver *driver)
 		mutex_lock(&dev->mutex);
 		if (dev->attached && dev->driver == driver) {
 			if (dev->use_count)
-				printk
-				    (KERN_WARNING "BUG! detaching device with use_count=%d\n",
-				     dev->use_count);
+				printk(KERN_WARNING "BUG! detaching device "
+				       "with use_count=%d\n", dev->use_count);
 			comedi_device_detach(dev);
 		}
 		mutex_unlock(&dev->mutex);
@@ -441,21 +440,19 @@ int comedi_buf_alloc(struct comedi_device *dev, struct comedi_subdevice *s,
 	if (async->buf_page_list) {
 		unsigned i;
 		for (i = 0; i < async->n_buf_pages; ++i) {
-			if (async->buf_page_list[i].virt_addr) {
-				clear_bit(PG_reserved, &(virt_to_page(async->buf_page_list[i].virt_addr)->flags));
+			void *virt_addr = async->buf_page_list[i].virt_addr;
+			dma_addr_t dma_addr = async->buf_page_list[i].dma_addr;
+
+			if (virt_addr) {
+				struct page *page = virt_to_page(virt_addr);
+				clear_bit(PG_reserved, &page->flags);
 				if (s->async_dma_dir != DMA_NONE) {
 					dma_free_coherent(dev->hw_dev,
 							  PAGE_SIZE,
-							  async->
-							  buf_page_list
-							  [i].virt_addr,
-							  async->
-							  buf_page_list
-							  [i].dma_addr);
+							  virt_addr,
+							  dma_addr);
 				} else {
-					free_page((unsigned long)
-						  async->buf_page_list[i].
-						  virt_addr);
+					free_page((unsigned long) virt_addr);
 				}
 			}
 		}
@@ -478,26 +475,29 @@ int comedi_buf_alloc(struct comedi_device *dev, struct comedi_subdevice *s,
 		}
 		if (pages) {
 			for (i = 0; i < n_pages; i++) {
+				struct comedi_buf_page *buf_page =
+					&async->buf_page_list[i];
+				dma_addr_t dma_addr = buf_page->dma_addr;
+				struct page *page;
+
 				if (s->async_dma_dir != DMA_NONE) {
-					async->buf_page_list[i].virt_addr =
+					buf_page->virt_addr =
 					    dma_alloc_coherent(dev->hw_dev,
 							       PAGE_SIZE,
-							       &async->
-							       buf_page_list
-							       [i].dma_addr,
+							       &dma_addr,
 							       GFP_KERNEL |
 							       __GFP_COMP);
 				} else {
-					async->buf_page_list[i].virt_addr =
+					buf_page->virt_addr =
 					    (void *)
 					    get_zeroed_page(GFP_KERNEL);
 				}
-				if (async->buf_page_list[i].virt_addr == NULL)
+				if (buf_page->virt_addr == NULL)
 					break;
 
-				set_bit(PG_reserved,
-					&(virt_to_page(async->buf_page_list[i].virt_addr)->flags));
-				pages[i] = virt_to_page(async->buf_page_list[i].virt_addr);
+				page = virt_to_page(buf_page->virt_addr);
+				set_bit(PG_reserved, &page->flags);
+				pages[i] = page;
 			}
 		}
 		if (i == n_pages) {
@@ -510,24 +510,27 @@ int comedi_buf_alloc(struct comedi_device *dev, struct comedi_subdevice *s,
 			/* Some allocation failed above. */
 			if (async->buf_page_list) {
 				for (i = 0; i < n_pages; i++) {
-					if (async->buf_page_list[i].virt_addr ==
-					    NULL) {
+					struct comedi_buf_page *buf_page =
+						&async->buf_page_list[i];
+					void *virt_addr =
+						buf_page->virt_addr;
+					dma_addr_t dma_addr =
+						buf_page->dma_addr;
+					struct page *page =
+						virt_to_page(virt_addr);
+
+					if (virt_addr == NULL)
 						break;
-					}
-					clear_bit(PG_reserved, &(virt_to_page(async->buf_page_list[i].virt_addr)->flags));
+
+					clear_bit(PG_reserved, &page->flags);
 					if (s->async_dma_dir != DMA_NONE) {
 						dma_free_coherent(dev->hw_dev,
 								  PAGE_SIZE,
-								  async->
-								  buf_page_list
-								  [i].virt_addr,
-								  async->
-								  buf_page_list
-								  [i].dma_addr);
+								  virt_addr,
+								  dma_addr);
 					} else {
 						free_page((unsigned long)
-							  async->buf_page_list
-							  [i].virt_addr);
+							  virt_addr);
 					}
 				}
 				vfree(async->buf_page_list);
@@ -646,8 +649,8 @@ unsigned comedi_buf_write_free(struct comedi_async *async, unsigned int nbytes)
 {
 	if ((int)(async->buf_write_count + nbytes -
 		  async->buf_write_alloc_count) > 0) {
-		printk
-		    (KERN_INFO "comedi: attempted to write-free more bytes than have been write-allocated.\n");
+		printk(KERN_INFO "comedi: attempted to write-free more bytes "
+		       "than have been write-allocated.\n");
 		nbytes = async->buf_write_alloc_count - async->buf_write_count;
 	}
 	async->buf_write_count += nbytes;
@@ -683,8 +686,8 @@ unsigned comedi_buf_read_free(struct comedi_async *async, unsigned int nbytes)
 	smp_mb();
 	if ((int)(async->buf_read_count + nbytes -
 		  async->buf_read_alloc_count) > 0) {
-		printk(KERN_INFO
-		       "comedi: attempted to read-free more bytes than have been read-allocated.\n");
+		printk(KERN_INFO "comedi: attempted to read-free more bytes "
+		       "than have been read-allocated.\n");
 		nbytes = async->buf_read_alloc_count - async->buf_read_count;
 	}
 	async->buf_read_count += nbytes;
-- 
1.7.1

