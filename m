Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325Ab1KSEix (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 23:38:53 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63204 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932274Ab1KSEit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 23:38:49 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 24/25] Staging: comedi: fix printk issue in pcl818.c
Date: Sat, 19 Nov 2011 10:06:56 +0530
Message-Id: <1321677417-2415-24-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1321677417-2415-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1321677417-2415-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the pcl818.c file that fixes up a printk
warning found by the checkpatch.pl tool.
Converted printks to dev_version.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/pcl818.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index c207b25..bad7ee4 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -1007,7 +1007,7 @@ static int pcl818_ai_cmd_mode(int mode, struct comedi_device *dev,
 	int divisor1 = 0, divisor2 = 0;
 	unsigned int seglen;
 
-	printk("pcl818_ai_cmd_mode()\n");
+	dev_dbg(dev->hw_dev, "pcl818_ai_cmd_mode()\n");
 	if ((!dev->irq) && (!devpriv->dma_rtc)) {
 		comedi_error(dev, "IRQ not defined!");
 		return -EINVAL;
@@ -1110,7 +1110,7 @@ static int pcl818_ai_cmd_mode(int mode, struct comedi_device *dev,
 		break;
 	}
 #endif
-	printk("pcl818_ai_cmd_mode() end\n");
+	dev_dbg(dev->hw_dev, "pcl818_ai_cmd_mode() end\n");
 	return 0;
 }
 
@@ -1453,7 +1453,7 @@ static int ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	struct comedi_cmd *cmd = &s->async->cmd;
 	int retval;
 
-	printk("pcl818_ai_cmd()\n");
+	dev_dbg(dev->hw_dev, "pcl818_ai_cmd()\n");
 	devpriv->ai_n_chan = cmd->chanlist_len;
 	devpriv->ai_chanlist = cmd->chanlist;
 	devpriv->ai_flags = cmd->flags;
@@ -1471,7 +1471,7 @@ static int ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		if (cmd->convert_src == TRIG_TIMER) {	/*  mode 1 */
 			devpriv->ai_timer1 = cmd->convert_arg;
 			retval = pcl818_ai_cmd_mode(1, dev, s);
-			printk("pcl818_ai_cmd() end\n");
+			dev_dbg(dev->hw_dev, "pcl818_ai_cmd() end\n");
 			return retval;
 		}
 		if (cmd->convert_src == TRIG_EXT) {	/*  mode 3 */
@@ -1490,7 +1490,7 @@ static int pcl818_ai_cancel(struct comedi_device *dev,
 			    struct comedi_subdevice *s)
 {
 	if (devpriv->irq_blocked > 0) {
-		printk("pcl818_ai_cancel()\n");
+		dev_dbg(dev->hw_dev, "pcl818_ai_cancel()\n");
 		devpriv->irq_was_now_closed = 1;
 
 		switch (devpriv->ai_mode) {
@@ -1540,7 +1540,7 @@ static int pcl818_ai_cancel(struct comedi_device *dev,
 	}
 
 end:
-	printk("pcl818_ai_cancel() end\n");
+	dev_dbg(dev->hw_dev, "pcl818_ai_cancel() end\n");
 	return 0;
 }
 
-- 
1.7.0.4

