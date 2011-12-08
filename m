Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab1LHMyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 07:54:47 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36787 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab1LHMyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 07:54:43 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 22/30] Staging: comedi: fix brace coding style issue in ni_at_a2150.c
Date: Thu,  8 Dec 2011 18:22:17 +0530
Message-Id: <1323348745-31477-22-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the ni_at_a2150.c file that fixes up a brace
warning found by the checkpatch.pl tool.

Removed unnecessary printk statement.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/ni_at_a2150.c |   27 ++++++++++---------------
 1 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_at_a2150.c b/drivers/staging/comedi/drivers/ni_at_a2150.c
index 32e675e..f5f21c6 100644
--- a/drivers/staging/comedi/drivers/ni_at_a2150.c
+++ b/drivers/staging/comedi/drivers/ni_at_a2150.c
@@ -349,17 +349,15 @@ static int a2150_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	printk("comedi%d: %s: io 0x%lx", dev->minor, driver_a2150.driver_name,
 	       iobase);
-	if (irq) {
+	if (irq)
 		printk(", irq %u", irq);
-	} else {
+	else
 		printk(", no irq");
-	}
-	if (dma) {
+
+	if (dma)
 		printk(", dma %u", dma);
-	} else {
+	else
 		printk(", no dma");
-	}
-	printk("\n");
 
 	/* allocate and initialize dev->private */
 	if (alloc_private(dev, sizeof(struct a2150_private)) < 0)
@@ -731,9 +729,8 @@ static int a2150_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	outw(trigger_bits, dev->iobase + TRIGGER_REG);
 
 	/*  start acquisition for soft trigger */
-	if (cmd->start_src == TRIG_NOW) {
+	if (cmd->start_src == TRIG_NOW)
 		outw(0, dev->iobase + FIFO_START_REG);
-	}
 #ifdef A2150_DEBUG
 	ni_dump_regs(dev);
 #endif
@@ -860,11 +857,10 @@ static int a2150_get_timing(struct comedi_device *dev, unsigned int *period,
 	case TRIG_ROUND_NEAREST:
 	default:
 		/*  if least upper bound is better approximation */
-		if (lub - *period < *period - glb) {
+		if (lub - *period < *period - glb)
 			*period = lub;
-		} else {
+		else
 			*period = glb;
-		}
 		break;
 	case TRIG_ROUND_UP:
 		*period = lub;
@@ -903,13 +899,12 @@ static int a2150_set_chanlist(struct comedi_device *dev,
 		devpriv->config_bits |= CHANNEL_BITS(0x4 | start_channel);
 		break;
 	case 2:
-		if (start_channel == 0) {
+		if (start_channel == 0)
 			devpriv->config_bits |= CHANNEL_BITS(0x2);
-		} else if (start_channel == 2) {
+		else if (start_channel == 2)
 			devpriv->config_bits |= CHANNEL_BITS(0x3);
-		} else {
+		else
 			return -1;
-		}
 		break;
 	case 4:
 		devpriv->config_bits |= CHANNEL_BITS(0x1);
-- 
1.7.0.4

