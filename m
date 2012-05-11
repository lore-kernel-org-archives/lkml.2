Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758992Ab2EKKkK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 06:40:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63800 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab2EKKkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 06:40:08 -0400
From: Ravishankar Karkala Mallikarjunayya <ravishankarkm32@gmail.com>
To: gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 03/25] Staging: comedi: fix printk issue in usbduxfast.c
Date: Fri, 11 May 2012 16:07:51 +0530
Message-Id: <1336732693-7408-4-git-send-email-ravishankar.km@greenturtles.in>
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
 drivers/staging/comedi/drivers/usbduxfast.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index 32e3f65..4264552 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -291,11 +291,11 @@ static int usbduxfast_ai_cancel(struct comedi_device *dev,
 
 	/* force unlink of all urbs */
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi: usbduxfast_ai_cancel\n");
+	dev_dbg(dev->hw_dev, "comedi: usbduxfast_ai_cancel\n");
 #endif
 	udfs = dev->private;
 	if (!udfs) {
-		printk(KERN_ERR "comedi: usbduxfast_ai_cancel: udfs=NULL\n");
+		dev_err(dev->hw_dev, "comedi: usbduxfast_ai_cancel: udfs=NULL\n");
 		return -EFAULT;
 	}
 	down(&udfs->sem);
@@ -565,10 +565,10 @@ static int usbduxfast_ai_cmdtest(struct comedi_device *dev,
 		return -ENODEV;
 
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi%d: usbduxfast_ai_cmdtest\n", dev->minor);
-	printk(KERN_DEBUG "comedi%d: usbduxfast: convert_arg=%u "
-	       "scan_begin_arg=%u\n",
-	       dev->minor, cmd->convert_arg, cmd->scan_begin_arg);
+	dev_dbg(dev->hw_dev, "comedi%d: usbduxfast_ai_cmdtest\n",
+		dev->minor);
+	dev_dbg(dev->hw_dev, "comedi%d: usbduxfast: convert_arg=%u scan_begin_arg=%u\n",
+		dev->minor, cmd->convert_arg, cmd->scan_begin_arg);
 #endif
 	/* step 1: make sure trigger sources are trivially valid */
 
@@ -711,12 +711,12 @@ static int usbduxfast_ai_inttrig(struct comedi_device *dev,
 		return -ENODEV;
 	}
 #ifdef CONFIG_COMEDI_DEBUG
-	printk(KERN_DEBUG "comedi%d: usbduxfast_ai_inttrig\n", dev->minor);
+	dev_dbg(dev->hw_dev, "comedi%d: usbduxfast_ai_inttrig\n", dev->minor);
 #endif
 
 	if (trignum != 0) {
-		printk(KERN_ERR "comedi%d: usbduxfast_ai_inttrig: invalid"
-		       " trignum\n", dev->minor);
+		dev_err(dev->hw_dev, "comedi%d: usbduxfast_ai_inttrig: invalid trignum\n",
+			dev->minor);
 		up(&udfs->sem);
 		return -EINVAL;
 	}
@@ -724,16 +724,16 @@ static int usbduxfast_ai_inttrig(struct comedi_device *dev,
 		udfs->ai_cmd_running = 1;
 		ret = usbduxfastsub_submit_InURBs(udfs);
 		if (ret < 0) {
-			printk(KERN_ERR "comedi%d: usbduxfast_ai_inttrig: "
-			       "urbSubmit: err=%d\n", dev->minor, ret);
+			dev_err(dev->hw_dev, "comedi%d: usbduxfast_ai_inttrig: urbSubmit: err=%d\n",
+				dev->minor, ret);
 			udfs->ai_cmd_running = 0;
 			up(&udfs->sem);
 			return ret;
 		}
 		s->async->inttrig = NULL;
 	} else {
-		printk(KERN_ERR "comedi%d: ai_inttrig but acqu is already"
-		       " running\n", dev->minor);
+		dev_err(dev->hw_dev, "comedi%d: ai_inttrig but acqu is already running\n",
+			dev->minor);
 	}
 	up(&udfs->sem);
 	return 1;
-- 
1.7.0.4

