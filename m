Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab1GLJYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 05:24:53 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61992 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab1GLJYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 05:24:52 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 21/21] Staging: comedi: fix braces and line over 80 character style issue in ni_at_12150.c
Date: Tue, 12 Jul 2011 15:07:32 +0530
Message-Id: <1310463452-974-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH 1/1]Staging: comedi: fix brace and line over 80 character issue in ni_at_2150.c>
References: <[PATCH 1/1]Staging: comedi: fix brace and line over 80 character issue in ni_at_2150.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the ni_at_12150.c file that fixes up a braces and line over 80 character warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/ni_at_a2150.c |   39 ++++++++++++++------------
 1 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_at_a2150.c b/drivers/staging/comedi/drivers/ni_at_a2150.c
index 32e675e..aa49469 100644
--- a/drivers/staging/comedi/drivers/ni_at_a2150.c
+++ b/drivers/staging/comedi/drivers/ni_at_a2150.c
@@ -88,8 +88,12 @@ TRIG_WAKE_EOS
 #define   CLOCK_SELECT_BITS(x)		(((x) & 0x3) << 3)
 #define   CLOCK_DIVISOR_BITS(x)		(((x) & 0x3) << 5)
 #define   CLOCK_MASK		(0xf << 3)
-#define   ENABLE0_BIT		0x80	/*  enable (don't internally ground) channels 0 and 1 */
-#define   ENABLE1_BIT		0x100	/*  enable (don't internally ground) channels 2 and 3 */
+#define   ENABLE0_BIT		0x80	/* enable (don't internally ground)
+					 * channels 0 and 1
+					 */
+#define   ENABLE1_BIT		0x100	/* enable (don't internally ground)
+					 * channels 2 and 3
+					 */
 #define   AC0_BIT		0x200	/*  ac couple channels 0,1 */
 #define   AC1_BIT		0x400	/*  ac couple channels 2,3 */
 #define   APD_BIT		0x800	/*  analog power down */
@@ -101,14 +105,17 @@ TRIG_WAKE_EOS
 #define FIFO_START_REG		0x6	/*  software start aquistion trigger */
 #define FIFO_RESET_REG		0x8	/*  clears fifo + fifo flags */
 #define FIFO_DATA_REG		0xa	/*  read data */
-#define DMA_TC_CLEAR_REG		0xe	/*  clear dma terminal count interrupt */
+#define DMA_TC_CLEAR_REG		0xe	/* clear dma terminal count
+						 * interrupt
+						 */
 #define STATUS_REG		0x12	/*  read only */
 #define   FNE_BIT		0x1	/*  fifo not empty */
 #define   OVFL_BIT		0x8	/*  fifo overflow */
 #define   EDAQ_BIT		0x10	/*  end of acquisition interrupt */
 #define   DCAL_BIT		0x20	/*  offset calibration in progress */
 #define   INTR_BIT		0x40	/*  interrupt has occurred */
@@ -215,9 +222,9 @@ module_exit(driver_a2150_cleanup_module);
 
 static void ni_dump_regs(struct comedi_device *dev)
 {
-	printk("config bits 0x%x\n", devpriv->config_bits);
-	printk("irq dma bits 0x%x\n", devpriv->irq_dma_bits);
-	printk("status bits 0x%x\n", inw(dev->iobase + STATUS_REG));
+	printk(KERN_DEBUG "config bits 0x%x\n", devpriv->config_bits);
+	printk(KERN_DEBUG "irq dma bits 0x%x\n", devpriv->irq_dma_bits);
+	printk(KERN_DEBUG "status bits 0x%x\n", inw(dev->iobase + STATUS_REG));
 }
 
 #endif
@@ -349,16 +356,14 @@ static int a2150_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
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
+	if (dma)
 		printk(", dma %u", dma);
-	} else {
+	else
 		printk(", no dma");
-	}
 	printk("\n");
 
 	/* allocate and initialize dev->private */
@@ -731,9 +736,8 @@ static int a2150_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	outw(trigger_bits, dev->iobase + TRIGGER_REG);
 
 	/*  start acquisition for soft trigger */
-	if (cmd->start_src == TRIG_NOW) {
+	if (cmd->start_src == TRIG_NOW)
 		outw(0, dev->iobase + FIFO_START_REG);
-	}
 #ifdef A2150_DEBUG
 	ni_dump_regs(dev);
 #endif
@@ -860,11 +864,10 @@ static int a2150_get_timing(struct comedi_device *dev, unsigned int *period,
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
-- 
1.6.5.2

