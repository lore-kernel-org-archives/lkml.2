Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237Ab1GKHGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 03:06:36 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60061 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757083Ab1GKHGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 03:06:35 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 8/8] Staging: comedi: fix printk() issue in pcl818.c
Date: Mon, 11 Jul 2011 12:49:14 +0530
Message-Id: <1310368754-25560-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH 7/7]Staging: comedi: fix printk issue in pcl818.c>
References: <[PATCH 7/7]Staging: comedi: fix printk issue in pcl818.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the pcl818.c file that fixes up a printk warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/pcl818.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index ae097b3..21f1cc9 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -1447,7 +1447,7 @@ static int ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	struct comedi_cmd *cmd = &s->async->cmd;
 	int retval;
 
-	printk("pcl818_ai_cmd()\n");
+	printk(KERN_INFO "pcl818_ai_cmd()\n");
 	devpriv->ai_n_chan = cmd->chanlist_len;
 	devpriv->ai_chanlist = cmd->chanlist;
 	devpriv->ai_flags = cmd->flags;
@@ -1465,7 +1465,7 @@ static int ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		if (cmd->convert_src == TRIG_TIMER) {	/*  mode 1 */
 			devpriv->ai_timer1 = cmd->convert_arg;
 			retval = pcl818_ai_cmd_mode(1, dev, s);
-			printk("pcl818_ai_cmd() end\n");
+			printk(KERN_INFO "pcl818_ai_cmd() end\n");
 			return retval;
 		}
 		if (cmd->convert_src == TRIG_EXT) {	/*  mode 3 */
@@ -1484,7 +1484,7 @@ static int pcl818_ai_cancel(struct comedi_device *dev,
 			    struct comedi_subdevice *s)
 {
 	if (devpriv->irq_blocked > 0) {
-		printk("pcl818_ai_cancel()\n");
+		printk(KERN_INFO "pcl818_ai_cancel()\n");
 		devpriv->irq_was_now_closed = 1;
 
 		switch (devpriv->ai_mode) {
-- 
1.6.5.2

