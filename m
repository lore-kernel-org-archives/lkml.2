Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914Ab1I3NTs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 09:19:48 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:46656 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757861Ab1I3NTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 09:19:45 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 9/9] Staging: comedi: fix line over 80 character issue in cb_pcidas.c
Date: Fri, 30 Sep 2011 18:48:27 +0530
Message-Id: <1317388707-1980-9-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.6.2
In-Reply-To: <1317388707-1980-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1317388707-1980-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcidas.c file that fixes up a line over 80 character warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcidas.c |  112 +++++++++++++++++++++-------
 1 files changed, 84 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 617d3a6..0a2d6f2 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -116,16 +116,31 @@ analog triggering on 1602 series
 #define   INTE 0x4		/*  interrupt enable */
 #define   DAHFIE 0x8		/*  dac half full interrupt enable */
 #define   EOAIE	0x10		/*  end of acquisition interrupt enable */
-#define   DAHFI	0x20		/*  dac half full read status / write interrupt clear */
-#define   EOAI 0x40		/*  read end of acq. interrupt status / write clear */
+#define   DAHFI 0x20            /*
+				 * dac half full read status / write
+				 * interrupt clear
+				 */
+#define   EOAI 0x40             /*
+				 * read end of acq. interrupt status / write
+				 * clear
+				 */
 #define   INT 0x80		/*  read interrupt status / write clear */
 #define   EOBI 0x200		/*  read end of burst interrupt status */
 #define   ADHFI 0x400		/*  read half-full interrupt status */
-#define   ADNEI 0x800		/*  read fifo not empty interrupt latch status */
-#define   ADNE 0x1000		/*  read, fifo not empty (realtime, not latched) status */
+#define   ADNEI 0x800		/*
+				 * read fifo not empty interrupt
+				 * latch status
+				 */
+#define   ADNE 0x1000           /*
+				 * read, fifo not empty (realtime,
+				 * not latched) status
+				 */
 #define   DAEMIE	0x1000	/*  write, dac empty interrupt enable */
 #define   LADFUL 0x2000		/*  read fifo overflow / write clear */
-#define   DAEMI 0x4000		/*  dac fifo empty interrupt status / write clear */
+#define   DAEMI 0x4000		/*
+				 * dac fifo empty interrupt
+				 * status / write clear
+				 */
 
 #define ADCMUX_CONT	2	/*  ADC CHANNEL MUX AND CONTROL register */
 #define   BEGIN_SCAN(x)	((x) & 0xf)
@@ -144,8 +159,14 @@ analog triggering on 1602 series
 #define   EXT_TRIGGER 0x2	/*  external start trigger */
 #define   ANALOG_TRIGGER 0x3	/*  external analog trigger */
 #define   TRIGGER_MASK	0x3	/*  mask of bits that determine start trigger */
-#define   TGPOL	0x04		/*  invert the edge/level of the external trigger (1602 only) */
-#define   TGSEL	0x08		/*  if set edge triggered, otherwise level trigerred (1602 only) */
+#define   TGPOL	0x04		/*
+				 * invert the edge/level of the external
+				 * trigger (1602 only)
+				 */
+#define   TGSEL	0x08		/*
+				 * if set edge triggered, otherwise level
+				 * trigerred (1602 only)
+				 */
 #define   TGEN	0x10		/*  enable external start trigger */
 #define   BURSTE 0x20		/*  burst mode enable */
 #define   XTRCL	0x80		/*  clear external trigger */
@@ -155,13 +176,20 @@ analog triggering on 1602 series
 #define   SELECT_TRIMPOT_BIT	0x200	/*  select ad7376 trim pot */
 #define   SELECT_DAC08_BIT	0x400	/*  select dac08 caldac */
 #define   CAL_SRC_BITS(x)	(((x) & 0x7) << 11)
-#define   CAL_EN_BIT	0x4000	/*  read calibration source instead of analog input channel 0 */
-#define   SERIAL_DATA_IN_BIT	0x8000	/*  serial data stream going to 8800 and 7376 */
+#define   CAL_EN_BIT	0x4000	/*
+				 * read calibration source instead of
+				 * analog input channel 0
+				 */
+/* serial data stream going to 8800 and 7376 */
+#define   SERIAL_DATA_IN_BIT    0x8000
 
 #define DAC_CSR	0x8		/*  dac control and status register */
 enum dac_csr_bits {
 	DACEN = 0x2,		/*  dac enable */
-	DAC_MODE_UPDATE_BOTH = 0x80,	/*  update both dacs when dac0 is written */
+	DAC_MODE_UPDATE_BOTH = 0x80,	/*
+					 * update both dacs when dac0 is
+					 * written
+					 */
 };
 static inline unsigned int DAC_RANGE(unsigned int channel, unsigned int range)
 {
@@ -206,7 +234,10 @@ static inline unsigned int DAC_DATA_REG(unsigned int channel)
 #define DACDATA	0		/*  DAC DATA register */
 #define DACFIFOCLR	2	/*  DAC FIFO CLEAR */
 
-/* bit in hexadecimal representation of range index that indicates unipolar input range */
+/*
+ * bit in hexadecimal representation of range index that
+ * indicates unipolar input range
+ */
 #define IS_UNIPOLAR 0x4
 /* analog input ranges for most boards */
 static const struct comedi_lrange cb_pcidas_ranges = {
@@ -263,13 +294,18 @@ struct cb_pcidas_board {
 	int ai_speed;		/*  fastest conversion period in ns */
 	int ao_nchan;		/*  number of analog out channels */
 	int has_ao_fifo;	/*  analog output has fifo */
-	int ao_scan_speed;	/*  analog output speed for 1602 series (for a scan, not conversion) */
+	int ao_scan_speed;	/*
+				 * analog output speed for 1602 series
+				 * (for a scan, not conversion)
+				 */
 	int fifo_size;		/*  number of samples fifo can hold */
 	const struct comedi_lrange *ranges;
 	enum trimpot_model trimpot;
 	unsigned has_dac08:1;
-	unsigned has_ai_trig_gated:1;	/* Tells if the AI trigger can be gated */
-	unsigned has_ai_trig_invert:1;	/* Tells if the AI trigger can be inverted */
+	/* Tells if the AI trigger can be gated */
+	unsigned has_ai_trig_gated:1;
+	/* Tells if the AI trigger can be inverted */
+	unsigned has_ai_trig_invert:1;
 };
 
 static const struct cb_pcidas_board cb_pcidas_boards[] = {
@@ -424,9 +460,12 @@ MODULE_DEVICE_TABLE(pci, cb_pcidas_pci_table);
  */
 #define thisboard ((const struct cb_pcidas_board *)dev->board_ptr)
 
-/* this structure is for data unique to this hardware driver.  If
-   several hardware drivers keep similar information in this structure,
-   feel free to suggest moving the variable to the struct comedi_device struct.  */
+/*
+ * this structure is for data unique to this hardware driver.  If
+ * several hardware drivers keep similar information in this structure,
+ * feel free to suggest moving the variable to the struct comedi_device
+ * struct.
+ */
 struct cb_pcidas_private {
 	/* would be useful for a PCI device */
 	struct pci_dev *pci_dev;
@@ -449,9 +488,12 @@ struct cb_pcidas_private {
 	unsigned int ao_divisor1;
 	unsigned int ao_divisor2;
 	volatile unsigned int ao_count;	/*  number of analog output samples remaining */
-	int ao_value[2];	/*  remember what the analog outputs are set to, to allow readback */
-	unsigned int caldac_value[NUM_CHANNELS_8800];	/*  for readback of caldac */
-	unsigned int trimpot_value[NUM_CHANNELS_8402];	/*  for readback of trimpot */
+	/* remember what the analog outputs are set to, to allow readback */
+	int ao_value[2];
+	/* for readback of caldac */
+	unsigned int caldac_value[NUM_CHANNELS_8800];
+	/* for readback of trimpot */
+	unsigned int trimpot_value[NUM_CHANNELS_8402];
 	unsigned int dac08_value;
 	unsigned int calibration_source;
 };
@@ -680,7 +722,10 @@ found:
 		s->type = COMEDI_SUBD_AO;
 		s->subdev_flags = SDF_READABLE | SDF_WRITABLE | SDF_GROUND;
 		s->n_chan = thisboard->ao_nchan;
-		/*  analog out resolution is the same as analog input resolution, so use ai_bits */
+		/*
+		 * analog out resolution is the same as analog
+		 * input resolution, so use ai_bits
+		 */
 		s->maxdata = (1 << thisboard->ai_bits) - 1;
 		s->range_table = &cb_pcidas_ao_ranges;
 		s->insn_read = cb_pcidas_ao_readback_insn;
@@ -781,7 +826,8 @@ static int cb_pcidas_detach(struct comedi_device *dev)
 			outl(INTCSR_INBOX_INTR_STATUS,
 			     devpriv->s5933_config + AMCC_OP_REG_INTCSR);
 			dev_dbg(&pcidev->dev, "detaching, incsr is 0x%x\n",
-				inl(devpriv->s5933_config + AMCC_OP_REG_INTCSR));
+				inl(devpriv->s5933_config +
+					AMCC_OP_REG_INTCSR));
 		}
 	}
 	if (dev->irq)
@@ -947,7 +993,10 @@ static int cb_pcidas_ao_fifo_winsn(struct comedi_device *dev,
 }
 
 /* analog output readback insn */
-/* XXX loses track of analog output value back after an analog ouput command is executed */
+/*
+ * XXX loses track of analog output value back after
+ * an analog ouput command is executed
+ */
 static int cb_pcidas_ao_readback_insn(struct comedi_device *dev,
 				      struct comedi_subdevice *s,
 				      struct comedi_insn *insn,
@@ -1117,7 +1166,9 @@ static int cb_pcidas_ai_cmdtest(struct comedi_device *dev,
 	if (err)
 		return 1;
 
-	/* step 2: make sure trigger sources are unique and mutually compatible */
+	/*
+	 * step 2: make sure trigger sources are unique and mutually compatible
+	 */
 
 	if (cmd->start_src != TRIG_NOW && cmd->start_src != TRIG_EXT)
 		err++;
@@ -1301,11 +1352,14 @@ static int cb_pcidas_ai_cmd(struct comedi_device *dev,
 	devpriv->adc_fifo_bits &= ~INT_MASK;
 	if (cmd->flags & TRIG_WAKE_EOS) {
 		if (cmd->convert_src == TRIG_NOW && cmd->chanlist_len > 1)
-			devpriv->adc_fifo_bits |= INT_EOS;	/*  interrupt end of burst */
+			/* interrupt end of burst */
+			devpriv->adc_fifo_bits |= INT_EOS;
 		else
-			devpriv->adc_fifo_bits |= INT_FNE;	/*  interrupt fifo not empty */
+			/*  interrupt fifo not empty */
+			devpriv->adc_fifo_bits |= INT_FNE;
 	} else {
-		devpriv->adc_fifo_bits |= INT_FHF;	/* interrupt fifo half full */
+		/* interrupt fifo half full */
+		devpriv->adc_fifo_bits |= INT_FHF;
 	}
 	dev_dbg(&pcidev->dev, "comedi: adc_fifo_bits are 0x%x\n",
 		devpriv->adc_fifo_bits);
@@ -1382,7 +1436,9 @@ static int cb_pcidas_ao_cmdtest(struct comedi_device *dev,
 	if (err)
 		return 1;
 
-	/* step 2: make sure trigger sources are unique and mutually compatible */
+	/*
+	 * step 2: make sure trigger sources are unique and mutually compatible
+	 */
 
 	if (cmd->scan_begin_src != TRIG_TIMER &&
 	    cmd->scan_begin_src != TRIG_EXT)
-- 
1.7.6.2

