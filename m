Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab0EFJgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 05:36:14 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:36082 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab0EFJgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 05:36:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=X/IA4rzvU7NagG54Vq/gR704lY7/wPs1xtt8DEurDxzhnAO4wtgZgP1mXLazC1SWcB
         AsK+trgF1qtsdUxNb2G8EFMBFrdqjWaEBKU7AcvTcabMnHZyotQ3iUzWOSTphvONqyyv
         rBRhMxB9Zijzol32UXVrEvDeZRN5WlE/Rp5wA=
From: Mark <reodge@gmail.com>
To: gregkh@suse.de, mithlesh@linsyssoft.com, wfp5p@virginia.edu,
       andrea.gelmini@gelma.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mark <reodge@gmail.com>
Subject: [PATCH] Staging: comedi: Fixed printk call lengths and log levels
Date: Thu,  6 May 2010 17:36:38 +0800
Message-Id: <1273138598-7364-1-git-send-email-reodge@gmail.com>
X-Mailer: git-send-email 1.7.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to include log levels and fix some over length lines in
printk calls in drivers.c

Signed-off-by: Mark Rankilor <reodge@gmail.com>
---
 drivers/staging/comedi/drivers.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index 1f48b6d..ffb0ad4 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -95,7 +95,8 @@ static void __comedi_device_detach(struct comedi_device *dev)
 	if (dev->driver)
 		dev->driver->detach(dev);
 	else
-		printk(KERN_WARNING "BUG: dev->driver=NULL in comedi_device_detach()\n");
+		printk(KERN_WARNING
+		       "BUG: dev->driver=NULL in comedi_device_detach()\n");
 	cleanup_device(dev);
 }
 
@@ -148,7 +149,8 @@ int comedi_device_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	/*  report valid board names before returning error */
 	for (driv = comedi_drivers; driv; driv = driv->next) {
 		if (!try_module_get(driv->module)) {
-			printk(KERN_INFO "comedi: failed to increment module count\n");
+			printk(KERN_INFO 
+			       "comedi: failed to increment module count\n");
 			continue;
 		}
 		comedi_report_boards(driv);
@@ -250,7 +252,8 @@ static int postconfig(struct comedi_device *dev)
 			async =
 			    kzalloc(sizeof(struct comedi_async), GFP_KERNEL);
 			if (async == NULL) {
-				printk(KERN_INFO "failed to allocate async struct\n");
+				printk(KERN_INFO
+				       "failed to allocate async struct\n");
 				return -ENOMEM;
 			}
 			init_waitqueue_head(&async->wait_head);
@@ -560,7 +563,8 @@ static unsigned int comedi_buf_munge(struct comedi_async *async,
 
 		block_size = num_bytes - count;
 		if (block_size < 0) {
-			printk(KERN_WARNING "%s: %s: bug! block_size is negative\n",
+			printk(KERN_WARNING
+			       "%s: %s: bug! block_size is negative\n",
 			       __FILE__, __func__);
 			break;
 		}
@@ -679,8 +683,8 @@ unsigned comedi_buf_read_free(struct comedi_async *async, unsigned int nbytes)
 	smp_mb();
 	if ((int)(async->buf_read_count + nbytes -
 		  async->buf_read_alloc_count) > 0) {
-		printk
-		    ("comedi: attempted to read-free more bytes than have been read-allocated.\n");
+		printk(KERN_INFO
+		       "comedi: attempted to read-free more bytes than have been read-allocated.\n");
 		nbytes = async->buf_read_alloc_count - async->buf_read_count;
 	}
 	async->buf_read_count += nbytes;
-- 
1.7.0.5

