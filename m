Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab1GLNxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 09:53:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61438 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab1GLNxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 09:53:21 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 23/23] Staging: comedi: fix warning: line over 80 character issue in das800.c
Date: Tue, 12 Jul 2011 19:35:47 +0530
Message-Id: <1310479547-26893-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH 1/1]Staging: comedi: fix warning: line over 80 character issue in das800.c>
References: <[PATCH 1/1]Staging: comedi: fix warning: line over 80 character issue in das800.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the das800.c file that fixes up a  warning: line over 80 character found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/das800.c |   62 +++++++++++++++++++++----------
 1 files changed, 42 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das800.c b/drivers/staging/comedi/drivers/das800.c
index 96d41ad..4973ec0 100644
--- a/drivers/staging/comedi/drivers/das800.c
+++ b/drivers/staging/comedi/drivers/das800.c
@@ -96,7 +96,9 @@ cmd triggers supported:
 #define   BUSY                  0x80
 #define DAS800_GAIN           3
 #define   CIO_FFOV              0x8	/*  fifo overflow for cio-das802/16 */
-#define   CIO_ENHF              0x90	/*  interrupt fifo half full for cio-das802/16 */
+#define   CIO_ENHF              0x90	/* interrupt fifo half full for
+					 * cio - das802 / 16
+					 */
 #define   CONTROL1              0x80
 #define   CONV_CONTROL          0xa0
 #define   SCAN_LIMITS           0xc0
@@ -285,9 +287,12 @@ static int das800_probe(struct comedi_device *dev)
 	unsigned long irq_flags;
 	int board;
 
-	/*  'comedi spin lock irqsave' disables even rt interrupts, we use them to protect indirect addressing */
+	/* 'comedi spin lock irqsave' disables even rt interrupts,
+	 * we use them to protect indirect addressing
+	 */
 	spin_lock_irqsave(&dev->spinlock, irq_flags);
-	outb(ID, dev->iobase + DAS800_GAIN);	/* select base address + 7 to be ID register */
+	/* select base address + 7 to be ID register */
+	outb(ID, dev->iobase + DAS800_GAIN);
 	id_bits = inb(dev->iobase + DAS800_ID) & 0x3;	/* get id bits */
 	spin_unlock_irqrestore(&dev->spinlock, irq_flags);
 
@@ -366,11 +371,13 @@ static irqreturn_t das800_interrupt(int irq, void *d)
 	short i;		/* loop index */
 	short dataPoint = 0;
 	struct comedi_device *dev = d;
-	struct comedi_subdevice *s = dev->read_subdev;	/* analog input subdevice */
+	/* analog input subdevice */
+	struct comedi_subdevice *s = dev->read_subdev;
 	struct comedi_async *async;
 	int status;
 	unsigned long irq_flags;
-	static const int max_loops = 128;	/*  half-fifo size for cio-das802/16 */
+	/* half-fifo size for cio-das802/16 */
+	static const int max_loops = 128;
 	/*  flags */
 	int fifo_empty = 0;
 	int fifo_overflow = 0;
@@ -389,7 +396,8 @@ static irqreturn_t das800_interrupt(int irq, void *d)
 
 	/*  if hardware conversions are not enabled, then quit */
 	spin_lock_irqsave(&dev->spinlock, irq_flags);
-	outb(CONTROL1, dev->iobase + DAS800_GAIN);	/* select base address + 7 to be STATUS2 register */
+	 /* select base address + 7 to be STATUS2 register */
+	outb(CONTROL1, dev->iobase + DAS800_GAIN);
 	status = inb(dev->iobase + DAS800_STATUS2) & STATUS2_HCEN;
 	/* don't release spinlock yet since we want to make sure no one else disables hardware conversions */
 	if (status == 0) {
@@ -443,14 +451,16 @@ static irqreturn_t das800_interrupt(int irq, void *d)
 	if (devpriv->count > 0 || devpriv->forever == 1) {
 		/* Re-enable card's interrupt.
 		 * We already have spinlock, so indirect addressing is safe */
-		outb(CONTROL1, dev->iobase + DAS800_GAIN);	/* select dev->iobase + 2 to be control register 1 */
+		/* select dev->iobase + 2 to be control register 1 */
+		outb(CONTROL1, dev->iobase + DAS800_GAIN);
 		outb(CONTROL1_INTE | devpriv->do_bits,
 		     dev->iobase + DAS800_CONTROL1);
 		spin_unlock_irqrestore(&dev->spinlock, irq_flags);
 		/* otherwise, stop taking data */
 	} else {
 		spin_unlock_irqrestore(&dev->spinlock, irq_flags);
-		disable_das800(dev);	/* diable hardware triggered conversions */
+		/* diable hardware triggered conversions */
+		disable_das800(dev);
 		async->events |= COMEDI_CB_EOA;
 	}
 	comedi_event(dev, s);
@@ -548,7 +558,8 @@ static int das800_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	/* initialize digital out channels */
 	spin_lock_irqsave(&dev->spinlock, irq_flags);
-	outb(CONTROL1, dev->iobase + DAS800_GAIN);	/* select dev->iobase + 2 to be control register 1 */
+	/* select dev->iobase + 2 to be control register 1 */
+	outb(CONTROL1, dev->iobase + DAS800_GAIN);
 	outb(CONTROL1_INTE | devpriv->do_bits, dev->iobase + DAS800_CONTROL1);
 	spin_unlock_irqrestore(&dev->spinlock, irq_flags);
 
@@ -583,10 +594,14 @@ static void enable_das800(struct comedi_device *dev)
 	/*  enable fifo-half full interrupts for cio-das802/16 */
 	if (thisboard->resolution == 16)
 		outb(CIO_ENHF, dev->iobase + DAS800_GAIN);
-	outb(CONV_CONTROL, dev->iobase + DAS800_GAIN);	/* select dev->iobase + 2 to be conversion control register */
-	outb(CONV_HCEN, dev->iobase + DAS800_CONV_CONTROL);	/* enable hardware triggering */
-	outb(CONTROL1, dev->iobase + DAS800_GAIN);	/* select dev->iobase + 2 to be control register 1 */
-	outb(CONTROL1_INTE | devpriv->do_bits, dev->iobase + DAS800_CONTROL1);	/* enable card's interrupt */
+	/* select dev->iobase + 2 to be conversion control register */
+	outb(CONV_CONTROL, dev->iobase + DAS800_GAIN);
+	/* enable hardware triggering */
+	outb(CONV_HCEN, dev->iobase + DAS800_CONV_CONTROL);
+	/* select dev->iobase + 2 to be control register 1 */
+	outb(CONTROL1, dev->iobase + DAS800_GAIN);
+	/* enable card's interrupt */
+	outb(CONTROL1_INTE | devpriv->do_bits, dev->iobase + DAS800_CONTROL1);
 	spin_unlock_irqrestore(&dev->spinlock, irq_flags);
 }
 
@@ -595,8 +610,10 @@ static void disable_das800(struct comedi_device *dev)
 {
 	unsigned long irq_flags;
 	spin_lock_irqsave(&dev->spinlock, irq_flags);
-	outb(CONV_CONTROL, dev->iobase + DAS800_GAIN);	/* select dev->iobase + 2 to be conversion control register */
-	outb(0x0, dev->iobase + DAS800_CONV_CONTROL);	/* disable hardware triggering of conversions */
+	/* select dev->iobase + 2 to be conversion control register */
+	outb(CONV_CONTROL, dev->iobase + DAS800_GAIN);
+	/* disable hardware triggering of conversions */
+	outb(0x0, dev->iobase + DAS800_CONV_CONTROL);
 	spin_unlock_irqrestore(&dev->spinlock, irq_flags);
 }
 
@@ -749,7 +766,8 @@ static int das800_ai_do_cmd(struct comedi_device *dev,
 	scan = (endChan << 3) | startChan;
 
 	spin_lock_irqsave(&dev->spinlock, irq_flags);
-	outb(SCAN_LIMITS, dev->iobase + DAS800_GAIN);	/* select base address + 2 to be scan limits register */
+	/* select base address + 2 to be scan limits register */
+	outb(SCAN_LIMITS, dev->iobase + DAS800_GAIN);
 	outb(scan, dev->iobase + DAS800_SCAN_LIMITS);	/* set scan limits */
 	spin_unlock_irqrestore(&dev->spinlock, irq_flags);
 
@@ -801,7 +819,8 @@ static int das800_ai_do_cmd(struct comedi_device *dev,
 	}
 
 	spin_lock_irqsave(&dev->spinlock, irq_flags);
-	outb(CONV_CONTROL, dev->iobase + DAS800_GAIN);	/* select dev->iobase + 2 to be conversion control register */
+	/* select dev->iobase + 2 to be conversion control register */
+	outb(CONV_CONTROL, dev->iobase + DAS800_GAIN);
 	outb(conv_bits, dev->iobase + DAS800_CONV_CONTROL);
 	spin_unlock_irqrestore(&dev->spinlock, irq_flags);
 	async->events = 0;
@@ -820,13 +839,15 @@ static int das800_ai_rinsn(struct comedi_device *dev,
 	int timeout = 1000;
 	unsigned long irq_flags;
 
-	disable_das800(dev);	/* disable hardware conversions (enables software conversions) */
+	/* disable hardware conversions (enables software conversions) */
+	disable_das800(dev);
 
 	/* set multiplexer */
 	chan = CR_CHAN(insn->chanspec);
 
 	spin_lock_irqsave(&dev->spinlock, irq_flags);
-	outb(CONTROL1, dev->iobase + DAS800_GAIN);	/* select dev->iobase + 2 to be control register 1 */
+	/* select dev->iobase + 2 to be control register 1 */
+	outb(CONTROL1, dev->iobase + DAS800_GAIN);
 	outb(chan | devpriv->do_bits, dev->iobase + DAS800_CONTROL1);
 	spin_unlock_irqrestore(&dev->spinlock, irq_flags);
 
@@ -893,7 +914,8 @@ static int das800_do_wbits(struct comedi_device *dev,
 	devpriv->do_bits = wbits << 4;
 
 	spin_lock_irqsave(&dev->spinlock, irq_flags);
-	outb(CONTROL1, dev->iobase + DAS800_GAIN);	/* select dev->iobase + 2 to be control register 1 */
+	/* select dev->iobase + 2 to be control register 1 */
+	outb(CONTROL1, dev->iobase + DAS800_GAIN);
 	outb(devpriv->do_bits | CONTROL1_INTE, dev->iobase + DAS800_CONTROL1);
 	spin_unlock_irqrestore(&dev->spinlock, irq_flags);
 
-- 
1.6.5.2

