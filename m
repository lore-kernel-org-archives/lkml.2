Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab0DZMC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 08:02:56 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36394 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab0DZMCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 08:02:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dMxdjljDuGOD7TfAIszS9aCcnZ1UH9OzrMjIZ94FANUxeh5NHdtqyBSemtjPAEQh0C
         Y6KWYsQsup2c6aqFfGIYNuYKlgO11qodmrbjrMoxjUrN6QSDgy57vboVpvzqYG/YFgiH
         3Q7tSftPcfLPBFMFhDGUoDTLr7TPSgEDLNAy8=
From: Zachary R <zr.public@gmail.com>
To: zr.public@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: comedi: fixed coding style issues in drivers.c This patch fixes coding style issues found by checkpatch.pl, and doesnt line break string literals. Signed-off-by: Zachary Richey <zr.public@gmail.com>
Date: Mon, 26 Apr 2010 08:02:46 -0400
Message-Id: <1272283366-3316-1-git-send-email-zr.public@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <[PATCH] Staging: comedi: fixed coding style issues in drivers.c>
References: <[PATCH] Staging: comedi: fixed coding style issues in drivers.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/comedi/drivers.c |   36 ++++++++++++++++++++----------------
 1 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index 44d6b62..3c92be1 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -102,7 +102,7 @@ static void __comedi_device_detach(struct comedi_device *dev)
 	if (dev->driver)
 		dev->driver->detach(dev);
 	else
-		printk("BUG: dev->driver=NULL in comedi_device_detach()\n");
+		printk(KERN_WARNING "BUG: dev->driver=NULL in comedi_device_detach()\n");
 	cleanup_device(dev);
 }
 
@@ -124,7 +124,7 @@ int comedi_device_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	for (driv = comedi_drivers; driv; driv = driv->next) {
 		if (!try_module_get(driv->module)) {
 			printk
-			    ("comedi: failed to increment module count, skipping\n");
+			    (KERN_INFO "comedi: failed to increment module count, skipping\n");
 			continue;
 		}
 		if (driv->num_names) {
@@ -139,7 +139,8 @@ int comedi_device_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 				continue;
 			}
 		}
-		/* initialize dev->driver here so comedi_error() can be called from attach */
+		/* initialize dev->driver here so
+		*comedi_error() can be called from attach */
 		dev->driver = driv;
 		ret = driv->attach(dev, it);
 		if (ret < 0) {
@@ -154,7 +155,7 @@ int comedi_device_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	/*  report valid board names before returning error */
 	for (driv = comedi_drivers; driv; driv = driv->next) {
 		if (!try_module_get(driv->module)) {
-			printk("comedi: failed to increment module count\n");
+			printk(KERN_INFO "comedi: failed to increment module count\n");
 			continue;
 		}
 		comedi_report_boards(driv);
@@ -172,7 +173,7 @@ attached:
 	}
 
 	if (!dev->board_name) {
-		printk("BUG: dev->board_name=<%p>\n", dev->board_name);
+		printk(KERN_WARNING "BUG: dev->board_name=<%p>\n", dev->board_name);
 		dev->board_name = "BUG";
 	}
 	smp_wmb();
@@ -208,7 +209,7 @@ int comedi_driver_unregister(struct comedi_driver *driver)
 		if (dev->attached && dev->driver == driver) {
 			if (dev->use_count)
 				printk
-				    ("BUG! detaching device with use_count=%d\n",
+				    (KERN_WARNING "BUG! detaching device with use_count=%d\n",
 				     dev->use_count);
 			comedi_device_detach(dev);
 		}
@@ -253,7 +254,7 @@ static int postconfig(struct comedi_device *dev)
 			async =
 			    kzalloc(sizeof(struct comedi_async), GFP_KERNEL);
 			if (async == NULL) {
-				printk("failed to allocate async struct\n");
+				printk(KERN_INFO "failed to allocate async struct\n");
 				return -ENOMEM;
 			}
 			init_waitqueue_head(&async->wait_head);
@@ -268,7 +269,7 @@ static int postconfig(struct comedi_device *dev)
 			async->prealloc_buf = NULL;
 			async->prealloc_bufsz = 0;
 			if (comedi_buf_alloc(dev, s, DEFAULT_BUF_SIZE) < 0) {
-				printk("Buffer allocation failed\n");
+				printk(KERN_INFO "Buffer allocation failed\n");
 				return -ENOMEM;
 			}
 			if (s->buf_change) {
@@ -303,7 +304,8 @@ static int postconfig(struct comedi_device *dev)
 	return 0;
 }
 
-/*  generic recognize function for drivers that register their supported board names */
+/*  generic recognize function for drivers
+*that register their supported board names */
 void *comedi_recognize(struct comedi_driver *driv, const char *name)
 {
 	unsigned i;
@@ -324,17 +326,17 @@ void comedi_report_boards(struct comedi_driver *driv)
 	unsigned int i;
 	const char *const *name_ptr;
 
-	printk("comedi: valid board names for %s driver are:\n",
+	printk(KERN_INFO "comedi: valid board names for %s driver are:\n",
 	       driv->driver_name);
 
 	name_ptr = driv->board_name;
 	for (i = 0; i < driv->num_names; i++) {
-		printk(" %s\n", *name_ptr);
+		printk(KERN_INFO " %s\n", *name_ptr);
 		name_ptr = (const char **)((char *)name_ptr + driv->offset);
 	}
 
 	if (driv->num_names == 0)
-		printk(" %s\n", driv->driver_name);
+		printk(KERN_INFO " %s\n", driv->driver_name);
 }
 
 static int poll_invalid(struct comedi_device *dev, struct comedi_subdevice *s)
@@ -568,7 +570,7 @@ unsigned int comedi_buf_munge(struct comedi_async *async,
 
 		block_size = num_bytes - count;
 		if (block_size < 0) {
-			printk("%s: %s: bug! block_size is negative\n",
+			printk(KERN_WARNING "%s: %s: bug! block_size is negative\n",
 			       __FILE__, __func__);
 			break;
 		}
@@ -579,7 +581,8 @@ unsigned int comedi_buf_munge(struct comedi_async *async,
 		s->munge(s->device, s, async->prealloc_buf + async->munge_ptr,
 			 block_size, async->munge_chan);
 
-		smp_wmb();	/* barrier insures data is munged in buffer before munge_count is incremented */
+		smp_wmb();	/* barrier insures data is munged in buffer
+				*before munge_count is incremented */
 
 		async->munge_chan += block_size / num_sample_bytes;
 		async->munge_chan %= async->cmd.chanlist_len;
@@ -649,7 +652,7 @@ unsigned comedi_buf_write_free(struct comedi_async *async, unsigned int nbytes)
 	if ((int)(async->buf_write_count + nbytes -
 		  async->buf_write_alloc_count) > 0) {
 		printk
-		    ("comedi: attempted to write-free more bytes than have been write-allocated.\n");
+		    (KERN_INFO "comedi: attempted to write-free more bytes than have been write-allocated.\n");
 		nbytes = async->buf_write_alloc_count - async->buf_write_count;
 	}
 	async->buf_write_count += nbytes;
@@ -678,7 +681,8 @@ unsigned comedi_buf_read_alloc(struct comedi_async *async, unsigned nbytes)
 /* transfers control of a chunk from reader to free buffer space */
 unsigned comedi_buf_read_free(struct comedi_async *async, unsigned int nbytes)
 {
-	/*  barrier insures data has been read out of buffer before read count is incremented */
+	/*  barrier insures data has been read out of
+	*buffer before read count is incremented */
 	smp_mb();
 	if ((int)(async->buf_read_count + nbytes -
 		  async->buf_read_alloc_count) > 0) {
-- 
1.6.3.3

