Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933087Ab0D3Sne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:43:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46396 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932769Ab0D3SnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:43:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=o1HIF/MRdEARTYWj1QrO4L+zsR/AmLiig4qpkzQQLelm/PSQfSaQfWackvOH5ChMt/
         t+ecAIcQGSTZzoQmgFHsdJDxoSXTJVbIn/IWGipy2KTk+VqnSRPteabBAGW3JFAaFlre
         dF9Y3RezvxeBJ/S9v6VtIfeLdrPLE/bUussmE=
From: Iain Churcher <iain.linux.coding@googlemail.com>
To: iain.linux.coding@googlemail.com, gregkh@suse.de, wfp5p@virginia.edu,
       jkosina@suse.cz, mithlesh@linsyssoft.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 121/121] Staging: comedi: numerous checkpatch.pl issues in dt282x.c This patch cleans up numerous WARNINGS and ERRORS listed by the checkpatch.pl tool Signed-off-by: Iain Churcher <iain.linux.coding@googlemail.com>
Date: Thu, 29 Apr 2010 19:02:01 +0100
Message-Id: <1272564121-4494-1-git-send-email-iain.linux.coding@googlemail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/comedi/drivers/dt282x.c |  225 +++++++++++++++----------------
 1 files changed, 107 insertions(+), 118 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt282x.c b/drivers/staging/comedi/drivers/dt282x.c
index e548763..fd8728c 100644
--- a/drivers/staging/comedi/drivers/dt282x.c
+++ b/drivers/staging/comedi/drivers/dt282x.c
@@ -45,9 +45,9 @@ Configuration options:
   [7] - AO 1 jumpered for 0=straight binary, 1=2's complement
   [8] - AI jumpered for 0=[-10,10]V, 1=[0,10], 2=[-5,5], 3=[0,5]
   [9] - AO 0 jumpered for 0=[-10,10]V, 1=[0,10], 2=[-5,5], 3=[0,5],
-        4=[-2.5,2.5]
+	4=[-2.5,2.5]
   [10]- A0 1 jumpered for 0=[-10,10]V, 1=[0,10], 2=[-5,5], 3=[0,5],
-        4=[-2.5,2.5]
+	4=[-2.5,2.5]
 
 Notes:
   - AO commands might be broken.
@@ -155,79 +155,58 @@ Notes:
 #define DT2821_XCLK	0x0002	/* (R/W) external clock enable            */
 #define DT2821_BDINIT	0x0001	/* (W)   initialize board         */
 
-static const struct comedi_lrange range_dt282x_ai_lo_bipolar = { 4, {
-								     RANGE(-10,
-									   10),
-								     RANGE(-5,
-									   5),
-								     RANGE(-2.5,
-									   2.5),
-								     RANGE
-								     (-1.25,
-								      1.25)
-								     }
+static const struct comedi_lrange range_dt282x_ai_lo_bipolar = {
+	4, {
+		RANGE(-10, 10),
+		RANGE(-5, 5),
+		RANGE(-2.5, 2.5),
+		RANGE(-1.25, 1.25)
+	}
 };
 
-static const struct comedi_lrange range_dt282x_ai_lo_unipolar = { 4, {
-								      RANGE(0,
-									    10),
-								      RANGE(0,
-									    5),
-								      RANGE(0,
-									    2.5),
-								      RANGE(0,
-									    1.25)
-								      }
+static const struct comedi_lrange range_dt282x_ai_lo_unipolar = {
+	4, {
+		RANGE(0, 10),
+		RANGE(0, 5),
+		RANGE(0, 2.5),
+		RANGE(0, 1.25)
+	}
 };
 
-static const struct comedi_lrange range_dt282x_ai_5_bipolar = { 4, {
-								    RANGE(-5,
-									  5),
-								    RANGE(-2.5,
-									  2.5),
-								    RANGE(-1.25,
-									  1.25),
-								    RANGE
-								    (-0.625,
-								     0.625),
-								    }
+static const struct comedi_lrange range_dt282x_ai_5_bipolar = {
+	4, {
+		RANGE(-5, 5),
+		RANGE(-2.5, 2.5),
+		RANGE(-1.25, 1.25),
+		RANGE(-0.625, 0.625)
+	}
 };
 
-static const struct comedi_lrange range_dt282x_ai_5_unipolar = { 4, {
-								     RANGE(0,
-									   5),
-								     RANGE(0,
-									   2.5),
-								     RANGE(0,
-									   1.25),
-								     RANGE(0,
-									   0.625),
-								     }
+static const struct comedi_lrange range_dt282x_ai_5_unipolar = {
+	4, {
+		RANGE(0, 5),
+		RANGE(0, 2.5),
+		RANGE(0, 1.25),
+		RANGE(0, 0.625),
+	}
 };
 
-static const struct comedi_lrange range_dt282x_ai_hi_bipolar = { 4, {
-								     RANGE(-10,
-									   10),
-								     RANGE(-1,
-									   1),
-								     RANGE(-0.1,
-									   0.1),
-								     RANGE
-								     (-0.02,
-								      0.02)
-								     }
+static const struct comedi_lrange range_dt282x_ai_hi_bipolar = {
+	4, {
+		RANGE(-10, 10),
+		RANGE(-1, 1),
+		RANGE(-0.1, 0.1),
+		RANGE(-0.02, 0.02)
+	}
 };
 
-static const struct comedi_lrange range_dt282x_ai_hi_unipolar = { 4, {
-								      RANGE(0,
-									    10),
-								      RANGE(0,
-									    1),
-								      RANGE(0,
-									    0.1),
-								      RANGE(0,
-									    0.02)
-								      }
+static const struct comedi_lrange range_dt282x_ai_hi_unipolar = {
+	4, {
+		RANGE(0, 10),
+		RANGE(0, 1),
+		RANGE(0, 0.1),
+		RANGE(0, 0.02)
+	}
 };
 
 struct dt282x_board {
@@ -370,7 +349,7 @@ static const struct dt282x_board boardtypes[] = {
 	 },
 };
 
-#define n_boardtypes sizeof(boardtypes)/sizeof(struct dt282x_board)
+#define n_boardtypes (sizeof(boardtypes)/sizeof(struct dt282x_board))
 #define this_board ((const struct dt282x_board *)dev->board_ptr)
 
 struct dt282x_private {
@@ -411,21 +390,25 @@ struct dt282x_private {
 #define update_adcsr(a)	outw(devpriv->adcsr|(a), dev->iobase+DT2821_ADCSR)
 #define mux_busy() (inw(dev->iobase+DT2821_ADCSR)&DT2821_MUXBUSY)
 #define ad_done() (inw(dev->iobase+DT2821_ADCSR)&DT2821_ADDONE)
-#define update_supcsr(a)	outw(devpriv->supcsr|(a), dev->iobase+DT2821_SUPCSR)
+#define update_supcsr(a) outw(devpriv->supcsr|(a), dev->iobase+DT2821_SUPCSR)
 
 /*
  *    danger! macro abuse... a is the expression to wait on, and b is
  *      the statement(s) to execute if it doesn't happen.
  */
-#define wait_for(a, b)	 				\
-	do{						\
-		int _i;					\
-		for (_i=0;_i<DT2821_TIMEOUT;_i++){	\
-			if (a){_i=0;break;}		\
-			udelay(5);			\
-		}					\
-		if (_i){b}				\
-	}while (0)
+#define wait_for(a, b)						\
+	do {							\
+		int _i;						\
+		for (_i = 0; _i < DT2821_TIMEOUT; _i++) {	\
+			if (a) {				\
+				_i = 0;				\
+				break;				\
+			}					\
+			udelay(5);				\
+		}						\
+		if (_i)						\
+			b					\
+	} while (0)
 
 static int dt282x_attach(struct comedi_device *dev,
 			 struct comedi_devconfig *it);
@@ -462,18 +445,16 @@ static void dt282x_munge(struct comedi_device *dev, short *buf,
 	unsigned short sign = 1 << (boardtype.adbits - 1);
 	int n;
 
-	if (devpriv->ad_2scomp) {
+	if (devpriv->ad_2scomp)
 		sign = 1 << (boardtype.adbits - 1);
-	} else {
+	else
 		sign = 0;
-	}
 
 	if (nbytes % 2)
 		comedi_error(dev, "bug! odd number of bytes from dma xfer");
 	n = nbytes / 2;
-	for (i = 0; i < n; i++) {
+	for (i = 0; i < n; i++)
 		buf[i] = (buf[i] & mask) ^ sign;
-	}
 }
 
 static void dt282x_ao_dma_interrupt(struct comedi_device *dev)
@@ -486,7 +467,7 @@ static void dt282x_ao_dma_interrupt(struct comedi_device *dev)
 	update_supcsr(DT2821_CLRDMADNE);
 
 	if (!s->async->prealloc_buf) {
-		printk("async->data disappeared.  dang!\n");
+		printk(KERN_ERR "async->data disappeared.  dang!\n");
 		return;
 	}
 
@@ -499,7 +480,7 @@ static void dt282x_ao_dma_interrupt(struct comedi_device *dev)
 
 	size = cfc_read_array_from_buffer(s, ptr, devpriv->dma_maxsize);
 	if (size == 0) {
-		printk("dt282x: AO underrun\n");
+		printk(KERN_ERR "dt282x: AO underrun\n");
 		dt282x_ao_cancel(dev, s);
 		s->async->events |= COMEDI_CB_OVERFLOW;
 		return;
@@ -519,7 +500,7 @@ static void dt282x_ai_dma_interrupt(struct comedi_device *dev)
 	update_supcsr(DT2821_CLRDMADNE);
 
 	if (!s->async->prealloc_buf) {
-		printk("async->data disappeared.  dang!\n");
+		printk(KERN_ERR "async->data disappeared.  dang!\n");
 		return;
 	}
 
@@ -540,7 +521,7 @@ static void dt282x_ai_dma_interrupt(struct comedi_device *dev)
 	devpriv->nread -= size / 2;
 
 	if (devpriv->nread < 0) {
-		printk("dt282x: off by one\n");
+		printk(KERN_INFO "dt282x: off by one\n");
 		devpriv->nread = 0;
 	}
 	if (!devpriv->nread) {
@@ -651,7 +632,7 @@ static irqreturn_t dt282x_interrupt(int irq, void *d)
 		static int warn = 5;
 		if (--warn <= 0) {
 			disable_irq(dev->irq);
-			printk("disabling irq\n");
+			printk(KERN_INFO "disabling irq\n");
 		}
 #endif
 		comedi_error(dev, "D/A error");
@@ -666,13 +647,13 @@ static irqreturn_t dt282x_interrupt(int irq, void *d)
 
 		data = (short)inw(dev->iobase + DT2821_ADDAT);
 		data &= (1 << boardtype.adbits) - 1;
-		if (devpriv->ad_2scomp) {
+
+		if (devpriv->ad_2scomp)
 			data ^= 1 << (boardtype.adbits - 1);
-		}
 		ret = comedi_buf_put(s->async, data);
-		if (ret == 0) {
+
+		if (ret == 0)
 			s->async->events |= COMEDI_CB_OVERFLOW;
-		}
 
 		devpriv->nread--;
 		if (!devpriv->nread) {
@@ -685,7 +666,8 @@ static irqreturn_t dt282x_interrupt(int irq, void *d)
 	}
 #endif
 	comedi_event(dev, s);
-	/* printk("adcsr=0x%02x dacsr-0x%02x supcsr=0x%02x\n", adcsr, dacsr, supcsr); */
+	/* printk("adcsr=0x%02x dacsr-0x%02x supcsr=0x%02x\n",
+		adcsr, dacsr, supcsr); */
 	return IRQ_RETVAL(handled);
 }
 
@@ -776,7 +758,10 @@ static int dt282x_ai_cmdtest(struct comedi_device *dev,
 	if (err)
 		return 1;
 
-	/* step 2: make sure trigger sources are unique and mutually compatible */
+	/*
+	 * step 2: make sure trigger sources are unique
+	 * and mutually compatible
+	 */
 
 	/* note that mutual compatibility is not an issue here */
 	if (cmd->scan_begin_src != TRIG_FOLLOW &&
@@ -859,7 +844,8 @@ static int dt282x_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 
 	if (devpriv->usedma == 0) {
 		comedi_error(dev,
-			     "driver requires 2 dma channels to execute command");
+			     "driver requires 2 dma channels"
+						" to execute command");
 		return -EIO;
 	}
 
@@ -1049,7 +1035,10 @@ static int dt282x_ao_cmdtest(struct comedi_device *dev,
 	if (err)
 		return 1;
 
-	/* step 2: make sure trigger sources are unique and mutually compatible */
+	/*
+	 * step 2: make sure trigger sources are unique
+	 * and mutually compatible
+	 */
 
 	/* note that mutual compatibility is not an issue here */
 	if (cmd->stop_src != TRIG_COUNT && cmd->stop_src != TRIG_NONE)
@@ -1064,7 +1053,7 @@ static int dt282x_ao_cmdtest(struct comedi_device *dev,
 		cmd->start_arg = 0;
 		err++;
 	}
-	if (cmd->scan_begin_arg < 5000 /* XXX unknown */ ) {
+	if (cmd->scan_begin_arg < 5000 /* XXX unknown */) {
 		cmd->scan_begin_arg = 5000;
 		err++;
 	}
@@ -1115,7 +1104,7 @@ static int dt282x_ao_inttrig(struct comedi_device *dev,
 	size = cfc_read_array_from_buffer(s, devpriv->dma[0].buf,
 					  devpriv->dma_maxsize);
 	if (size == 0) {
-		printk("dt282x: AO underrun\n");
+		printk(KERN_ERR "dt282x: AO underrun\n");
 		return -EPIPE;
 	}
 	prep_ao_dma(dev, 0, size);
@@ -1123,7 +1112,7 @@ static int dt282x_ao_inttrig(struct comedi_device *dev,
 	size = cfc_read_array_from_buffer(s, devpriv->dma[1].buf,
 					  devpriv->dma_maxsize);
 	if (size == 0) {
-		printk("dt282x: AO underrun\n");
+		printk(KERN_ERR "dt282x: AO underrun\n");
 		return -EPIPE;
 	}
 	prep_ao_dma(dev, 1, size);
@@ -1141,7 +1130,8 @@ static int dt282x_ao_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 
 	if (devpriv->usedma == 0) {
 		comedi_error(dev,
-			     "driver requires 2 dma channels to execute command");
+			     "driver requires 2 dma channels"
+						" to execute command");
 		return -EIO;
 	}
 
@@ -1262,7 +1252,8 @@ static const struct comedi_lrange *opt_ao_range_lkup(int x)
 	return ao_range_table[x];
 }
 
-enum { opt_iobase = 0, opt_irq, opt_dma1, opt_dma2,	/* i/o base, irq, dma channels */
+enum {  /* i/o base, irq, dma channels */
+	opt_iobase = 0, opt_irq, opt_dma1, opt_dma2,
 	opt_diff,		/* differential */
 	opt_ai_twos, opt_ao0_twos, opt_ao1_twos,	/* twos comp */
 	opt_ai_range, opt_ao0_range, opt_ao1_range,	/* range */
@@ -1295,9 +1286,9 @@ static int dt282x_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (!iobase)
 		iobase = 0x240;
 
-	printk("comedi%d: dt282x: 0x%04lx", dev->minor, iobase);
+	printk(KERN_INFO "comedi%d: dt282x: 0x%04lx", dev->minor, iobase);
 	if (!request_region(iobase, DT2821_SIZE, "dt282x")) {
-		printk(" I/O port conflict\n");
+		printk(KERN_INFO " I/O port conflict\n");
 		return -EBUSY;
 	}
 	dev->iobase = iobase;
@@ -1305,7 +1296,7 @@ static int dt282x_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	outw(DT2821_BDINIT, dev->iobase + DT2821_SUPCSR);
 	i = inw(dev->iobase + DT2821_ADCSR);
 #ifdef DEBUG
-	printk(" fingerprint=%x,%x,%x,%x,%x",
+	printk(KERN_DEBUG " fingerprint=%x,%x,%x,%x,%x",
 	       inw(dev->iobase + DT2821_ADCSR),
 	       inw(dev->iobase + DT2821_CHANCSR),
 	       inw(dev->iobase + DT2821_DACSR),
@@ -1323,7 +1314,7 @@ static int dt282x_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	     != DT2821_SUPCSR_VAL) ||
 	    ((inw(dev->iobase + DT2821_TMRCTR) & DT2821_TMRCTR_MASK)
 	     != DT2821_TMRCTR_VAL)) {
-		printk(" board not found");
+		printk(KERN_ERR " board not found");
 		return -EIO;
 	}
 	/* should do board test */
@@ -1344,26 +1335,25 @@ static int dt282x_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 		irq = probe_irq_off(irqs);
 		restore_flags(flags);
-		if (0 /* error */ ) {
-			printk(" error probing irq (bad)");
-		}
+		if (0 /* error */)
+			printk(KERN_ERR " error probing irq (bad)");
 	}
 #endif
 	if (irq > 0) {
-		printk(" ( irq = %d )", irq);
+		printk(KERN_INFO " ( irq = %d )", irq);
 		ret = request_irq(irq, dt282x_interrupt, 0, "dt282x", dev);
 		if (ret < 0) {
-			printk(" failed to get irq\n");
+			printk(KERN_ERR " failed to get irq\n");
 			return -EIO;
 		}
 		dev->irq = irq;
 	} else if (irq == 0) {
-		printk(" (no irq)");
+		printk(KERN_INFO " (no irq)");
 	} else {
 #if 0
-		printk(" (probe returned multiple irqs--bad)");
+		printk(KERN_INFO " (probe returned multiple irqs--bad)");
 #else
-		printk(" (irq probe not implemented)");
+		printk(KERN_INFO " (irq probe not implemented)");
 #endif
 	}
 
@@ -1435,16 +1425,15 @@ static int dt282x_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->maxdata = 1;
 	s->range_table = &range_digital;
 
-	printk("\n");
+	printk(KERN_INFO "\n");
 
 	return 0;
 }
 
 static void free_resources(struct comedi_device *dev)
 {
-	if (dev->irq) {
+	if (dev->irq)
 		free_irq(dev->irq, dev);
-	}
 	if (dev->iobase)
 		release_region(dev->iobase, DT2821_SIZE);
 	if (dev->private) {
@@ -1461,7 +1450,7 @@ static void free_resources(struct comedi_device *dev)
 
 static int dt282x_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: dt282x: remove\n", dev->minor);
+	printk(KERN_INFO "comedi%d: dt282x: remove\n", dev->minor);
 
 	free_resources(dev);
 
@@ -1475,7 +1464,7 @@ static int dt282x_grab_dma(struct comedi_device *dev, int dma1, int dma2)
 	devpriv->usedma = 0;
 
 	if (!dma1 && !dma2) {
-		printk(" (no dma)");
+		printk(KERN_ERR " (no dma)");
 		return 0;
 	}
 
@@ -1503,11 +1492,11 @@ static int dt282x_grab_dma(struct comedi_device *dev, int dma1, int dma2)
 	devpriv->dma[0].buf = (void *)__get_free_page(GFP_KERNEL | GFP_DMA);
 	devpriv->dma[1].buf = (void *)__get_free_page(GFP_KERNEL | GFP_DMA);
 	if (!devpriv->dma[0].buf || !devpriv->dma[1].buf) {
-		printk(" can't get DMA memory");
+		printk(KERN_ERR " can't get DMA memory");
 		return -ENOMEM;
 	}
 
-	printk(" (dma=%d,%d)", dma1, dma2);
+	printk(KERN_INFO " (dma=%d,%d)", dma1, dma2);
 
 	devpriv->usedma = 1;
 
-- 
1.7.0.4

