Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab0KCVUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 17:20:00 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34922 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab0KCVT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 17:19:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jbrRT1H3/GX4gVZfJdfh5EtyMiaQiTXwYtWGHuNqDU4XLd/mM4b0MPz0k2VNhoiLZg
         VKMNhNerWVXUNoy8EMfBRjnDZvMc27yfo5vb3Hcfl8iABus+F71qrMKX9PBnsT1chpbL
         Vv4DF6GfhFWgEKhVyw0dM5V72kaxJmUEVTvL0=
From: Damian Varayud <davarayud@gmail.com>
To: gregkh@suse.de, harmonco@engr.orst.edu, sam.j.richardson@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Medina Raul Ezequiel <ezemed7@gmail.com>
Subject: [PATCH 3/3] Staging: comedi: fix brace coding style issue in pcl818.c
Date: Wed,  3 Nov 2010 18:19:22 -0300
Message-Id: <1288819162-6330-3-git-send-email-user@netbu>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1288819162-6330-1-git-send-email-user@netbu>
References: <1288819162-6330-1-git-send-email-user@netbu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the pcl818.c file that fixes up braces, indentation, printk() and overlines warning
and error at initializing variable found by the checkpatch.pl tool

Signed-off-by: Medina Raul Ezequiel <ezemed7@gmail.com>
---
 drivers/staging/comedi/drivers/pcl818.c |  536 +++++++++++++++++--------------
 1 files changed, 296 insertions(+), 240 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index d2bd6f8..6f7420d 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -1,19 +1,19 @@
 /*
-   comedi/drivers/pcl818.c
+	comedi/drivers/pcl818.c
 
-   Author:  Michal Dobes <dobes@tesnet.cz>
+	Author:  Michal Dobes <dobes@tesnet.cz>
 
-   hardware driver for Advantech cards:
-    card:   PCL-818L, PCL-818H, PCL-818HD, PCL-818HG, PCL-818, PCL-718
-    driver: pcl818l,  pcl818h,  pcl818hd,  pcl818hg,  pcl818,  pcl718
+	hardware driver for Advantech cards:
+	card:   PCL-818L, PCL-818H, PCL-818HD, PCL-818HG, PCL-818, PCL-718
+	driver: pcl818l,  pcl818h,  pcl818hd,  pcl818hg,  pcl818,  pcl718
 */
 /*
 Driver: pcl818
 Description: Advantech PCL-818 cards, PCL-718
 Author: Michal Dobes <dobes@tesnet.cz>
 Devices: [Advantech] PCL-818L (pcl818l), PCL-818H (pcl818h),
-  PCL-818HD (pcl818hd), PCL-818HG (pcl818hg), PCL-818 (pcl818),
-  PCL-718 (pcl718)
+	PCL-818HD (pcl818hd), PCL-818HG (pcl818hg), PCL-818 (pcl818),
+	PCL-718 (pcl718)
 Status: works
 
 All cards have 16 SE/8 DIFF ADCs, one or two DACs, 16 DI and 16 DO.
@@ -25,76 +25,77 @@ PCL-818HD and PCL-818HG support 1kword FIFO. Driver support this FIFO
 but this code is untested.
 A word or two about DMA. Driver support DMA operations at two ways:
 1) DMA uses two buffers and after one is filled then is generated
-   INT and DMA restart with second buffer. With this mode I'm unable run
-   more that 80Ksamples/secs without data dropouts on K6/233.
+	INT and DMA restart with second buffer. With this mode I'm unable run
+	more that 80Ksamples/secs without data dropouts on K6/233.
 2) DMA uses one buffer and run in autoinit mode and the data are
-   from DMA buffer moved on the fly with 2kHz interrupts from RTC.
-   This mode is used if the interrupt 8 is available for allocation.
-   If not, then first DMA mode is used. With this I can run at
-   full speed one card (100ksamples/secs) or two cards with
-   60ksamples/secs each (more is problem on account of ISA limitations).
-   To use this mode you must have compiled  kernel with disabled
-   "Enhanced Real Time Clock Support".
-   Maybe you can have problems if you use xntpd or similar.
-   If you've data dropouts with DMA mode 2 then:
-    a) disable IDE DMA
-    b) switch text mode console to fb.
-
-   Options for PCL-818L:
-    [0] - IO Base
-    [1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
-    [2] - DMA	(0=disable, 1, 3)
-    [3] - 0, 10=10MHz clock for 8254
-              1= 1MHz clock for 8254
-    [4] - 0,  5=A/D input  -5V.. +5V
-          1, 10=A/D input -10V..+10V
-    [5] - 0,  5=D/A output 0-5V  (internal reference -5V)
-          1, 10=D/A output 0-10V (internal reference -10V)
-	  2    =D/A output unknown (external reference)
-
-   Options for PCL-818, PCL-818H:
-    [0] - IO Base
-    [1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
-    [2] - DMA	(0=disable, 1, 3)
-    [3] - 0, 10=10MHz clock for 8254
-              1= 1MHz clock for 8254
-    [4] - 0,  5=D/A output 0-5V  (internal reference -5V)
-          1, 10=D/A output 0-10V (internal reference -10V)
-	  2    =D/A output unknown (external reference)
-
-   Options for PCL-818HD, PCL-818HG:
-    [0] - IO Base
-    [1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
-    [2] - DMA/FIFO  (-1=use FIFO, 0=disable both FIFO and DMA,
-                      1=use DMA ch 1, 3=use DMA ch 3)
-    [3] - 0, 10=10MHz clock for 8254
-              1= 1MHz clock for 8254
-    [4] - 0,  5=D/A output 0-5V  (internal reference -5V)
-          1, 10=D/A output 0-10V (internal reference -10V)
-   	  2    =D/A output unknown (external reference)
-
-   Options for PCL-718:
-    [0] - IO Base
-    [1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
-    [2] - DMA	(0=disable, 1, 3)
-    [3] - 0, 10=10MHz clock for 8254
-              1= 1MHz clock for 8254
-    [4] -     0=A/D Range is +/-10V
-	      1=             +/-5V
-	      2=             +/-2.5V
-	      3=             +/-1V
-	      4=             +/-0.5V
-	      5=  	     user defined bipolar
-	      6=	     0-10V
-	      7=	     0-5V
- 	      8=	     0-2V
-	      9=	     0-1V
-	     10=	     user defined unipolar
-    [5] - 0,  5=D/A outputs 0-5V  (internal reference -5V)
-          1, 10=D/A outputs 0-10V (internal reference -10V)
-	      2=D/A outputs unknown (external reference)
-    [6] - 0, 60=max  60kHz A/D sampling
-          1,100=max 100kHz A/D sampling (PCL-718 with Option 001 installed)
+	from DMA buffer moved on the fly with 2kHz interrupts from RTC.
+	This mode is used if the interrupt 8 is available for allocation.
+	If not, then first DMA mode is used. With this I can run at
+	full speed one card (100ksamples/secs) or two cards with
+	60ksamples/secs each (more is problem on account of ISA limitations).
+	To use this mode you must have compiled  kernel with disabled
+	"Enhanced Real Time Clock Support".
+	Maybe you can have problems if you use xntpd or similar.
+	If you've data dropouts with DMA mode 2 then:
+		a) disable IDE DMA
+		b) switch text mode console to fb.
+
+	Options for PCL-818L:
+	[0] - IO Base
+	[1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
+	[2] - DMA	(0=disable, 1, 3)
+	[3] - 0, 10=10MHz clock for 8254
+		1= 1MHz clock for 8254
+	[4] - 0,  5=A/D input  -5V.. +5V
+		1, 10=A/D input -10V..+10V
+	[5] - 0,  5=D/A output 0-5V  (internal reference -5V)
+		1, 10=D/A output 0-10V (internal reference -10V)
+		2    =D/A output unknown (external reference)
+
+	Options for PCL-818, PCL-818H:
+	[0] - IO Base
+	[1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
+	[2] - DMA	(0=disable, 1, 3)
+	[3] - 0, 10=10MHz clock for 8254
+		1= 1MHz clock for 8254
+	[4] - 0,  5=D/A output 0-5V  (internal reference -5V)
+		1, 10=D/A output 0-10V (internal reference -10V)
+		2    =D/A output unknown (external reference)
+
+	Options for PCL-818HD, PCL-818HG:
+	[0] - IO Base
+	[1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
+	[2] - DMA/FIFO  (-1=use FIFO, 0=disable both FIFO and DMA,
+			1=use DMA ch 1, 3=use DMA ch 3)
+	[3] - 0, 10=10MHz clock for 8254
+			1= 1MHz clock for 8254
+	[4] - 0,  5=D/A output 0-5V  (internal reference -5V)
+		1, 10=D/A output 0-10V (internal reference -10V)
+		2    =D/A output unknown (external reference)
+
+	Options for PCL-718:
+	[0] - IO Base
+	[1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
+	[2] - DMA	(0=disable, 1, 3)
+	[3] - 0, 10=10MHz clock for 8254
+		1= 1MHz clock for 8254
+	[4] -     0=A/D Range is +/-10V
+		1=             +/-5V
+		2=             +/-2.5V
+		3=             +/-1V
+		4=             +/-0.5V
+		5=	     user defined bipolar
+		6=	     0-10V
+		7=	     0-5V
+		8=	     0-2V
+		9=	     0-1V
+		10=	     user defined unipolar
+	[5] - 0,  5=D/A outputs 0-5V  (internal reference -5V)
+		1, 10=D/A outputs 0-10V (internal reference -10V)
+		2=D/A outputs unknown (external reference)
+	[6] - 0, 60=max  60kHz A/D sampling
+		1,100=max 100kHz A/D sampling
+		(PCL-718 with Option 001 installed)
 
 */
 
@@ -189,7 +190,7 @@ A word or two about DMA. Driver support DMA operations at two ways:
 #define INT_TYPE_AI1_DMA_RTC 9
 #define INT_TYPE_AI3_DMA_RTC 10
 
-#define RTC_IRQ 	8
+#define RTC_IRQ		8
 #define RTC_IO_EXTENT	0x10
 #endif
 
@@ -241,8 +242,8 @@ static const struct comedi_lrange range_pcl818l_h_ai = { 4, {
 };
 
 static const struct comedi_lrange range718_bipolar1 = { 1, {BIP_RANGE(1),} };
-static const struct comedi_lrange range718_bipolar0_5 =
-    { 1, {BIP_RANGE(0.5),} };
+static const struct comedi_lrange range718_bipolar0_5 = { 1,
+							{BIP_RANGE(0.5),} };
 static const struct comedi_lrange range718_unipolar2 = { 1, {UNI_RANGE(2),} };
 static const struct comedi_lrange range718_unipolar1 = { 1, {BIP_RANGE(1),} };
 
@@ -251,8 +252,8 @@ static int pcl818_attach(struct comedi_device *dev,
 static int pcl818_detach(struct comedi_device *dev);
 
 #ifdef unused
-static int RTC_lock = 0;	/* RTC lock */
-static int RTC_timer_lock = 0;	/* RTC int lock */
+static int RTC_lock;	/* RTC lock */
+static int RTC_timer_lock;	/* RTC int lock */
 #endif
 
 struct pcl818_board {
@@ -261,12 +262,13 @@ struct pcl818_board {
 	int n_ranges;		/*  len of range list */
 	int n_aichan_se;	/*  num of A/D chans in single ended  mode */
 	int n_aichan_diff;	/*  num of A/D chans in diferencial mode */
-	unsigned int ns_min;	/*  minimal alllowed delay between samples (in ns) */
+	unsigned int ns_min;	/*  minimal alllowed delay between
+				    samples (in ns) */
 	int n_aochan;		/*  num of D/A chans */
 	int n_dichan;		/*  num of DI chans */
 	int n_dochan;		/*  num of DO chans */
-	const struct comedi_lrange *ai_range_type;	/*  default A/D rangelist */
-	const struct comedi_lrange *ao_range_type;	/*  default D/A rangelist */
+	const struct comedi_lrange *ai_range_type; /*  default A/D rangelist */
+	const struct comedi_lrange *ao_range_type; /*  default D/A rangelist */
 	unsigned int io_range;	/*  len of IO space */
 	unsigned int IRQbits;	/*  allowed interrupts */
 	unsigned int DMAbits;	/*  allowed DMA chans */
@@ -335,7 +337,7 @@ struct pcl818_private {
 	unsigned long rtc_iobase;	/*  RTC port region */
 	unsigned int rtc_iosize;
 	unsigned int rtc_irq;
-	struct timer_list rtc_irq_timer;	/*  timer for RTC sanity check */
+	struct timer_list rtc_irq_timer;      /*  timer for RTC sanity check */
 	unsigned long rtc_freq;	/*  RTC int freq */
 	int rtc_irq_blocked;	/*  1=we now do AI with DMA&RTC */
 #endif
@@ -346,19 +348,27 @@ struct pcl818_private {
 	unsigned int dmasamplsize;	/*  size in samples hwdmasize[0]/2 */
 	unsigned int last_top_dma;	/*  DMA pointer in last RTC int */
 	int next_dma_buf;	/*  which DMA buffer will be used next round */
-	long dma_runs_to_end;	/*  how many we must permorm DMA transfer to end of record */
-	unsigned long last_dma_run;	/*  how many bytes we must transfer on last DMA page */
-	unsigned char neverending_ai;	/*  if=1, then we do neverending record (you must use cancel()) */
-	unsigned int ns_min;	/*  manimal alllowed delay between samples (in us) for actual card */
+	long dma_runs_to_end;	/*  how many we must permorm DMA transfer to
+				    end of record */
+	unsigned long last_dma_run;	/*  how many bytes we must transfer
+					    on last DMA page */
+	unsigned char neverending_ai;	/*  if=1, then we do neverending
+					    record (you must use cancel()) */
+	unsigned int ns_min;	/*  manimal alllowed delay between samples
+				    (in us) for actual card */
 	int i8253_osc_base;	/*  1/frequency of on board oscilator in ns */
 	int irq_free;		/*  1=have allocated IRQ */
 	int irq_blocked;	/*  1=IRQ now uses any subdev */
-	int irq_was_now_closed;	/*  when IRQ finish, there's stored int818_mode for last interrupt */
-	int ai_mode;		/*  who now uses IRQ - 1=AI1 int, 2=AI1 dma, 3=AI3 int, 4AI3 dma */
-	struct comedi_subdevice *last_int_sub;	/*  ptr to subdevice which now finish */
+	int irq_was_now_closed;	/*  when IRQ finish, there's stored
+				    int818_mode for last interrupt */
+	int ai_mode;		/*  who now uses IRQ - 1=AI1 int, 2=AI1 dma,
+				    3=AI3 int, 4AI3 dma */
+	struct comedi_subdevice *last_int_sub;	/*  ptr to subdevice which
+						    now finish */
 	int ai_act_scan;	/*  how many scans we finished */
 	int ai_act_chan;	/*  actual position in actual scan */
-	unsigned int act_chanlist[16];	/*  MUX setting for actual AI operations */
+	unsigned int act_chanlist[16];	/*  MUX setting for actual
+					    AI operations */
 	unsigned int act_chanlist_len;	/*  how long is actual MUX list */
 	unsigned int act_chanlist_pos;	/*  actual position in MUX list */
 	unsigned int ai_scans;	/*  len of scanlist */
@@ -374,8 +384,10 @@ struct pcl818_private {
 	unsigned int ao_readback[2];
 };
 
-static const unsigned int muxonechan[] = { 0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77,	/*  used for gain list programming */
-	0x88, 0x99, 0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff
+/*  used for gain list programming */
+static const unsigned int muxonechan[] = { 0x00, 0x11, 0x22, 0x33, 0x44, 0x55,
+					   0x66, 0x77, 0x88, 0x99, 0xaa, 0xbb,
+					   0xcc, 0xdd, 0xee, 0xff
 };
 
 #define devpriv ((struct pcl818_private *)dev->private)
@@ -405,7 +417,7 @@ static int rtc_setfreq_irq(int freq);
 
 /*
 ==============================================================================
-   ANALOG INPUT MODE0, 818 cards, slow version
+	ANALOG INPUT MODE0, 818 cards, slow version
 */
 static int pcl818_ai_insn_read(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
@@ -452,8 +464,8 @@ conv_finish:
 
 /*
 ==============================================================================
-   ANALOG OUTPUT MODE0, 818 cards
-   only one sample per call is supported
+	ANALOG OUTPUT MODE0, 818 cards
+	only one sample per call is supported
 */
 static int pcl818_ao_insn_read(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
@@ -462,9 +474,8 @@ static int pcl818_ao_insn_read(struct comedi_device *dev,
 	int n;
 	int chan = CR_CHAN(insn->chanspec);
 
-	for (n = 0; n < insn->n; n++) {
+	for (n = 0; n < insn->n; n++)
 		data[n] = devpriv->ao_readback[chan];
-	}
 
 	return n;
 }
@@ -489,9 +500,9 @@ static int pcl818_ao_insn_write(struct comedi_device *dev,
 
 /*
 ==============================================================================
-   DIGITAL INPUT MODE0, 818 cards
+	DIGITAL INPUT MODE0, 818 cards
 
-   only one sample per call is supported
+	only one sample per call is supported
 */
 static int pcl818_di_insn_bits(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
@@ -508,9 +519,9 @@ static int pcl818_di_insn_bits(struct comedi_device *dev,
 
 /*
 ==============================================================================
-   DIGITAL OUTPUT MODE0, 818 cards
+	DIGITAL OUTPUT MODE0, 818 cards
 
-   only one sample per call is supported
+	only one sample per call is supported
 */
 static int pcl818_do_insn_bits(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
@@ -532,8 +543,8 @@ static int pcl818_do_insn_bits(struct comedi_device *dev,
 
 /*
 ==============================================================================
-   analog input interrupt mode 1 & 3, 818 cards
-   one sample per interrupt version
+	analog input interrupt mode 1 & 3, 818 cards
+	one sample per interrupt version
 */
 static irqreturn_t interrupt_pcl818_ai_mode13_int(int irq, void *d)
 {
@@ -556,10 +567,12 @@ static irqreturn_t interrupt_pcl818_ai_mode13_int(int irq, void *d)
 
 conv_finish:
 	low = inb(dev->iobase + PCL818_AD_LO);
-	comedi_buf_put(s->async, ((inb(dev->iobase + PCL818_AD_HI) << 4) | (low >> 4)));	/*  get one sample */
+	comedi_buf_put(s->async, ((inb(dev->iobase + PCL818_AD_HI) << 4)
+				  | (low >> 4)));/*  get one sample */
 	outb(0, dev->iobase + PCL818_CLRINT);	/* clear INT request */
 
-	if ((low & 0xf) != devpriv->act_chanlist[devpriv->act_chanlist_pos]) {	/*  dropout! */
+	/*  dropout! */
+	if ((low & 0xf) != devpriv->act_chanlist[devpriv->act_chanlist_pos]) {
 		printk
 		    ("comedi: A/D mode1/3 IRQ - channel dropout %x!=%x !\n",
 		     (low & 0xf),
@@ -570,9 +583,8 @@ conv_finish:
 		return IRQ_HANDLED;
 	}
 	devpriv->act_chanlist_pos++;
-	if (devpriv->act_chanlist_pos >= devpriv->act_chanlist_len) {
+	if (devpriv->act_chanlist_pos >= devpriv->act_chanlist_len)
 		devpriv->act_chanlist_pos = 0;
-	}
 	s->async->cur_chan++;
 	if (s->async->cur_chan >= devpriv->ai_n_chan) {
 		/*  printk("E"); */
@@ -592,7 +604,7 @@ conv_finish:
 
 /*
 ==============================================================================
-   analog input dma mode 1 & 3, 818 cards
+	analog input dma mode 1 & 3, 818 cards
 */
 static irqreturn_t interrupt_pcl818_ai_mode13_dma(int irq, void *d)
 {
@@ -604,7 +616,8 @@ static irqreturn_t interrupt_pcl818_ai_mode13_dma(int irq, void *d)
 
 	disable_dma(devpriv->dma);
 	devpriv->next_dma_buf = 1 - devpriv->next_dma_buf;
-	if ((devpriv->dma_runs_to_end) > -1 || devpriv->neverending_ai) {	/*  switch dma bufs */
+	/*  switch dma bufs */
+	if ((devpriv->dma_runs_to_end) > -1 || devpriv->neverending_ai) {
 		set_dma_mode(devpriv->dma, DMA_MODE_READ);
 		flags = claim_dma_lock();
 		set_dma_addr(devpriv->dma,
@@ -619,8 +632,7 @@ static irqreturn_t interrupt_pcl818_ai_mode13_dma(int irq, void *d)
 		release_dma_lock(flags);
 		enable_dma(devpriv->dma);
 	}
-	printk("comedi: A/D mode1/3 IRQ \n");
-
+	printk(KERN_ERR "comedi: A/D mode1/3 IRQ\n");
 	devpriv->dma_runs_to_end--;
 	outb(0, dev->iobase + PCL818_CLRINT);	/* clear INT request */
 	ptr = (short *)devpriv->dmabuf[1 - devpriv->next_dma_buf];
@@ -629,9 +641,12 @@ static irqreturn_t interrupt_pcl818_ai_mode13_dma(int irq, void *d)
 	bufptr = 0;
 
 	for (i = 0; i < len; i++) {
-		if ((ptr[bufptr] & 0xf) != devpriv->act_chanlist[devpriv->act_chanlist_pos]) {	/*  dropout! */
+		/* dropout! */
+		if ((ptr[bufptr] & 0xf) != devpriv->
+			act_chanlist[devpriv->act_chanlist_pos]) {
 			printk
-			    ("comedi: A/D mode1/3 DMA - channel dropout %d(card)!=%d(chanlist) at %d !\n",
+			    ("comedi: A/D mode1/3 DMA - channel dropout "
+			     "%d(card)!=%d(chanlist) at %d !\n",
 			     (ptr[bufptr] & 0xf),
 			     devpriv->act_chanlist[devpriv->act_chanlist_pos],
 			     devpriv->act_chanlist_pos);
@@ -641,12 +656,12 @@ static irqreturn_t interrupt_pcl818_ai_mode13_dma(int irq, void *d)
 			return IRQ_HANDLED;
 		}
 
-		comedi_buf_put(s->async, ptr[bufptr++] >> 4);	/*  get one sample */
+		/* get one sample */
+		comedi_buf_put(s->async, ptr[bufptr++] >> 4);
 
 		devpriv->act_chanlist_pos++;
-		if (devpriv->act_chanlist_pos >= devpriv->act_chanlist_len) {
+		if (devpriv->act_chanlist_pos >= devpriv->act_chanlist_len)
 			devpriv->act_chanlist_pos = 0;
-		}
 		s->async->cur_chan++;
 		if (s->async->cur_chan >= devpriv->ai_n_chan) {
 			s->async->cur_chan = 0;
@@ -654,7 +669,7 @@ static irqreturn_t interrupt_pcl818_ai_mode13_dma(int irq, void *d)
 		}
 
 		if (!devpriv->neverending_ai)
-			if (devpriv->ai_act_scan == 0) {	/* all data sampled */
+			if (devpriv->ai_act_scan == 0) { /* all data sampled */
 				pcl818_ai_cancel(dev, s);
 				s->async->events |= COMEDI_CB_EOA;
 				comedi_event(dev, s);
@@ -671,7 +686,7 @@ static irqreturn_t interrupt_pcl818_ai_mode13_dma(int irq, void *d)
 #ifdef unused
 /*
 ==============================================================================
-   analog input dma mode 1 & 3 over RTC, 818 cards
+	analog input dma mode 1 & 3 over RTC, 818 cards
 */
 static irqreturn_t interrupt_pcl818_ai_mode13_dma_rtc(int irq, void *d)
 {
@@ -699,20 +714,24 @@ static irqreturn_t interrupt_pcl818_ai_mode13_dma_rtc(int irq, void *d)
 
 		if (top1 != top2)
 			return IRQ_HANDLED;
-		top1 = devpriv->hwdmasize[0] - top1;	/*  where is now DMA in buffer */
+		/*  where is now DMA in buffer */
+		top1 = devpriv->hwdmasize[0] - top1;
 		top1 >>= 1;
-		ofs_dats = top1 - devpriv->last_top_dma;	/*  new samples from last call */
+		/*  new samples from last call */
+		ofs_dats = top1 - devpriv->last_top_dma;
 		if (ofs_dats < 0)
 			ofs_dats = (devpriv->dmasamplsize) + ofs_dats;
+		/*  exit=no new samples from last call */
 		if (!ofs_dats)
-			return IRQ_HANDLED;	/*  exit=no new samples from last call */
+			return IRQ_HANDLED;
 		/*  obsluz data */
 		i = devpriv->last_top_dma - 1;
 		i &= (devpriv->dmasamplsize - 1);
 
 		if (dmabuf[i] != MAGIC_DMA_WORD) {	/*  DMA overflow! */
 			comedi_error(dev, "A/D mode1/3 DMA buffer overflow!");
-			/* printk("I %d dmabuf[i] %d %d\n",i,dmabuf[i],devpriv->dmasamplsize); */
+			/* printk("I %d dmabuf[i] %d %d\n",i,dmabuf[i],
+			   devpriv->dmasamplsize); */
 			pcl818_ai_cancel(dev, s);
 			s->async->events |= COMEDI_CB_EOA | COMEDI_CB_ERROR;
 			comedi_event(dev, s);
@@ -723,9 +742,12 @@ static irqreturn_t interrupt_pcl818_ai_mode13_dma_rtc(int irq, void *d)
 		bufptr = devpriv->last_top_dma;
 
 		for (i = 0; i < ofs_dats; i++) {
-			if ((dmabuf[bufptr] & 0xf) != devpriv->act_chanlist[devpriv->act_chanlist_pos]) {	/*  dropout! */
+			/*  dropout! */
+			if ((dmabuf[bufptr] & 0xf) != devpriv->
+				act_chanlist[devpriv->act_chanlist_pos]) {
 				printk
-				    ("comedi: A/D mode1/3 DMA - channel dropout %d!=%d !\n",
+				    ("comedi: A/D mode1/3 DMA - channel "
+				     "dropout %d!=%d !\n",
 				     (dmabuf[bufptr] & 0xf),
 				     devpriv->
 				     act_chanlist[devpriv->act_chanlist_pos]);
@@ -736,7 +758,8 @@ static irqreturn_t interrupt_pcl818_ai_mode13_dma_rtc(int irq, void *d)
 				return IRQ_HANDLED;
 			}
 
-			comedi_buf_put(s->async, dmabuf[bufptr++] >> 4);	/*  get one sample */
+			/*  get one sample */
+			comedi_buf_put(s->async, dmabuf[bufptr++] >> 4);
 			bufptr &= (devpriv->dmasamplsize - 1);
 
 			devpriv->act_chanlist_pos++;
@@ -751,7 +774,8 @@ static irqreturn_t interrupt_pcl818_ai_mode13_dma_rtc(int irq, void *d)
 			}
 
 			if (!devpriv->neverending_ai)
-				if (devpriv->ai_act_scan == 0) {	/* all data sampled */
+				/* all data sampled */
+				if (devpriv->ai_act_scan == 0) {
 					pcl818_ai_cancel(dev, s);
 					s->async->events |= COMEDI_CB_EOA;
 					comedi_event(dev, s);
@@ -776,7 +800,7 @@ static irqreturn_t interrupt_pcl818_ai_mode13_dma_rtc(int irq, void *d)
 
 /*
 ==============================================================================
-   analog input interrupt mode 1 & 3, 818HD/HG cards
+	analog input interrupt mode 1 & 3, 818HD/HG cards
 */
 static irqreturn_t interrupt_pcl818_ai_mode13_fifo(int irq, void *d)
 {
@@ -784,7 +808,7 @@ static irqreturn_t interrupt_pcl818_ai_mode13_fifo(int irq, void *d)
 	struct comedi_subdevice *s = dev->subdevices + 0;
 	int i, len, lo;
 
-	outb(0, dev->iobase + PCL818_FI_INTCLR);	/*  clear fifo int request */
+	outb(0, dev->iobase + PCL818_FI_INTCLR); /*  clear fifo int request */
 
 	lo = inb(dev->iobase + PCL818_FI_STATUS);
 
@@ -804,17 +828,19 @@ static irqreturn_t interrupt_pcl818_ai_mode13_fifo(int irq, void *d)
 		return IRQ_HANDLED;
 	}
 
-	if (lo & 2) {
+	if (lo & 2)
 		len = 512;
-	} else {
+	else
 		len = 0;
-	}
 
 	for (i = 0; i < len; i++) {
 		lo = inb(dev->iobase + PCL818_FI_DATALO);
-		if ((lo & 0xf) != devpriv->act_chanlist[devpriv->act_chanlist_pos]) {	/*  dropout! */
+		/*  dropout! */
+		if ((lo & 0xf) != devpriv->
+			act_chanlist[devpriv->act_chanlist_pos]) {
 			printk
-			    ("comedi: A/D mode1/3 FIFO - channel dropout %d!=%d !\n",
+			    ("comedi: A/D mode1/3 FIFO - channel "
+			     "dropout %d!=%d !\n",
 			     (lo & 0xf),
 			     devpriv->act_chanlist[devpriv->act_chanlist_pos]);
 			pcl818_ai_cancel(dev, s);
@@ -823,12 +849,13 @@ static irqreturn_t interrupt_pcl818_ai_mode13_fifo(int irq, void *d)
 			return IRQ_HANDLED;
 		}
 
-		comedi_buf_put(s->async, (lo >> 4) | (inb(dev->iobase + PCL818_FI_DATAHI) << 4));	/*  get one sample */
+		/*  get one sample */
+		comedi_buf_put(s->async, (lo >> 4)
+				| (inb(dev->iobase + PCL818_FI_DATAHI) << 4));
 
 		devpriv->act_chanlist_pos++;
-		if (devpriv->act_chanlist_pos >= devpriv->act_chanlist_len) {
+		if (devpriv->act_chanlist_pos >= devpriv->act_chanlist_len)
 			devpriv->act_chanlist_pos = 0;
-		}
 		s->async->cur_chan++;
 		if (s->async->cur_chan >= devpriv->ai_n_chan) {
 			s->async->cur_chan = 0;
@@ -836,7 +863,7 @@ static irqreturn_t interrupt_pcl818_ai_mode13_fifo(int irq, void *d)
 		}
 
 		if (!devpriv->neverending_ai)
-			if (devpriv->ai_act_scan == 0) {	/* all data sampled */
+			if (devpriv->ai_act_scan == 0) { /* all data sampled */
 				pcl818_ai_cancel(dev, s);
 				s->async->events |= COMEDI_CB_EOA;
 				comedi_event(dev, s);
@@ -851,7 +878,7 @@ static irqreturn_t interrupt_pcl818_ai_mode13_fifo(int irq, void *d)
 
 /*
 ==============================================================================
-    INT procedure
+	INT procedure
 */
 static irqreturn_t interrupt_pcl818(int irq, void *d)
 {
@@ -917,7 +944,7 @@ static irqreturn_t interrupt_pcl818(int irq, void *d)
 
 /*
 ==============================================================================
-   ANALOG INPUT MODE 1 or 3 DMA , 818 cards
+	ANALOG INPUT MODE 1 or 3 DMA , 818 cards
 */
 static void pcl818_ai_mode13dma_int(int mode, struct comedi_device *dev,
 				    struct comedi_subdevice *s)
@@ -925,13 +952,16 @@ static void pcl818_ai_mode13dma_int(int mode, struct comedi_device *dev,
 	unsigned int flags;
 	unsigned int bytes;
 
-	printk("mode13dma_int, mode: %d\n", mode);
+	printk(KERN_ERR "mode13dma_int, mode: %d\n", mode);
 	disable_dma(devpriv->dma);	/*  disable dma */
 	bytes = devpriv->hwdmasize[0];
 	if (!devpriv->neverending_ai) {
-		bytes = devpriv->ai_n_chan * devpriv->ai_scans * sizeof(short);	/*  how many */
-		devpriv->dma_runs_to_end = bytes / devpriv->hwdmasize[0];	/*  how many DMA pages we must fiil */
-		devpriv->last_dma_run = bytes % devpriv->hwdmasize[0];	/* on last dma transfer must be moved */
+		bytes = devpriv->ai_n_chan * devpriv->
+			ai_scans * sizeof(short);	/*  how many */
+		/*  how many DMA pages we must fiil */
+		devpriv->dma_runs_to_end = bytes / devpriv->hwdmasize[0];
+		/* on last dma transfer must be moved */
+		devpriv->last_dma_run = bytes % devpriv->hwdmasize[0];
 		devpriv->dma_runs_to_end--;
 		if (devpriv->dma_runs_to_end >= 0)
 			bytes = devpriv->hwdmasize[0];
@@ -948,17 +978,19 @@ static void pcl818_ai_mode13dma_int(int mode, struct comedi_device *dev,
 
 	if (mode == 1) {
 		devpriv->ai_mode = INT_TYPE_AI1_DMA;
-		outb(0x87 | (dev->irq << 4), dev->iobase + PCL818_CONTROL);	/* Pacer+IRQ+DMA */
+		/* Pacer+IRQ+DMA */
+		outb(0x87 | (dev->irq << 4), dev->iobase + PCL818_CONTROL);
 	} else {
 		devpriv->ai_mode = INT_TYPE_AI3_DMA;
-		outb(0x86 | (dev->irq << 4), dev->iobase + PCL818_CONTROL);	/* Ext trig+IRQ+DMA */
+		/* Ext trig+IRQ+DMA */
+		outb(0x86 | (dev->irq << 4), dev->iobase + PCL818_CONTROL);
 	};
 }
 
 #ifdef unused
 /*
 ==============================================================================
-   ANALOG INPUT MODE 1 or 3 DMA rtc, 818 cards
+	ANALOG INPUT MODE 1 or 3 DMA rtc, 818 cards
 */
 static void pcl818_ai_mode13dma_rtc(int mode, struct comedi_device *dev,
 				    struct comedi_subdevice *s)
@@ -989,17 +1021,19 @@ static void pcl818_ai_mode13dma_rtc(int mode, struct comedi_device *dev,
 
 	if (mode == 1) {
 		devpriv->int818_mode = INT_TYPE_AI1_DMA_RTC;
-		outb(0x07 | (dev->irq << 4), dev->iobase + PCL818_CONTROL);	/* Pacer+DMA */
+		/* Pacer+DMA */
+		outb(0x07 | (dev->irq << 4), dev->iobase + PCL818_CONTROL);
 	} else {
 		devpriv->int818_mode = INT_TYPE_AI3_DMA_RTC;
-		outb(0x06 | (dev->irq << 4), dev->iobase + PCL818_CONTROL);	/* Ext trig+DMA */
+		/* Ext trig+DMA */
+		outb(0x06 | (dev->irq << 4), dev->iobase + PCL818_CONTROL);
 	};
 }
 #endif
 
 /*
 ==============================================================================
-   ANALOG INPUT MODE 1 or 3, 818 cards
+	ANALOG INPUT MODE 1 or 3, 818 cards
 */
 static int pcl818_ai_cmd_mode(int mode, struct comedi_device *dev,
 			      struct comedi_subdevice *s)
@@ -1008,7 +1042,7 @@ static int pcl818_ai_cmd_mode(int mode, struct comedi_device *dev,
 	int divisor1 = 0, divisor2 = 0;
 	unsigned int seglen;
 
-	printk("pcl818_ai_cmd_mode()\n");
+	printk(KERN_ERR "pcl818_ai_cmd_mode()\n");
 	if ((!dev->irq) && (!devpriv->dma_rtc)) {
 		comedi_error(dev, "IRQ not defined!");
 		return -EINVAL;
@@ -1037,13 +1071,14 @@ static int pcl818_ai_cmd_mode(int mode, struct comedi_device *dev,
 	devpriv->dma_runs_to_end = 0;
 
 	if ((devpriv->ai_scans == 0) || (devpriv->ai_scans == -1))
-		devpriv->neverending_ai = 1;	/* well, user want neverending */
+		devpriv->neverending_ai = 1; /* well, user want neverending */
 
 	if (mode == 1) {
 		i8253_cascade_ns_to_timer(devpriv->i8253_osc_base, &divisor1,
 					  &divisor2, &cmd->convert_arg,
 					  TRIG_ROUND_NEAREST);
-		if (divisor1 == 1) {	/* PCL718/818 crash if any divisor is set to 1 */
+		if (divisor1 == 1) {	/* PCL718/818 crash if any
+					   divisor is set to 1 */
 			divisor1 = 2;
 			divisor2 /= 2;
 		}
@@ -1058,17 +1093,14 @@ static int pcl818_ai_cmd_mode(int mode, struct comedi_device *dev,
 	switch (devpriv->dma) {
 	case 1:		/*  DMA */
 	case 3:
-		if (devpriv->dma_rtc == 0) {
+		if (devpriv->dma_rtc == 0)
 			pcl818_ai_mode13dma_int(mode, dev, s);
-		}
 #ifdef unused
-		else {
+		else
 			pcl818_ai_mode13dma_rtc(mode, dev, s);
-		}
 #else
-		else {
+		else
 			return -EINVAL;
-		}
 #endif
 		break;
 	case 0:
@@ -1111,14 +1143,14 @@ static int pcl818_ai_cmd_mode(int mode, struct comedi_device *dev,
 		break;
 	}
 #endif
-	printk("pcl818_ai_cmd_mode() end\n");
+	printk(KERN_ERR "pcl818_ai_cmd_mode() end\n");
 	return 0;
 }
 
 #ifdef unused
 /*
 ==============================================================================
-   ANALOG OUTPUT MODE 1 or 3, 818 cards
+	ANALOG OUTPUT MODE 1 or 3, 818 cards
 */
 #ifdef PCL818_MODE13_AO
 static int pcl818_ao_mode13(int mode, struct comedi_device *dev,
@@ -1147,7 +1179,8 @@ static int pcl818_ao_mode13(int mode, struct comedi_device *dev,
 		i8253_cascade_ns_to_timer(devpriv->i8253_osc_base, &divisor1,
 					  &divisor2, &it->trigvar,
 					  TRIG_ROUND_NEAREST);
-		if (divisor1 == 1) {	/* PCL818 crash if any divisor is set to 1 */
+		if (divisor1 == 1) {	/* PCL818 crash if any divisor
+					   is set to 1 */
 			divisor1 = 2;
 			divisor2 /= 2;
 		}
@@ -1160,10 +1193,12 @@ static int pcl818_ao_mode13(int mode, struct comedi_device *dev,
 	outb(0, dev->iobase + PCL818_CNTENABLE);	/* enable pacer */
 	if (mode == 1) {
 		devpriv->int818_mode = INT_TYPE_AO1_INT;
-		outb(0x83 | (dev->irq << 4), dev->iobase + PCL818_CONTROL);	/* Pacer+IRQ */
+		/* Pacer+IRQ */
+		outb(0x83 | (dev->irq << 4), dev->iobase + PCL818_CONTROL);
 	} else {
 		devpriv->int818_mode = INT_TYPE_AO3_INT;
-		outb(0x82 | (dev->irq << 4), dev->iobase + PCL818_CONTROL);	/* Ext trig+IRQ */
+		/* Ext trig+IRQ */
+		outb(0x82 | (dev->irq << 4), dev->iobase + PCL818_CONTROL);
 	};
 
 	start_pacer(dev, mode, divisor1, divisor2);
@@ -1173,7 +1208,7 @@ static int pcl818_ao_mode13(int mode, struct comedi_device *dev,
 
 /*
 ==============================================================================
-   ANALOG OUTPUT MODE 1, 818 cards
+	ANALOG OUTPUT MODE 1, 818 cards
 */
 static int pcl818_ao_mode1(struct comedi_device *dev,
 			   struct comedi_subdevice *s, comedi_trig * it)
@@ -1183,7 +1218,7 @@ static int pcl818_ao_mode1(struct comedi_device *dev,
 
 /*
 ==============================================================================
-   ANALOG OUTPUT MODE 3, 818 cards
+	ANALOG OUTPUT MODE 3, 818 cards
 */
 static int pcl818_ao_mode3(struct comedi_device *dev,
 			   struct comedi_subdevice *s, comedi_trig * it)
@@ -1195,7 +1230,7 @@ static int pcl818_ao_mode3(struct comedi_device *dev,
 
 /*
 ==============================================================================
- Start/stop pacer onboard pacer
+	Start/stop pacer onboard pacer
 */
 static void start_pacer(struct comedi_device *dev, int mode,
 			unsigned int divisor1, unsigned int divisor2)
@@ -1214,8 +1249,8 @@ static void start_pacer(struct comedi_device *dev, int mode,
 
 /*
 ==============================================================================
- Check if channel list from user is builded correctly
- If it's ok, then program scan/gain logic
+	Check if channel list from user is builded correctly
+	If it's ok, then program scan/gain logic
 */
 static int check_channel_list(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
@@ -1237,7 +1272,9 @@ static int check_channel_list(struct comedi_device *dev,
 		for (i = 1, seglen = 1; i < n_chan; i++, seglen++) {
 
 			/* printk("%d. %d * %d\n",i,
-			 * CR_CHAN(it->chanlist[i]),CR_RANGE(it->chanlist[i]));*/
+			 * CR_CHAN(it->chanlist[i]),
+			   CR_RANGE(it->chanlist[i])
+			   );*/
 
 			/* we detect loop, this must by finish */
 
@@ -1245,9 +1282,12 @@ static int check_channel_list(struct comedi_device *dev,
 				break;
 			nowmustbechan =
 			    (CR_CHAN(chansegment[i - 1]) + 1) % s->n_chan;
-			if (nowmustbechan != CR_CHAN(chanlist[i])) {	/*  channel list isn't continous :-( */
+			/*  channel list isn't continous :-( */
+			if (nowmustbechan != CR_CHAN(chanlist[i])) {
 				printk
-				    ("comedi%d: pcl818: channel list must be continous! chanlist[%i]=%d but must be %d or %d!\n",
+				    ("comedi%d: pcl818: channel list must be "
+				     "continous! chanlist[%i]=%d but must be "
+				     "%d or %d!\n",
 				     dev->minor, i, CR_CHAN(chanlist[i]),
 				     nowmustbechan, CR_CHAN(chanlist[0]));
 				return 0;
@@ -1258,23 +1298,29 @@ static int check_channel_list(struct comedi_device *dev,
 
 		/*  check whole chanlist */
 		for (i = 0, segpos = 0; i < n_chan; i++) {
-			/* printk("%d %d=%d %d\n",CR_CHAN(chansegment[i%seglen]),CR_RANGE(chansegment[i%seglen]),CR_CHAN(it->chanlist[i]),CR_RANGE(it->chanlist[i])); */
+			/* printk("%d %d=%d %d\n",
+			   CR_CHAN(chansegment[i%seglen]),
+			   CR_RANGE(chansegment[i%seglen]),
+			   CR_CHAN(it->chanlist[i]),
+			   CR_RANGE(it->chanlist[i])); */
 			if (chanlist[i] != chansegment[i % seglen]) {
 				printk
-				    ("comedi%d: pcl818: bad channel or range number! chanlist[%i]=%d,%d,%d and not %d,%d,%d!\n",
+				    ("comedi%d: pcl818: bad channel or range "
+				     "number! chanlist[%i]=%d,%d,%d and not "
+				     "%d,%d,%d!\n",
 				     dev->minor, i, CR_CHAN(chansegment[i]),
 				     CR_RANGE(chansegment[i]),
 				     CR_AREF(chansegment[i]),
 				     CR_CHAN(chanlist[i % seglen]),
 				     CR_RANGE(chanlist[i % seglen]),
 				     CR_AREF(chansegment[i % seglen]));
-				return 0;	/*  chan/gain list is strange */
+				return 0;	/* chan/gain list is strange */
 			}
 		}
 	} else {
 		seglen = 1;
 	}
-	printk("check_channel_list: seglen %d\n", seglen);
+	printk(KERN_ERR "check_channel_list: seglen %d\n", seglen);
 	return seglen;
 }
 
@@ -1290,8 +1336,11 @@ static void setup_channel_list(struct comedi_device *dev,
 
 	for (i = 0; i < seglen; i++) {	/*  store range list to card */
 		devpriv->act_chanlist[i] = CR_CHAN(chanlist[i]);
-		outb(muxonechan[CR_CHAN(chanlist[i])], dev->iobase + PCL818_MUX);	/* select channel */
-		outb(CR_RANGE(chanlist[i]), dev->iobase + PCL818_RANGE);	/* select gain */
+		/* select channel */
+		outb(muxonechan[CR_CHAN(chanlist[i])],
+		     dev->iobase + PCL818_MUX);
+		/* select gain */
+		outb(CR_RANGE(chanlist[i]), dev->iobase + PCL818_RANGE);
 	}
 
 	udelay(1);
@@ -1304,15 +1353,14 @@ static void setup_channel_list(struct comedi_device *dev,
 
 /*
 ==============================================================================
- Check if board is switched to SE (1) or DIFF(0) mode
+	Check if board is switched to SE (1) or DIFF(0) mode
 */
 static int check_single_ended(unsigned int port)
 {
-	if (inb(port + PCL818_STATUS) & 0x20) {
+	if (inb(port + PCL818_STATUS) & 0x20)
 		return 1;
-	} else {
+	else
 		return 0;
-	}
 }
 
 /*
@@ -1351,11 +1399,11 @@ static int ai_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 	if (!cmd->stop_src || tmp != cmd->stop_src)
 		err++;
 
-	if (err) {
+	if (err)
 		return 1;
-	}
 
-	/* step 2: make sure trigger sources are unique and mutually compatible */
+	/* step 2: make sure trigger sources
+	   are unique and mutually compatible */
 
 	if (cmd->start_src != TRIG_NOW) {
 		cmd->start_src = TRIG_NOW;
@@ -1376,9 +1424,8 @@ static int ai_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 	if (cmd->stop_src != TRIG_NONE && cmd->stop_src != TRIG_COUNT)
 		err++;
 
-	if (err) {
+	if (err)
 		return 2;
-	}
 
 	/* step 3: make sure arguments are trivially compatible */
 
@@ -1420,9 +1467,8 @@ static int ai_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 		}
 	}
 
-	if (err) {
+	if (err)
 		return 3;
-	}
 
 	/* step 4: fix up any arguments */
 
@@ -1437,9 +1483,8 @@ static int ai_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 			err++;
 	}
 
-	if (err) {
+	if (err)
 		return 4;
-	}
 
 	/* step 5: complain about special chanlist considerations */
 
@@ -1460,7 +1505,7 @@ static int ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	struct comedi_cmd *cmd = &s->async->cmd;
 	int retval;
 
-	printk("pcl818_ai_cmd()\n");
+	printk(KERN_ERR "pcl818_ai_cmd()\n");
 	devpriv->ai_n_chan = cmd->chanlist_len;
 	devpriv->ai_chanlist = cmd->chanlist;
 	devpriv->ai_flags = cmd->flags;
@@ -1469,17 +1514,16 @@ static int ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	devpriv->ai_timer1 = 0;
 	devpriv->ai_timer2 = 0;
 
-	if (cmd->stop_src == TRIG_COUNT) {
+	if (cmd->stop_src == TRIG_COUNT)
 		devpriv->ai_scans = cmd->stop_arg;
-	} else {
+	else
 		devpriv->ai_scans = 0;
-	}
 
 	if (cmd->scan_begin_src == TRIG_FOLLOW) {	/*  mode 1, 3 */
 		if (cmd->convert_src == TRIG_TIMER) {	/*  mode 1 */
 			devpriv->ai_timer1 = cmd->convert_arg;
 			retval = pcl818_ai_cmd_mode(1, dev, s);
-			printk("pcl818_ai_cmd() end\n");
+			printk(KERN_ERR "pcl818_ai_cmd() end\n");
 			return retval;
 		}
 		if (cmd->convert_src == TRIG_EXT) {	/*  mode 3 */
@@ -1492,13 +1536,13 @@ static int ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 
 /*
 ==============================================================================
- cancel any mode 1-4 AI
+	cancel any mode 1-4 AI
 */
 static int pcl818_ai_cancel(struct comedi_device *dev,
 			    struct comedi_subdevice *s)
 {
 	if (devpriv->irq_blocked > 0) {
-		printk("pcl818_ai_cancel()\n");
+		printk(KERN_ERR "pcl818_ai_cancel()\n");
 		devpriv->irq_was_now_closed = 1;
 
 		switch (devpriv->ai_mode) {
@@ -1513,7 +1557,8 @@ static int pcl818_ai_cancel(struct comedi_device *dev,
 			if (devpriv->neverending_ai ||
 			    (!devpriv->neverending_ai &&
 			     devpriv->ai_act_scan > 0)) {
-				/* wait for running dma transfer to end, do cleanup in interrupt */
+				/* wait for running dma transfer to end, do
+				   cleanup in interrupt */
 				goto end;
 			}
 			disable_dma(devpriv->dma);
@@ -1525,13 +1570,15 @@ static int pcl818_ai_cancel(struct comedi_device *dev,
 		case INT_TYPE_AO1_INT:
 		case INT_TYPE_AO3_INT:
 #endif
-			outb(inb(dev->iobase + PCL818_CONTROL) & 0x73, dev->iobase + PCL818_CONTROL);	/* Stop A/D */
+			outb(inb(dev->iobase + PCL818_CONTROL) & 0x73,
+			     dev->iobase + PCL818_CONTROL);	/* Stop A/D */
 			udelay(1);
 			start_pacer(dev, -1, 0, 0);
 			outb(0, dev->iobase + PCL818_AD_LO);
 			inb(dev->iobase + PCL818_AD_LO);
 			inb(dev->iobase + PCL818_AD_HI);
-			outb(0, dev->iobase + PCL818_CLRINT);	/* clear INT request */
+			/* clear INT request */
+			outb(0, dev->iobase + PCL818_CLRINT);
 			outb(0, dev->iobase + PCL818_CONTROL);	/* Stop A/D */
 			if (devpriv->usefifo) {	/*  FIFO shutdown */
 				outb(0, dev->iobase + PCL818_FI_INTCLR);
@@ -1548,13 +1595,13 @@ static int pcl818_ai_cancel(struct comedi_device *dev,
 	}
 
 end:
-	printk("pcl818_ai_cancel() end\n");
+	printk(KERN_ERR "pcl818_ai_cancel() end\n");
 	return 0;
 }
 
 /*
 ==============================================================================
- chech for PCL818
+	chech for PCL818
 */
 static int pcl818_check(unsigned long iobase)
 {
@@ -1577,7 +1624,7 @@ static int pcl818_check(unsigned long iobase)
 
 /*
 ==============================================================================
- reset whole PCL-818 cards
+	reset whole PCL-818 cards
 */
 static void pcl818_reset(struct comedi_device *dev)
 {
@@ -1610,7 +1657,7 @@ static void pcl818_reset(struct comedi_device *dev)
 #ifdef unused
 /*
 ==============================================================================
-  Enable(1)/disable(0) periodic interrupts from RTC
+	Enable(1)/disable(0) periodic interrupts from RTC
 */
 static int set_rtc_irq_bit(unsigned char bit)
 {
@@ -1632,11 +1679,10 @@ static int set_rtc_irq_bit(unsigned char bit)
 	save_flags(flags);
 	cli();
 	val = CMOS_READ(RTC_CONTROL);
-	if (bit) {
+	if (bit)
 		val |= RTC_PIE;
-	} else {
+	else
 		val &= ~RTC_PIE;
-	}
 	CMOS_WRITE(val, RTC_CONTROL);
 	CMOS_READ(RTC_INTR_FLAGS);
 	restore_flags(flags);
@@ -1645,7 +1691,8 @@ static int set_rtc_irq_bit(unsigned char bit)
 
 /*
 ==============================================================================
-  Restart RTC if something stop it (xntpd every 11 mins or large IDE transfers)
+	Restart RTC if something stop it
+	(xntpd every 11 mins or large IDE transfers)
 */
 static void rtc_dropped_irq(unsigned long data)
 {
@@ -1667,7 +1714,7 @@ static void rtc_dropped_irq(unsigned long data)
 
 /*
 ==============================================================================
-  Set frequency of interrupts from RTC
+	Set frequency of interrupts from RTC
 */
 static int rtc_setfreq_irq(int freq)
 {
@@ -1698,7 +1745,7 @@ static int rtc_setfreq_irq(int freq)
 
 /*
 ==============================================================================
-  Free any resources that we have claimed
+	Free any resources that we have claimed
 */
 static void free_resources(struct comedi_device *dev)
 {
@@ -1735,7 +1782,7 @@ static void free_resources(struct comedi_device *dev)
 /*
 ==============================================================================
 
-   Initialization
+	Initialization
 
 */
 static int pcl818_attach(struct comedi_device *dev, struct comedi_devconfig *it)
@@ -1753,22 +1800,23 @@ static int pcl818_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	/* claim our I/O space */
 	iobase = it->options[0];
-	printk("comedi%d: pcl818:  board=%s, ioport=0x%03lx",
+	printk(KERN_ERR "comedi%d: pcl818:  board=%s, ioport=0x%03lx",
 	       dev->minor, this_board->name, iobase);
 	devpriv->io_range = this_board->io_range;
-	if ((this_board->fifo) && (it->options[2] == -1)) {	/*  we've board with FIFO and we want to use FIFO */
+	/*  we've board with FIFO and we want to use FIFO */
+	if ((this_board->fifo) && (it->options[2] == -1)) {
 		devpriv->io_range = PCLx1xFIFO_RANGE;
 		devpriv->usefifo = 1;
 	}
 	if (!request_region(iobase, devpriv->io_range, "pcl818")) {
-		printk("I/O port conflict\n");
+		printk(KERN_ERR "I/O port conflict\n");
 		return -EIO;
 	}
 
 	dev->iobase = iobase;
 
 	if (pcl818_check(iobase)) {
-		printk(", I can't detect board. FAIL!\n");
+		printk(KERN_ERR ", I can't detect board. FAIL!\n");
 		return -EIO;
 	}
 
@@ -1781,30 +1829,32 @@ static int pcl818_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		if (irq) {	/* we want to use IRQ */
 			if (((1 << irq) & this_board->IRQbits) == 0) {
 				printk
-				    (", IRQ %u is out of allowed range, DISABLING IT",
+				    (", IRQ %u is out of allowed range, "
+				     "DISABLING IT",
 				     irq);
 				irq = 0;	/* Bad IRQ */
 			} else {
 				if (request_irq
-				    (irq, interrupt_pcl818, 0, "pcl818", dev)) {
+				    (irq, interrupt_pcl818, 0, "pcl818", dev)
+				    ) {
 					printk
-					    (", unable to allocate IRQ %u, DISABLING IT",
+					    (", unable to allocate IRQ %u, "
+					     "DISABLING IT",
 					     irq);
 					irq = 0;	/* Can't use IRQ */
 				} else {
-					printk(", irq=%u", irq);
+					printk(KERN_ERR ", irq=%u", irq);
 				}
 			}
 		}
 	}
 
 	dev->irq = irq;
-	if (irq) {
+	if (irq)
 		devpriv->irq_free = 1;
-	} /* 1=we have allocated irq */
-	else {
+	/* 1=we have allocated irq */
+	else
 		devpriv->irq_free = 0;
-	}
 	devpriv->irq_blocked = 0;	/* number of subdevice which use IRQ */
 	devpriv->ai_mode = 0;	/* mode of irq */
 
@@ -1854,27 +1904,32 @@ no_rtc:
 		}
 		ret = request_dma(dma, "pcl818");
 		if (ret) {
-			printk(", unable to allocate DMA %u, FAIL!\n", dma);
+			printk(KERN_ERR ", unable to allocate DMA %u, FAIL!\n",
+			       dma);
 			return -EBUSY;	/* DMA isn't free */
 		}
 		devpriv->dma = dma;
-		printk(", dma=%u", dma);
+		printk(KERN_ERR ", dma=%u", dma);
 		pages = 2;	/* we need 16KB */
 		devpriv->dmabuf[0] = __get_dma_pages(GFP_KERNEL, pages);
 		if (!devpriv->dmabuf[0]) {
 			printk(", unable to allocate DMA buffer, FAIL!\n");
-			/* maybe experiment with try_to_free_pages() will help .... */
+			/* maybe experiment with
+			   try_to_free_pages() will help .... */
 			return -EBUSY;	/* no buffer :-( */
 		}
 		devpriv->dmapages[0] = pages;
 		devpriv->hwdmaptr[0] = virt_to_bus((void *)devpriv->dmabuf[0]);
 		devpriv->hwdmasize[0] = (1 << pages) * PAGE_SIZE;
-		/* printk("%d %d %ld, ",devpriv->dmapages[0],devpriv->hwdmasize[0],PAGE_SIZE); */
-		if (devpriv->dma_rtc == 0) {	/*  we must do duble buff :-( */
-			devpriv->dmabuf[1] = __get_dma_pages(GFP_KERNEL, pages);
+		/* printk("%d %d %ld, ",devpriv->dmapages[0],devpriv->
+		   hwdmasize[0],PAGE_SIZE); */
+		if (devpriv->dma_rtc == 0) {	/* we must do duble buff :-( */
+			devpriv->dmabuf[1] = __get_dma_pages(GFP_KERNEL,
+							     pages);
 			if (!devpriv->dmabuf[1]) {
 				printk
-				    (", unable to allocate DMA buffer, FAIL!\n");
+				    (", unable to allocate DMA buffer, "
+				     "FAIL!\n");
 				return -EBUSY;
 			}
 			devpriv->dmapages[1] = pages;
@@ -1900,7 +1955,7 @@ no_dma:
 		if (check_single_ended(dev->iobase)) {
 			s->n_chan = this_board->n_aichan_se;
 			s->subdev_flags |= SDF_COMMON | SDF_GROUND;
-			printk(", %dchans S.E. DAC", s->n_chan);
+			printk(KERN_ERR ", %dchans S.E. DAC", s->n_chan);
 		} else {
 			s->n_chan = this_board->n_aichan_diff;
 			s->subdev_flags |= SDF_DIFF;
@@ -1918,8 +1973,9 @@ no_dma:
 			s->do_cmd = ai_cmd;
 		}
 		if (this_board->is_818) {
+			/*  secondary range list jumper selectable */
 			if ((it->options[4] == 1) || (it->options[4] == 10))
-				s->range_table = &range_pcl818l_h_ai;	/*  secondary range list jumper selectable */
+				s->range_table = &range_pcl818l_h_ai;
 		} else {
 			switch (it->options[4]) {
 			case 0:
@@ -2016,18 +2072,18 @@ no_dma:
 	}
 
 	/* select 1/10MHz oscilator */
-	if ((it->options[3] == 0) || (it->options[3] == 10)) {
+	if ((it->options[3] == 0) || (it->options[3] == 10))
 		devpriv->i8253_osc_base = 100;
-	} else {
+	else
 		devpriv->i8253_osc_base = 1000;
-	}
 
 	/* max sampling speed */
 	devpriv->ns_min = this_board->ns_min;
 
 	if (!this_board->is_818) {
+		/* extended PCL718 to 100kHz DAC */
 		if ((it->options[6] == 1) || (it->options[6] == 100))
-			devpriv->ns_min = 10000;	/* extended PCL718 to 100kHz DAC */
+			devpriv->ns_min = 10000;
 	}
 
 	pcl818_reset(dev);
@@ -2039,7 +2095,7 @@ no_dma:
 
 /*
 ==============================================================================
-  Removes device
+	Removes device
  */
 static int pcl818_detach(struct comedi_device *dev)
 {
-- 
1.7.0.4

