Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab0CROrE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 10:47:04 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:55262 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab0CROq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 10:46:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=SjE9VLsxE7GKEn4QweZoj14CSTxJk+yQpsj3MT918MCuYStkV4ryX+WqIdLUqOaxE6
         K/aSWRljjPgX3J4K1NPmm0Ck+VgvGL7g0Mk/XM9gcwM89gcvQmyV0YpM7SQ16mgjvEHO
         uK158dKtd6IRXcfJ48OdWgOwth/UYoUl0S+Uk=
From: Maurice Dawson <mauricedawson2699@googlemail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 18/18] Staging: comedi: fix 80 character coding style issue in adl_pci9118.c
Date: Thu, 18 Mar 2010 14:46:37 +0000
Message-Id: <1268923597-5029-1-git-send-email-mauricedawson2699@googlemail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes all over 80 character warnings in the adl_pci9118.c file found by the checkpatch.pl tool

Signed-off-by: Maurice Dawson <mauricedawson2699@googlemail.com>
---
 drivers/staging/comedi/drivers/adl_pci9118.c |  792 +++++++++++++++++---------
 1 files changed, 537 insertions(+), 255 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index 9f30dee..2c39430 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -46,18 +46,18 @@ Configuration options:
   [1] - PCI slot of device (optional)
 	If bus/slot is not specified, then first available PCI
 	card will be used.
-  [2] - 0= standard 8 DIFF/16 SE channels configuration
-	n= external multiplexer connected, 1<=n<=256
+  [2] - 0 = standard 8 DIFF/16 SE channels configuration
+	n = external multiplexer connected, 1 <= n <= 256
   [3] - 0=autoselect DMA or EOC interrupts operation
-	1=disable DMA mode
-	3=disable DMA and INT, only insn interface will work
+	1 = disable DMA mode
+	3 = disable DMA and INT, only insn interface will work
   [4] - sample&hold signal - card can generate signal for external S&H board
-	0=use SSHO (pin 45) signal is generated in onboard hardware S&H logic
-	0!=use ADCHN7 (pin 23) signal is generated from driver, number say how
+	0 = use SSHO(pin 45) signal is generated in onboard hardware S&H logic
+	0 != use ADCHN7(pin 23) signal is generated from driver, number say how
 		long delay is requested in ns and sign polarity of the hold
 		(in this case external multiplexor can serve only 128 channels)
   [5] - 0=stop measure on all hardware errors
-	2|=ignore ADOR - A/D Overrun status
+	2 | = ignore ADOR - A/D Overrun status
 	8|=ignore Bover - A/D Burst Mode Overrun status
 	256|=ignore nFull - A/D FIFO Full status
 
@@ -74,9 +74,15 @@ Configuration options:
 #include "comedi_fc.h"
 
 /* paranoid checks are broken */
-#undef PCI9118_PARANOIDCHECK	/* if defined, then is used code which control correct channel number on every 12 bit sample */
+#undef PCI9118_PARANOIDCHECK	/*
+				 * if defined, then is used code which control
+				 * correct channel number on every 12 bit sample
+				 */
 
-#undef PCI9118_EXTDEBUG		/* if defined then driver prints a lot of messages */
+#undef PCI9118_EXTDEBUG		/*
+				 * if defined then driver prints
+				 * a lot of messages
+				 */
 
 #undef DPRINTK
 #ifdef PCI9118_EXTDEBUG
@@ -86,7 +92,10 @@ Configuration options:
 #endif
 
 #define IORANGE_9118 	64	/* I hope */
-#define PCI9118_CHANLEN	255	/* len of chanlist, some source say 256, but reality looks like 255 :-( */
+#define PCI9118_CHANLEN	255	/*
+				 * len of chanlist, some source say 256,
+				 * but reality looks like 255 :-(
+				 */
 
 #define PCI9118_CNT0	0x00	/* R/W: 8254 couter 0 */
 #define PCI9118_CNT1	0x04	/* R/W: 8254 couter 0 */
@@ -112,20 +121,47 @@ Configuration options:
 #define AdControl_UniP	0x80	/* 1=bipolar, 0=unipolar */
 #define AdControl_Diff	0x40	/* 1=differential, 0= single end inputs */
 #define AdControl_SoftG	0x20	/* 1=8254 counter works, 0=counter stops */
-#define	AdControl_ExtG	0x10	/* 1=8254 countrol controlled by TGIN(pin 46), 0=controled by SoftG */
-#define AdControl_ExtM	0x08	/* 1=external hardware trigger (pin 44), 0=internal trigger */
-#define AdControl_TmrTr	0x04	/* 1=8254 is iternal trigger source, 0=software trigger is source (register PCI9118_SOFTTRG) */
+#define	AdControl_ExtG	0x10	/*
+				 * 1=8254 countrol controlled by TGIN(pin 46),
+				 * 0=controlled by SoftG
+				 */
+#define AdControl_ExtM	0x08	/*
+				 * 1=external hardware trigger (pin 44),
+				 * 0=internal trigger
+				 */
+#define AdControl_TmrTr	0x04	/*
+				 * 1=8254 is iternal trigger source,
+				 * 0=software trigger is source
+				 * (register PCI9118_SOFTTRG)
+				 */
 #define AdControl_Int	0x02	/* 1=enable INT, 0=disable */
 #define AdControl_Dma	0x01	/* 1=enable DMA, 0=disable */
 
 /* bits from A/D function register (PCI9118_ADFUNC) */
-#define AdFunction_PDTrg	0x80	/* 1=positive, 0=negative digital trigger (only positive is correct) */
-#define AdFunction_PETrg	0x40	/* 1=positive, 0=negative external trigger (only positive is correct) */
+#define AdFunction_PDTrg	0x80	/*
+					 * 1=positive,
+					 * 0=negative digital trigger
+					 * (only positive is correct)
+					 */
+#define AdFunction_PETrg	0x40	/*
+					 * 1=positive,
+					 * 0=negative external trigger
+					 * (only positive is correct)
+					 */
 #define AdFunction_BSSH		0x20	/* 1=with sample&hold, 0=without */
 #define AdFunction_BM		0x10	/* 1=burst mode, 0=normal mode */
-#define AdFunction_BS		0x08	/* 1=burst mode start, 0=burst mode stop */
-#define AdFunction_PM		0x04	/* 1=post trigger mode, 0=not post trigger */
-#define AdFunction_AM		0x02	/* 1=about trigger mode, 0=not about trigger */
+#define AdFunction_BS		0x08	/*
+					 * 1=burst mode start,
+					 * 0=burst mode stop
+					 */
+#define AdFunction_PM		0x04	/*
+					 * 1=post trigger mode,
+					 * 0=not post trigger
+					 */
+#define AdFunction_AM		0x02	/*
+					 * 1=about trigger mode,
+					 * 0=not about trigger
+					 */
 #define AdFunction_Start	0x01	/* 1=trigger start, 0=trigger stop */
 
 /* bits from A/D status register (PCI9118_ADSTAT) */
@@ -177,30 +213,39 @@ static const struct comedi_lrange range_pci9118hg = { 8, {
 							  }
 };
 
-#define PCI9118_BIPOLAR_RANGES	4	/* used for test on mixture of BIP/UNI ranges */
+#define PCI9118_BIPOLAR_RANGES	4	/*
+					 * used for test on mixture
+					 * of BIP/UNI ranges
+					 */
 
 static int pci9118_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it);
 static int pci9118_detach(struct comedi_device *dev);
 
 struct boardtype {
-	const char *name;	/*  board name */
-	int vendor_id;		/*  PCI vendor a device ID of card */
+	const char *name;		/* board name */
+	int vendor_id;			/* PCI vendor a device ID of card */
 	int device_id;
-	int iorange_amcc;	/*  iorange for own S5933 region */
-	int iorange_9118;	/*  pass thru card region size */
-	int n_aichan;		/*  num of A/D chans */
-	int n_aichand;		/*  num of A/D chans in diff mode */
-	int mux_aichan;		/*  num of A/D chans with external multiplexor */
-	int n_aichanlist;	/*  len of chanlist */
-	int n_aochan;		/*  num of D/A chans */
-	int ai_maxdata;		/*  resolution of A/D */
-	int ao_maxdata;		/*  resolution of D/A */
-	const struct comedi_lrange *rangelist_ai;	/*  rangelist for A/D */
-	const struct comedi_lrange *rangelist_ao;	/*  rangelist for D/A */
-	unsigned int ai_ns_min;	/*  max sample speed of card v ns */
-	unsigned int ai_pacer_min;	/*  minimal pacer value (c1*c2 or c1 in burst) */
-	int half_fifo_size;	/*  size of FIFO/2 */
+	int iorange_amcc;		/* iorange for own S5933 region */
+	int iorange_9118;		/* pass thru card region size */
+	int n_aichan;			/* num of A/D chans */
+	int n_aichand;			/* num of A/D chans in diff mode */
+	int mux_aichan;			/*
+					 * num of A/D chans with
+					 * external multiplexor
+					 */
+	int n_aichanlist;		/* len of chanlist */
+	int n_aochan;			/* num of D/A chans */
+	int ai_maxdata;			/* resolution of A/D */
+	int ao_maxdata;			/* resolution of D/A */
+	const struct comedi_lrange *rangelist_ai;	/* rangelist for A/D */
+	const struct comedi_lrange *rangelist_ao;	/* rangelist for D/A */
+	unsigned int ai_ns_min;		/* max sample speed of card v ns */
+	unsigned int ai_pacer_min;	/*
+					 * minimal pacer value
+					 * (c1*c2 or c1 in burst)
+					 */
+	int half_fifo_size;		/* size of FIFO/2 */
 
 };
 
@@ -245,63 +290,113 @@ static struct comedi_driver driver_pci9118 = {
 COMEDI_PCI_INITCLEANUP(driver_pci9118, pci9118_pci_table);
 
 struct pci9118_private {
-	unsigned long iobase_a;	/*  base+size for AMCC chip */
-	unsigned int master;	/*  master capable */
-	struct pci_dev *pcidev;	/*  ptr to actual pcidev */
-	unsigned int usemux;	/*  we want to use external multiplexor! */
+	unsigned long iobase_a;	/* base+size for AMCC chip */
+	unsigned int master;	/* master capable */
+	struct pci_dev *pcidev;	/* ptr to actual pcidev */
+	unsigned int usemux;	/* we want to use external multiplexor! */
 #ifdef PCI9118_PARANOIDCHECK
-	unsigned short chanlist[PCI9118_CHANLEN + 1];	/*  list of scaned channel */
-	unsigned char chanlistlen;	/*  number of scanlist */
+	unsigned short chanlist[PCI9118_CHANLEN + 1];	/*
+							 * list of
+							 * scanned channel
+							 */
+	unsigned char chanlistlen;	/* number of scanlist */
 #endif
-	unsigned char AdControlReg;	/*  A/D control register */
-	unsigned char IntControlReg;	/*  Interrupt control register */
-	unsigned char AdFunctionReg;	/*  A/D function register */
-	char valid;		/*  driver is ok */
-	char ai_neverending;	/*  we do unlimited AI */
-	unsigned int i8254_osc_base;	/*  frequence of onboard oscilator */
-	unsigned int ai_do;	/*  what do AI? 0=nothing, 1 to 4 mode */
-	unsigned int ai_act_scan;	/*  how many scans we finished */
-	unsigned int ai_buf_ptr;	/*  data buffer ptr in samples */
-	unsigned int ai_n_chan;	/*  how many channels is measured */
-	unsigned int ai_n_scanlen;	/*  len of actual scanlist */
-	unsigned int ai_n_realscanlen;	/*  what we must transfer for one outgoing scan include front/back adds */
-	unsigned int ai_act_dmapos;	/*  position in actual real stream */
-	unsigned int ai_add_front;	/*  how many channels we must add before scan to satisfy S&H? */
-	unsigned int ai_add_back;	/*  how many channels we must add before scan to satisfy DMA? */
-	unsigned int *ai_chanlist;	/*  actaul chanlist */
+	unsigned char AdControlReg;	/* A/D control register */
+	unsigned char IntControlReg;	/* Interrupt control register */
+	unsigned char AdFunctionReg;	/* A/D function register */
+	char valid;			/* driver is ok */
+	char ai_neverending;		/* we do unlimited AI */
+	unsigned int i8254_osc_base;	/* frequence of onboard oscilator */
+	unsigned int ai_do;		/* what do AI? 0=nothing, 1 to 4 mode */
+	unsigned int ai_act_scan;	/* how many scans we finished */
+	unsigned int ai_buf_ptr;	/* data buffer ptr in samples */
+	unsigned int ai_n_chan;		/* how many channels is measured */
+	unsigned int ai_n_scanlen;	/* len of actual scanlist */
+	unsigned int ai_n_realscanlen;	/*
+					 * what we must transfer for one
+					 * outgoing scan include front/back adds
+					 */
+	unsigned int ai_act_dmapos;	/* position in actual real stream */
+	unsigned int ai_add_front;	/*
+					 * how many channels we must add
+					 * before scan to satisfy S&H?
+					 */
+	unsigned int ai_add_back;	/*
+					 * how many channels we must add
+					 * before scan to satisfy DMA?
+					 */
+	unsigned int *ai_chanlist;	/* actual chanlist */
 	unsigned int ai_timer1;
 	unsigned int ai_timer2;
 	unsigned int ai_flags;
-	char ai12_startstop;	/*  measure can start/stop on external trigger */
-	unsigned int ai_divisor1, ai_divisor2;	/*  divisors for start of measure on external start */
+	char ai12_startstop;		/*
+					 * measure can start/stop
+					 * on external trigger
+					 */
+	unsigned int ai_divisor1, ai_divisor2;	/*
+						 * divisors for start of measure
+						 * on external start
+						 */
 	unsigned int ai_data_len;
 	short *ai_data;
-	short ao_data[2];	/*  data output buffer */
-	unsigned int ai_scans;	/*  number of scans to do */
-	char dma_doublebuf;	/*  we can use double buffring */
-	unsigned int dma_actbuf;	/*  which buffer is used now */
-	short *dmabuf_virt[2];	/*  pointers to begin of DMA buffer */
-	unsigned long dmabuf_hw[2];	/*  hw address of DMA buff */
-	unsigned int dmabuf_size[2];	/*  size of dma buffer in bytes */
-	unsigned int dmabuf_use_size[2];	/*  which size we may now used for transfer */
-	unsigned int dmabuf_used_size[2];	/*  which size was trully used */
+	short ao_data[2];			/* data output buffer */
+	unsigned int ai_scans;			/* number of scans to do */
+	char dma_doublebuf;			/* we can use double buffring */
+	unsigned int dma_actbuf;		/* which buffer is used now */
+	short *dmabuf_virt[2];			/*
+						 * pointers to begin of
+						 * DMA buffer
+						 */
+	unsigned long dmabuf_hw[2];		/* hw address of DMA buff */
+	unsigned int dmabuf_size[2];		/*
+						 * size of dma buffer in bytes
+						 */
+	unsigned int dmabuf_use_size[2];	/*
+						 * which size we may now use
+						 * for transfer
+						 */
+	unsigned int dmabuf_used_size[2];	/* which size was truly used */
 	unsigned int dmabuf_panic_size[2];
-	unsigned int dmabuf_samples[2];	/*  size in samples */
-	int dmabuf_pages[2];	/*  number of pages in buffer */
-	unsigned char cnt0_users;	/*  bit field of 8254 CNT0 users (0-unused, 1-AO, 2-DI, 3-DO) */
-	unsigned char exttrg_users;	/*  bit field of external trigger users (0-AI, 1-AO, 2-DI, 3-DO) */
-	unsigned int cnt0_divisor;	/*  actual CNT0 divisor */
-	void (*int_ai_func) (struct comedi_device *, struct comedi_subdevice *, unsigned short, unsigned int, unsigned short);	/*  ptr to actual interrupt AI function */
-	unsigned char ai16bits;	/*  =1 16 bit card */
-	unsigned char usedma;	/*  =1 use DMA transfer and not INT */
-	unsigned char useeoshandle;	/*  =1 change WAKE_EOS DMA transfer to fit on every second */
-	unsigned char usessh;	/*  =1 turn on S&H support */
-	int softsshdelay;	/*  >0 use software S&H, numer is requested delay in ns */
-	unsigned char softsshsample;	/*  polarity of S&H signal in sample state */
-	unsigned char softsshhold;	/*  polarity of S&H signal in hold state */
-	unsigned int ai_maskerr;	/*  which warning was printed */
-	unsigned int ai_maskharderr;	/*  on which error bits stops */
-	unsigned int ai_inttrig_start;	/*  TRIG_INT for start */
+	unsigned int dmabuf_samples[2];		/* size in samples */
+	int dmabuf_pages[2];			/* number of pages in buffer */
+	unsigned char cnt0_users;		/*
+						 * bit field of 8254 CNT0 users
+						 * (0-unused, 1-AO, 2-DI, 3-DO)
+						 */
+	unsigned char exttrg_users;		/*
+						 * bit field of external trigger
+						 * users(0-AI, 1-AO, 2-DI, 3-DO)
+						 */
+	unsigned int cnt0_divisor;		/* actual CNT0 divisor */
+	void (*int_ai_func) (struct comedi_device *, struct comedi_subdevice *,
+		unsigned short,
+		unsigned int,
+		unsigned short);	/*
+					 * ptr to actual interrupt
+					 * AI function
+					 */
+	unsigned char ai16bits;		/* =1 16 bit card */
+	unsigned char usedma;		/* =1 use DMA transfer and not INT */
+	unsigned char useeoshandle;	/*
+					 * =1 change WAKE_EOS DMA transfer
+					 * to fit on every second
+					 */
+	unsigned char usessh;		/* =1 turn on S&H support */
+	int softsshdelay;		/*
+					 * >0 use software S&H,
+					 * numer is requested delay in ns
+					 */
+	unsigned char softsshsample;	/*
+					 * polarity of S&H signal
+					 * in sample state
+					 */
+	unsigned char softsshhold;	/*
+					 * polarity of S&H signal
+					 * in hold state
+					 */
+	unsigned int ai_maskerr;	/* which warning was printed */
+	unsigned int ai_maskharderr;	/* on which error bits stops */
+	unsigned int ai_inttrig_start;	/* TRIG_INT for start */
 };
 
 #define devpriv ((struct pci9118_private *)dev->private)
@@ -345,12 +440,19 @@ static int pci9118_insn_read_ai(struct comedi_device *dev,
 
 	devpriv->AdControlReg = AdControl_Int & 0xff;
 	devpriv->AdFunctionReg = AdFunction_PDTrg | AdFunction_PETrg;
-	outl(devpriv->AdFunctionReg, dev->iobase + PCI9118_ADFUNC);	/*  positive triggers, no S&H, no burst, burst stop, no post trigger, no about trigger, trigger stop */
+	outl(devpriv->AdFunctionReg, dev->iobase + PCI9118_ADFUNC);
+						/*
+						 * positive triggers, no S&H,
+						 * no burst, burst stop,
+						 * no post trigger,
+						 * no about trigger,
+						 * trigger stop
+						 */
 
 	if (!setup_channel_list(dev, s, 1, &insn->chanspec, 0, 0, 0, 0, 0))
 		return -EINVAL;
 
-	outl(0, dev->iobase + PCI9118_DELFIFO);	/*  flush FIFO */
+	outl(0, dev->iobase + PCI9118_DELFIFO);	/* flush FIFO */
 
 	for (n = 0; n < insn->n; n++) {
 		outw(0, dev->iobase + PCI9118_SOFTTRG);	/* start conversion */
@@ -364,7 +466,7 @@ static int pci9118_insn_read_ai(struct comedi_device *dev,
 
 		comedi_error(dev, "A/D insn timeout");
 		data[n] = 0;
-		outl(0, dev->iobase + PCI9118_DELFIFO);	/*  flush FIFO */
+		outl(0, dev->iobase + PCI9118_DELFIFO);	/* flush FIFO */
 		return -ETIME;
 
 conv_finish:
@@ -378,7 +480,7 @@ conv_finish:
 		}
 	}
 
-	outl(0, dev->iobase + PCI9118_DELFIFO);	/*  flush FIFO */
+	outl(0, dev->iobase + PCI9118_DELFIFO);	/* flush FIFO */
 	return n;
 
 }
@@ -589,11 +691,13 @@ static void interrupt_pci9118_ai_onesample(struct comedi_device *dev,
 
 #ifdef PCI9118_PARANOIDCHECK
 	if (devpriv->ai16bits == 0) {
-		if ((sampl & 0x000f) != devpriv->chanlist[s->async->cur_chan]) {	/*  data dropout! */
+		if ((sampl & 0x000f) != devpriv->chanlist[s->async->cur_chan]) {
+							/* data dropout! */
 			printk
-			    ("comedi: A/D  SAMPL - data dropout: received channel %d, expected %d!\n",
-			     sampl & 0x000f,
-			     devpriv->chanlist[s->async->cur_chan]);
+			    ("comedi: A/D  SAMPL - data dropout: "
+				"received channel %d, expected %d!\n",
+				sampl & 0x000f,
+				devpriv->chanlist[s->async->cur_chan]);
 			s->async->events |= COMEDI_CB_ERROR | COMEDI_CB_EOA;
 			pci9118_ai_cancel(dev, s);
 			comedi_event(dev, s);
@@ -603,11 +707,13 @@ static void interrupt_pci9118_ai_onesample(struct comedi_device *dev,
 #endif
 	cfc_write_to_buffer(s, sampl);
 	s->async->cur_chan++;
-	if (s->async->cur_chan >= devpriv->ai_n_scanlen) {	/* one scan done */
+	if (s->async->cur_chan >= devpriv->ai_n_scanlen) {
+							/* one scan done */
 		s->async->cur_chan %= devpriv->ai_n_scanlen;
 		devpriv->ai_act_scan++;
 		if (!(devpriv->ai_neverending))
-			if (devpriv->ai_act_scan >= devpriv->ai_scans) {	/* all data sampled */
+			if (devpriv->ai_act_scan >= devpriv->ai_scans) {
+							/* all data sampled */
 				pci9118_ai_cancel(dev, s);
 				s->async->events |= COMEDI_CB_EOA;
 			}
@@ -649,10 +755,14 @@ static void interrupt_pci9118_ai_dma(struct comedi_device *dev,
 		if (pci9118_decode_error_status(dev, s, int_adstat))
 			return;
 
-	samplesinbuf = devpriv->dmabuf_use_size[devpriv->dma_actbuf] >> 1;	/*  number of received real samples */
+	samplesinbuf = devpriv->dmabuf_use_size[devpriv->dma_actbuf] >> 1;
+					/* number of received real samples */
 /* DPRINTK("dma_actbuf=%d\n",devpriv->dma_actbuf); */
 
-	if (devpriv->dma_doublebuf) {	/*  switch DMA buffers if is used double buffering */
+	if (devpriv->dma_doublebuf) {	/*
+					 * switch DMA buffers if is used
+					 * double buffering
+					 */
 		next_dma_buf = 1 - devpriv->dma_actbuf;
 		outl(devpriv->dmabuf_hw[next_dma_buf],
 		     devpriv->iobase_a + AMCC_OP_REG_MWAR);
@@ -665,25 +775,32 @@ static void interrupt_pci9118_ai_dma(struct comedi_device *dev,
 	}
 
 	if (samplesinbuf) {
-		m = devpriv->ai_data_len >> 1;	/*  how many samples is to end of buffer */
-/* DPRINTK("samps=%d m=%d %d %d\n",samplesinbuf,m,s->async->buf_int_count,s->async->buf_int_ptr); */
+		m = devpriv->ai_data_len >> 1;	/*
+						 * how many samples is to
+						 * end of buffer
+						 */
+/*
+ * DPRINTK("samps=%d m=%d %d %d\n",
+ * samplesinbuf,m,s->async->buf_int_count,s->async->buf_int_ptr);
+ */
 		sampls = m;
 		move_block_from_dma(dev, s,
 				    devpriv->dmabuf_virt[devpriv->dma_actbuf],
 				    samplesinbuf);
-		m = m - sampls;	/*  m= how many samples was transfered */
+		m = m - sampls;		/* m= how many samples was transfered */
 	}
 /* DPRINTK("YYY\n"); */
 
 	if (!devpriv->ai_neverending)
-		if (devpriv->ai_act_scan >= devpriv->ai_scans) {	/* all data sampled */
+		if (devpriv->ai_act_scan >= devpriv->ai_scans) {
+							/* all data sampled */
 			pci9118_ai_cancel(dev, s);
 			s->async->events |= COMEDI_CB_EOA;
 		}
 
-	if (devpriv->dma_doublebuf) {	/*  switch dma buffers */
+	if (devpriv->dma_doublebuf) {	/* switch dma buffers */
 		devpriv->dma_actbuf = 1 - devpriv->dma_actbuf;
-	} else {		/*  restart DMA if is not used double buffering */
+	} else {	/* restart DMA if is not used double buffering */
 		outl(devpriv->dmabuf_hw[0],
 		     devpriv->iobase_a + AMCC_OP_REG_MWAR);
 		outl(devpriv->dmabuf_use_size[0],
@@ -704,39 +821,62 @@ static irqreturn_t interrupt_pci9118(int irq, void *d)
 	unsigned int int_daq = 0, int_amcc, int_adstat;
 
 	if (!dev->attached)
-		return IRQ_NONE;	/*  not fully initialized */
+		return IRQ_NONE;	/* not fully initialized */
 
-	int_daq = inl(dev->iobase + PCI9118_INTSRC) & 0xf;	/*  get IRQ reasons from card */
-	int_amcc = inl(devpriv->iobase_a + AMCC_OP_REG_INTCSR);	/*  get INT register from AMCC chip */
+	int_daq = inl(dev->iobase + PCI9118_INTSRC) & 0xf;
+					/* get IRQ reasons from card */
+	int_amcc = inl(devpriv->iobase_a + AMCC_OP_REG_INTCSR);
+					/* get INT register from AMCC chip */
 
-/* DPRINTK("INT daq=0x%01x amcc=0x%08x MWAR=0x%08x MWTC=0x%08x ADSTAT=0x%02x ai_do=%d\n", int_daq, int_amcc, inl(devpriv->iobase_a+AMCC_OP_REG_MWAR), inl(devpriv->iobase_a+AMCC_OP_REG_MWTC), inw(dev->iobase+PCI9118_ADSTAT)&0x1ff,devpriv->ai_do); */
+/*
+ * DPRINTK("INT daq=0x%01x amcc=0x%08x MWAR=0x%08x
+ * MWTC=0x%08x ADSTAT=0x%02x ai_do=%d\n",
+ * int_daq, int_amcc, inl(devpriv->iobase_a+AMCC_OP_REG_MWAR),
+ * inl(devpriv->iobase_a+AMCC_OP_REG_MWTC),
+ * inw(dev->iobase+PCI9118_ADSTAT)&0x1ff,devpriv->ai_do);
+ */
 
 	if ((!int_daq) && (!(int_amcc & ANY_S593X_INT)))
-		return IRQ_NONE;	/*  interrupt from other source */
+		return IRQ_NONE;	/* interrupt from other source */
 
-	outl(int_amcc | 0x00ff0000, devpriv->iobase_a + AMCC_OP_REG_INTCSR);	/*  shutdown IRQ reasons in AMCC */
+	outl(int_amcc | 0x00ff0000, devpriv->iobase_a + AMCC_OP_REG_INTCSR);
+					/* shutdown IRQ reasons in AMCC */
 
-	int_adstat = inw(dev->iobase + PCI9118_ADSTAT) & 0x1ff;	/*  get STATUS register */
+	int_adstat = inw(dev->iobase + PCI9118_ADSTAT) & 0x1ff;
+					/* get STATUS register */
 
 	if (devpriv->ai_do) {
 		if (devpriv->ai12_startstop)
-			if ((int_adstat & AdStatus_DTH) && (int_daq & Int_DTrg)) {	/*  start stop of measure */
+			if ((int_adstat & AdStatus_DTH) &&
+							(int_daq & Int_DTrg)) {
+						/* start stop of measure */
 				if (devpriv->ai12_startstop & START_AI_EXT) {
 					devpriv->ai12_startstop &=
 					    ~START_AI_EXT;
 					if (!(devpriv->ai12_startstop &
-					      STOP_AI_EXT))
-						pci9118_exttrg_del(dev, EXTTRG_AI);	/*  deactivate EXT trigger */
-					start_pacer(dev, devpriv->ai_do, devpriv->ai_divisor1, devpriv->ai_divisor2);	/*  start pacer */
+							STOP_AI_EXT))
+							pci9118_exttrg_del
+							(dev, EXTTRG_AI);
+						/* deactivate EXT trigger */
+					start_pacer(dev, devpriv->ai_do,
+						devpriv->ai_divisor1,
+						devpriv->ai_divisor2);
+						/* start pacer */
 					outl(devpriv->AdControlReg,
-					     dev->iobase + PCI9118_ADCNTRL);
+						dev->iobase + PCI9118_ADCNTRL);
 				} else {
 					if (devpriv->ai12_startstop &
-					    STOP_AI_EXT) {
+						STOP_AI_EXT) {
 						devpriv->ai12_startstop &=
-						    ~STOP_AI_EXT;
-						pci9118_exttrg_del(dev, EXTTRG_AI);	/*  deactivate EXT trigger */
-						devpriv->ai_neverending = 0;	/* well, on next interrupt from DMA/EOC measure will stop */
+							~STOP_AI_EXT;
+						pci9118_exttrg_del
+							(dev, EXTTRG_AI);
+						/* deactivate EXT trigger */
+						devpriv->ai_neverending = 0;
+						/*
+						 * well, on next interrupt from
+						 * DMA/EOC measure will stop
+						 */
 					}
 				}
 			}
@@ -820,7 +960,11 @@ static int pci9118_ai_cmdtest(struct comedi_device *dev,
 	if (err)
 		return 1;
 
-	/* step 2: make sure trigger sources are unique and mutually compatible */
+	/*
+	 * step 2:
+	 * make sure trigger sources are
+	 * unique and mutually compatible
+	 */
 
 	if (cmd->start_src != TRIG_NOW &&
 	    cmd->start_src != TRIG_INT && cmd->start_src != TRIG_EXT) {
@@ -1025,7 +1169,7 @@ static int pci9118_ai_cmdtest(struct comedi_device *dev,
 	if (cmd->chanlist)
 		if (!check_channel_list(dev, s, cmd->chanlist_len,
 					cmd->chanlist, 0, 0))
-			return 5;	/*  incorrect channels list */
+			return 5;	/* incorrect channels list */
 
 	return 0;
 }
@@ -1042,88 +1186,101 @@ static int Compute_and_setup_dma(struct comedi_device *dev)
 	dmalen1 = devpriv->dmabuf_size[1];
 	DPRINTK("1 dmalen0=%d dmalen1=%d ai_data_len=%d\n", dmalen0, dmalen1,
 		devpriv->ai_data_len);
-	/*  isn't output buff smaller that our DMA buff? */
+	/* isn't output buff smaller that our DMA buff? */
 	if (dmalen0 > (devpriv->ai_data_len)) {
-		dmalen0 = devpriv->ai_data_len & ~3L;	/*  allign to 32bit down */
+		dmalen0 = devpriv->ai_data_len & ~3L;	/*
+							 * align to 32bit down
+							 */
 	}
 	if (dmalen1 > (devpriv->ai_data_len)) {
-		dmalen1 = devpriv->ai_data_len & ~3L;	/*  allign to 32bit down */
+		dmalen1 = devpriv->ai_data_len & ~3L;	/*
+							 * align to 32bit down
+							 */
 	}
 	DPRINTK("2 dmalen0=%d dmalen1=%d \n", dmalen0, dmalen1);
 
-	/*  we want wake up every scan? */
+	/* we want wake up every scan? */
 	if (devpriv->ai_flags & TRIG_WAKE_EOS) {
 		if (dmalen0 < (devpriv->ai_n_realscanlen << 1)) {
-			/*  uff, too short DMA buffer, disable EOS support! */
+			/* uff, too short DMA buffer, disable EOS support! */
 			devpriv->ai_flags &= (~TRIG_WAKE_EOS);
 			printk
-			    ("comedi%d: WAR: DMA0 buf too short, cann't support TRIG_WAKE_EOS (%d<%d)\n",
+			    ("comedi%d: WAR: DMA0 buf too short, can't "
+					"support TRIG_WAKE_EOS (%d<%d)\n",
 			     dev->minor, dmalen0,
 			     devpriv->ai_n_realscanlen << 1);
 		} else {
-			/*  short first DMA buffer to one scan */
+			/* short first DMA buffer to one scan */
 			dmalen0 = devpriv->ai_n_realscanlen << 1;
 			DPRINTK
-			    ("21 dmalen0=%d ai_n_realscanlen=%d useeoshandle=%d\n",
-			     dmalen0, devpriv->ai_n_realscanlen,
-			     devpriv->useeoshandle);
+				("21 dmalen0=%d ai_n_realscanlen=%d "
+							"useeoshandle=%d\n",
+				dmalen0, devpriv->ai_n_realscanlen,
+				devpriv->useeoshandle);
 			if (devpriv->useeoshandle)
 				dmalen0 += 2;
 			if (dmalen0 < 4) {
 				printk
-				    ("comedi%d: ERR: DMA0 buf len bug? (%d<4)\n",
-				     dev->minor, dmalen0);
+					("comedi%d: ERR: DMA0 buf len bug? "
+								"(%d<4)\n",
+					dev->minor, dmalen0);
 				dmalen0 = 4;
 			}
 		}
 	}
 	if (devpriv->ai_flags & TRIG_WAKE_EOS) {
 		if (dmalen1 < (devpriv->ai_n_realscanlen << 1)) {
-			/*  uff, too short DMA buffer, disable EOS support! */
+			/* uff, too short DMA buffer, disable EOS support! */
 			devpriv->ai_flags &= (~TRIG_WAKE_EOS);
 			printk
-			    ("comedi%d: WAR: DMA1 buf too short, cann't support TRIG_WAKE_EOS (%d<%d)\n",
+			    ("comedi%d: WAR: DMA1 buf too short, "
+					"can't support TRIG_WAKE_EOS (%d<%d)\n",
 			     dev->minor, dmalen1,
 			     devpriv->ai_n_realscanlen << 1);
 		} else {
-			/*  short second DMA buffer to one scan */
+			/* short second DMA buffer to one scan */
 			dmalen1 = devpriv->ai_n_realscanlen << 1;
 			DPRINTK
-			    ("22 dmalen1=%d ai_n_realscanlen=%d useeoshandle=%d\n",
+			    ("22 dmalen1=%d ai_n_realscanlen=%d "
+							"useeoshandle=%d\n",
 			     dmalen1, devpriv->ai_n_realscanlen,
 			     devpriv->useeoshandle);
 			if (devpriv->useeoshandle)
 				dmalen1 -= 2;
 			if (dmalen1 < 4) {
 				printk
-				    ("comedi%d: ERR: DMA1 buf len bug? (%d<4)\n",
-				     dev->minor, dmalen1);
+					("comedi%d: ERR: DMA1 buf len bug? "
+								"(%d<4)\n",
+					dev->minor, dmalen1);
 				dmalen1 = 4;
 			}
 		}
 	}
 
 	DPRINTK("3 dmalen0=%d dmalen1=%d \n", dmalen0, dmalen1);
-	/*  transfer without TRIG_WAKE_EOS */
+	/* transfer without TRIG_WAKE_EOS */
 	if (!(devpriv->ai_flags & TRIG_WAKE_EOS)) {
-		/*  if it's possible then allign DMA buffers to length of scan */
+		/* if it's possible then allign DMA buffers to length of scan */
 		i = dmalen0;
 		dmalen0 =
 		    (dmalen0 / (devpriv->ai_n_realscanlen << 1)) *
 		    (devpriv->ai_n_realscanlen << 1);
 		dmalen0 &= ~3L;
 		if (!dmalen0)
-			dmalen0 = i;	/*  uff. very long scan? */
+			dmalen0 = i;	/* uff. very long scan? */
 		i = dmalen1;
 		dmalen1 =
 		    (dmalen1 / (devpriv->ai_n_realscanlen << 1)) *
 		    (devpriv->ai_n_realscanlen << 1);
 		dmalen1 &= ~3L;
 		if (!dmalen1)
-			dmalen1 = i;	/*  uff. very long scan? */
-		/*  if measure isn't neverending then test, if it whole fits into one or two DMA buffers */
+			dmalen1 = i;	/* uff. very long scan? */
+		/*
+		 * if measure isn't neverending then test, if it fits whole
+		 * into one or two DMA buffers
+		 */
 		if (!devpriv->ai_neverending) {
-			/*  fits whole measure into one DMA buffer? */
+			/* fits whole measure into one DMA buffer? */
 			if (dmalen0 >
 			    ((devpriv->ai_n_realscanlen << 1) *
 			     devpriv->ai_scans)) {
@@ -1137,7 +1294,10 @@ static int Compute_and_setup_dma(struct comedi_device *dev)
 				DPRINTK("3.1 dmalen0=%d dmalen1=%d \n", dmalen0,
 					dmalen1);
 				dmalen0 &= ~3L;
-			} else {	/*  fits whole measure into two DMA buffer? */
+			} else {	/*
+					 * fits whole measure into
+					 * two DMA buffer?
+					 */
 				if (dmalen1 >
 				    ((devpriv->ai_n_realscanlen << 1) *
 				     devpriv->ai_scans - dmalen0))
@@ -1153,7 +1313,7 @@ static int Compute_and_setup_dma(struct comedi_device *dev)
 
 	DPRINTK("4 dmalen0=%d dmalen1=%d \n", dmalen0, dmalen1);
 
-	/*  these DMA buffer size we'll be used */
+	/* these DMA buffer size will be used */
 	devpriv->dma_actbuf = 0;
 	devpriv->dmabuf_use_size[0] = dmalen0;
 	devpriv->dmabuf_use_size[1] = dmalen1;
@@ -1175,10 +1335,11 @@ static int Compute_and_setup_dma(struct comedi_device *dev)
 	}
 #endif
 
-	outl(inl(devpriv->iobase_a + AMCC_OP_REG_MCSR) & (~EN_A2P_TRANSFERS), devpriv->iobase_a + AMCC_OP_REG_MCSR);	/*  stop DMA */
+	outl(inl(devpriv->iobase_a + AMCC_OP_REG_MCSR) & (~EN_A2P_TRANSFERS),
+			devpriv->iobase_a + AMCC_OP_REG_MCSR);	/* stop DMA */
 	outl(devpriv->dmabuf_hw[0], devpriv->iobase_a + AMCC_OP_REG_MWAR);
 	outl(devpriv->dmabuf_use_size[0], devpriv->iobase_a + AMCC_OP_REG_MWTC);
-	/*  init DMA transfer */
+	/* init DMA transfer */
 	outl(0x00000000 | AINT_WRITE_COMPL,
 	     devpriv->iobase_a + AMCC_OP_REG_INTCSR);
 /* outl(0x02000000|AINT_WRITE_COMPL, devpriv->iobase_a+AMCC_OP_REG_INTCSR); */
@@ -1186,7 +1347,9 @@ static int Compute_and_setup_dma(struct comedi_device *dev)
 	outl(inl(devpriv->iobase_a +
 		 AMCC_OP_REG_MCSR) | RESET_A2P_FLAGS | A2P_HI_PRIORITY |
 	     EN_A2P_TRANSFERS, devpriv->iobase_a + AMCC_OP_REG_MCSR);
-	outl(inl(devpriv->iobase_a + AMCC_OP_REG_INTCSR) | EN_A2P_TRANSFERS, devpriv->iobase_a + AMCC_OP_REG_INTCSR);	/*  allow bus mastering */
+	outl(inl(devpriv->iobase_a + AMCC_OP_REG_INTCSR) | EN_A2P_TRANSFERS,
+			devpriv->iobase_a + AMCC_OP_REG_INTCSR);
+						/* allow bus mastering */
 
 	DPRINTK("adl_pci9118 EDBG: END: Compute_and_setup_dma()\n");
 	return 0;
@@ -1219,17 +1382,21 @@ static int pci9118_ai_docmd_sampl(struct comedi_device *dev,
 		return -EIO;
 	};
 
-	devpriv->int_ai_func = interrupt_pci9118_ai_onesample;	/* transfer function */
+	devpriv->int_ai_func = interrupt_pci9118_ai_onesample;
+						/* transfer function */
 
 	if (devpriv->ai12_startstop)
-		pci9118_exttrg_add(dev, EXTTRG_AI);	/*  activate EXT trigger */
+		pci9118_exttrg_add(dev, EXTTRG_AI);
+						/* activate EXT trigger */
 
 	if ((devpriv->ai_do == 1) || (devpriv->ai_do == 2))
 		devpriv->IntControlReg |= Int_Timer;
 
 	devpriv->AdControlReg |= AdControl_Int;
 
-	outl(inl(devpriv->iobase_a + AMCC_OP_REG_INTCSR) | 0x1f00, devpriv->iobase_a + AMCC_OP_REG_INTCSR);	/*  allow INT in AMCC */
+	outl(inl(devpriv->iobase_a + AMCC_OP_REG_INTCSR) | 0x1f00,
+			devpriv->iobase_a + AMCC_OP_REG_INTCSR);
+							/* allow INT in AMCC */
 
 	if (!(devpriv->ai12_startstop & (START_AI_EXT | START_AI_INT))) {
 		outl(devpriv->IntControlReg, dev->iobase + PCI9118_INTCTRL);
@@ -1295,10 +1462,12 @@ static int pci9118_ai_docmd_dma(struct comedi_device *dev,
 	};
 
 	if (devpriv->ai12_startstop) {
-		pci9118_exttrg_add(dev, EXTTRG_AI);	/*  activate EXT trigger */
+		pci9118_exttrg_add(dev, EXTTRG_AI);
+						/* activate EXT trigger */
 	}
 
-	devpriv->int_ai_func = interrupt_pci9118_ai_dma;	/* transfer function */
+	devpriv->int_ai_func = interrupt_pci9118_ai_dma;
+						/* transfer function */
 
 	outl(0x02000000 | AINT_WRITE_COMPL,
 	     devpriv->iobase_a + AMCC_OP_REG_INTCSR);
@@ -1341,7 +1510,7 @@ static int pci9118_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	devpriv->ai_add_back = 0;
 	devpriv->ai_maskerr = 0x10e;
 
-	/*  prepare for start/stop conditions */
+	/* prepare for start/stop conditions */
 	if (cmd->start_src == TRIG_EXT)
 		devpriv->ai12_startstop |= START_AI_EXT;
 	if (cmd->stop_src == TRIG_EXT) {
@@ -1368,10 +1537,10 @@ static int pci9118_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		devpriv->ai_scans = 0;
 	}
 
-	/*  use sample&hold signal? */
+	/* use sample&hold signal? */
 	if (cmd->convert_src == TRIG_NOW) {
 		devpriv->usessh = 1;
-	} /*  yes */
+	} /* yes */
 	else {
 		devpriv->usessh = 0;
 	}			/*  no */
@@ -1380,7 +1549,10 @@ static int pci9118_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		devpriv->ai_neverending, devpriv->ai_scans, devpriv->usessh,
 		devpriv->ai12_startstop);
 
-	/*  use additional sample at end of every scan to satisty DMA 32 bit transfer? */
+	/*
+	 * use additional sample at end of every scan
+	 * to satisty DMA 32 bit transfer?
+	 */
 	devpriv->ai_add_front = 0;
 	devpriv->ai_add_back = 0;
 	devpriv->useeoshandle = 0;
@@ -1392,27 +1564,44 @@ static int pci9118_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 				devpriv->ai_add_back = 1;
 			}
 			if (cmd->convert_src == TRIG_TIMER) {
-				devpriv->usedma = 0;	/*  use INT transfer if scanlist have only one channel */
+				devpriv->usedma = 0;
+					/*
+					 * use INT transfer if scanlist
+					 * have only one channel
+					 */
 			}
 		}
 		if ((cmd->flags & TRIG_WAKE_EOS) &&
 		    (devpriv->ai_n_scanlen & 1) &&
 		    (devpriv->ai_n_scanlen > 1)) {
 			if (cmd->scan_begin_src == TRIG_FOLLOW) {
-				/* vpriv->useeoshandle=1; // change DMA transfer block to fit EOS on every second call */
-				devpriv->usedma = 0;	/*  XXX maybe can be corrected to use 16 bit DMA */
-			} else {	/*  well, we must insert one sample to end of EOS to meet 32 bit transfer */
+				/*
+				 * vpriv->useeoshandle=1; // change DMA transfer
+				 * block to fit EOS on every second call
+				 */
+				devpriv->usedma = 0;
+				/*
+				 * XXX maybe can be corrected to use 16 bit DMA
+				 */
+			} else {	/*
+					 * well, we must insert one sample
+					 * to end of EOS to meet 32 bit transfer
+					 */
 				devpriv->ai_add_back = 1;
 			}
 		}
-	} else {		/*  interrupt transfer don't need any correction */
+	} else {	/* interrupt transfer don't need any correction */
 		devpriv->usedma = 0;
 	}
 
-	/*  we need software S&H signal? It add  two samples before every scan as minimum */
+	/*
+	 * we need software S&H signal?
+	 * It adds two samples before every scan as minimum
+	 */
 	if (devpriv->usessh && devpriv->softsshdelay) {
 		devpriv->ai_add_front = 2;
-		if ((devpriv->usedma == 1) && (devpriv->ai_add_back == 1)) {	/*  move it to front */
+		if ((devpriv->usedma == 1) && (devpriv->ai_add_back == 1)) {
+							/* move it to front */
 			devpriv->ai_add_front++;
 			devpriv->ai_add_back = 0;
 		}
@@ -1421,17 +1610,22 @@ static int pci9118_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		addchans = devpriv->softsshdelay / cmd->convert_arg;
 		if (devpriv->softsshdelay % cmd->convert_arg)
 			addchans++;
-		if (addchans > (devpriv->ai_add_front - 1)) {	/*  uff, still short :-( */
+		if (addchans > (devpriv->ai_add_front - 1)) {
+							/* uff, still short */
 			devpriv->ai_add_front = addchans + 1;
 			if (devpriv->usedma == 1)
 				if ((devpriv->ai_add_front +
 				     devpriv->ai_n_chan +
 				     devpriv->ai_add_back) & 1)
-					devpriv->ai_add_front++;	/*  round up to 32 bit */
+					devpriv->ai_add_front++;
+							/* round up to 32 bit */
 		}
 	}
-	/*  well, we now know what must be all added */
-	devpriv->ai_n_realscanlen =	/*  what we must take from card in real to have ai_n_scanlen on output? */
+	/* well, we now know what must be all added */
+	devpriv->ai_n_realscanlen =	/*
+					 * what we must take from card in real
+					 * to have ai_n_scanlen on output?
+					 */
 	    (devpriv->ai_add_front + devpriv->ai_n_chan +
 	     devpriv->ai_add_back) * (devpriv->ai_n_scanlen /
 				      devpriv->ai_n_chan);
@@ -1442,7 +1636,7 @@ static int pci9118_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		devpriv->ai_n_chan, devpriv->ai_add_back,
 		devpriv->ai_n_scanlen);
 
-	/*  check and setup channel list */
+	/* check and setup channel list */
 	if (!check_channel_list(dev, s, devpriv->ai_n_chan,
 				devpriv->ai_chanlist, devpriv->ai_add_front,
 				devpriv->ai_add_back))
@@ -1453,9 +1647,16 @@ static int pci9118_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 				devpriv->useeoshandle))
 		return -EINVAL;
 
-	/*  compute timers settings */
-	/*  simplest way, fr=4Mhz/(tim1*tim2), channel manipulation without timers effect */
-	if (((cmd->scan_begin_src == TRIG_FOLLOW) || (cmd->scan_begin_src == TRIG_EXT) || (cmd->scan_begin_src == TRIG_INT)) && (cmd->convert_src == TRIG_TIMER)) {	/*  both timer is used for one time */
+	/* compute timers settings */
+	/*
+	 * simplest way, fr=4Mhz/(tim1*tim2),
+	 * channel manipulation without timers effect
+	 */
+	if (((cmd->scan_begin_src == TRIG_FOLLOW) ||
+		(cmd->scan_begin_src == TRIG_EXT) ||
+		(cmd->scan_begin_src == TRIG_INT)) &&
+		(cmd->convert_src == TRIG_TIMER)) {
+					/* both timer is used for one time */
 		if (cmd->scan_begin_src == TRIG_EXT) {
 			devpriv->ai_do = 4;
 		} else {
@@ -1471,10 +1672,14 @@ static int pci9118_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		devpriv->ai_timer2 = cmd->convert_arg;
 	}
 
-	if ((cmd->scan_begin_src == TRIG_TIMER) && ((cmd->convert_src == TRIG_TIMER) || (cmd->convert_src == TRIG_NOW))) {	/*  double timed action */
+	if ((cmd->scan_begin_src == TRIG_TIMER) &&
+		((cmd->convert_src == TRIG_TIMER) ||
+		(cmd->convert_src == TRIG_NOW))) {
+						/* double timed action */
 		if (!devpriv->usedma) {
 			comedi_error(dev,
-				     "cmd->scan_begin_src=TRIG_TIMER works only with bus mastering!");
+				     "cmd->scan_begin_src=TRIG_TIMER works "
+						"only with bus mastering!");
 			return -EIO;
 		}
 
@@ -1495,15 +1700,27 @@ static int pci9118_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		devpriv->ai_do = 3;
 	}
 
-	start_pacer(dev, -1, 0, 0);	/*  stop pacer */
+	start_pacer(dev, -1, 0, 0);	/* stop pacer */
 
-	devpriv->AdControlReg = 0;	/*  bipolar, S.E., use 8254, stop 8354, internal trigger, soft trigger, disable DMA */
+	devpriv->AdControlReg = 0;	/*
+					 * bipolar, S.E., use 8254, stop 8354,
+					 * internal trigger, soft trigger,
+					 * disable DMA
+					 */
 	outl(devpriv->AdControlReg, dev->iobase + PCI9118_ADCNTRL);
-	devpriv->AdFunctionReg = AdFunction_PDTrg | AdFunction_PETrg;	/*  positive triggers, no S&H, no burst, burst stop, no post trigger, no about trigger, trigger stop */
+	devpriv->AdFunctionReg = AdFunction_PDTrg | AdFunction_PETrg;
+					/*
+					 * positive triggers, no S&H, no burst,
+					 * burst stop, no post trigger,
+					 * no about trigger, trigger stop
+					 */
 	outl(devpriv->AdFunctionReg, dev->iobase + PCI9118_ADFUNC);
 	udelay(1);
-	outl(0, dev->iobase + PCI9118_DELFIFO);	/*  flush FIFO */
-	inl(dev->iobase + PCI9118_ADSTAT);	/*  flush A/D and INT status register */
+	outl(0, dev->iobase + PCI9118_DELFIFO);	/* flush FIFO */
+	inl(dev->iobase + PCI9118_ADSTAT);	/*
+						 * flush A/D and INT
+						 * status register
+						 */
 	inl(dev->iobase + PCI9118_INTSRC);
 
 	devpriv->ai_act_scan = 0;
@@ -1536,33 +1753,37 @@ static int check_channel_list(struct comedi_device *dev,
 	}
 	if ((frontadd + n_chan + backadd) > s->len_chanlist) {
 		printk
-		    ("comedi%d: range/channel list is too long for actual configuration (%d>%d)!",
+		    ("comedi%d: range/channel list is too long for "
+						"actual configuration (%d>%d)!",
 		     dev->minor, n_chan, s->len_chanlist - frontadd - backadd);
 		return 0;
 	}
 
 	if (CR_AREF(chanlist[0]) == AREF_DIFF)
-		differencial = 1;	/*  all input must be diff */
+		differencial = 1;	/* all input must be diff */
 	if (CR_RANGE(chanlist[0]) < PCI9118_BIPOLAR_RANGES)
-		bipolar = 1;	/*  all input must be bipolar */
+		bipolar = 1;	/* all input must be bipolar */
 	if (n_chan > 1)
-		for (i = 1; i < n_chan; i++) {	/*  check S.E/diff */
+		for (i = 1; i < n_chan; i++) {	/* check S.E/diff */
 			if ((CR_AREF(chanlist[i]) == AREF_DIFF) !=
 			    (differencial)) {
 				comedi_error(dev,
-					     "Differencial and single ended inputs cann't be mixtured!");
+					     "Differencial and single ended "
+						"inputs can't be mixtured!");
 				return 0;
 			}
 			if ((CR_RANGE(chanlist[i]) < PCI9118_BIPOLAR_RANGES) !=
 			    (bipolar)) {
 				comedi_error(dev,
-					     "Bipolar and unipolar ranges cann't be mixtured!");
+					     "Bipolar and unipolar ranges "
+							"can't be mixtured!");
 				return 0;
 			}
 			if ((!devpriv->usemux) & (differencial) &
 			    (CR_CHAN(chanlist[i]) >= this_board->n_aichand)) {
 				comedi_error(dev,
-					     "If AREF_DIFF is used then is available only first 8 channels!");
+					     "If AREF_DIFF is used then is "
+					"available only first 8 channels!");
 				return 0;
 			}
 		}
@@ -1582,7 +1803,8 @@ static int setup_channel_list(struct comedi_device *dev,
 	unsigned int scanquad, gain, ssh = 0x00;
 
 	DPRINTK
-	    ("adl_pci9118 EDBG: BGN: setup_channel_list(%d,.,%d,.,%d,%d,%d,%d)\n",
+	    ("adl_pci9118 EDBG: BGN: setup_channel_list"
+						"(%d,.,%d,.,%d,%d,%d,%d)\n",
 	     dev->minor, n_chan, rot, frontadd, backadd, usedma);
 
 	if (usedma == 1) {
@@ -1591,27 +1813,33 @@ static int setup_channel_list(struct comedi_device *dev,
 	}
 
 	if (CR_AREF(chanlist[0]) == AREF_DIFF)
-		differencial = 1;	/*  all input must be diff */
+		differencial = 1;	/* all input must be diff */
 	if (CR_RANGE(chanlist[0]) < PCI9118_BIPOLAR_RANGES)
-		bipolar = 1;	/*  all input must be bipolar */
+		bipolar = 1;	/* all input must be bipolar */
 
-	/*  All is ok, so we can setup channel/range list */
+	/* All is ok, so we can setup channel/range list */
 
 	if (!bipolar) {
-		devpriv->AdControlReg |= AdControl_UniP;	/*  set unibipolar */
+		devpriv->AdControlReg |= AdControl_UniP;
+							/* set unibipolar */
 	} else {
-		devpriv->AdControlReg &= ((~AdControl_UniP) & 0xff);	/*  enable bipolar */
+		devpriv->AdControlReg &= ((~AdControl_UniP) & 0xff);
+							/* enable bipolar */
 	}
 
 	if (differencial) {
-		devpriv->AdControlReg |= AdControl_Diff;	/*  enable diff inputs */
+		devpriv->AdControlReg |= AdControl_Diff;
+							/* enable diff inputs */
 	} else {
-		devpriv->AdControlReg &= ((~AdControl_Diff) & 0xff);	/*  set single ended inputs */
+		devpriv->AdControlReg &= ((~AdControl_Diff) & 0xff);
+						/* set single ended inputs */
 	}
 
-	outl(devpriv->AdControlReg, dev->iobase + PCI9118_ADCNTRL);	/*  setup mode */
+	outl(devpriv->AdControlReg, dev->iobase + PCI9118_ADCNTRL);
+								/* setup mode */
 
-	outl(2, dev->iobase + PCI9118_SCANMOD);	/*  gods know why this sequence! */
+	outl(2, dev->iobase + PCI9118_SCANMOD);
+					/* gods know why this sequence! */
 	outl(0, dev->iobase + PCI9118_SCANMOD);
 	outl(1, dev->iobase + PCI9118_SCANMOD);
 
@@ -1621,12 +1849,15 @@ static int setup_channel_list(struct comedi_device *dev,
 		devpriv->chanlist[i] = 0x55aa;
 #endif
 
-	if (frontadd) {		/*  insert channels for S&H */
+	if (frontadd) {		/* insert channels for S&H */
 		ssh = devpriv->softsshsample;
 		DPRINTK("FA: %04x: ", ssh);
-		for (i = 0; i < frontadd; i++) {	/*  store range list to card */
-			scanquad = CR_CHAN(chanlist[0]);	/*  get channel number; */
-			gain = CR_RANGE(chanlist[0]);	/*  get gain number */
+		for (i = 0; i < frontadd; i++) {
+						/* store range list to card */
+			scanquad = CR_CHAN(chanlist[0]);
+						/* get channel number; */
+			gain = CR_RANGE(chanlist[0]);
+						/* get gain number */
 			scanquad |= ((gain & 0x03) << 8);
 			outl(scanquad | ssh, dev->iobase + PCI9118_GAIN);
 			DPRINTK("%02x ", scanquad | ssh);
@@ -1636,23 +1867,24 @@ static int setup_channel_list(struct comedi_device *dev,
 	}
 
 	DPRINTK("SL: ", ssh);
-	for (i = 0; i < n_chan; i++) {	/*  store range list to card */
-		scanquad = CR_CHAN(chanlist[i]);	/*  get channel number; */
+	for (i = 0; i < n_chan; i++) {	/* store range list to card */
+		scanquad = CR_CHAN(chanlist[i]);	/* get channel number */
 #ifdef PCI9118_PARANOIDCHECK
 		devpriv->chanlist[i ^ usedma] = (scanquad & 0xf) << rot;
 #endif
-		gain = CR_RANGE(chanlist[i]);	/*  get gain number */
+		gain = CR_RANGE(chanlist[i]);		/* get gain number */
 		scanquad |= ((gain & 0x03) << 8);
 		outl(scanquad | ssh, dev->iobase + PCI9118_GAIN);
 		DPRINTK("%02x ", scanquad | ssh);
 	}
 	DPRINTK("\n ");
 
-	if (backadd) {		/*  insert channels for fit onto 32bit DMA */
+	if (backadd) {		/* insert channels for fit onto 32bit DMA */
 		DPRINTK("BA: %04x: ", ssh);
-		for (i = 0; i < backadd; i++) {	/*  store range list to card */
-			scanquad = CR_CHAN(chanlist[0]);	/*  get channel number; */
-			gain = CR_RANGE(chanlist[0]);	/*  get gain number */
+		for (i = 0; i < backadd; i++) {	/* store range list to card */
+			scanquad = CR_CHAN(chanlist[0]);
+							/* get channel number */
+			gain = CR_RANGE(chanlist[0]);	/* get gain number */
 			scanquad |= ((gain & 0x03) << 8);
 			outl(scanquad | ssh, dev->iobase + PCI9118_GAIN);
 			DPRINTK("%02x ", scanquad | ssh);
@@ -1660,13 +1892,16 @@ static int setup_channel_list(struct comedi_device *dev,
 		DPRINTK("\n ");
 	}
 #ifdef PCI9118_PARANOIDCHECK
-	devpriv->chanlist[n_chan ^ usedma] = devpriv->chanlist[0 ^ usedma];	/*  for 32bit oerations */
+	devpriv->chanlist[n_chan ^ usedma] = devpriv->chanlist[0 ^ usedma];
+						/* for 32bit operations */
 	if (useeos) {
-		for (i = 1; i < n_chan; i++) {	/*  store range list to card */
+		for (i = 1; i < n_chan; i++) {	/* store range list to card */
 			devpriv->chanlist[(n_chan + i) ^ usedma] =
 			    (CR_CHAN(chanlist[i]) & 0xf) << rot;
 		}
-		devpriv->chanlist[(2 * n_chan) ^ usedma] = devpriv->chanlist[0 ^ usedma];	/*  for 32bit oerations */
+		devpriv->chanlist[(2 * n_chan) ^ usedma] =
+						devpriv->chanlist[0 ^ usedma];
+						/* for 32bit operations */
 		useeos = 2;
 	} else {
 		useeos = 1;
@@ -1679,11 +1914,11 @@ static int setup_channel_list(struct comedi_device *dev,
 	DPRINTK("\n ");
 #endif
 #endif
-	outl(0, dev->iobase + PCI9118_SCANMOD);	/*  close scan queue */
-/* udelay(100);                               important delay, or first sample will be cripled */
+	outl(0, dev->iobase + PCI9118_SCANMOD);	/* close scan queue */
+	/* udelay(100); important delay, or first sample will be crippled */
 
 	DPRINTK("adl_pci9118 EDBG: END: setup_channel_list()\n");
-	return 1;		/*  we can serve this with scan logic */
+	return 1;		/* we can serve this with scan logic */
 }
 
 /*
@@ -1698,7 +1933,8 @@ static void pci9118_calc_divisors(char mode, struct comedi_device *dev,
 				  char usessh, unsigned int chnsshfront)
 {
 	DPRINTK
-	    ("adl_pci9118 EDBG: BGN: pci9118_calc_divisors(%d,%d,.,%u,%u,%u,%d,.,.,,%u,%u)\n",
+	    ("adl_pci9118 EDBG: BGN: pci9118_calc_divisors"
+					"(%d,%d,.,%u,%u,%u,%d,.,.,,%u,%u)\n",
 	     mode, dev->minor, *tim1, *tim2, flags, chans, usessh, chnsshfront);
 	switch (mode) {
 	case 1:
@@ -1715,17 +1951,18 @@ static void pci9118_calc_divisors(char mode, struct comedi_device *dev,
 			*tim2 = this_board->ai_ns_min;
 		DPRINTK("1 div1=%u div2=%u timer1=%u timer2=%u\n", *div1, *div2,
 			*tim1, *tim2);
-		*div1 = *tim2 / devpriv->i8254_osc_base;	/*  convert timer (burst) */
+		*div1 = *tim2 / devpriv->i8254_osc_base;
+						/* convert timer (burst) */
 		DPRINTK("2 div1=%u div2=%u timer1=%u timer2=%u\n", *div1, *div2,
 			*tim1, *tim2);
 		if (*div1 < this_board->ai_pacer_min)
 			*div1 = this_board->ai_pacer_min;
 		DPRINTK("3 div1=%u div2=%u timer1=%u timer2=%u\n", *div1, *div2,
 			*tim1, *tim2);
-		*div2 = *tim1 / devpriv->i8254_osc_base;	/*  scan timer */
+		*div2 = *tim1 / devpriv->i8254_osc_base;	/* scan timer */
 		DPRINTK("4 div1=%u div2=%u timer1=%u timer2=%u\n", *div1, *div2,
 			*tim1, *tim2);
-		*div2 = *div2 / *div1;	/*  major timer is c1*c2 */
+		*div2 = *div2 / *div1;		/* major timer is c1*c2 */
 		DPRINTK("5 div1=%u div2=%u timer1=%u timer2=%u\n", *div1, *div2,
 			*tim1, *tim2);
 		if (*div2 < chans)
@@ -1733,9 +1970,10 @@ static void pci9118_calc_divisors(char mode, struct comedi_device *dev,
 		DPRINTK("6 div1=%u div2=%u timer1=%u timer2=%u\n", *div1, *div2,
 			*tim1, *tim2);
 
-		*tim2 = *div1 * devpriv->i8254_osc_base;	/*  real convert timer */
+		*tim2 = *div1 * devpriv->i8254_osc_base;
+							/* real convert timer */
 
-		if (usessh & (chnsshfront == 0))	/*  use BSSH signal */
+		if (usessh & (chnsshfront == 0))	/* use BSSH signal */
 			if (*div2 < (chans + 2))
 				*div2 = chans + 2;
 
@@ -1775,11 +2013,13 @@ static void start_pacer(struct comedi_device *dev, int mode,
 static int pci9118_exttrg_add(struct comedi_device *dev, unsigned char source)
 {
 	if (source > 3)
-		return -1;	/*  incorrect source */
+		return -1;				/* incorrect source */
 	devpriv->exttrg_users |= (1 << source);
 	devpriv->IntControlReg |= Int_DTrg;
 	outl(devpriv->IntControlReg, dev->iobase + PCI9118_INTCTRL);
-	outl(inl(devpriv->iobase_a + AMCC_OP_REG_INTCSR) | 0x1f00, devpriv->iobase_a + AMCC_OP_REG_INTCSR);	/*  allow INT in AMCC */
+	outl(inl(devpriv->iobase_a + AMCC_OP_REG_INTCSR) | 0x1f00,
+					devpriv->iobase_a + AMCC_OP_REG_INTCSR);
+							/* allow INT in AMCC */
 	return 0;
 }
 
@@ -1789,12 +2029,15 @@ static int pci9118_exttrg_add(struct comedi_device *dev, unsigned char source)
 static int pci9118_exttrg_del(struct comedi_device *dev, unsigned char source)
 {
 	if (source > 3)
-		return -1;	/*  incorrect source */
+		return -1;			/* incorrect source */
 	devpriv->exttrg_users &= ~(1 << source);
-	if (!devpriv->exttrg_users) {	/*  shutdown ext trg intterrupts */
+	if (!devpriv->exttrg_users) {	/* shutdown ext trg intterrupts */
 		devpriv->IntControlReg &= ~Int_DTrg;
-		if (!devpriv->IntControlReg)	/*  all IRQ disabled */
-			outl(inl(devpriv->iobase_a + AMCC_OP_REG_INTCSR) & (~0x00001f00), devpriv->iobase_a + AMCC_OP_REG_INTCSR);	/*  disable int in AMCC */
+		if (!devpriv->IntControlReg)	/* all IRQ disabled */
+			outl(inl(devpriv->iobase_a + AMCC_OP_REG_INTCSR) &
+					(~0x00001f00),
+					devpriv->iobase_a + AMCC_OP_REG_INTCSR);
+						/* disable int in AMCC */
 		outl(devpriv->IntControlReg, dev->iobase + PCI9118_INTCTRL);
 	}
 	return 0;
@@ -1807,17 +2050,29 @@ static int pci9118_ai_cancel(struct comedi_device *dev,
 			     struct comedi_subdevice *s)
 {
 	if (devpriv->usedma)
-		outl(inl(devpriv->iobase_a + AMCC_OP_REG_MCSR) & (~EN_A2P_TRANSFERS), devpriv->iobase_a + AMCC_OP_REG_MCSR);	/*  stop DMA */
+		outl(inl(devpriv->iobase_a + AMCC_OP_REG_MCSR) &
+			(~EN_A2P_TRANSFERS),
+			devpriv->iobase_a + AMCC_OP_REG_MCSR);	/* stop DMA */
 	pci9118_exttrg_del(dev, EXTTRG_AI);
-	start_pacer(dev, 0, 0, 0);	/*  stop 8254 counters */
+	start_pacer(dev, 0, 0, 0);	/* stop 8254 counters */
 	devpriv->AdFunctionReg = AdFunction_PDTrg | AdFunction_PETrg;
-	outl(devpriv->AdFunctionReg, dev->iobase + PCI9118_ADFUNC);	/*  positive triggers, no S&H, no burst, burst stop, no post trigger, no about trigger, trigger stop */
+	outl(devpriv->AdFunctionReg, dev->iobase + PCI9118_ADFUNC);
+					/*
+					 * positive triggers, no S&H, no burst,
+					 * burst stop, no post trigger,
+					 * no about trigger, trigger stop
+					 */
 	devpriv->AdControlReg = 0x00;
-	outl(devpriv->AdControlReg, dev->iobase + PCI9118_ADCNTRL);	/*  bipolar, S.E., use 8254, stop 8354, internal trigger, soft trigger, disable INT and DMA */
+	outl(devpriv->AdControlReg, dev->iobase + PCI9118_ADCNTRL);
+					/*
+					 * bipolar, S.E., use 8254, stop 8354,
+					 * internal trigger, soft trigger,
+					 * disable INT and DMA
+					 */
 	outl(0, dev->iobase + PCI9118_BURST);
 	outl(1, dev->iobase + PCI9118_SCANMOD);
-	outl(2, dev->iobase + PCI9118_SCANMOD);	/*  reset scan queue */
-	outl(0, dev->iobase + PCI9118_DELFIFO);	/*  flush FIFO */
+	outl(2, dev->iobase + PCI9118_SCANMOD);	/* reset scan queue */
+	outl(0, dev->iobase + PCI9118_DELFIFO);	/* flush FIFO */
 
 	devpriv->ai_do = 0;
 	devpriv->usedma = 0;
@@ -1831,7 +2086,9 @@ static int pci9118_ai_cancel(struct comedi_device *dev,
 	devpriv->dma_actbuf = 0;
 
 	if (!devpriv->IntControlReg)
-		outl(inl(devpriv->iobase_a + AMCC_OP_REG_INTCSR) | 0x1f00, devpriv->iobase_a + AMCC_OP_REG_INTCSR);	/*  allow INT in AMCC */
+		outl(inl(devpriv->iobase_a + AMCC_OP_REG_INTCSR) | 0x1f00,
+					devpriv->iobase_a + AMCC_OP_REG_INTCSR);
+							/* allow INT in AMCC */
 
 	return 0;
 }
@@ -1844,31 +2101,52 @@ static int pci9118_reset(struct comedi_device *dev)
 	devpriv->IntControlReg = 0;
 	devpriv->exttrg_users = 0;
 	inl(dev->iobase + PCI9118_INTCTRL);
-	outl(devpriv->IntControlReg, dev->iobase + PCI9118_INTCTRL);	/*  disable interrupts source */
+	outl(devpriv->IntControlReg, dev->iobase + PCI9118_INTCTRL);
+						/* disable interrupts source */
 	outl(0x30, dev->iobase + PCI9118_CNTCTRL);
 /* outl(0xb4, dev->iobase + PCI9118_CNTCTRL); */
-	start_pacer(dev, 0, 0, 0);	/*  stop 8254 counters */
+	start_pacer(dev, 0, 0, 0);		/* stop 8254 counters */
 	devpriv->AdControlReg = 0;
-	outl(devpriv->AdControlReg, dev->iobase + PCI9118_ADCNTRL);	/*  bipolar, S.E., use 8254, stop 8354, internal trigger, soft trigger, disable INT and DMA */
+	outl(devpriv->AdControlReg, dev->iobase + PCI9118_ADCNTRL);
+						/*
+						 * bipolar, S.E., use 8254,
+						 * stop 8354, internal trigger,
+						 * soft trigger,
+						 * disable INT and DMA
+						 */
 	outl(0, dev->iobase + PCI9118_BURST);
 	outl(1, dev->iobase + PCI9118_SCANMOD);
-	outl(2, dev->iobase + PCI9118_SCANMOD);	/*  reset scan queue */
+	outl(2, dev->iobase + PCI9118_SCANMOD);	/* reset scan queue */
 	devpriv->AdFunctionReg = AdFunction_PDTrg | AdFunction_PETrg;
-	outl(devpriv->AdFunctionReg, dev->iobase + PCI9118_ADFUNC);	/*  positive triggers, no S&H, no burst, burst stop, no post trigger, no about trigger, trigger stop */
+	outl(devpriv->AdFunctionReg, dev->iobase + PCI9118_ADFUNC);
+						/*
+						 * positive triggers, no S&H,
+						 * no burst, burst stop,
+						 * no post trigger,
+						 * no about trigger,
+						 * trigger stop
+						 */
 
 	devpriv->ao_data[0] = 2047;
 	devpriv->ao_data[1] = 2047;
-	outl(devpriv->ao_data[0], dev->iobase + PCI9118_DA1);	/*  reset A/D outs to 0V */
+	outl(devpriv->ao_data[0], dev->iobase + PCI9118_DA1);
+						/* reset A/D outs to 0V */
 	outl(devpriv->ao_data[1], dev->iobase + PCI9118_DA2);
-	outl(0, dev->iobase + PCI9118_DO);	/*  reset digi outs to L */
+	outl(0, dev->iobase + PCI9118_DO);	/* reset digi outs to L */
 	udelay(10);
 	inl(dev->iobase + PCI9118_AD_DATA);
-	outl(0, dev->iobase + PCI9118_DELFIFO);	/*  flush FIFO */
-	outl(0, dev->iobase + PCI9118_INTSRC);	/*  remove INT requests */
-	inl(dev->iobase + PCI9118_ADSTAT);	/*  flush A/D status register */
-	inl(dev->iobase + PCI9118_INTSRC);	/*  flush INT requests */
+	outl(0, dev->iobase + PCI9118_DELFIFO);	/* flush FIFO */
+	outl(0, dev->iobase + PCI9118_INTSRC);	/* remove INT requests */
+	inl(dev->iobase + PCI9118_ADSTAT);	/* flush A/D status register */
+	inl(dev->iobase + PCI9118_INTSRC);	/* flush INT requests */
 	devpriv->AdControlReg = 0;
-	outl(devpriv->AdControlReg, dev->iobase + PCI9118_ADCNTRL);	/*  bipolar, S.E., use 8254, stop 8354, internal trigger, soft trigger, disable INT and DMA */
+	outl(devpriv->AdControlReg, dev->iobase + PCI9118_ADCNTRL);
+						/*
+						 * bipolar, S.E., use 8254,
+						 * stop 8354, internal trigger,
+						 * soft trigger,
+						 * disable INT and DMA
+						 */
 
 	devpriv->cnt0_users = 0;
 	devpriv->exttrg_users = 0;
@@ -1898,7 +2176,7 @@ static int pci9118_attach(struct comedi_device *dev,
 	opt_bus = it->options[0];
 	opt_slot = it->options[1];
 	if (it->options[3] & 1) {
-		master = 0;	/*  user don't want use bus master */
+		master = 0;	/* user don't want use bus master */
 	} else {
 		master = 1;
 	}
@@ -1967,7 +2245,7 @@ static int pci9118_attach(struct comedi_device *dev,
 	pci9118_reset(dev);
 
 	if (it->options[3] & 2)
-		irq = 0;	/*  user don't want use IRQ */
+		irq = 0;	/* user don't want use IRQ */
 	if (irq > 0) {
 		if (request_irq(irq, interrupt_pci9118, IRQF_SHARED,
 				"ADLink PCI-9118", dev)) {
@@ -1983,7 +2261,7 @@ static int pci9118_attach(struct comedi_device *dev,
 
 	dev->irq = irq;
 
-	if (master) {		/*  alloc DMA buffers */
+	if (master) {		/* alloc DMA buffers */
 		devpriv->dma_doublebuf = 0;
 		for (i = 0; i < 2; i++) {
 			for (pages = 4; pages >= 0; pages--) {
@@ -2023,16 +2301,18 @@ static int pci9118_attach(struct comedi_device *dev,
 	if (it->options[2] > 0) {
 		devpriv->usemux = it->options[2];
 		if (devpriv->usemux > 256)
-			devpriv->usemux = 256;	/*  max 256 channels! */
+			devpriv->usemux = 256;	/* max 256 channels! */
 		if (it->options[4] > 0)
 			if (devpriv->usemux > 128) {
-				devpriv->usemux = 128;	/*  max 128 channels with softare S&H! */
+				devpriv->usemux = 128;
+					/* max 128 channels with softare S&H! */
 			}
 		printk(", ext. mux %d channels", devpriv->usemux);
 	}
 
 	devpriv->softsshdelay = it->options[4];
-	if (devpriv->softsshdelay < 0) {	/*  select sample&hold signal polarity */
+	if (devpriv->softsshdelay < 0) {
+					/* select sample&hold signal polarity */
 		devpriv->softsshdelay = -devpriv->softsshdelay;
 		devpriv->softsshsample = 0x80;
 		devpriv->softsshhold = 0x00;
@@ -2044,7 +2324,8 @@ static int pci9118_attach(struct comedi_device *dev,
 	printk(".\n");
 
 	pci_read_config_word(devpriv->pcidev, PCI_COMMAND, &u16w);
-	pci_write_config_word(devpriv->pcidev, PCI_COMMAND, u16w | 64);	/*  Enable parity check for parity error */
+	pci_write_config_word(devpriv->pcidev, PCI_COMMAND, u16w | 64);
+				/* Enable parity check for parity error */
 
 	ret = alloc_subdevices(dev, 4);
 	if (ret < 0)
@@ -2102,9 +2383,10 @@ static int pci9118_attach(struct comedi_device *dev,
 	s->insn_bits = pci9118_insn_bits_do;
 
 	devpriv->valid = 1;
-	devpriv->i8254_osc_base = 250;	/*  250ns=4MHz */
-	devpriv->ai_maskharderr = 0x10a;	/*  default measure crash condition */
-	if (it->options[5])	/*  disable some requested */
+	devpriv->i8254_osc_base = 250;	/* 250ns=4MHz */
+	devpriv->ai_maskharderr = 0x10a;
+					/* default measure crash condition */
+	if (it->options[5])		/* disable some requested */
 		devpriv->ai_maskharderr &= ~it->options[5];
 
 	switch (this_board->ai_maxdata) {
-- 
1.6.3.3

