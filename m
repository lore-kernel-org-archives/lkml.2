Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab2F0BJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 21:09:10 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:56858 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438Ab2F0BJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 21:09:08 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-132.messagelabs.com!1340759346!9744010!3
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 31/36] staging: comedi: cb_pcidas: add whitespace to all the #define's
Date: Tue, 26 Jun 2012 18:09:01 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261809.01777.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add whitespace to all the #define's in the driver in order to
improve the readability. Fix all the comments that are, or
already were, > 80 characters.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 141 +++++++++++++++--------------
 1 file changed, 71 insertions(+), 70 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 0188cf1..c0d9340 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -81,64 +81,65 @@ analog triggering on 1602 series
 
 /* PCI vendor number of ComputerBoards/MeasurementComputing */
 #define PCI_VENDOR_ID_CB	0x1307
-#define TIMER_BASE 100		/*  10MHz master clock */
-#define AI_BUFFER_SIZE 1024	/*  maximum fifo size of any supported board */
-#define AO_BUFFER_SIZE 1024	/*  maximum fifo size of any supported board */
-#define NUM_CHANNELS_8800 8
-#define NUM_CHANNELS_7376 1
-#define NUM_CHANNELS_8402 2
-#define NUM_CHANNELS_DAC08 1
+
+#define TIMER_BASE		100	/* 10MHz master clock */
+#define AI_BUFFER_SIZE		1024	/* max ai fifo size */
+#define AO_BUFFER_SIZE		1024	/* max ao fifo size */
+#define NUM_CHANNELS_8800	8
+#define NUM_CHANNELS_7376	1
+#define NUM_CHANNELS_8402	2
+#define NUM_CHANNELS_DAC08	1
 
 /* Control/Status registers */
-#define INT_ADCFIFO	0	/*  INTERRUPT / ADC FIFO register */
-#define   INT_EOS 0x1		/*  interrupt end of scan */
-#define   INT_FHF 0x2		/*  interrupt fifo half full */
-#define   INT_FNE 0x3		/*  interrupt fifo not empty */
-#define   INT_MASK 0x3		/*  mask of interrupt select bits */
-#define   INTE 0x4		/*  interrupt enable */
-#define   DAHFIE 0x8		/*  dac half full interrupt enable */
-#define   EOAIE	0x10		/*  end of acquisition interrupt enable */
-#define   DAHFI	0x20		/*  dac half full read status / write interrupt clear */
-#define   EOAI 0x40		/*  read end of acq. interrupt status / write clear */
-#define   INT 0x80		/*  read interrupt status / write clear */
-#define   EOBI 0x200		/*  read end of burst interrupt status */
-#define   ADHFI 0x400		/*  read half-full interrupt status */
-#define   ADNEI 0x800		/*  read fifo not empty interrupt latch status */
-#define   ADNE 0x1000		/*  read, fifo not empty (realtime, not latched) status */
-#define   DAEMIE	0x1000	/*  write, dac empty interrupt enable */
-#define   LADFUL 0x2000		/*  read fifo overflow / write clear */
-#define   DAEMI 0x4000		/*  dac fifo empty interrupt status / write clear */
-
-#define ADCMUX_CONT	2	/*  ADC CHANNEL MUX AND CONTROL register */
-#define   BEGIN_SCAN(x)	((x) & 0xf)
-#define   END_SCAN(x)	(((x) & 0xf) << 4)
-#define   GAIN_BITS(x)	(((x) & 0x3) << 8)
-#define   UNIP	0x800		/*  Analog front-end unipolar for range */
-#define   SE	0x400		/*  Inputs in single-ended mode */
-#define   PACER_MASK	0x3000	/*  pacer source bits */
-#define   PACER_INT 0x1000	/*  internal pacer */
-#define   PACER_EXT_FALL	0x2000	/*  external falling edge */
-#define   PACER_EXT_RISE	0x3000	/*  external rising edge */
-#define   EOC	0x4000		/*  adc not busy */
-
-#define TRIG_CONTSTAT 4		/*  TRIGGER CONTROL/STATUS register */
-#define   SW_TRIGGER 0x1	/*  software start trigger */
-#define   EXT_TRIGGER 0x2	/*  external start trigger */
-#define   ANALOG_TRIGGER 0x3	/*  external analog trigger */
-#define   TRIGGER_MASK	0x3	/*  mask of bits that determine start trigger */
-#define   TGPOL	0x04		/*  invert the edge/level of the external trigger (1602 only) */
-#define   TGSEL	0x08		/*  if set edge triggered, otherwise level trigerred (1602 only) */
-#define   TGEN	0x10		/*  enable external start trigger */
-#define   BURSTE 0x20		/*  burst mode enable */
-#define   XTRCL	0x80		/*  clear external trigger */
-
-#define CALIBRATION_REG	6	/*  CALIBRATION register */
-#define   SELECT_8800_BIT	0x100	/*  select 8800 caldac */
-#define   SELECT_TRIMPOT_BIT	0x200	/*  select ad7376 trim pot */
-#define   SELECT_DAC08_BIT	0x400	/*  select dac08 caldac */
+#define INT_ADCFIFO		0	/* INTERRUPT / ADC FIFO register */
+#define   INT_EOS		0x1	/* int end of scan */
+#define   INT_FHF		0x2	/* int fifo half full */
+#define   INT_FNE		0x3	/* int fifo not empty */
+#define   INT_MASK		0x3	/* mask of int select bits */
+#define   INTE			0x4	/* int enable */
+#define   DAHFIE		0x8	/* dac half full int enable */
+#define   EOAIE			0x10	/* end of acq. int enable */
+#define   DAHFI			0x20	/* dac half full status / clear */
+#define   EOAI			0x40	/* end of acq. int status / clear */
+#define   INT			0x80	/* int status / clear */
+#define   EOBI			0x200	/* end of burst int status */
+#define   ADHFI			0x400	/* half-full int status */
+#define   ADNEI			0x800	/* fifo not empty int status (latch) */
+#define   ADNE			0x1000	/* fifo not empty status (realtime) */
+#define   DAEMIE		0x1000	/* dac empty int enable */
+#define   LADFUL		0x2000	/* fifo overflow / clear */
+#define   DAEMI			0x4000	/* dac fifo empty int status / clear */
+
+#define ADCMUX_CONT		2	/* ADC CHANNEL MUX AND CONTROL reg */
+#define   BEGIN_SCAN(x)		((x) & 0xf)
+#define   END_SCAN(x)		(((x) & 0xf) << 4)
+#define   GAIN_BITS(x)		(((x) & 0x3) << 8)
+#define   UNIP			0x800	/* Analog front-end unipolar mode */
+#define   SE			0x400	/* Inputs in single-ended mode */
+#define   PACER_MASK		0x3000	/* pacer source bits */
+#define   PACER_INT		0x1000	/* int. pacer */
+#define   PACER_EXT_FALL	0x2000	/* ext. falling edge */
+#define   PACER_EXT_RISE	0x3000	/* ext. rising edge */
+#define   EOC			0x4000	/* adc not busy */
+
+#define TRIG_CONTSTAT		 4	/* TRIGGER CONTROL/STATUS register */
+#define   SW_TRIGGER		0x1	/* software start trigger */
+#define   EXT_TRIGGER		0x2	/* ext. start trigger */
+#define   ANALOG_TRIGGER	0x3	/* ext. analog trigger */
+#define   TRIGGER_MASK		0x3	/* start trigger mask */
+#define   TGPOL			0x04	/* invert trigger (1602 only) */
+#define   TGSEL			0x08	/* edge/level trigerred (1602 only) */
+#define   TGEN			0x10	/* enable external start trigger */
+#define   BURSTE		0x20	/* burst mode enable */
+#define   XTRCL			0x80	/* clear external trigger */
+
+#define CALIBRATION_REG		6	/* CALIBRATION register */
+#define   SELECT_8800_BIT	0x100	/* select 8800 caldac */
+#define   SELECT_TRIMPOT_BIT	0x200	/* select ad7376 trim pot */
+#define   SELECT_DAC08_BIT	0x400	/* select dac08 caldac */
 #define   CAL_SRC_BITS(x)	(((x) & 0x7) << 11)
-#define   CAL_EN_BIT	0x4000	/*  read calibration source instead of analog input channel 0 */
-#define   SERIAL_DATA_IN_BIT	0x8000	/*  serial data stream going to 8800 and 7376 */
+#define   CAL_EN_BIT		0x4000	/* calibration source enable */
+#define   SERIAL_DATA_IN_BIT	0x8000	/* serial data bit going to caldac */
 
 #define DAC_CSR			0x8	/* dac control and status register */
 #define   DACEN			0x02	/* dac enable */
@@ -155,12 +156,12 @@ static inline unsigned int DAC_RANGE_MASK(unsigned int channel)
 };
 
 /* bits for 1602 series only */
-#define   DAC_EMPTY		0x1	/*  fifo empty, read, write clear */
-#define   DAC_START		0x4	/*  start/arm fifo operations */
-#define   DAC_PACER_MASK	0x18	/*  bits that set pacer source */
-#define   DAC_PACER_INT		0x8	/*  int. pacing */
-#define   DAC_PACER_EXT_FALL	0x10	/*  ext. pacing, falling edge */
-#define   DAC_PACER_EXT_RISE	0x18	/*  ext. pacing, rising edge */
+#define   DAC_EMPTY		0x1	/* fifo empty, read, write clear */
+#define   DAC_START		0x4	/* start/arm fifo operations */
+#define   DAC_PACER_MASK	0x18	/* bits that set pacer source */
+#define   DAC_PACER_INT		0x8	/* int. pacing */
+#define   DAC_PACER_EXT_FALL	0x10	/* ext. pacing, falling edge */
+#define   DAC_PACER_EXT_RISE	0x18	/* ext. pacing, rising edge */
 
 static inline unsigned int DAC_CHAN_EN(unsigned int channel)
 {
@@ -168,13 +169,13 @@ static inline unsigned int DAC_CHAN_EN(unsigned int channel)
 };
 
 /* analog input fifo */
-#define ADCDATA	0		/*  ADC DATA register */
-#define ADCFIFOCLR	2	/*  ADC FIFO CLEAR */
+#define ADCDATA			0	/* ADC DATA register */
+#define ADCFIFOCLR		2	/* ADC FIFO CLEAR */
 
 /* pacer, counter, dio registers */
-#define ADC8254 0
-#define DIO_8255 4
-#define DAC8254 8
+#define ADC8254			0
+#define DIO_8255		4
+#define DAC8254			8
 
 /* analog output registers for 100x, 1200 series */
 static inline unsigned int DAC_DATA_REG(unsigned int channel)
@@ -183,11 +184,11 @@ static inline unsigned int DAC_DATA_REG(unsigned int channel)
 }
 
 /* analog output registers for 1602 series*/
-#define DACDATA	0		/*  DAC DATA register */
-#define DACFIFOCLR	2	/*  DAC FIFO CLEAR */
+#define DACDATA			0	/* DAC DATA register */
+#define DACFIFOCLR		2	/* DAC FIFO CLEAR */
+
+#define IS_UNIPOLAR		0x4	/* unipolar range mask */
 
-/* bit in hexadecimal representation of range index that indicates unipolar input range */
-#define IS_UNIPOLAR 0x4
 /* analog input ranges for most boards */
 static const struct comedi_lrange cb_pcidas_ranges = {
 	8,
-- 
1.7.11

