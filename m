Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471Ab2EKKlB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 06:41:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63800 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332Ab2EKKk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 06:40:57 -0400
From: Ravishankar Karkala Mallikarjunayya <ravishankarkm32@gmail.com>
To: gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 10/25] Staging: comedi: fix printk issue in s526.c
Date: Fri, 11 May 2012 16:07:58 +0530
Message-Id: <1336732693-7408-11-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the s526.c file that fixes up a printk found
by the checkpatch.pl tool.

Used dev_<level> functions instead of printks wherver possible.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/s526.c |   50 ++++++++++++++++----------------
 1 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/comedi/drivers/s526.c b/drivers/staging/comedi/drivers/s526.c
index ffe4362..c921055 100644
--- a/drivers/staging/comedi/drivers/s526.c
+++ b/drivers/staging/comedi/drivers/s526.c
@@ -241,7 +241,7 @@ static int s526_gpct_rinsn(struct comedi_device *dev,
 
 	/*  Check if (n > 0) */
 	if (insn->n <= 0) {
-		printk(KERN_ERR "s526: INSN_READ: n should be > 0\n");
+		dev_err(dev->hw_dev, "INSN_READ: n should be > 0\n");
 		return -EINVAL;
 	}
 	/*  Read the low word first */
@@ -284,7 +284,7 @@ static int s526_gpct_insn_config(struct comedi_device *dev,
 		   data[2]: Pre-load Register Value
 		   data[3]: Conter Control Register
 		 */
-		printk(KERN_INFO "s526: GPCT_INSN_CONFIG: Configuring Encoder\n");
+		dev_info(dev->hw_dev, "GPCT_INSN_CONFIG: Configuring Encoder\n");
 		devpriv->s526_gpct_config[subdev_channel].app =
 		    PositionMeasurement;
 
@@ -391,7 +391,7 @@ static int s526_gpct_insn_config(struct comedi_device *dev,
 		   data[3]: Pre-load Register 1 Value
 		   data[4]: Conter Control Register
 		 */
-		printk(KERN_INFO "s526: GPCT_INSN_CONFIG: Configuring SPG\n");
+		dev_info(dev->hw_dev, "GPCT_INSN_CONFIG: Configuring SPG\n");
 		devpriv->s526_gpct_config[subdev_channel].app =
 		    SinglePulseGeneration;
 
@@ -436,7 +436,7 @@ static int s526_gpct_insn_config(struct comedi_device *dev,
 		   data[3]: Pre-load Register 1 Value
 		   data[4]: Conter Control Register
 		 */
-		printk(KERN_INFO "s526: GPCT_INSN_CONFIG: Configuring PTG\n");
+		dev_info(dev->hw_dev, "GPCT_INSN_CONFIG: Configuring PTG\n");
 		devpriv->s526_gpct_config[subdev_channel].app =
 		    PulseTrainGeneration;
 
@@ -474,7 +474,7 @@ static int s526_gpct_insn_config(struct comedi_device *dev,
 		break;
 
 	default:
-		printk(KERN_ERR "s526: unsupported GPCT_insn_config\n");
+		dev_err(dev->hw_dev, "unsupported GPCT_insn_config\n");
 		return -EINVAL;
 		break;
 	}
@@ -490,21 +490,21 @@ static int s526_gpct_winsn(struct comedi_device *dev,
 	short value;
 	union cmReg cmReg;
 
-	printk(KERN_INFO "s526: GPCT_INSN_WRITE on channel %d\n",
-					subdev_channel);
+	dev_info(dev->hw_dev, "GPCT_INSN_WRITE on channel %d\n",
+		 subdev_channel);
 	cmReg.value = inw(ADDR_CHAN_REG(REG_C0M, subdev_channel));
-	printk(KERN_INFO "s526: Counter Mode Register: %x\n", cmReg.value);
+	dev_info(dev->hw_dev, "Counter Mode Register: %x\n", cmReg.value);
 	/*  Check what Application of Counter this channel is configured for */
 	switch (devpriv->s526_gpct_config[subdev_channel].app) {
 	case PositionMeasurement:
-		printk(KERN_INFO "S526: INSN_WRITE: PM\n");
+		dev_info(dev->hw_dev, "INSN_WRITE: PM\n");
 		outw(0xFFFF & ((*data) >> 16), ADDR_CHAN_REG(REG_C0H,
 							     subdev_channel));
 		outw(0xFFFF & (*data), ADDR_CHAN_REG(REG_C0L, subdev_channel));
 		break;
 
 	case SinglePulseGeneration:
-		printk(KERN_INFO "S526: INSN_WRITE: SPG\n");
+		dev_info(dev->hw_dev, "INSN_WRITE: SPG\n");
 		outw(0xFFFF & ((*data) >> 16), ADDR_CHAN_REG(REG_C0H,
 							     subdev_channel));
 		outw(0xFFFF & (*data), ADDR_CHAN_REG(REG_C0L, subdev_channel));
@@ -517,14 +517,14 @@ static int s526_gpct_winsn(struct comedi_device *dev,
 		   The above periods must be expressed as a multiple of the
 		   pulse frequency on the selected source
 		 */
-		printk(KERN_INFO "S526: INSN_WRITE: PTG\n");
+		dev_info(dev->hw_dev, "INSN_WRITE: PTG\n");
 		if ((insn->data[1] > insn->data[0]) && (insn->data[0] > 0)) {
 			(devpriv->s526_gpct_config[subdev_channel]).data[0] =
 			    insn->data[0];
 			(devpriv->s526_gpct_config[subdev_channel]).data[1] =
 			    insn->data[1];
 		} else {
-			printk(KERN_ERR "s526: INSN_WRITE: PTG: Problem with Pulse params -> %d %d\n",
+			dev_err(dev->hw_dev, "INSN_WRITE: PTG: Problem with Pulse params -> %d %d\n",
 				insn->data[0], insn->data[1]);
 			return -EINVAL;
 		}
@@ -613,8 +613,8 @@ static int s526_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 		if (i == TIMEOUT) {
 			/* printk() should be used instead of printk()
 			 * whenever the code can be called from real-time. */
-			printk(KERN_ERR "s526: ADC(0x%04x) timeout\n",
-			       inw(ADDR_REG(REG_ISR)));
+			dev_err(dev->hw_dev, "ADC(0x%04x) timeout\n",
+				inw(ADDR_REG(REG_ISR)));
 			return -ETIMEDOUT;
 		}
 
@@ -712,7 +712,7 @@ static int s526_dio_insn_config(struct comedi_device *dev,
 	int chan = CR_CHAN(insn->chanspec);
 	int group, mask;
 
-	printk(KERN_INFO "S526 DIO insn_config\n");
+	dev_info(dev->hw_dev, "S526 DIO insn_config\n");
 
 	/* The input or output configuration of each digital line is
 	 * configured by a special insn_config instruction.  chanspec
@@ -897,12 +897,12 @@ static int s526_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	cmReg.reg.reserved = 0;
 
 	n = 0;
-	printk(KERN_INFO "Mode reg=0x%04x, 0x%04lx\n",
-		cmReg.value, ADDR_CHAN_REG(REG_C0M, n));
+	dev_info(dev->hw_dev, "Mode reg=0x%04x, 0x%04lx\n",
+		 cmReg.value, ADDR_CHAN_REG(REG_C0M, n));
 	outw(cmReg.value, ADDR_CHAN_REG(REG_C0M, n));
 	udelay(1000);
-	printk(KERN_INFO "Read back mode reg=0x%04x\n",
-		inw(ADDR_CHAN_REG(REG_C0M, n)));
+	dev_info(dev->hw_dev, "Read back mode reg=0x%04x\n",
+		 inw(ADDR_CHAN_REG(REG_C0M, n)));
 
 	/*  Load the pre-load register high word */
 /* value = (short) (0x55); */
@@ -925,22 +925,22 @@ static int s526_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	outw(cmReg.value, ADDR_CHAN_REG(REG_C0M, n));
 	udelay(1000);
-	printk(KERN_INFO "Read back mode reg=0x%04x\n",
-			inw(ADDR_CHAN_REG(REG_C0M, n)));
+	dev_info(dev->hw_dev, "Read back mode reg=0x%04x\n",
+		 inw(ADDR_CHAN_REG(REG_C0M, n)));
 
 #endif
-	printk(KERN_INFO "Current registres:\n");
+	dev_info(dev->hw_dev, "Current registres:\n");
 
 	for (i = 0; i < S526_NUM_PORTS; i++) {
-		printk(KERN_INFO "0x%02lx: 0x%04x\n",
-			ADDR_REG(s526_ports[i]), inw(ADDR_REG(s526_ports[i])));
+		dev_info(dev->hw_dev, "0x%02lx: 0x%04x\n",
+			 ADDR_REG(s526_ports[i]), inw(ADDR_REG(s526_ports[i])));
 	}
 	return 1;
 }
 
 static int s526_detach(struct comedi_device *dev)
 {
-	printk(KERN_INFO "comedi%d: s526: remove\n", dev->minor);
+	dev_info(dev->hw_dev, "comedi%d: remove\n", dev->minor);
 
 	if (dev->iobase > 0)
 		release_region(dev->iobase, S526_IOSIZE);
-- 
1.7.0.4

