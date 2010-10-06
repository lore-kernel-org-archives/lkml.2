Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517Ab0JFBGD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 21:06:03 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65271 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758213Ab0JFBBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 21:01:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jc9KUuioLdh6E8b7K2b5Ot7x8qv+wfh2D0b9/uHQ9G0O1vdDg0HYjPsVsMj2z4Hnhj
         OseWZlG4Fwr1nEVsAdeaUE/WFK/Uc8wWtzsgcu8Zv59JehsphWEcSVyY81S0GhHTPNR6
         pqsce3OQ+D5Ndw+PPxlIhZemPvoB2nUv/xonQ=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com, abbotti@mev.co.uk, fmhess@users.sourceforge.net
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 07/28] Staging: comedi: drivers.c: Edit file so that checkpatch.pl has 4 warnings and 0 errors
Date: Tue,  5 Oct 2010 21:00:22 -0400
Message-Id: <1286326843-6170-7-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286326843-6170-1-git-send-email-tdent48227@gmail.com>
References: <1286326843-6170-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed a few lines that made checkpatch.pl complain. Could not get ever warning but
I got it down to to just 4, WARNING: line over 80 characters.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/comedi/drivers.c |   41 ++++++++++++++++++++-----------------
 1 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index 4a29ed7..849fa9a 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -1,23 +1,23 @@
 /*
-    module/drivers.c
-    functions for manipulating drivers
+	module/drivers.c
+	functions for manipulating drivers
 
-    COMEDI - Linux Control and Measurement Device Interface
-    Copyright (C) 1997-2000 David A. Schleef <ds@schleef.org>
+	COMEDI - Linux Control and Measurement Device Interface
+	Copyright (C) 1997-2000 David A. Schleef <ds@schleef.org>
 
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
 
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+	GNU General Public License for more details.
 
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+	You should have received a copy of the GNU General Public License
+	along with this program; if not, write to the Free Software
+	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 
 */
 
@@ -118,7 +118,8 @@ int comedi_device_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	for (driv = comedi_drivers; driv; driv = driv->next) {
 		if (!try_module_get(driv->module)) {
 			printk
-			    (KERN_INFO "comedi: failed to increment module count, skipping\n");
+			    (KERN_INFO "comedi: failed to increment	\
+					module count, skipping\n");
 			continue;
 		}
 		if (driv->num_names) {
@@ -206,8 +207,9 @@ int comedi_driver_unregister(struct comedi_driver *driver)
 		if (dev->attached && dev->driver == driver) {
 			if (dev->use_count)
 				printk
-				    (KERN_WARNING "BUG! detaching device with use_count=%d\n",
-				     dev->use_count);
+				    (KERN_WARNING "BUG! detaching device     \
+							with use_count=%d\n",
+							dev->use_count);
 			comedi_device_detach(dev);
 		}
 		mutex_unlock(&dev->mutex);
@@ -647,7 +649,8 @@ unsigned comedi_buf_write_free(struct comedi_async *async, unsigned int nbytes)
 	if ((int)(async->buf_write_count + nbytes -
 		  async->buf_write_alloc_count) > 0) {
 		printk
-		    (KERN_INFO "comedi: attempted to write-free more bytes than have been write-allocated.\n");
+		    (KERN_INFO "comedi: attempted to write-free more	\
+				bytes than have been write-allocated.\n");
 		nbytes = async->buf_write_alloc_count - async->buf_write_count;
 	}
 	async->buf_write_count += nbytes;
-- 
1.7.3.1.50.g1e633

