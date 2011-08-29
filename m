Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab1H2OEl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 10:04:41 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:42815 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab1H2OEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 10:04:32 -0400
From: Ravishankar <ravi.shankar@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankarkm <ravi.shankar@greenturtles.in>
Subject: [PATCH 1/1] Staging: comedi: fix printk and line over 80 charcter issue in dt3000.c
Date: Mon, 29 Aug 2011 19:34:10 +0530
Message-Id: <1314626650-14110-1-git-send-email-ravi.shankar@greenturtles.in>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <[PATCH]Staging: comedi: fix printk issue in dt3000.c>
References: <[PATCH]Staging: comedi: fix printk issue in dt3000.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankarkm <ravi.shankar@greenturtles.in>

This is a patch to the dt3000.c file that fixes up a printk and line over 80 character warning found by the checkpatch.pl tool

Signed-off-by: Ravishankarkm <ravi.shankar@greenturtles.in>
---
 drivers/staging/comedi/drivers/dt3000.c |   52 +++++++++++++++---------------
 1 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt3000.c b/drivers/staging/comedi/drivers/dt3000.c
index 6170f7b..d7c4857 100644
--- a/drivers/staging/comedi/drivers/dt3000.c
+++ b/drivers/staging/comedi/drivers/dt3000.c
@@ -161,7 +161,7 @@ static const struct dt3k_boardtype dt3k_boardtypes[] = {
 	 },
 };
 
-#define n_dt3k_boards sizeof(dt3k_boardtypes)/sizeof(struct dt3k_boardtype)
+#define n_dt3k_boards (sizeof(dt3k_boardtypes)/sizeof(struct dt3k_boardtype))
 #define this_board ((const struct dt3k_boardtype *)dev->board_ptr)
 
 static DEFINE_PCI_DEVICE_TABLE(dt3k_pci_table) = {
@@ -352,7 +352,7 @@ static int dt3k_send_cmd(struct comedi_device *dev, unsigned int cmd)
 	if ((status & DT3000_COMPLETION_MASK) == DT3000_NOERROR)
 		return 0;
 
-	printk("dt3k_send_cmd() timeout/error status=0x%04x\n", status);
+	pr_warn("dt3k_send_cmd() timeout/error status=0x%04x\n", status);
 
 	return -ETIME;
 }
@@ -383,7 +383,7 @@ static void dt3k_writesingle(struct comedi_device *dev, unsigned int subsys,
 	dt3k_send_cmd(dev, CMD_WRITESINGLE);
 }
 
-static int debug_n_ints = 0;
+static int debug_n_ints;
 
 /* FIXME! Assumes shared interrupt is for this card. */
 /* What's this debug_n_ints stuff? Obviously needs some work... */
@@ -420,7 +420,6 @@ static irqreturn_t dt3k_interrupt(int irq, void *d)
 	return IRQ_HANDLED;
 }
 
-#ifdef DEBUG
 static char *intr_flags[] = {
 	"AdFull", "AdSwError", "AdHwError", "DaEmpty",
 	"DaSwError", "DaHwError", "CtDone", "CmDone",
@@ -429,14 +428,13 @@ static char *intr_flags[] = {
 static void debug_intr_flags(unsigned int flags)
 {
 	int i;
-	printk("dt3k: intr_flags:");
+	pr_debug("dt3k: intr_flags:");
 	for (i = 0; i < 8; i++) {
 		if (flags & (1 << i))
-			printk(" %s", intr_flags[i]);
+			pr_cont(" %s", intr_flags[i]);
 	}
-	printk("\n");
+	pr_cont("\n");
 }
-#endif
 
 static void dt3k_ai_empty_fifo(struct comedi_device *dev,
 			       struct comedi_subdevice *s)
@@ -452,7 +450,7 @@ static void dt3k_ai_empty_fifo(struct comedi_device *dev,
 	if (count < 0)
 		count += AI_FIFO_DEPTH;
 
-	printk("reading %d samples\n", count);
+	pr_debug("reading %d samples\n", count);
 
 	rear = devpriv->ai_rear;
 
@@ -504,7 +502,8 @@ static int dt3k_ai_cmdtest(struct comedi_device *dev,
 	if (err)
 		return 1;
 
-	/* step 2: make sure trigger sources are unique and mutually compatible */
+	/* step 2: make sure trigger sources are unique
+	 * and mutually compatible */
 
 	if (err)
 		return 2;
@@ -640,7 +639,7 @@ static int dt3k_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	int ret;
 	unsigned int mode;
 
-	printk("dt3k_ai_cmd:\n");
+	pr_debug("dt3k_ai_cmd:\n");
 	for (i = 0; i < cmd->chanlist_len; i++) {
 		chan = CR_CHAN(cmd->chanlist[i]);
 		range = CR_RANGE(cmd->chanlist[i]);
@@ -651,15 +650,15 @@ static int dt3k_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	aref = CR_AREF(cmd->chanlist[0]);
 
 	writew(cmd->scan_end_arg, devpriv->io_addr + DPR_Params(0));
-	printk("param[0]=0x%04x\n", cmd->scan_end_arg);
+	pr_debug("param[0]=0x%04x\n", cmd->scan_end_arg);
 
 	if (cmd->convert_src == TRIG_TIMER) {
 		divider = dt3k_ns_to_timer(50, &cmd->convert_arg,
 					   cmd->flags & TRIG_ROUND_MASK);
 		writew((divider >> 16), devpriv->io_addr + DPR_Params(1));
-		printk("param[1]=0x%04x\n", divider >> 16);
+		pr_debug("param[1]=0x%04x\n", divider >> 16);
 		writew((divider & 0xffff), devpriv->io_addr + DPR_Params(2));
-		printk("param[2]=0x%04x\n", divider & 0xffff);
+		pr_debug("param[2]=0x%04x\n", divider & 0xffff);
 	} else {
 		/* not supported */
 	}
@@ -668,21 +667,21 @@ static int dt3k_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		tscandiv = dt3k_ns_to_timer(100, &cmd->scan_begin_arg,
 					    cmd->flags & TRIG_ROUND_MASK);
 		writew((tscandiv >> 16), devpriv->io_addr + DPR_Params(3));
-		printk("param[3]=0x%04x\n", tscandiv >> 16);
+		pr_debug("param[3]=0x%04x\n", tscandiv >> 16);
 		writew((tscandiv & 0xffff), devpriv->io_addr + DPR_Params(4));
-		printk("param[4]=0x%04x\n", tscandiv & 0xffff);
+		pr_debug("param[4]=0x%04x\n", tscandiv & 0xffff);
 	} else {
 		/* not supported */
 	}
 
 	mode = DT3000_AD_RETRIG_INTERNAL | 0 | 0;
 	writew(mode, devpriv->io_addr + DPR_Params(5));
-	printk("param[5]=0x%04x\n", mode);
+	pr_debug("param[5]=0x%04x\n", mode);
 	writew(aref == AREF_DIFF, devpriv->io_addr + DPR_Params(6));
-	printk("param[6]=0x%04x\n", aref == AREF_DIFF);
+	pr_debug("param[6]=0x%04x\n", aref == AREF_DIFF);
 
 	writew(AI_FIFO_DEPTH / 2, devpriv->io_addr + DPR_Params(7));
-	printk("param[7]=0x%04x\n", AI_FIFO_DEPTH / 2);
+	pr_debug("param[7]=0x%04x\n", AI_FIFO_DEPTH / 2);
 
 	writew(SUBS_AI, devpriv->io_addr + DPR_SubSys);
 	ret = dt3k_send_cmd(dev, CMD_CONFIG);
@@ -848,7 +847,7 @@ static int dt3000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	int bus, slot;
 	int ret = 0;
 
-	printk("dt3000:");
+	pr_info("dt3000:");
 	bus = it->options[0];
 	slot = it->options[1];
 
@@ -860,7 +859,8 @@ static int dt3000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret < 0)
 		return ret;
 	if (ret == 0) {
-		printk(" no DT board found\n");
+		pr_cont("\n");
+		pr_warn("dt3000:no DT board found\n");
 		return -ENODEV;
 	}
 
@@ -868,7 +868,9 @@ static int dt3000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	if (request_irq(devpriv->pci_dev->irq, dt3k_interrupt, IRQF_SHARED,
 			"dt3000", dev)) {
-		printk(" unable to allocate IRQ %u\n", devpriv->pci_dev->irq);
+		pr_cont("\n");
+		pr_warn("dt3000:unable to allocate IRQ %u\n",
+				devpriv->pci_dev->irq);
 		return -EINVAL;
 	}
 	dev->irq = devpriv->pci_dev->irq;
@@ -998,10 +1000,8 @@ static int setup_pci(struct comedi_device *dev)
 	devpriv->io_addr = ioremap(devpriv->phys_addr, DT3000_SIZE);
 	if (!devpriv->io_addr)
 		return -ENOMEM;
-#if DEBUG
-	printk("0x%08llx mapped to %p, ",
-	       (unsigned long long)devpriv->phys_addr, devpriv->io_addr);
-#endif
+	pr_debug("0x%08llx mapped to %p, ",
+			(unsigned long long)devpriv->phys_addr,
+			devpriv->io_addr);
 
 	return 0;
 }
-- 
1.7.6

