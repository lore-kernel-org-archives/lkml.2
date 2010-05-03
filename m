Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab0ECJfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 05:35:51 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:51115 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab0ECJft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 05:35:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=tU2D7RfC1plVnNAAbK6a7uKq2lbyOQqiIpRYsDPl0I7DUhTWqSBtXTfU5d/5H6qXPw
         fIQdh3lBV/fugGm/AXjBEYMp3prJHiLNjE/DolQVjH77MArP/nufy5lPFeUIzw/IyL7n
         96nfOFc5/lumWHjQJyKOWjAAZdn3X1+TIlFnM=
From: Iain Churcher <iain.linux.coding@googlemail.com>
To: iain.linux.coding@googlemail.com, gregkh@suse.de, wfp5p@virginia.edu,
       jkosina@suse.cz, mithlesh@linsyssoft.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: comedi: Fix Checkpatch.pl issues in mpc624.c This patch resolves all checkpatch.pl issues in the mpc624.c file
Date: Mon,  3 May 2010 10:35:37 +0100
Message-Id: <1272879337-3472-1-git-send-email-iain.linux.coding@googlemail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Iain Churcher <iain.linux.coding@googlemail.com>
---
 drivers/staging/comedi/drivers/mpc624.c |  185 +++++++++++++++++--------------
 1 files changed, 104 insertions(+), 81 deletions(-)

diff --git a/drivers/staging/comedi/drivers/mpc624.c b/drivers/staging/comedi/drivers/mpc624.c
index 12e72c8..9874ac3 100644
--- a/drivers/staging/comedi/drivers/mpc624.c
+++ b/drivers/staging/comedi/drivers/mpc624.c
@@ -40,20 +40,20 @@ Status: working
 Configuration Options:
   [0] - I/O base address
   [1] - convertion rate
-            Convertion rate  RMS noise  Effective Number Of Bits
-         0      3.52kHz        23uV                17
-         1      1.76kHz       3.5uV                20
-         2       880Hz         2uV                21.3
-         3       440Hz        1.4uV               21.8
-         4       220Hz         1uV                22.4
-         5       110Hz        750uV               22.9
-         6       55Hz         510nV               23.4
-         7      27.5Hz        375nV                24
-         8      13.75Hz       250nV               24.4
-         9      6.875Hz       200nV               24.6
-   [2] - voltage range
-         0      -1.01V .. +1.01V
-         1      -10.1V .. +10.1V
+	Convertion rate  RMS noise  Effective Number Of Bits
+	0      3.52kHz        23uV                17
+	1      1.76kHz       3.5uV                20
+	2       880Hz         2uV                21.3
+	3       440Hz        1.4uV               21.8
+	4       220Hz         1uV                22.4
+	5       110Hz        750uV               22.9
+	6       55Hz         510nV               23.4
+	7      27.5Hz        375nV                24
+	8      13.75Hz       250nV               24.4
+	9      6.875Hz       200nV               24.6
+  [2] - voltage range
+	0      -1.01V .. +1.01V
+	1      -10.1V .. +10.1V
 */
 
 #include "../comedidev.h"
@@ -65,13 +65,13 @@ Configuration Options:
 #define MPC624_SIZE             16
 
 /* Offsets of different ports */
-#define MPC624_MASTER_CONTROL	0	/*  not used */
-#define MPC624_GNMUXCH          1	/*  Gain, Mux, Channel of ADC */
-#define MPC624_ADC              2	/*  read/write to/from ADC */
-#define MPC624_EE               3	/*  read/write to/from serial EEPROM via I2C */
-#define MPC624_LEDS             4	/*  write to LEDs */
-#define MPC624_DIO              5	/*  read/write to/from digital I/O ports */
-#define MPC624_IRQ_MASK         6	/*  IRQ masking enable/disable */
+#define MPC624_MASTER_CONTROL	0 /* not used */
+#define MPC624_GNMUXCH          1 /* Gain, Mux, Channel of ADC */
+#define MPC624_ADC              2 /* read/write to/from ADC */
+#define MPC624_EE               3 /* read/write to/from serial EEPROM via I2C */
+#define MPC624_LEDS             4 /* write to LEDs */
+#define MPC624_DIO              5 /* read/write to/from digital I/O ports */
+#define MPC624_IRQ_MASK         6 /* IRQ masking enable/disable */
 
 /* Register bits' names */
 #define MPC624_ADBUSY           (1<<5)
@@ -109,24 +109,27 @@ Configuration Options:
  * ^ - Effective Number Of Bits
  */
 
-#define MPC624_SPEED_3_52_kHz   (MPC624_OSR4                                           | MPC624_OSR0)
-#define MPC624_SPEED_1_76_kHz   (MPC624_OSR4                             | MPC624_OSR1)
-#define MPC624_SPEED_880_Hz     (MPC624_OSR4                             | MPC624_OSR1 | MPC624_OSR0)
-#define MPC624_SPEED_440_Hz     (MPC624_OSR4               | MPC624_OSR2)
-#define MPC624_SPEED_220_Hz     (MPC624_OSR4               | MPC624_OSR2               | MPC624_OSR0)
-#define MPC624_SPEED_110_Hz     (MPC624_OSR4               | MPC624_OSR2 | MPC624_OSR1)
-#define MPC624_SPEED_55_Hz      (MPC624_OSR4               | MPC624_OSR2 | MPC624_OSR1 | MPC624_OSR0)
-#define MPC624_SPEED_27_5_Hz    (MPC624_OSR4 | MPC624_OSR3)
-#define MPC624_SPEED_13_75_Hz   (MPC624_OSR4 | MPC624_OSR3                             | MPC624_OSR0)
-#define MPC624_SPEED_6_875_Hz   (MPC624_OSR4 | MPC624_OSR3 | MPC624_OSR2 | MPC624_OSR1 | MPC624_OSR0)
-/* ---------------------------------------------------------------------------- */
+#define MPC624_SPEED_3_52_kHz (MPC624_OSR4 | MPC624_OSR0)
+#define MPC624_SPEED_1_76_kHz (MPC624_OSR4 | MPC624_OSR1)
+#define MPC624_SPEED_880_Hz   (MPC624_OSR4 | MPC624_OSR1 | MPC624_OSR0)
+#define MPC624_SPEED_440_Hz   (MPC624_OSR4 | MPC624_OSR2)
+#define MPC624_SPEED_220_Hz   (MPC624_OSR4 | MPC624_OSR2 | MPC624_OSR0)
+#define MPC624_SPEED_110_Hz   (MPC624_OSR4 | MPC624_OSR2 | MPC624_OSR1)
+#define MPC624_SPEED_55_Hz \
+	(MPC624_OSR4 | MPC624_OSR2 | MPC624_OSR1 | MPC624_OSR0)
+#define MPC624_SPEED_27_5_Hz  (MPC624_OSR4 | MPC624_OSR3)
+#define MPC624_SPEED_13_75_Hz (MPC624_OSR4 | MPC624_OSR3 | MPC624_OSR0)
+#define MPC624_SPEED_6_875_Hz \
+	(MPC624_OSR4 | MPC624_OSR3 | MPC624_OSR2 | MPC624_OSR1 | MPC624_OSR0)
+/* -------------------------------------------------------------------------- */
 struct skel_private {
 
-	unsigned long int ulConvertionRate;	/*  set by mpc624_attach() from driver's parameters */
+	/*  set by mpc624_attach() from driver's parameters */
+	unsigned long int ulConvertionRate;
 };
 
 #define devpriv ((struct skel_private *)dev->private)
-/* ---------------------------------------------------------------------------- */
+/* -------------------------------------------------------------------------- */
 static const struct comedi_lrange range_mpc624_bipolar1 = {
 	1,
 	{
@@ -145,11 +148,11 @@ static const struct comedi_lrange range_mpc624_bipolar10 = {
 	 }
 };
 
-/* ---------------------------------------------------------------------------- */
+/* -------------------------------------------------------------------------- */
 static int mpc624_attach(struct comedi_device *dev,
 			 struct comedi_devconfig *it);
 static int mpc624_detach(struct comedi_device *dev);
-/* ---------------------------------------------------------------------------- */
+/* -------------------------------------------------------------------------- */
 static struct comedi_driver driver_mpc624 = {
 	.driver_name = "mpc624",
 	.module = THIS_MODULE,
@@ -157,20 +160,20 @@ static struct comedi_driver driver_mpc624 = {
 	.detach = mpc624_detach
 };
 
-/* ---------------------------------------------------------------------------- */
+/* -------------------------------------------------------------------------- */
 static int mpc624_ai_rinsn(struct comedi_device *dev,
 			   struct comedi_subdevice *s, struct comedi_insn *insn,
 			   unsigned int *data);
-/* ---------------------------------------------------------------------------- */
+/* -------------------------------------------------------------------------- */
 static int mpc624_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	struct comedi_subdevice *s;
 	unsigned long iobase;
 
 	iobase = it->options[0];
-	printk("comedi%d: mpc624 [0x%04lx, ", dev->minor, iobase);
+	printk(KERN_INFO "comedi%d: mpc624 [0x%04lx, ", dev->minor, iobase);
 	if (request_region(iobase, MPC624_SIZE, "mpc624") == NULL) {
-		printk("I/O port(s) in use\n");
+		printk(KERN_ERR "I/O port(s) in use\n");
 		return -EIO;
 	}
 
@@ -184,47 +187,48 @@ static int mpc624_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	switch (it->options[1]) {
 	case 0:
 		devpriv->ulConvertionRate = MPC624_SPEED_3_52_kHz;
-		printk("3.52 kHz, ");
+		printk(KERN_INFO "3.52 kHz, ");
 		break;
 	case 1:
 		devpriv->ulConvertionRate = MPC624_SPEED_1_76_kHz;
-		printk("1.76 kHz, ");
+		printk(KERN_INFO "1.76 kHz, ");
 		break;
 	case 2:
 		devpriv->ulConvertionRate = MPC624_SPEED_880_Hz;
-		printk("880 Hz, ");
+		printk(KERN_INFO "880 Hz, ");
 		break;
 	case 3:
 		devpriv->ulConvertionRate = MPC624_SPEED_440_Hz;
-		printk("440 Hz, ");
+		printk(KERN_INFO "440 Hz, ");
 		break;
 	case 4:
 		devpriv->ulConvertionRate = MPC624_SPEED_220_Hz;
-		printk("220 Hz, ");
+		printk(KERN_INFO "220 Hz, ");
 		break;
 	case 5:
 		devpriv->ulConvertionRate = MPC624_SPEED_110_Hz;
-		printk("110 Hz, ");
+		printk(KERN_INFO "110 Hz, ");
 		break;
 	case 6:
 		devpriv->ulConvertionRate = MPC624_SPEED_55_Hz;
-		printk("55 Hz, ");
+		printk(KERN_INFO "55 Hz, ");
 		break;
 	case 7:
 		devpriv->ulConvertionRate = MPC624_SPEED_27_5_Hz;
-		printk("27.5 Hz, ");
+		printk(KERN_INFO "27.5 Hz, ");
 		break;
 	case 8:
 		devpriv->ulConvertionRate = MPC624_SPEED_13_75_Hz;
-		printk("13.75 Hz, ");
+		printk(KERN_INFO "13.75 Hz, ");
 		break;
 	case 9:
 		devpriv->ulConvertionRate = MPC624_SPEED_6_875_Hz;
-		printk("6.875 Hz, ");
+		printk(KERN_INFO "6.875 Hz, ");
 		break;
 	default:
 		printk
-		    ("illegal convertion rate setting! Valid numbers are 0..9. Using 9 => 6.875 Hz, ");
+		    (KERN_ERR "illegal convertion rate setting!"
+			" Valid numbers are 0..9. Using 9 => 6.875 Hz, ");
 		devpriv->ulConvertionRate = MPC624_SPEED_3_52_kHz;
 	}
 
@@ -239,29 +243,29 @@ static int mpc624_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	switch (it->options[1]) {
 	default:
 		s->maxdata = 0x3FFFFFFF;
-		printk("30 bit, ");
+		printk(KERN_INFO "30 bit, ");
 	}
 
 	switch (it->options[1]) {
 	case 0:
 		s->range_table = &range_mpc624_bipolar1;
-		printk("1.01V]: ");
+		printk(KERN_INFO "1.01V]: ");
 		break;
 	default:
 		s->range_table = &range_mpc624_bipolar10;
-		printk("10.1V]: ");
+		printk(KERN_INFO "10.1V]: ");
 	}
 	s->len_chanlist = 1;
 	s->insn_read = mpc624_ai_rinsn;
 
-	printk("attached\n");
+	printk(KERN_INFO "attached\n");
 
 	return 1;
 }
 
 static int mpc624_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: mpc624: remove\n", dev->minor);
+	printk(KERN_INFO "comedi%d: mpc624: remove\n", dev->minor);
 
 	if (dev->iobase)
 		release_region(dev->iobase, MPC624_SIZE);
@@ -280,11 +284,14 @@ static int mpc624_ai_rinsn(struct comedi_device *dev,
 	unsigned long int data_in, data_out;
 	unsigned char ucPort;
 
-	/*  WARNING: We always write 0 to GNSWA bit, so the channel range is +-/10.1Vdc */
+	/*
+	 *  WARNING:
+	 *  We always write 0 to GNSWA bit, so the channel range is +-/10.1Vdc
+	 */
 	outb(insn->chanspec, dev->iobase + MPC624_GNMUXCH);
-/* printk("Channel %d: \n", insn->chanspec); */
+/* printk("Channel %d:\n", insn->chanspec); */
 	if (!insn->n) {
-		printk("MPC624: Warning, no data to acquire\n");
+		printk(KERN_INFO "MPC624: Warning, no data to acquire\n");
 		return 0;
 	}
 
@@ -306,7 +313,7 @@ static int mpc624_ai_rinsn(struct comedi_device *dev,
 				break;
 		}
 		if (i == TIMEOUT) {
-			printk("MPC624: timeout (%dms)\n", TIMEOUT);
+			printk(KERN_ERR "MPC624: timeout (%dms)\n", TIMEOUT);
 			data[n] = 0;
 			return -ETIMEDOUT;
 		}
@@ -319,7 +326,7 @@ static int mpc624_ai_rinsn(struct comedi_device *dev,
 			outb(0, dev->iobase + MPC624_ADC);
 			udelay(1);
 
-			if (data_out & (1 << 31)) {	/*  the next bit is a 1 */
+			if (data_out & (1 << 31)) { /*  the next bit is a 1 */
 				/*  Set the ADSDI line (send to MPC624) */
 				outb(MPC624_ADSDI, dev->iobase + MPC624_ADC);
 				udelay(1);
@@ -344,31 +351,47 @@ static int mpc624_ai_rinsn(struct comedi_device *dev,
 			data_out <<= 1;
 		}
 
-		/*  Received 32-bit long value consist of: */
-		/*    31: EOC (End Of Transmission) bit - should be 0 */
-		/*    30: DMY (Dummy) bit               - should be 0 */
-		/*    29: SIG (Sign) bit                - 1 if the voltage is positive, 0 if negative */
-		/*    28: MSB (Most Significant Bit)    - the first bit of convertion result */
-		/*    .... */
-		/*    05: LSB (Least Significant Bit)   - the last bit of convertion result */
-		/*    04: sub-LSB                       - sub-LSBs are basically noise, but when */
-		/*    03: sub-LSB                         averaged properly, they can increase convertion */
-		/*    02: sub-LSB                         precision up to 29 bits; they can be discarded */
-		/*    01: sub-LSB                         without loss of resolution. */
-		/*    00: sub-LSB */
+		/*
+		 *  Received 32-bit long value consist of:
+		 *    31: EOC -
+		 *          (End Of Transmission) bit - should be 0
+		 *    30: DMY
+		 *          (Dummy) bit - should be 0
+		 *    29: SIG
+		 *          (Sign) bit- 1 if the voltage is positive,
+		 *                      0 if negative
+		 *    28: MSB
+		 *          (Most Significant Bit) - the first bit of
+		 *                                   the conversion result
+		 *    ....
+		 *    05: LSB
+		 *          (Least Significant Bit)- the last bit of the
+		 *                                   conversion result
+		 *    04-00: sub-LSB
+		 *          - sub-LSBs are basically noise, but when
+		 *            averaged properly, they can increase conversion
+		 *            precision up to 29 bits; they can be discarded
+		 *            without loss of resolution.
+		 */
 
 		if (data_in & MPC624_EOC_BIT)
-			printk("MPC624: EOC bit is set (data_in=%lu)!",
+			printk(KERN_INFO "MPC624:EOC bit is set (data_in=%lu)!",
 			       data_in);
 		if (data_in & MPC624_DMY_BIT)
-			printk("MPC624: DMY bit is set (data_in=%lu)!",
+			printk(KERN_INFO "MPC624:DMY bit is set (data_in=%lu)!",
 			       data_in);
-		if (data_in & MPC624_SGN_BIT) {	/*  check the sign bit *//*  The voltage is positive */
-			data_in &= 0x3FFFFFFF;	/*  EOC and DMY should be 0, but we will mask them out just to be sure */
-			data[n] = data_in;	/*  comedi operates on unsigned numbers, so we don't clear the SGN bit */
-			/*  SGN bit is still set! It's correct, since we're converting to unsigned. */
-		} else {	/*  The voltage is negative */
-			/*  data_in contains a number in 30-bit two's complement code and we must deal with it */
+		if (data_in & MPC624_SGN_BIT) {	/* Volatge is positive */
+			/*
+			 * comedi operates on unsigned numbers, so mask off EOC
+			 * and DMY and don't clear the SGN bit
+			 */
+			data_in &= 0x3FFFFFFF;
+			data[n] = data_in;
+		} else { /*  The voltage is negative */
+			/*
+			 * data_in contains a number in 30-bit two's complement
+			 * code and we must deal with it
+			 */
 			data_in |= MPC624_SGN_BIT;
 			data_in = ~data_in;
 			data_in += 1;
-- 
1.7.0.4

