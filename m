Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759127Ab2EKKk2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 06:40:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56846 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759000Ab2EKKkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 06:40:23 -0400
From: Ravishankar Karkala Mallikarjunayya <ravishankarkm32@gmail.com>
To: gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 05/25] Staging: comedi: fix printk issue in usbduxfast.c
Date: Fri, 11 May 2012 16:07:53 +0530
Message-Id: <1336732693-7408-6-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the usbduxfast.c file that fixes up a printk found
by the checkpatch.pl tool.

Used dev_*() functions instead of printks wherver possible and fixed
a quoted string split across line warnings.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/usbduxfast.c |   38 +++++++++++++-------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index 57e3283..e66c1f3 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -1222,13 +1222,13 @@ static int usbduxfast_ai_insn_read(struct comedi_device *dev,
 
 	udfs = dev->private;
 	if (!udfs) {
-		printk(KERN_ERR "comedi%d: ai_insn_read: no usb dev.\n",
-		       dev->minor);
+		dev_err(dev->hw_dev, "comedi%d: ai_insn_read: no usb dev.\n",
+			dev->minor);
 		return -ENODEV;
 	}
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi%d: ai_insn_read, insn->n=%d, "
-	       "insn->subdev=%d\n", dev->minor, insn->n, insn->subdev);
+	dev_dbg(dev->hw_dev, "comedi%d: ai_insn_read, insn->n=%d, insn->subdev=%d\n",
+		dev->minor, insn->n, insn->subdev);
 #endif
 	down(&udfs->sem);
 	if (!udfs->probed) {
@@ -1236,8 +1236,8 @@ static int usbduxfast_ai_insn_read(struct comedi_device *dev,
 		return -ENODEV;
 	}
 	if (udfs->ai_cmd_running) {
-		printk(KERN_ERR "comedi%d: ai_insn_read not possible. Async "
-		       "Command is running.\n", dev->minor);
+		dev_err(dev->hw_dev, "comedi%d: ai_insn_read not possible. Async Command is running.\n",
+			dev->minor);
 		up(&udfs->sem);
 		return -EBUSY;
 	}
@@ -1291,21 +1291,21 @@ static int usbduxfast_ai_insn_read(struct comedi_device *dev,
 	udfs->dux_commands[LOGBASE + 0] = 0;
 
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi %d: sending commands to the usb device\n",
-	       dev->minor);
+	dev_dbg(dev->hw_dev, "comedi%d: sending commands to the usb device\n",
+		dev->minor);
 #endif
 	/* 0 means that the AD commands are sent */
 	err = send_dux_commands(udfs, SENDADCOMMANDS);
 	if (err < 0) {
-		printk(KERN_ERR "comedi%d: adc command could not be submitted."
-		       "Aborting...\n", dev->minor);
+		dev_err(dev->hw_dev, "comedi%d: adc command could not be submitted. Aborting...\n",
+			dev->minor);
 		up(&udfs->sem);
 		return err;
 	}
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi%d: usbduxfast: submitting in-urb: "
-	       "0x%p,0x%p\n", udfs->comedidev->minor, udfs->urbIn->context,
-	       udfs->urbIn->dev);
+	dev_dbg(dev->hw_dev, "comedi%d: submitting in-urb: 0x%p,0x%p\n",
+		udfs->comedidev->minor, udfs->urbIn->context,
+		udfs->urbIn->dev);
 #endif
 	for (i = 0; i < PACKETS_TO_IGNORE; i++) {
 		err = usb_bulk_msg(udfs->usbdev,
@@ -1313,8 +1313,8 @@ static int usbduxfast_ai_insn_read(struct comedi_device *dev,
 				   udfs->transfer_buffer, SIZEINBUF,
 				   &actual_length, 10000);
 		if (err < 0) {
-			printk(KERN_ERR "comedi%d: insn timeout. No data.\n",
-			       dev->minor);
+			dev_err(dev->hw_dev, "comedi%d: insn timeout. No data.\n",
+				dev->minor);
 			up(&udfs->sem);
 			return err;
 		}
@@ -1326,15 +1326,15 @@ static int usbduxfast_ai_insn_read(struct comedi_device *dev,
 				   udfs->transfer_buffer, SIZEINBUF,
 				   &actual_length, 10000);
 		if (err < 0) {
-			printk(KERN_ERR "comedi%d: insn data error: %d\n",
-			       dev->minor, err);
+			dev_err(dev->hw_dev, "comedi%d: insn data error: %d\n",
+				dev->minor, err);
 			up(&udfs->sem);
 			return err;
 		}
 		n = actual_length / sizeof(uint16_t);
 		if ((n % 16) != 0) {
-			printk(KERN_ERR "comedi%d: insn data packet "
-			       "corrupted.\n", dev->minor);
+			dev_err(dev->hw_dev, "comedi%d: insn data packet corrupted.\n",
+				dev->minor);
 			up(&udfs->sem);
 			return -EINVAL;
 		}
-- 
1.7.0.4

