Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759055Ab2EKKkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 06:40:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63800 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759011Ab2EKKkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 06:40:15 -0400
From: Ravishankar Karkala Mallikarjunayya <ravishankarkm32@gmail.com>
To: gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 04/25] Staging: comedi: fix printk issue in usbduxfast.c
Date: Fri, 11 May 2012 16:07:52 +0530
Message-Id: <1336732693-7408-5-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the usbduxfast.c file that fixes up a printk found
by the checkpatch.pl tool.

Used dev_*() functions instead of printks wherver possible and fixed
a quoted string split across lines warnings.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/usbduxfast.c |   58 ++++++++++++--------------
 1 files changed, 27 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index 4264552..57e3283 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -759,7 +759,7 @@ static int usbduxfast_ai_cmd(struct comedi_device *dev,
 	long steps, steps_tmp;
 
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi%d: usbduxfast_ai_cmd\n", dev->minor);
+	dev_dbg(dev->hw_dev, "comedi%d: usbduxfast_ai_cmd\n", dev->minor);
 #endif
 	udfs = dev->private;
 	if (!udfs)
@@ -771,8 +771,8 @@ static int usbduxfast_ai_cmd(struct comedi_device *dev,
 		return -ENODEV;
 	}
 	if (udfs->ai_cmd_running) {
-		printk(KERN_ERR "comedi%d: ai_cmd not possible. Another ai_cmd"
-		       " is running.\n", dev->minor);
+		dev_err(dev->hw_dev, "comedi%d: ai_cmd not possible. Another ai_cmd is running.\n",
+			dev->minor);
 		up(&udfs->sem);
 		return -EBUSY;
 	}
@@ -790,31 +790,29 @@ static int usbduxfast_ai_cmd(struct comedi_device *dev,
 		for (i = 0; i < cmd->chanlist_len; ++i) {
 			chan = CR_CHAN(cmd->chanlist[i]);
 			if (chan != i) {
-				printk(KERN_ERR "comedi%d: cmd is accepting "
-				       "only consecutive channels.\n",
-				       dev->minor);
+				dev_err(dev->hw_dev, "comedi%d: cmd is accepting only consecutive channels.\n",
+					dev->minor);
 				up(&udfs->sem);
 				return -EINVAL;
 			}
 			if ((gain != CR_RANGE(cmd->chanlist[i]))
 			    && (cmd->chanlist_len > 3)) {
-				printk(KERN_ERR "comedi%d: the gain must be"
-				       " the same for all channels.\n",
-				       dev->minor);
+				dev_err(dev->hw_dev, "comedi%d: the gain must be the same for all channels.\n",
+					dev->minor);
 				up(&udfs->sem);
 				return -EINVAL;
 			}
 			if (i >= NUMCHANNELS) {
-				printk(KERN_ERR "comedi%d: channel list too"
-				       " long\n", dev->minor);
+				dev_err(dev->hw_dev, "comedi%d: channel list too long\n",
+					dev->minor);
 				break;
 			}
 		}
 	}
 	steps = 0;
 	if (cmd->scan_begin_src == TRIG_TIMER) {
-		printk(KERN_ERR "comedi%d: usbduxfast: "
-		       "scan_begin_src==TRIG_TIMER not valid.\n", dev->minor);
+		dev_err(dev->hw_dev, "comedi%d: scan_begin_src==TRIG_TIMER not valid.\n",
+			dev->minor);
 		up(&udfs->sem);
 		return -EINVAL;
 	}
@@ -822,28 +820,27 @@ static int usbduxfast_ai_cmd(struct comedi_device *dev,
 		steps = (cmd->convert_arg * 30) / 1000;
 
 	if ((steps < MIN_SAMPLING_PERIOD) && (cmd->chanlist_len != 1)) {
-		printk(KERN_ERR "comedi%d: usbduxfast: ai_cmd: steps=%ld, "
-		       "scan_begin_arg=%d. Not properly tested by cmdtest?\n",
-		       dev->minor, steps, cmd->scan_begin_arg);
+		dev_err(dev->hw_dev, "comedi%d: ai_cmd: steps=%ld, scan_begin_arg=%d. Not properly tested by cmdtest?\n",
+			dev->minor, steps, cmd->scan_begin_arg);
 		up(&udfs->sem);
 		return -EINVAL;
 	}
 	if (steps > MAX_SAMPLING_PERIOD) {
-		printk(KERN_ERR "comedi%d: usbduxfast: ai_cmd: sampling rate "
-		       "too low.\n", dev->minor);
+		dev_err(dev->hw_dev, "comedi%d: ai_cmd: sampling rate too low.\n",
+			dev->minor);
 		up(&udfs->sem);
 		return -EINVAL;
 	}
 	if ((cmd->start_src == TRIG_EXT) && (cmd->chanlist_len != 1)
 	    && (cmd->chanlist_len != 16)) {
-		printk(KERN_ERR "comedi%d: usbduxfast: ai_cmd: TRIG_EXT only"
-		       " with 1 or 16 channels possible.\n", dev->minor);
+		dev_err(dev->hw_dev, "comedi%d: ai_cmd: TRIG_EXT only with 1 or 16 channels possible.\n",
+			dev->minor);
 		up(&udfs->sem);
 		return -EINVAL;
 	}
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi%d: usbduxfast: steps=%ld, convert_arg=%u\n",
-	       dev->minor, steps, cmd->convert_arg);
+	dev_dbg(dev->hw_dev, "comedi%d: steps=%ld, convert_arg=%u\n",
+		dev->minor, steps, cmd->convert_arg);
 #endif
 
 	switch (cmd->chanlist_len) {
@@ -1154,30 +1151,29 @@ static int usbduxfast_ai_cmd(struct comedi_device *dev,
 		break;
 
 	default:
-		printk(KERN_ERR "comedi %d: unsupported combination of "
-		       "channels\n", dev->minor);
+		dev_err(dev->hw_dev, "comedi%d: unsupported combination of channels\n",
+			dev->minor);
 		up(&udfs->sem);
 		return -EFAULT;
 	}
 
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi %d: sending commands to the usb device\n",
-	       dev->minor);
+	dev_dbg(dev->hw_dev, "comedi%d: sending commands to the usb device\n",
+		dev->minor);
 #endif
 	/* 0 means that the AD commands are sent */
 	result = send_dux_commands(udfs, SENDADCOMMANDS);
 	if (result < 0) {
-		printk(KERN_ERR "comedi%d: adc command could not be submitted."
-		       "Aborting...\n", dev->minor);
+		dev_err(dev->hw_dev, "comedi%d: adc command could not be submitted.Aborting...\n",
+			dev->minor);
 		up(&udfs->sem);
 		return result;
 	}
 	if (cmd->stop_src == TRIG_COUNT) {
 		udfs->ai_sample_count = cmd->stop_arg * cmd->scan_end_arg;
 		if (udfs->ai_sample_count < 1) {
-			printk(KERN_ERR "comedi%d: "
-			       "(cmd->stop_arg)*(cmd->scan_end_arg)<1, "
-			       "aborting.\n", dev->minor);
+			dev_err(dev->hw_dev, "comedi%d: (cmd->stop_arg)*(cmd->scan_end_arg)<1, aborting.\n",
+				dev->minor);
 			up(&udfs->sem);
 			return -EFAULT;
 		}
-- 
1.7.0.4

