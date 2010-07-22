Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016Ab0GVRIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 13:08:09 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43695 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab0GVRID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 13:08:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=azTxmHx2FTMUAR8NOZ4NQ8mlzZuY0YTWb/bvQBblA7mlhRFGqXixq13uDUWXy7Acaf
         tbUSqZi/1lQraRt5Yi9s5b8vUWLO38IXO/UNH3+3lCViwXgXsYD+DYXFBMlw6sqLBTcz
         ztegJiWEFripky5/e5YC4QdRJ8bVvbKoL0vPk=
From: Chihau Chau <chihau@gmail.com>
To: gregkh@suse.de
Cc: mithlesh@linsyssoft.com, reodge@gmail.com, andrea.gelmini@gelma.net,
        penberg@cs.helsinki.fi, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Chihau Chau <chihau@gmail.com>
Subject: [PATCH] Staging: comedi: drivers: Code style issues
Date: Thu, 22 Jul 2010 13:07:53 -0400
Message-Id: <1279818473-18212-1-git-send-email-chihau@gmail.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chihau Chau <chihau@gmail.com>

This fix some lines over 80 characters.

Signed-off-by: Chihau Chau <chihau@gmail.com>
---
 drivers/staging/comedi/drivers.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index 4a29ed7..50c8295 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -117,8 +117,8 @@ int comedi_device_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	for (driv = comedi_drivers; driv; driv = driv->next) {
 		if (!try_module_get(driv->module)) {
-			printk
-			    (KERN_INFO "comedi: failed to increment module count, skipping\n");
+			printk(KERN_INFO "comedi: failed to increment module "
+				"count, skipping\n");
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
+				printk(KERN_WARNING "BUG! detaching device with"
+					" use_count=%d\n", dev->use_count);
 			comedi_device_detach(dev);
 		}
 		mutex_unlock(&dev->mutex);
@@ -646,8 +645,8 @@ unsigned comedi_buf_write_free(struct comedi_async *async, unsigned int nbytes)
 {
 	if ((int)(async->buf_write_count + nbytes -
 		  async->buf_write_alloc_count) > 0) {
-		printk
-		    (KERN_INFO "comedi: attempted to write-free more bytes than have been write-allocated.\n");
+		printk(KERN_INFO "comedi: attempted to write-free more bytes "
+			"than have been write-allocated.\n");
 		nbytes = async->buf_write_alloc_count - async->buf_write_count;
 	}
 	async->buf_write_count += nbytes;
@@ -683,8 +682,8 @@ unsigned comedi_buf_read_free(struct comedi_async *async, unsigned int nbytes)
 	smp_mb();
 	if ((int)(async->buf_read_count + nbytes -
 		  async->buf_read_alloc_count) > 0) {
-		printk(KERN_INFO
-		       "comedi: attempted to read-free more bytes than have been read-allocated.\n");
+		printk(KERN_INFO "comedi: attempted to read-free more bytes "
+			"than have been read-allocated.\n");
 		nbytes = async->buf_read_alloc_count - async->buf_read_count;
 	}
 	async->buf_read_count += nbytes;
-- 
1.5.6.3

