Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab2F2PeC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 11:34:02 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51289 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485Ab2F2Pd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 11:33:58 -0400
From: Sebastian Benvenuti <sebastianbenvenuti@gmail.com>
To: abbotti@mev.co.uk
Cc: fmhess@users.sourceforge.net, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org,
        Sebastian Benvenuti <sebastianbenvenuti@gmail.com>
Subject: [PATCH 4/4] Staging: comedi: ssv_dnp: Syntax issues fixed
Date: Fri, 29 Jun 2012 12:33:52 -0300
Message-Id: <1340984032-1827-1-git-send-email-sebastianbenvenuti@gmail.com>
X-Mailer: git-send-email 1.7.11.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed "printk(KERN_X" to "pr_x(" and line lenght issues

Signed-off-by: Sebastian Benvenuti <sebastianbenvenuti@gmail.com>
---
 drivers/staging/comedi/drivers/s526.c | 40 +++++++++++++++++------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/comedi/drivers/s526.c b/drivers/staging/comedi/drivers/s526.c
index 7a56434..c3abe82 100644
--- a/drivers/staging/comedi/drivers/s526.c
+++ b/drivers/staging/comedi/drivers/s526.c
@@ -241,7 +241,7 @@ static int s526_gpct_rinsn(struct comedi_device *dev,
 
 	/*  Check if (n > 0) */
 	if (insn->n <= 0) {
-		printk(KERN_ERR "s526: INSN_READ: n should be > 0\n");
+		pr_err("s526: INSN_READ: n should be > 0\n");
 		return -EINVAL;
 	}
 	/*  Read the low word first */
@@ -284,7 +284,7 @@ static int s526_gpct_insn_config(struct comedi_device *dev,
 		   data[2]: Pre-load Register Value
 		   data[3]: Conter Control Register
 		 */
-		printk(KERN_INFO "s526: GPCT_INSN_CONFIG: Configuring Encoder\n");
+		pr_info("s526: GPCT_INSN_CONFIG: Configuring Encoder\n");
 		devpriv->s526_gpct_config[subdev_channel].app =
 		    PositionMeasurement;
 
@@ -391,7 +391,7 @@ static int s526_gpct_insn_config(struct comedi_device *dev,
 		   data[3]: Pre-load Register 1 Value
 		   data[4]: Conter Control Register
 		 */
-		printk(KERN_INFO "s526: GPCT_INSN_CONFIG: Configuring SPG\n");
+		pr_info("s526: GPCT_INSN_CONFIG: Configuring SPG\n");
 		devpriv->s526_gpct_config[subdev_channel].app =
 		    SinglePulseGeneration;
 
@@ -436,7 +436,7 @@ static int s526_gpct_insn_config(struct comedi_device *dev,
 		   data[3]: Pre-load Register 1 Value
 		   data[4]: Conter Control Register
 		 */
-		printk(KERN_INFO "s526: GPCT_INSN_CONFIG: Configuring PTG\n");
+		pr_info("s526: GPCT_INSN_CONFIG: Configuring PTG\n");
 		devpriv->s526_gpct_config[subdev_channel].app =
 		    PulseTrainGeneration;
 
@@ -474,7 +474,7 @@ static int s526_gpct_insn_config(struct comedi_device *dev,
 		break;
 
 	default:
-		printk(KERN_ERR "s526: unsupported GPCT_insn_config\n");
+		pr_err("s526: unsupported GPCT_insn_config\n");
 		return -EINVAL;
 		break;
 	}
@@ -490,21 +490,21 @@ static int s526_gpct_winsn(struct comedi_device *dev,
 	short value;
 	union cmReg cmReg;
 
-	printk(KERN_INFO "s526: GPCT_INSN_WRITE on channel %d\n",
+	pr_info("s526: GPCT_INSN_WRITE on channel %d\n",
 					subdev_channel);
 	cmReg.value = inw(ADDR_CHAN_REG(REG_C0M, subdev_channel));
-	printk(KERN_INFO "s526: Counter Mode Register: %x\n", cmReg.value);
+	pr_info("s526: Counter Mode Register: %x\n", cmReg.value);
 	/*  Check what Application of Counter this channel is configured for */
 	switch (devpriv->s526_gpct_config[subdev_channel].app) {
 	case PositionMeasurement:
-		printk(KERN_INFO "S526: INSN_WRITE: PM\n");
+		pr_info("S526: INSN_WRITE: PM\n");
 		outw(0xFFFF & ((*data) >> 16), ADDR_CHAN_REG(REG_C0H,
 							     subdev_channel));
 		outw(0xFFFF & (*data), ADDR_CHAN_REG(REG_C0L, subdev_channel));
 		break;
 
 	case SinglePulseGeneration:
-		printk(KERN_INFO "S526: INSN_WRITE: SPG\n");
+		pr_info("S526: INSN_WRITE: SPG\n");
 		outw(0xFFFF & ((*data) >> 16), ADDR_CHAN_REG(REG_C0H,
 							     subdev_channel));
 		outw(0xFFFF & (*data), ADDR_CHAN_REG(REG_C0L, subdev_channel));
@@ -517,14 +517,14 @@ static int s526_gpct_winsn(struct comedi_device *dev,
 		   The above periods must be expressed as a multiple of the
 		   pulse frequency on the selected source
 		 */
-		printk(KERN_INFO "S526: INSN_WRITE: PTG\n");
+		pr_info("S526: INSN_WRITE: PTG\n");
 		if ((insn->data[1] > insn->data[0]) && (insn->data[0] > 0)) {
 			(devpriv->s526_gpct_config[subdev_channel]).data[0] =
 			    insn->data[0];
 			(devpriv->s526_gpct_config[subdev_channel]).data[1] =
 			    insn->data[1];
 		} else {
-			printk(KERN_ERR "s526: INSN_WRITE: PTG: Problem with Pulse params -> %d %d\n",
+			pr_err("s526: INSN_WRITE: PTG: Problem with Pulse params -> %d %d\n",
 				insn->data[0], insn->data[1]);
 			return -EINVAL;
 		}
@@ -613,7 +613,7 @@ static int s526_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 		if (i == TIMEOUT) {
 			/* printk() should be used instead of printk()
 			 * whenever the code can be called from real-time. */
-			printk(KERN_ERR "s526: ADC(0x%04x) timeout\n",
+			pr_err("s526: ADC(0x%04x) timeout\n",
 			       inw(ADDR_REG(REG_ISR)));
 			return -ETIMEDOUT;
 		}
@@ -712,7 +712,7 @@ static int s526_dio_insn_config(struct comedi_device *dev,
 	int chan = CR_CHAN(insn->chanspec);
 	int group, mask;
 
-	printk(KERN_INFO "S526 DIO insn_config\n");
+	pr_info("S526 DIO insn_config\n");
 
 	/* The input or output configuration of each digital line is
 	 * configured by a special insn_config instruction.  chanspec
@@ -751,7 +751,7 @@ static int s526_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 /* int subdev_channel = 0; */
 	union cmReg cmReg;
 
-	printk(KERN_INFO "comedi%d: s526: ", dev->minor);
+	pr_info("comedi%d: s526: ", dev->minor);
 
 	iobase = it->options[0];
 	if (!iobase || !request_region(iobase, S526_IOSIZE, thisboard->name)) {
@@ -850,7 +850,7 @@ static int s526_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		s->type = COMEDI_SUBD_UNUSED;
 	}
 
-	printk(KERN_INFO "attached\n");
+	pr_info("attached\n");
 
 	return 1;
 
@@ -897,11 +897,11 @@ static int s526_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	cmReg.reg.reserved = 0;
 
 	n = 0;
-	printk(KERN_INFO "Mode reg=0x%04x, 0x%04lx\n",
+	pr_info("Mode reg=0x%04x, 0x%04lx\n",
 		cmReg.value, ADDR_CHAN_REG(REG_C0M, n));
 	outw(cmReg.value, ADDR_CHAN_REG(REG_C0M, n));
 	udelay(1000);
-	printk(KERN_INFO "Read back mode reg=0x%04x\n",
+	pr_info("Read back mode reg=0x%04x\n",
 		inw(ADDR_CHAN_REG(REG_C0M, n)));
 
 	/*  Load the pre-load register high word */
@@ -925,14 +925,14 @@ static int s526_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	outw(cmReg.value, ADDR_CHAN_REG(REG_C0M, n));
 	udelay(1000);
-	printk(KERN_INFO "Read back mode reg=0x%04x\n",
+	pr_info("Read back mode reg=0x%04x\n",
 			inw(ADDR_CHAN_REG(REG_C0M, n)));
 
 #endif
-	printk(KERN_INFO "Current registres:\n");
+	pr_info("Current registres:\n");
 
 	for (i = 0; i < S526_NUM_PORTS; i++) {
-		printk(KERN_INFO "0x%02lx: 0x%04x\n",
+		pr_info("0x%02lx: 0x%04x\n",
 			ADDR_REG(s526_ports[i]), inw(ADDR_REG(s526_ports[i])));
 	}
 	return 1;
-- 
1.7.11.1

