Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab1LHMyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 07:54:13 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64358 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab1LHMyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 07:54:06 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 15/30] Staging: comedi: fix printk issue in dt3000.c
Date: Thu,  8 Dec 2011 18:22:10 +0530
Message-Id: <1323348745-31477-15-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the dt3000.c file that fixes up a
printk warning found by the checkpatch.pl tool.

Removed ifdef DEBUG.
Converted printks to pr_<levels>.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/dt3000.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt3000.c b/drivers/staging/comedi/drivers/dt3000.c
index 069a691..c656fe4 100644
--- a/drivers/staging/comedi/drivers/dt3000.c
+++ b/drivers/staging/comedi/drivers/dt3000.c
@@ -352,7 +352,7 @@ static int dt3k_send_cmd(struct comedi_device *dev, unsigned int cmd)
 	if ((status & DT3000_COMPLETION_MASK) == DT3000_NOERROR)
 		return 0;
 
-	printk("dt3k_send_cmd() timeout/error status=0x%04x\n", status);
+	pr_err("dt3k_send_cmd() timeout/error status=0x%04x\n", status);
 
 	return -ETIME;
 }
@@ -420,7 +420,6 @@ static irqreturn_t dt3k_interrupt(int irq, void *d)
 	return IRQ_HANDLED;
 }
 
-#ifdef DEBUG
 static char *intr_flags[] = {
 	"AdFull", "AdSwError", "AdHwError", "DaEmpty",
 	"DaSwError", "DaHwError", "CtDone", "CmDone",
@@ -429,14 +428,12 @@ static char *intr_flags[] = {
 static void debug_intr_flags(unsigned int flags)
 {
 	int i;
-	printk("dt3k: intr_flags:");
+	pr_debug("dt3k: intr_flags:\n");
 	for (i = 0; i < 8; i++) {
 		if (flags & (1 << i))
-			printk(" %s", intr_flags[i]);
+			pr_debug("%s\n", intr_flags[i]);
 	}
-	printk("\n");
 }
-#endif
 
 static void dt3k_ai_empty_fifo(struct comedi_device *dev,
 			       struct comedi_subdevice *s)
@@ -452,7 +449,7 @@ static void dt3k_ai_empty_fifo(struct comedi_device *dev,
 	if (count < 0)
 		count += AI_FIFO_DEPTH;
 
-	printk("reading %d samples\n", count);
+	pr_debug("reading %d samples\n", count);
 
 	rear = devpriv->ai_rear;
 
-- 
1.7.0.4

