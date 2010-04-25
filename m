Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab0DYN6l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 09:58:41 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:32865 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab0DYN6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 09:58:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ejkqBvKggJrjmUuEEapAL1uS7E5xCvi1ESEAbSFJFGUgu+5/gxSBEJ3pH1mdshD46C
         S6tQOH4kM2Tuc92+kn4Gp/AUhe/eSmvdhqJ5L7sDSgf2zU4uKoCpWThQPcK+FhH2o4zN
         eIRzlMCgoKkPoOWYypDNcNBdSXICRlvx1tjrU=
From: zr.public@gmail.com
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Zachary_r <zr.public@gmail.com>
Subject: [PATCH] Staging: comedi: fixed coding style issues in drivers.c
Date: Sun, 25 Apr 2010 09:58:11 -0400
Message-Id: <1272203891-15546-1-git-send-email-zr.public@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zachary_r <zr.public@gmail.com>

This patch to drivers.c fixes a majority of the warnings from checkpatch.pl
Signed-off-by: Zachary Richey <zr.public@gmail.com>
---
 drivers/staging/comedi/drivers.c |   61 +++++++++++++++++++++++---------------
 1 files changed, 37 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index 44d6b62..1314bf8 100644
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
 
@@ -123,8 +123,8 @@ int comedi_device_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	for (driv = comedi_drivers; driv; driv = driv->next) {
 		if (!try_module_get(driv->module)) {
-			printk
-			    ("comedi: failed to increment module count, skipping\n");
+			printk(KERN_INFO "comedi: failed to increment\
+			module count, skipping\n");
 			continue;
 		}
 		if (driv->num_names) {
@@ -139,7 +139,8 @@ int comedi_device_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 				continue;
 			}
 		}
-		/* initialize dev->driver here so comedi_error() can be called from attach */
+		/* initialize dev->driver here
+		* so comedi_error() can be called from attach */
 		dev->driver = driv;
 		ret = driv->attach(dev, it);
 		if (ret < 0) {
@@ -154,7 +155,8 @@ int comedi_device_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	/*  report valid board names before returning error */
 	for (driv = comedi_drivers; driv; driv = driv->next) {
 		if (!try_module_get(driv->module)) {
-			printk("comedi: failed to increment module count\n");
+			printk(KERN_INFO \
+			"comedi: failed to increment module count\n");
 			continue;
 		}
 		comedi_report_boards(driv);
@@ -172,7 +174,9 @@ attached:
 	}
 
 	if (!dev->board_name) {
-		printk("BUG: dev->board_name=<%p>\n", dev->board_name);
+		printk(KERN_WARNING "BUG: dev->board_name=<%p>\n",\
+		dev->board_name);
+
 		dev->board_name = "BUG";
 	}
 	smp_wmb();
@@ -207,9 +211,9 @@ int comedi_driver_unregister(struct comedi_driver *driver)
 		mutex_lock(&dev->mutex);
 		if (dev->attached && dev->driver == driver) {
 			if (dev->use_count)
-				printk
-				    ("BUG! detaching device with use_count=%d\n",
-				     dev->use_count);
+				printk(KERN_WARNING "BUG! detaching device \
+				with use_count=%d\n" , dev->use_count);
+
 			comedi_device_detach(dev);
 		}
 		mutex_unlock(&dev->mutex);
@@ -253,7 +257,8 @@ static int postconfig(struct comedi_device *dev)
 			async =
 			    kzalloc(sizeof(struct comedi_async), GFP_KERNEL);
 			if (async == NULL) {
-				printk("failed to allocate async struct\n");
+				printk(KERN_INFO\
+				"failed to allocate async struct\n");
 				return -ENOMEM;
 			}
 			init_waitqueue_head(&async->wait_head);
@@ -268,7 +273,8 @@ static int postconfig(struct comedi_device *dev)
 			async->prealloc_buf = NULL;
 			async->prealloc_bufsz = 0;
 			if (comedi_buf_alloc(dev, s, DEFAULT_BUF_SIZE) < 0) {
-				printk("Buffer allocation failed\n");
+				printk(KERN_WARNING\
+				"Buffer allocation failed\n");
 				return -ENOMEM;
 			}
 			if (s->buf_change) {
@@ -303,7 +309,8 @@ static int postconfig(struct comedi_device *dev)
 	return 0;
 }
 
-/*  generic recognize function for drivers that register their supported board names */
+/*  generic recognize function for drivers
+* that register their supported board names */
 void *comedi_recognize(struct comedi_driver *driv, const char *name)
 {
 	unsigned i;
@@ -329,12 +336,12 @@ void comedi_report_boards(struct comedi_driver *driv)
 
 	name_ptr = driv->board_name;
 	for (i = 0; i < driv->num_names; i++) {
-		printk(" %s\n", *name_ptr);
+		printk(KERN_DEBUG " %s\n", *name_ptr);
 		name_ptr = (const char **)((char *)name_ptr + driv->offset);
 	}
 
 	if (driv->num_names == 0)
-		printk(" %s\n", driv->driver_name);
+		printk(KERN_DEBUG " %s\n", driv->driver_name);
 }
 
 static int poll_invalid(struct comedi_device *dev, struct comedi_subdevice *s)
@@ -371,8 +378,11 @@ static int insn_rw_emulate_bits(struct comedi_device *dev,
 	if (insn->insn == INSN_WRITE) {
 		if (!(s->subdev_flags & SDF_WRITABLE))
 			return -EINVAL;
-		new_data[0] = 1 << (chan - base_bitfield_channel);	/* mask */
-		new_data[1] = data[0] ? (1 << (chan - base_bitfield_channel)) : 0;	/* bits */
+		new_data[0] = 1 << \
+		(chan - base_bitfield_channel);	/* mask */
+
+		new_data[1] = data[0] \
+		? (1 << (chan - base_bitfield_channel)) : 0; /* bits */
 	}
 
 	ret = s->insn_bits(dev, s, &new_insn, new_data);
@@ -568,8 +578,9 @@ unsigned int comedi_buf_munge(struct comedi_async *async,
 
 		block_size = num_bytes - count;
 		if (block_size < 0) {
-			printk("%s: %s: bug! block_size is negative\n",
-			       __FILE__, __func__);
+			printk(KERN_WARNING "%s: %s: bug! \
+			block_size is negative" , __FILE__ , __func__);
+
 			break;
 		}
 		if ((int)(async->munge_ptr + block_size -
@@ -579,7 +590,8 @@ unsigned int comedi_buf_munge(struct comedi_async *async,
 		s->munge(s->device, s, async->prealloc_buf + async->munge_ptr,
 			 block_size, async->munge_chan);
 
-		smp_wmb();	/* barrier insures data is munged in buffer before munge_count is incremented */
+		smp_wmb();	/* barrier insures data is munged in buffer
+				*before munge_count is incremented */
 
 		async->munge_chan += block_size / num_sample_bytes;
 		async->munge_chan %= async->cmd.chanlist_len;
@@ -648,8 +660,8 @@ unsigned comedi_buf_write_free(struct comedi_async *async, unsigned int nbytes)
 {
 	if ((int)(async->buf_write_count + nbytes -
 		  async->buf_write_alloc_count) > 0) {
-		printk
-		    ("comedi: attempted to write-free more bytes than have been write-allocated.\n");
+		printk(KERN_WARNING "comedi: attempted to write-free more\
+		bytes than have been write-allocated.\n");
 		nbytes = async->buf_write_alloc_count - async->buf_write_count;
 	}
 	async->buf_write_count += nbytes;
@@ -678,12 +690,13 @@ unsigned comedi_buf_read_alloc(struct comedi_async *async, unsigned nbytes)
 /* transfers control of a chunk from reader to free buffer space */
 unsigned comedi_buf_read_free(struct comedi_async *async, unsigned int nbytes)
 {
-	/*  barrier insures data has been read out of buffer before read count is incremented */
+	/*  barrier insures data has been read out of buffer
+	*before read count is incremented */
 	smp_mb();
 	if ((int)(async->buf_read_count + nbytes -
 		  async->buf_read_alloc_count) > 0) {
-		printk
-		    ("comedi: attempted to read-free more bytes than have been read-allocated.\n");
+		printk(KERN_WARNING "comedi: attempted to read-free \
+		more bytes than have been read-allocated.\n");
 		nbytes = async->buf_read_alloc_count - async->buf_read_count;
 	}
 	async->buf_read_count += nbytes;
-- 
1.6.3.3

