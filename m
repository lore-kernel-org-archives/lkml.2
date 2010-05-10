Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631Ab0EJJgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 05:36:20 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43082 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab0EJJgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 05:36:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=nrYkyVxocfPnVrWYsAiQ2JDxK2z5eYm+9BL7NNi45bYqNPXC5ODPQDm61DUKtyqVth
         mGhJo3hmc7KMeOts9rhwCHSsXkwuRv9oTisEMjWcrChN6h1ePfcSY1XuxlaZI0ihoH42
         oBJrOV4mwY09GtFjpXxYqzHZAUUWs3Ak3BnoI=
From: Mark <reodge@gmail.com>
To: gregkh@suse.de, shawn.bohrer@gmail.com, fmhess@users.sourceforge.net,
       andrea.gelmini@gelma.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mark <reodge@gmail.com>
Subject: [PATCH] Staging: comedi: Fix long line lengths in comedi_fops.c
Date: Mon, 10 May 2010 17:36:57 +0800
Message-Id: <1273484217-4073-1-git-send-email-reodge@gmail.com>
X-Mailer: git-send-email 1.7.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes lots of long line lengths in comedi_fops.c found by
checkpatch.pl

Signed-off-by: Mark Rankilor <reodge@gmail.com>
---
 drivers/staging/comedi/comedi_fops.c |   38 ++++++++++++++++++++++-----------
 1 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index e7095d7..9bfab73 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -962,7 +962,8 @@ static int do_insn_ioctl(struct comedi_device *dev,
 	if (ret < 0)
 		goto error;
 	if (insn.insn & INSN_MASK_READ) {
-		if (copy_to_user(insn.data, data, insn.n * sizeof(unsigned int))) {
+		if (copy_to_user
+		    (insn.data, data, insn.n * sizeof(unsigned int))) {
 			ret = -EFAULT;
 			goto error;
 		}
@@ -1070,7 +1071,9 @@ static int do_cmd_ioctl(struct comedi_device *dev,
 	}
 
 	/* make sure each element in channel/gain list is valid */
-	ret = comedi_check_chanlist(s, async->cmd.chanlist_len, async->cmd.chanlist);
+	ret = comedi_check_chanlist(s,
+				    async->cmd.chanlist_len,
+				    async->cmd.chanlist);
 	if (ret < 0) {
 		DPRINTK("bad chanlist\n");
 		goto cleanup;
@@ -2119,8 +2122,8 @@ int comedi_alloc_board_minor(struct device *hardware_device)
 		kfree(info->device);
 		kfree(info);
 		printk(KERN_ERR
-
-		       "comedi: error: ran out of minor numbers for board device files.\n");
+		       "comedi: error: "
+		       "ran out of minor numbers for board device files.\n");
 		return -EBUSY;
 	}
 	info->device->minor = i;
@@ -2133,7 +2136,8 @@ int comedi_alloc_board_minor(struct device *hardware_device)
 	retval = device_create_file(csdev, &dev_attr_max_read_buffer_kb);
 	if (retval) {
 		printk(KERN_ERR
-		       "comedi: failed to create sysfs attribute file \"%s\".\n",
+		       "comedi: "
+		       "failed to create sysfs attribute file \"%s\".\n",
 		       dev_attr_max_read_buffer_kb.attr.name);
 		comedi_free_board_minor(i);
 		return retval;
@@ -2141,7 +2145,8 @@ int comedi_alloc_board_minor(struct device *hardware_device)
 	retval = device_create_file(csdev, &dev_attr_read_buffer_kb);
 	if (retval) {
 		printk(KERN_ERR
-		       "comedi: failed to create sysfs attribute file \"%s\".\n",
+		       "comedi: "
+		       "failed to create sysfs attribute file \"%s\".\n",
 		       dev_attr_read_buffer_kb.attr.name);
 		comedi_free_board_minor(i);
 		return retval;
@@ -2149,7 +2154,8 @@ int comedi_alloc_board_minor(struct device *hardware_device)
 	retval = device_create_file(csdev, &dev_attr_max_write_buffer_kb);
 	if (retval) {
 		printk(KERN_ERR
-		       "comedi: failed to create sysfs attribute file \"%s\".\n",
+		       "comedi: "
+		       "failed to create sysfs attribute file \"%s\".\n",
 		       dev_attr_max_write_buffer_kb.attr.name);
 		comedi_free_board_minor(i);
 		return retval;
@@ -2157,7 +2163,8 @@ int comedi_alloc_board_minor(struct device *hardware_device)
 	retval = device_create_file(csdev, &dev_attr_write_buffer_kb);
 	if (retval) {
 		printk(KERN_ERR
-		       "comedi: failed to create sysfs attribute file \"%s\".\n",
+		       "comedi: "
+		       "failed to create sysfs attribute file \"%s\".\n",
 		       dev_attr_write_buffer_kb.attr.name);
 		comedi_free_board_minor(i);
 		return retval;
@@ -2216,7 +2223,8 @@ int comedi_alloc_subdevice_minor(struct comedi_device *dev,
 	if (i == COMEDI_NUM_MINORS) {
 		kfree(info);
 		printk(KERN_ERR
-		       "comedi: error: ran out of minor numbers for board device files.\n");
+		       "comedi: error: "
+		       "ran out of minor numbers for board device files.\n");
 		return -EBUSY;
 	}
 	s->minor = i;
@@ -2230,7 +2238,8 @@ int comedi_alloc_subdevice_minor(struct comedi_device *dev,
 	retval = device_create_file(csdev, &dev_attr_max_read_buffer_kb);
 	if (retval) {
 		printk(KERN_ERR
-		       "comedi: failed to create sysfs attribute file \"%s\".\n",
+		       "comedi: "
+		       "failed to create sysfs attribute file \"%s\".\n",
 		       dev_attr_max_read_buffer_kb.attr.name);
 		comedi_free_subdevice_minor(s);
 		return retval;
@@ -2238,7 +2247,8 @@ int comedi_alloc_subdevice_minor(struct comedi_device *dev,
 	retval = device_create_file(csdev, &dev_attr_read_buffer_kb);
 	if (retval) {
 		printk(KERN_ERR
-		       "comedi: failed to create sysfs attribute file \"%s\".\n",
+		       "comedi: "
+		       "failed to create sysfs attribute file \"%s\".\n",
 		       dev_attr_read_buffer_kb.attr.name);
 		comedi_free_subdevice_minor(s);
 		return retval;
@@ -2246,7 +2256,8 @@ int comedi_alloc_subdevice_minor(struct comedi_device *dev,
 	retval = device_create_file(csdev, &dev_attr_max_write_buffer_kb);
 	if (retval) {
 		printk(KERN_ERR
-		       "comedi: failed to create sysfs attribute file \"%s\".\n",
+		       "comedi: "
+		       "failed to create sysfs attribute file \"%s\".\n",
 		       dev_attr_max_write_buffer_kb.attr.name);
 		comedi_free_subdevice_minor(s);
 		return retval;
@@ -2254,7 +2265,8 @@ int comedi_alloc_subdevice_minor(struct comedi_device *dev,
 	retval = device_create_file(csdev, &dev_attr_write_buffer_kb);
 	if (retval) {
 		printk(KERN_ERR
-		       "comedi: failed to create sysfs attribute file \"%s\".\n",
+		       "comedi: "
+		       "failed to create sysfs attribute file \"%s\".\n",
 		       dev_attr_write_buffer_kb.attr.name);
 		comedi_free_subdevice_minor(s);
 		return retval;
-- 
1.7.0.5

