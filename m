Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab0EMJoD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 05:44:03 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33034 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab0EMJn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 05:43:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=k6m//HT2aj8GfgZNUMKCPvUAsB/NO+0HcHwVtMdbF4Q4OdLT4s4cvbTyVcRON892kq
         WlUrnb9cVzP1N096tRsP+kmQGvmjhnOc4AtXelUf85V5psOH860bqFGjgd7QHjFBl3Lj
         XFBUejst1azFsvErjF6dY3S3bbtvpb3bQTB+8=
From: Mark <reodge@gmail.com>
To: gregkh@suse.de, shawn.bohrer@gmail.com, fmhess@users.sourceforge.net,
       andrea.gelmini@gelma.net, caratorn@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mark <reodge@gmail.com>
Subject: [PATCH] Staging: comedi: Fix long line lengths in comedi_fops.c
Date: Thu, 13 May 2010 17:44:39 +0800
Message-Id: <1273743879-2842-2-git-send-email-reodge@gmail.com>
X-Mailer: git-send-email 1.7.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes lots of long line lengths in comedi_fops.c found by
checkpatch.pl

Signed-off-by: Mark Rankilor <reodge@gmail.com>
---
 drivers/staging/comedi/comedi_fops.c |   44 ++++++++++++++++++++++-----------
 1 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index e7095d7..aced00e 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -952,8 +952,9 @@ static int do_insn_ioctl(struct comedi_device *dev,
 	if (insn.n > MAX_SAMPLES)
 		insn.n = MAX_SAMPLES;
 	if (insn.insn & INSN_MASK_WRITE) {
-		if (copy_from_user
-		    (data, insn.data, insn.n * sizeof(unsigned int))) {
+		if (copy_from_user(data,
+				   insn.data,
+				   insn.n * sizeof(unsigned int))) {
 			ret = -EFAULT;
 			goto error;
 		}
@@ -962,7 +963,9 @@ static int do_insn_ioctl(struct comedi_device *dev,
 	if (ret < 0)
 		goto error;
 	if (insn.insn & INSN_MASK_READ) {
-		if (copy_to_user(insn.data, data, insn.n * sizeof(unsigned int))) {
+		if (copy_to_user(insn.data,
+				 data,
+				 insn.n * sizeof(unsigned int))) {
 			ret = -EFAULT;
 			goto error;
 		}
@@ -1070,7 +1073,9 @@ static int do_cmd_ioctl(struct comedi_device *dev,
 	}
 
 	/* make sure each element in channel/gain list is valid */
-	ret = comedi_check_chanlist(s, async->cmd.chanlist_len, async->cmd.chanlist);
+	ret = comedi_check_chanlist(s,
+				    async->cmd.chanlist_len,
+				    async->cmd.chanlist);
 	if (ret < 0) {
 		DPRINTK("bad chanlist\n");
 		goto cleanup;
@@ -2119,8 +2124,8 @@ int comedi_alloc_board_minor(struct device *hardware_device)
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
@@ -2133,7 +2138,8 @@ int comedi_alloc_board_minor(struct device *hardware_device)
 	retval = device_create_file(csdev, &dev_attr_max_read_buffer_kb);
 	if (retval) {
 		printk(KERN_ERR
-		       "comedi: failed to create sysfs attribute file \"%s\".\n",
+		       "comedi: "
+		       "failed to create sysfs attribute file \"%s\".\n",
 		       dev_attr_max_read_buffer_kb.attr.name);
 		comedi_free_board_minor(i);
 		return retval;
@@ -2141,7 +2147,8 @@ int comedi_alloc_board_minor(struct device *hardware_device)
 	retval = device_create_file(csdev, &dev_attr_read_buffer_kb);
 	if (retval) {
 		printk(KERN_ERR
-		       "comedi: failed to create sysfs attribute file \"%s\".\n",
+		       "comedi: "
+		       "failed to create sysfs attribute file \"%s\".\n",
 		       dev_attr_read_buffer_kb.attr.name);
 		comedi_free_board_minor(i);
 		return retval;
@@ -2149,7 +2156,8 @@ int comedi_alloc_board_minor(struct device *hardware_device)
 	retval = device_create_file(csdev, &dev_attr_max_write_buffer_kb);
 	if (retval) {
 		printk(KERN_ERR
-		       "comedi: failed to create sysfs attribute file \"%s\".\n",
+		       "comedi: "
+		       "failed to create sysfs attribute file \"%s\".\n",
 		       dev_attr_max_write_buffer_kb.attr.name);
 		comedi_free_board_minor(i);
 		return retval;
@@ -2157,7 +2165,8 @@ int comedi_alloc_board_minor(struct device *hardware_device)
 	retval = device_create_file(csdev, &dev_attr_write_buffer_kb);
 	if (retval) {
 		printk(KERN_ERR
-		       "comedi: failed to create sysfs attribute file \"%s\".\n",
+		       "comedi: "
+		       "failed to create sysfs attribute file \"%s\".\n",
 		       dev_attr_write_buffer_kb.attr.name);
 		comedi_free_board_minor(i);
 		return retval;
@@ -2216,7 +2225,8 @@ int comedi_alloc_subdevice_minor(struct comedi_device *dev,
 	if (i == COMEDI_NUM_MINORS) {
 		kfree(info);
 		printk(KERN_ERR
-		       "comedi: error: ran out of minor numbers for board device files.\n");
+		       "comedi: error: "
+		       "ran out of minor numbers for board device files.\n");
 		return -EBUSY;
 	}
 	s->minor = i;
@@ -2230,7 +2240,8 @@ int comedi_alloc_subdevice_minor(struct comedi_device *dev,
 	retval = device_create_file(csdev, &dev_attr_max_read_buffer_kb);
 	if (retval) {
 		printk(KERN_ERR
-		       "comedi: failed to create sysfs attribute file \"%s\".\n",
+		       "comedi: "
+		       "failed to create sysfs attribute file \"%s\".\n",
 		       dev_attr_max_read_buffer_kb.attr.name);
 		comedi_free_subdevice_minor(s);
 		return retval;
@@ -2238,7 +2249,8 @@ int comedi_alloc_subdevice_minor(struct comedi_device *dev,
 	retval = device_create_file(csdev, &dev_attr_read_buffer_kb);
 	if (retval) {
 		printk(KERN_ERR
-		       "comedi: failed to create sysfs attribute file \"%s\".\n",
+		       "comedi: "
+		       "failed to create sysfs attribute file \"%s\".\n",
 		       dev_attr_read_buffer_kb.attr.name);
 		comedi_free_subdevice_minor(s);
 		return retval;
@@ -2246,7 +2258,8 @@ int comedi_alloc_subdevice_minor(struct comedi_device *dev,
 	retval = device_create_file(csdev, &dev_attr_max_write_buffer_kb);
 	if (retval) {
 		printk(KERN_ERR
-		       "comedi: failed to create sysfs attribute file \"%s\".\n",
+		       "comedi: "
+		       "failed to create sysfs attribute file \"%s\".\n",
 		       dev_attr_max_write_buffer_kb.attr.name);
 		comedi_free_subdevice_minor(s);
 		return retval;
@@ -2254,7 +2267,8 @@ int comedi_alloc_subdevice_minor(struct comedi_device *dev,
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

