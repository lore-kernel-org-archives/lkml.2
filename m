Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab0CZOGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 10:06:52 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:42485 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab0CZOGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 10:06:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=h4iGkGLyBPJKaO9CMS1d8HRO7NGnm1f6+GHZ/dpqb9mtE+QOTyONINzFSH/MdWld2V
         KMAvR3fAjNYJmc3Js3B5/9OeMwtuNxs4Bpp8lKnYg7leWmr/H/S8Jit6fE3w8JlI3l2G
         meqXjv0yUjfHZwu6Kj5m7QhLacB/z433zd/vg=
From: Maurice Dawson <mauricedawson2699@googlemail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, abbotti@mev.co.uk,
       mithlesh@linsyssoft.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 25/25] Staging: comedi: fix brace, print(k), indent and over 80 character coding style issues in adv_pci1710.c
Date: Fri, 26 Mar 2010 14:06:35 +0000
Message-Id: <1269612395-3896-1-git-send-email-mauricedawson2699@googlemail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the adv_pci1710.c file that fixes up brace, print(k), indent and over 80 character warnings found by the checkpatch.pl tool

Signed-off-by: Maurice Dawson <mauricedawson2699@googlemail.com>
---
 drivers/staging/comedi/drivers/adv_pci1710.c |  250 ++++++++++++++++----------
 1 files changed, 152 insertions(+), 98 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index 951e579..1d1c418 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -19,7 +19,7 @@
 /*
 Driver: adv_pci1710
 Description: Advantech PCI-1710, PCI-1710HG, PCI-1711, PCI-1713,
-             Advantech PCI-1720, PCI-1731
+	     Advantech PCI-1720, PCI-1731
 Author: Michal Dobes <dobes@tesnet.cz>
 Devices: [Advantech] PCI-1710 (adv_pci1710), PCI-1710HG (pci1710hg),
   PCI-1711 (adv_pci1710), PCI-1713, PCI-1720,
@@ -37,8 +37,8 @@ PCI driver.
 Configuration options:
   [0] - PCI bus of device (optional)
   [1] - PCI slot of device (optional)
-          If bus/slot is not specified, the first available PCI
-          device will be used.
+		If bus/slot is not specified, the first available PCI
+		device will be used.
 */
 
 #include <linux/interrupt.h>
@@ -50,7 +50,10 @@ Configuration options:
 #include "8253.h"
 #include "amcc_s5933.h"
 
-#define PCI171x_PARANOIDCHECK	/* if defined, then is used code which control correct channel number on every 12 bit sample */
+#define PCI171x_PARANOIDCHECK	/*
+				 * if defined, then is used code which control
+				 * correct channel number on every 12 bit sample
+				 */
 
 #undef PCI171X_EXTDEBUG
 
@@ -89,13 +92,19 @@ Configuration options:
 #define PCI171x_CNT2	28	/* R/W: 8254 couter 2 */
 #define PCI171x_CNTCTRL	30	/* W:   8254 counter control */
 
-/* upper bits from status register (PCI171x_STATUS) (lower is same woth control reg) */
+/*
+ * upper bits from status register (PCI171x_STATUS)
+ * (lower is same with control reg)
+ */
 #define	Status_FE	0x0100	/* 1=FIFO is empty */
 #define Status_FH	0x0200	/* 1=FIFO is half full */
 #define Status_FF	0x0400	/* 1=FIFO is full, fatal error */
 #define Status_IRQ	0x0800	/* 1=IRQ occured */
 /* bits from control register (PCI171x_CONTROL) */
-#define Control_CNT0	0x0040	/* 1=CNT0 have external source, 0=have internal 100kHz source */
+#define Control_CNT0	0x0040	/*
+				 * 1=CNT0 have external source,
+				 * 0=have internal 100kHz source
+				 */
 #define Control_ONEFH	0x0020	/* 1=IRQ on FIFO is half full, 0=every sample */
 #define Control_IRQEN	0x0010	/* 1=enable IRQ */
 #define Control_GATE	0x0008	/* 1=enable external trigger GATE (8254?) */
@@ -110,7 +119,10 @@ Configuration options:
 #define Counter_RW0     0x0010	/* RW0/RW1 select read/write mode */
 #define Counter_RW1     0x0020
 #define Counter_SC0     0x0040	/* Select Counter. Only 00 or 11 may */
-#define Counter_SC1     0x0080	/* be used, 00 for CNT0, 11 for read-back command */
+#define Counter_SC1     0x0080	/*
+				 * be used, 00 for CNT0,
+				 * 11 for read-back command
+				 */
 
 #define PCI1720_DA0	 0	/* W:   D/A register 0 */
 #define PCI1720_DA1	 2	/* W:   D/A register 1 */
@@ -136,8 +148,8 @@ static const struct comedi_lrange range_pci1710_3 = { 9, {
 							  }
 };
 
-static const char range_codes_pci1710_3[] =
-    { 0x00, 0x01, 0x02, 0x03, 0x04, 0x10, 0x11, 0x12, 0x13 };
+static const char range_codes_pci1710_3[] = { 0x00, 0x01, 0x02, 0x03, 0x04,
+					      0x10, 0x11, 0x12, 0x13 };
 
 static const struct comedi_lrange range_pci1710hg = { 12, {
 							   BIP_RANGE(5),
@@ -155,10 +167,8 @@ static const struct comedi_lrange range_pci1710hg = { 12, {
 							   }
 };
 
-static const char range_codes_pci1710hg[] =
-    { 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x10, 0x11, 0x12,
-	0x13
-};
+static const char range_codes_pci1710hg[] = { 0x00, 0x01, 0x02, 0x03, 0x04,
+				0x05, 0x06, 0x07, 0x10, 0x11, 0x12, 0x13 };
 
 static const struct comedi_lrange range_pci17x1 = { 5, {
 							BIP_RANGE(10),
@@ -286,20 +296,23 @@ struct pci1710_private {
 	unsigned int ai_et_CntrlReg;
 	unsigned int ai_et_MuxVal;
 	unsigned int ai_et_div1, ai_et_div2;
-	unsigned int act_chanlist[32];	/*  list of scaned channel */
+	unsigned int act_chanlist[32];	/*  list of scanned channel */
 	unsigned char act_chanlist_len;	/*  len of scanlist */
 	unsigned char act_chanlist_pos;	/*  actual position in MUX list */
 	unsigned char da_ranges;	/*  copy of D/A outpit range register */
 	unsigned int ai_scans;	/*  len of scanlist */
-	unsigned int ai_n_chan;	/*  how many channels is measured */
-	unsigned int *ai_chanlist;	/*  actaul chanlist */
+	unsigned int ai_n_chan;	/*  how many channels are measured */
+	unsigned int *ai_chanlist;	/*  actual chanlist */
 	unsigned int ai_flags;	/*  flaglist */
 	unsigned int ai_data_len;	/*  len of data buffer */
 	short *ai_data;		/*  data buffer */
 	unsigned int ai_timer1;	/*  timers */
 	unsigned int ai_timer2;
 	short ao_data[4];	/*  data output buffer */
-	unsigned int cnt0_write_wait;	/*  after a write, wait for update of the internal state */
+	unsigned int cnt0_write_wait;	/*
+					 * after a write, wait for update
+					 * of the internal state
+					 */
 };
 
 #define devpriv ((struct pci1710_private *)dev->private)
@@ -322,7 +335,9 @@ static int pci1710_reset(struct comedi_device *dev);
 static int pci171x_ai_cancel(struct comedi_device *dev,
 			     struct comedi_subdevice *s);
 
-static const unsigned int muxonechan[] = { 0x0000, 0x0101, 0x0202, 0x0303, 0x0404, 0x0505, 0x0606, 0x0707,	/*  used for gain list programming */
+static const unsigned int muxonechan[] = { 0x0000, 0x0101, 0x0202, 0x0303,
+					   0x0404, 0x0505, 0x0606, 0x0707,
+					   /* used for gain list programming */
 	0x0808, 0x0909, 0x0a0a, 0x0b0b, 0x0c0c, 0x0d0d, 0x0e0e, 0x0f0f,
 	0x1010, 0x1111, 0x1212, 0x1313, 0x1414, 0x1515, 0x1616, 0x1717,
 	0x1818, 0x1919, 0x1a1a, 0x1b1b, 0x1c1c, 0x1d1d, 0x1e1e, 0x1f1f
@@ -636,7 +651,8 @@ static void interrupt_pci1710_every_sample(void *d)
 			if ((sampl & 0xf000) !=
 			    devpriv->act_chanlist[s->async->cur_chan]) {
 				printk
-				    ("comedi: A/D data dropout: received data from channel %d, expected %d!\n",
+				    ("comedi: A/D data dropout: received data "
+					"from channel %d, expected %d!\n",
 				     (sampl & 0xf000) >> 12,
 				     (devpriv->
 				      act_chanlist[s->
@@ -657,18 +673,20 @@ static void interrupt_pci1710_every_sample(void *d)
 #endif
 		++s->async->cur_chan;
 
-		if (s->async->cur_chan >= devpriv->ai_n_chan) {
+		if (s->async->cur_chan >= devpriv->ai_n_chan)
 			s->async->cur_chan = 0;
-		}
 
 		if (s->async->cur_chan == 0) {	/*  one scan done */
 			devpriv->ai_act_scan++;
 			DPRINTK
-			    ("adv_pci1710 EDBG: EOS1 bic %d bip %d buc %d bup %d\n",
+			    ("adv_pci1710 EDBG: "
+					"EOS1 bic %d bip %d buc %d bup %d\n",
 			     s->async->buf_int_count, s->async->buf_int_ptr,
 			     s->async->buf_user_count, s->async->buf_user_ptr);
 			DPRINTK("adv_pci1710 EDBG: EOS2\n");
-			if ((!devpriv->neverending_ai) && (devpriv->ai_act_scan >= devpriv->ai_scans)) {	/*  all data sampled */
+			if ((!devpriv->neverending_ai) &&
+				(devpriv->ai_act_scan >= devpriv->ai_scans)) {
+							/*  all data sampled */
 				pci171x_ai_cancel(dev, s);
 				s->async->events |= COMEDI_CB_EOA;
 				comedi_event(dev, s);
@@ -702,7 +720,9 @@ static int move_block_from_fifo(struct comedi_device *dev,
 		if (this_board->cardtype != TYPE_PCI1713)
 			if ((sampl & 0xf000) != devpriv->act_chanlist[j]) {
 				printk
-				    ("comedi%d: A/D  FIFO data dropout: received data from channel %d, expected %d! (%d/%d/%d/%d/%d/%4x)\n",
+				   (KERN_ERR "comedi%d: A/D FIFO data dropout: "
+					"received data from channel %d, "
+					"expected %d! (%d/%d/%d/%d/%d/%4x)\n",
 				     dev->minor, (sampl & 0xf000) >> 12,
 				     (devpriv->act_chanlist[j] & 0xf000) >> 12,
 				     i, j, devpriv->ai_act_scan, n, turn,
@@ -740,7 +760,7 @@ static void interrupt_pci1710_half_fifo(void *d)
 	DPRINTK("adv_pci1710 EDBG: BGN: interrupt_pci1710_half_fifo(...)\n");
 	m = inw(dev->iobase + PCI171x_STATUS);
 	if (!(m & Status_FH)) {
-		printk("comedi%d: A/D FIFO not half full! (%4x)\n",
+		printk(KERN_ERR "comedi%d: A/D FIFO not half full! (%4x)\n",
 		       dev->minor, m);
 		pci171x_ai_cancel(dev, s);
 		s->async->events |= COMEDI_CB_EOA | COMEDI_CB_ERROR;
@@ -771,7 +791,8 @@ static void interrupt_pci1710_half_fifo(void *d)
 	}
 
 	if (!devpriv->neverending_ai)
-		if (devpriv->ai_act_scan >= devpriv->ai_scans) {	/* all data sampled */
+		if (devpriv->ai_act_scan >= devpriv->ai_scans) {
+							/* all data sampled */
 			pci171x_ai_cancel(dev, s);
 			s->async->events |= COMEDI_CB_EOA;
 			comedi_event(dev, s);
@@ -795,7 +816,8 @@ static irqreturn_t interrupt_service_pci1710(int irq, void *d)
 	if (!dev->attached)	/*  is device attached? */
 		return IRQ_NONE;	/*  no, exit */
 
-	if (!(inw(dev->iobase + PCI171x_STATUS) & Status_IRQ))	/*  is this interrupt from our board? */
+	if (!(inw(dev->iobase + PCI171x_STATUS) & Status_IRQ))
+					/* is this interrupt from our board? */
 		return IRQ_NONE;	/*  no, exit */
 
 	DPRINTK("adv_pci1710 EDBG: interrupt_service_pci1710() ST: %4x\n",
@@ -804,7 +826,8 @@ static irqreturn_t interrupt_service_pci1710(int irq, void *d)
 	if (devpriv->ai_et) {	/*  Switch from initial TRIG_EXT to TRIG_xxx. */
 		devpriv->ai_et = 0;
 		devpriv->CntrlReg &= Control_CNT0;
-		devpriv->CntrlReg |= Control_SW;	/*  set software trigger */
+		devpriv->CntrlReg |= Control_SW;
+						/* set software trigger */
 		outw(devpriv->CntrlReg, dev->iobase + PCI171x_CONTROL);
 		devpriv->CntrlReg = devpriv->ai_et_CntrlReg;
 		outb(0, dev->iobase + PCI171x_CLRFIFO);
@@ -855,19 +878,20 @@ static int pci171x_ai_docmd_and_mode(int mode, struct comedi_device *dev,
 	devpriv->neverending_ai = 0;
 
 	devpriv->CntrlReg &= Control_CNT0;
-	if ((devpriv->ai_flags & TRIG_WAKE_EOS)) {	/*  don't we want wake up every scan?            devpriv->ai_eos=1; */
+	if ((devpriv->ai_flags & TRIG_WAKE_EOS)) {
+		/* don't we want wake up every scan? devpriv->ai_eos=1; */
 		devpriv->ai_eos = 1;
 	} else {
 		devpriv->CntrlReg |= Control_ONEFH;
 		devpriv->ai_eos = 0;
 	}
 
-	if ((devpriv->ai_scans == 0) || (devpriv->ai_scans == -1)) {
+	if ((devpriv->ai_scans == 0) || (devpriv->ai_scans == -1))
 		devpriv->neverending_ai = 1;
-	} /* well, user want neverending */
-	else {
+		/* well, user want neverending */
+	else
 		devpriv->neverending_ai = 0;
-	}
+
 	switch (mode) {
 	case 1:
 	case 2:
@@ -915,14 +939,15 @@ static int pci171x_ai_docmd_and_mode(int mode, struct comedi_device *dev,
 */
 static void pci171x_cmdtest_out(int e, struct comedi_cmd *cmd)
 {
-	printk("adv_pci1710 e=%d startsrc=%x scansrc=%x convsrc=%x\n", e,
-	       cmd->start_src, cmd->scan_begin_src, cmd->convert_src);
-	printk("adv_pci1710 e=%d startarg=%d scanarg=%d convarg=%d\n", e,
-	       cmd->start_arg, cmd->scan_begin_arg, cmd->convert_arg);
-	printk("adv_pci1710 e=%d stopsrc=%x scanend=%x\n", e, cmd->stop_src,
-	       cmd->scan_end_src);
-	printk("adv_pci1710 e=%d stoparg=%d scanendarg=%d chanlistlen=%d\n",
-	       e, cmd->stop_arg, cmd->scan_end_arg, cmd->chanlist_len);
+	printk(KERN_ERR "adv_pci1710 e=%d startsrc=%x scansrc=%x convsrc=%x\n",
+		e, cmd->start_src, cmd->scan_begin_src, cmd->convert_src);
+	printk(KERN_ERR "adv_pci1710 e=%d startarg=%d scanarg=%d convarg=%d\n",
+		e, cmd->start_arg, cmd->scan_begin_arg, cmd->convert_arg);
+	printk(KERN_ERR "adv_pci1710 e=%d stopsrc=%x scanend=%x\n",
+		e, cmd->stop_src, cmd->scan_end_src);
+	printk(KERN_ERR "adv_pci1710 e=%d stoparg=%d scanendarg=%d "
+							"chanlistlen=%d\n",
+		e, cmd->stop_arg, cmd->scan_end_arg, cmd->chanlist_len);
 }
 #endif
 
@@ -971,13 +996,15 @@ static int pci171x_ai_cmdtest(struct comedi_device *dev,
 #ifdef PCI171X_EXTDEBUG
 		pci171x_cmdtest_out(1, cmd);
 #endif
-		DPRINTK
-		    ("adv_pci1710 EDBG: BGN: pci171x_ai_cmdtest(...) err=%d ret=1\n",
-		     err);
+		DPRINTK("adv_pci1710 EDBG: BGN: "
+				"pci171x_ai_cmdtest(...) err=%d ret=1\n", err);
 		return 1;
 	}
 
-	/* step 2: make sure trigger sources are unique and mutually compatible */
+	/*
+	 * step 2:
+	 * make sure trigger sources are unique and mutually compatible
+	 */
 
 	if (cmd->start_src != TRIG_NOW && cmd->start_src != TRIG_EXT) {
 		cmd->start_src = TRIG_NOW;
@@ -1004,9 +1031,8 @@ static int pci171x_ai_cmdtest(struct comedi_device *dev,
 #ifdef PCI171X_EXTDEBUG
 		pci171x_cmdtest_out(2, cmd);
 #endif
-		DPRINTK
-		    ("adv_pci1710 EDBG: BGN: pci171x_ai_cmdtest(...) err=%d ret=2\n",
-		     err);
+		DPRINTK("adv_pci1710 EDBG: BGN: "
+				"pci171x_ai_cmdtest(...) err=%d ret=2\n", err);
 		return 2;
 	}
 
@@ -1062,9 +1088,8 @@ static int pci171x_ai_cmdtest(struct comedi_device *dev,
 #ifdef PCI171X_EXTDEBUG
 		pci171x_cmdtest_out(3, cmd);
 #endif
-		DPRINTK
-		    ("adv_pci1710 EDBG: BGN: pci171x_ai_cmdtest(...) err=%d ret=3\n",
-		     err);
+		DPRINTK("adv_pci1710 EDBG: BGN: "
+				"pci171x_ai_cmdtest(...) err=%d ret=3\n", err);
 		return 3;
 	}
 
@@ -1082,9 +1107,8 @@ static int pci171x_ai_cmdtest(struct comedi_device *dev,
 	}
 
 	if (err) {
-		DPRINTK
-		    ("adv_pci1710 EDBG: BGN: pci171x_ai_cmdtest(...) err=%d ret=4\n",
-		     err);
+		DPRINTK("adv_pci1710 EDBG: BGN: "
+				"pci171x_ai_cmdtest(...) err=%d ret=4\n", err);
 		return 4;
 	}
 
@@ -1116,11 +1140,10 @@ static int pci171x_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	devpriv->ai_timer1 = 0;
 	devpriv->ai_timer2 = 0;
 
-	if (cmd->stop_src == TRIG_COUNT) {
+	if (cmd->stop_src == TRIG_COUNT)
 		devpriv->ai_scans = cmd->stop_arg;
-	} else {
+	else
 		devpriv->ai_scans = 0;
-	}
 
 	if (cmd->scan_begin_src == TRIG_FOLLOW) {	/*  mode 1, 2, 3 */
 		if (cmd->convert_src == TRIG_TIMER) {	/*  mode 1 and 2 */
@@ -1158,36 +1181,53 @@ static int check_channel_list(struct comedi_device *dev,
 	}
 
 	if (n_chan > 1) {
-		chansegment[0] = chanlist[0];	/*  first channel is everytime ok */
-		for (i = 1, seglen = 1; i < n_chan; i++, seglen++) {	/*  build part of chanlist */
-			/*  printk("%d. %d %d\n",i,CR_CHAN(chanlist[i]),CR_RANGE(chanlist[i])); */
+		chansegment[0] = chanlist[0];
+					/* first channel is everytime ok */
+		for (i = 1, seglen = 1; i < n_chan; i++, seglen++) {
+						/* build part of chanlist */
+#if 0
+	printk(KERN_ERR "%d. %d %d\n", i, CR_CHAN(chanlist[i]),
+					  CR_RANGE(chanlist[i]));
+#endif
 			if (chanlist[0] == chanlist[i])
-				break;	/*  we detect loop, this must by finish */
-			if (CR_CHAN(chanlist[i]) & 1)	/*  odd channel cann't by differencial */
+				break;
+				/* we detect loop, this must be finished */
+			if (CR_CHAN(chanlist[i]) & 1)
+				/* odd channel can't be differential */
 				if (CR_AREF(chanlist[i]) == AREF_DIFF) {
 					comedi_error(dev,
-						     "Odd channel can't be differential input!\n");
+						"Odd channel can't be "
+						"differential input!\n");
 					return 0;
 				}
 			nowmustbechan =
 			    (CR_CHAN(chansegment[i - 1]) + 1) % s->n_chan;
 			if (CR_AREF(chansegment[i - 1]) == AREF_DIFF)
 				nowmustbechan = (nowmustbechan + 1) % s->n_chan;
-			if (nowmustbechan != CR_CHAN(chanlist[i])) {	/*  channel list isn't continous :-( */
+			if (nowmustbechan != CR_CHAN(chanlist[i])) {
+					/* channel list isn't continous :-( */
 				printk
-				    ("channel list must be continous! chanlist[%i]=%d but must be %d or %d!\n",
+				    (KERN_ERR "channel list must be continous! "
+				      "chanlist[%i]=%d but must be %d or %d!\n",
 				     i, CR_CHAN(chanlist[i]), nowmustbechan,
 				     CR_CHAN(chanlist[0]));
 				return 0;
 			}
-			chansegment[i] = chanlist[i];	/*  well, this is next correct channel in list */
+			chansegment[i] = chanlist[i];
+				/* well, this is next correct channel in list */
 		}
 
-		for (i = 0, segpos = 0; i < n_chan; i++) {	/*  check whole chanlist */
-			/* printk("%d %d=%d %d\n",CR_CHAN(chansegment[i%seglen]),CR_RANGE(chansegment[i%seglen]),CR_CHAN(chanlist[i]),CR_RANGE(chanlist[i])); */
+		for (i = 0, segpos = 0; i < n_chan; i++) {
+						/* check whole chanlist */
+#if 0
+	printk(KERN_ERR "%d %d=%d %d\n", CR_CHAN(chansegment[i%seglen]),
+					 CR_RANGE(chansegment[i%seglen]),
+					 CR_CHAN(chanlist[i]),
+					 CR_RANGE(chanlist[i]));
+#endif
 			if (chanlist[i] != chansegment[i % seglen]) {
 				printk
-				    ("bad channel, reference or range number! chanlist[%i]=%d,%d,%d and not %d,%d,%d!\n",
+				   ("bad channel, reference or range number! "
+				    "chanlist[%i]=%d,%d,%d and not %d,%d,%d!\n",
 				     i, CR_CHAN(chansegment[i]),
 				     CR_RANGE(chansegment[i]),
 				     CR_AREF(chansegment[i]),
@@ -1218,11 +1258,13 @@ static void setup_channel_list(struct comedi_device *dev,
 	DPRINTK("SegLen: %d\n", seglen);
 	for (i = 0; i < seglen; i++) {	/*  store range list to card */
 		chanprog = muxonechan[CR_CHAN(chanlist[i])];
-		outw(chanprog, dev->iobase + PCI171x_MUX);	/* select channel */
+		outw(chanprog, dev->iobase + PCI171x_MUX);
+							/* select channel */
 		range = this_board->rangecode_ai[CR_RANGE(chanlist[i])];
 		if (CR_AREF(chanlist[i]) == AREF_DIFF)
 			range |= 0x0020;
-		outw(range, dev->iobase + PCI171x_RANGE);	/* select gain */
+		outw(range, dev->iobase + PCI171x_RANGE);
+							/* select gain */
 #ifdef PCI171x_PARANOIDCHECK
 		devpriv->act_chanlist[i] =
 		    (CR_CHAN(chanlist[i]) << 12) & 0xf000;
@@ -1233,7 +1275,8 @@ static void setup_channel_list(struct comedi_device *dev,
 
 	devpriv->ai_et_MuxVal =
 	    CR_CHAN(chanlist[0]) | (CR_CHAN(chanlist[seglen - 1]) << 8);
-	outw(devpriv->ai_et_MuxVal, dev->iobase + PCI171x_MUX);	/* select channel interval to scan */
+	outw(devpriv->ai_et_MuxVal, dev->iobase + PCI171x_MUX);
+					/* select channel interval to scan */
 	DPRINTK("MUX: %4x L%4x.H%4x\n",
 		CR_CHAN(chanlist[0]) | (CR_CHAN(chanlist[seglen - 1]) << 8),
 		CR_CHAN(chanlist[0]), CR_CHAN(chanlist[seglen - 1]));
@@ -1272,7 +1315,8 @@ static int pci171x_ai_cancel(struct comedi_device *dev,
 		devpriv->CntrlReg &= Control_CNT0;
 		devpriv->CntrlReg |= Control_SW;
 
-		outw(devpriv->CntrlReg, dev->iobase + PCI171x_CONTROL);	/*  reset any operations */
+		outw(devpriv->CntrlReg, dev->iobase + PCI171x_CONTROL);
+						/* reset any operations */
 		start_pacer(dev, -1, 0, 0);
 		outb(0, dev->iobase + PCI171x_CLRFIFO);
 		outb(0, dev->iobase + PCI171x_CLRINT);
@@ -1296,24 +1340,28 @@ static int pci171x_reset(struct comedi_device *dev)
 {
 	DPRINTK("adv_pci1710 EDBG: BGN: pci171x_reset(...)\n");
 	outw(0x30, dev->iobase + PCI171x_CNTCTRL);
-	devpriv->CntrlReg = Control_SW | Control_CNT0;	/*  Software trigger, CNT0=external */
-	outw(devpriv->CntrlReg, dev->iobase + PCI171x_CONTROL);	/*  reset any operations */
-	outb(0, dev->iobase + PCI171x_CLRFIFO);	/*  clear FIFO */
-	outb(0, dev->iobase + PCI171x_CLRINT);	/*  clear INT request */
-	start_pacer(dev, -1, 0, 0);	/*  stop 8254 */
+	devpriv->CntrlReg = Control_SW | Control_CNT0;
+					/* Software trigger, CNT0=external */
+	outw(devpriv->CntrlReg, dev->iobase + PCI171x_CONTROL);
+						/* reset any operations */
+	outb(0, dev->iobase + PCI171x_CLRFIFO);	/* clear FIFO */
+	outb(0, dev->iobase + PCI171x_CLRINT);	/* clear INT request */
+	start_pacer(dev, -1, 0, 0);		/* stop 8254 */
 	devpriv->da_ranges = 0;
 	if (this_board->n_aochan) {
-		outb(devpriv->da_ranges, dev->iobase + PCI171x_DAREF);	/*  set DACs to 0..5V */
-		outw(0, dev->iobase + PCI171x_DA1);	/*  set DA outputs to 0V */
+		outb(devpriv->da_ranges, dev->iobase + PCI171x_DAREF);
+						/* set DACs to 0..5V */
+		outw(0, dev->iobase + PCI171x_DA1);
+						/* set DA outputs to 0V */
 		devpriv->ao_data[0] = 0x0000;
 		if (this_board->n_aochan > 1) {
 			outw(0, dev->iobase + PCI171x_DA2);
 			devpriv->ao_data[1] = 0x0000;
 		}
 	}
-	outw(0, dev->iobase + PCI171x_DO);	/*  digital outputs to 0 */
-	outb(0, dev->iobase + PCI171x_CLRFIFO);	/*  clear FIFO */
-	outb(0, dev->iobase + PCI171x_CLRINT);	/*  clear INT request */
+	outw(0, dev->iobase + PCI171x_DO);	/* digital outputs to 0 */
+	outb(0, dev->iobase + PCI171x_CLRFIFO);	/* clear FIFO */
+	outb(0, dev->iobase + PCI171x_CLRINT);	/* clear INT request */
 
 	DPRINTK("adv_pci1710 EDBG: END: pci171x_reset(...)\n");
 	return 0;
@@ -1325,14 +1373,16 @@ static int pci171x_reset(struct comedi_device *dev)
 static int pci1720_reset(struct comedi_device *dev)
 {
 	DPRINTK("adv_pci1710 EDBG: BGN: pci1720_reset(...)\n");
-	outb(Syncont_SC0, dev->iobase + PCI1720_SYNCONT);	/*  set synchronous output mode */
+	outb(Syncont_SC0, dev->iobase + PCI1720_SYNCONT);
+					/* set synchronous output mode */
 	devpriv->da_ranges = 0xAA;
-	outb(devpriv->da_ranges, dev->iobase + PCI1720_RANGE);	/*  set all ranges to +/-5V */
-	outw(0x0800, dev->iobase + PCI1720_DA0);	/*  set outputs to 0V */
+	outb(devpriv->da_ranges, dev->iobase + PCI1720_RANGE);
+						/* set all ranges to +/-5V */
+	outw(0x0800, dev->iobase + PCI1720_DA0);	/* set outputs to 0V */
 	outw(0x0800, dev->iobase + PCI1720_DA1);
 	outw(0x0800, dev->iobase + PCI1720_DA2);
 	outw(0x0800, dev->iobase + PCI1720_DA3);
-	outb(0, dev->iobase + PCI1720_SYNCOUT);	/*  update outputs */
+	outb(0, dev->iobase + PCI1720_SYNCOUT);		/* update outputs */
 	devpriv->ao_data[0] = 0x0800;
 	devpriv->ao_data[1] = 0x0800;
 	devpriv->ao_data[2] = 0x0800;
@@ -1373,7 +1423,7 @@ static int pci1710_attach(struct comedi_device *dev,
 	int i;
 	int board_index;
 
-	printk("comedi%d: adv_pci1710: ", dev->minor);
+	printk(KERN_ERR "comedi%d: adv_pci1710: ", dev->minor);
 
 	opt_bus = it->options[0];
 	opt_slot = it->options[1];
@@ -1420,17 +1470,20 @@ static int pci1710_attach(struct comedi_device *dev,
 			    "failed to enable PCI device and request regions!";
 			continue;
 		}
-		/*  fixup board_ptr in case we were using the dummy entry with the driver name */
+		/*
+		 *fixup board_ptr in case we were using
+		 *the dummy entry with the driver name
+		 */
 		dev->board_ptr = &boardtypes[board_index];
 		break;
 	}
 
 	if (!pcidev) {
 		if (opt_bus || opt_slot) {
-			printk(" - Card at b:s %d:%d %s\n",
+			printk(KERN_ERR " - Card at b:s %d:%d %s\n",
 			       opt_bus, opt_slot, errstr);
 		} else {
-			printk(" - Card %s\n", errstr);
+			printk(KERN_ERR " - Card %s\n", errstr);
 		}
 		return -EIO;
 	}
@@ -1441,8 +1494,8 @@ static int pci1710_attach(struct comedi_device *dev,
 	irq = pcidev->irq;
 	iobase = pci_resource_start(pcidev, 2);
 
-	printk(", b:s:f=%d:%d:%d, io=0x%4lx", pci_bus, pci_slot, pci_func,
-	       iobase);
+	printk(KERN_ERR ", b:s:f=%d:%d:%d, io=0x%4lx",
+					pci_bus, pci_slot, pci_func, iobase);
 
 	dev->iobase = iobase;
 
@@ -1475,11 +1528,11 @@ static int pci1710_attach(struct comedi_device *dev,
 					IRQF_SHARED, "Advantech PCI-1710",
 					dev)) {
 				printk
-				    (", unable to allocate IRQ %d, DISABLING IT",
+				   (", unable to allocate IRQ %d, DISABLING IT",
 				     irq);
 				irq = 0;	/* Can't use IRQ */
 			} else {
-				printk(", irq=%u", irq);
+				printk(KERN_ERR ", irq=%u", irq);
 			}
 		} else {
 			printk(", IRQ disabled");
@@ -1557,7 +1610,8 @@ static int pci1710_attach(struct comedi_device *dev,
 		s->maxdata = 1;
 		s->len_chanlist = this_board->n_dochan;
 		s->range_table = &range_digital;
-		s->io_bits = (1 << this_board->n_dochan) - 1;	/* all bits output */
+		s->io_bits = (1 << this_board->n_dochan) - 1;
+							/* all bits output */
 		s->state = 0;
 		s->insn_bits = pci171x_insn_bits_do;
 		subdev++;
@@ -1594,9 +1648,9 @@ static int pci1710_detach(struct comedi_device *dev)
 		if (dev->irq)
 			free_irq(dev->irq, dev);
 		if (devpriv->pcidev) {
-			if (dev->iobase) {
+			if (dev->iobase)
 				comedi_pci_disable(devpriv->pcidev);
-			}
+
 			pci_dev_put(devpriv->pcidev);
 		}
 	}
-- 
1.6.3.3

