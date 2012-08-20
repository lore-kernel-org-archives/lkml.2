Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab2HTS3K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 14:29:10 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:14741 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab2HTS3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 14:29:05 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-131.messagelabs.com!1345487302!21581519!90
X-Originating-IP: [216.166.12.180]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] staging: comedi: aio_aio12_8: document the register map
Date: Mon, 20 Aug 2012 11:28:52 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208201128.53053.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fully document the register map and add namespace to all the
defines.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/aio_aio12_8.c | 129 ++++++++++++++++-----------
 1 file changed, 75 insertions(+), 54 deletions(-)

diff --git a/drivers/staging/comedi/drivers/aio_aio12_8.c b/drivers/staging/comedi/drivers/aio_aio12_8.c
index c06f5cb..46ef41a 100644
--- a/drivers/staging/comedi/drivers/aio_aio12_8.c
+++ b/drivers/staging/comedi/drivers/aio_aio12_8.c
@@ -43,34 +43,43 @@ Notes:
 #include <linux/ioport.h>
 #include "8255.h"
 
-#define AIO12_8_STATUS			0x00
-#define AIO12_8_INTERRUPT		0x01
-#define AIO12_8_ADC			0x02
-#define AIO12_8_DAC_0			0x04
-#define AIO12_8_DAC_1			0x06
-#define AIO12_8_DAC_2			0x08
-#define AIO12_8_DAC_3			0x0A
-#define AIO12_8_COUNTER_0		0x0C
-#define AIO12_8_COUNTER_1		0x0D
-#define AIO12_8_COUNTER_2		0x0E
-#define AIO12_8_COUNTER_CONTROL		0x0F
-#define AIO12_8_DIO_0			0x10
-#define AIO12_8_DIO_1			0x11
-#define AIO12_8_DIO_2			0x12
-#define AIO12_8_DIO_STATUS		0x13
-#define AIO12_8_DIO_CONTROL		0x14
-#define AIO12_8_ADC_TRIGGER_CONTROL	0x15
-#define AIO12_8_TRIGGER			0x16
-#define AIO12_8_POWER			0x17
-
-#define STATUS_ADC_EOC			0x80
-
-#define ADC_MODE_NORMAL			0x00
-#define ADC_MODE_INTERNAL_CLOCK		0x40
-#define ADC_MODE_STANDBY		0x80
-#define ADC_MODE_POWERDOWN		0xC0
-
-#define DAC_ENABLE			0x18
+/*
+ * Register map
+ */
+#define AIO12_8_STATUS_REG		0x00
+#define AIO12_8_STATUS_ADC_EOC		(1 << 7)
+#define AIO12_8_STATUS_PORT_C_COS	(1 << 6)
+#define AIO12_8_STATUS_IRQ_ENA		(1 << 2)
+#define AIO12_8_INTERRUPT_REG		0x01
+#define AIO12_8_INTERRUPT_ADC		(1 << 7)
+#define AIO12_8_INTERRUPT_COS		(1 << 6)
+#define AIO12_8_INTERRUPT_COUNTER1	(1 << 5)
+#define AIO12_8_INTERRUPT_PORT_C3	(1 << 4)
+#define AIO12_8_INTERRUPT_PORT_C0	(1 << 3)
+#define AIO12_8_INTERRUPT_ENA		(1 << 2)
+#define AIO12_8_ADC_REG			0x02
+#define AIO12_8_ADC_MODE_NORMAL		(0 << 6)
+#define AIO12_8_ADC_MODE_INT_CLK	(1 << 6)
+#define AIO12_8_ADC_MODE_STANDBY	(2 << 6)
+#define AIO12_8_ADC_MODE_POWERDOWN	(3 << 6)
+#define AIO12_8_ADC_ACQ_3USEC		(0 << 5)
+#define AIO12_8_ADC_ACQ_PROGRAM		(1 << 5)
+#define AIO12_8_ADC_RANGE(x)		((x) << 3)
+#define AIO12_8_ADC_CHAN(x)		((x) << 0)
+#define AIO12_8_DAC_REG(x)		(0x04 + (x) * 2)
+#define AIO12_8_8254_BASE_REG		0x0c
+#define AIO12_8_8255_BASE_REG		0x10
+#define AIO12_8_DIO_CONTROL_REG		0x14
+#define AIO12_8_DIO_CONTROL_TST		(1 << 0)
+#define AIO12_8_ADC_TRIGGER_REG		0x15
+#define AIO12_8_ADC_TRIGGER_RANGE(x)	((x) << 3)
+#define AIO12_8_ADC_TRIGGER_CHAN(x)	((x) << 0)
+#define AIO12_8_TRIGGER_REG		0x16
+#define AIO12_8_TRIGGER_ADTRIG		(1 << 1)
+#define AIO12_8_TRIGGER_DACTRIG		(1 << 0)
+#define AIO12_8_COS_REG			0x17
+#define AIO12_8_DAC_ENABLE_REG		0x18
+#define AIO12_8_DAC_ENABLE_REF_ENA	(1 << 0)
 
 struct aio12_8_boardtype {
 	const char *name;
@@ -100,35 +109,42 @@ static int aio_aio12_8_ai_read(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	unsigned int chan = CR_CHAN(insn->chanspec);
+	unsigned int range = CR_RANGE(insn->chanspec);
+	unsigned int val;
+	unsigned char control;
 	int n;
-	unsigned char control =
-	    ADC_MODE_NORMAL |
-	    (CR_RANGE(insn->chanspec) << 3) | CR_CHAN(insn->chanspec);
 
-	/* read status to clear EOC latch */
-	inb(dev->iobase + AIO12_8_STATUS);
+	/*
+	 * Setup the control byte for internal 2MHz clock, 3uS conversion,
+	 * at the desired range of the requested channel.
+	 */
+	control = AIO12_8_ADC_MODE_NORMAL | AIO12_8_ADC_ACQ_3USEC |
+		  AIO12_8_ADC_RANGE(range) | AIO12_8_ADC_CHAN(chan);
+
+	/* Read status to clear EOC latch */
+	inb(dev->iobase + AIO12_8_STATUS_REG);
 
 	for (n = 0; n < insn->n; n++) {
 		int timeout = 5;
 
 		/*  Setup and start conversion */
-		outb(control, dev->iobase + AIO12_8_ADC);
+		outb(control, dev->iobase + AIO12_8_ADC_REG);
 
 		/*  Wait for conversion to complete */
-		while (timeout &&
-		       !(inb(dev->iobase + AIO12_8_STATUS) & STATUS_ADC_EOC)) {
+		do {
+			val = inb(dev->iobase + AIO12_8_STATUS_REG);
 			timeout--;
-			printk(KERN_ERR "timeout %d\n", timeout);
-			udelay(1);
-		}
-		if (timeout == 0) {
-			comedi_error(dev, "ADC timeout");
-			return -EIO;
-		}
-
-		data[n] = inw(dev->iobase + AIO12_8_ADC) & 0x0FFF;
+			if (timeout == 0) {
+				dev_err(dev->class_dev, "ADC timeout\n");
+				return -ETIMEDOUT;
+			}
+		} while (!(val & AIO12_8_STATUS_ADC_EOC));
+
+		data[n] = inw(dev->iobase + AIO12_8_ADC_REG) & s->maxdata;
 	}
-	return n;
+
+	return insn->n;
 }
 
 static int aio_aio12_8_ao_read(struct comedi_device *dev,
@@ -136,8 +152,9 @@ static int aio_aio12_8_ao_read(struct comedi_device *dev,
 			       struct comedi_insn *insn, unsigned int *data)
 {
 	struct aio12_8_private *devpriv = dev->private;
+	unsigned int chan = CR_CHAN(insn->chanspec);
+	int val = devpriv->ao_readback[chan];
 	int i;
-	int val = devpriv->ao_readback[CR_CHAN(insn->chanspec)];
 
 	for (i = 0; i < insn->n; i++)
 		data[i] = val;
@@ -149,18 +166,21 @@ static int aio_aio12_8_ao_write(struct comedi_device *dev,
 				struct comedi_insn *insn, unsigned int *data)
 {
 	struct aio12_8_private *devpriv = dev->private;
+	unsigned int chan = CR_CHAN(insn->chanspec);
+	unsigned long port = dev->iobase + AIO12_8_DAC_REG(chan);
+	unsigned int val = 0;
 	int i;
-	int chan = CR_CHAN(insn->chanspec);
-	unsigned long port = dev->iobase + AIO12_8_DAC_0 + (2 * chan);
 
 	/* enable DACs */
-	outb(0x01, dev->iobase + DAC_ENABLE);
+	outb(AIO12_8_DAC_ENABLE_REF_ENA, dev->iobase + AIO12_8_DAC_ENABLE_REG);
 
 	for (i = 0; i < insn->n; i++) {
-		outb(data[i] & 0xFF, port);	/*  LSB */
-		outb((data[i] >> 8) & 0x0F, port + 1);	/*  MSB */
-		devpriv->ao_readback[chan] = data[i];
+		val = data[i];
+		outw(val, port);
 	}
+
+	devpriv->ao_readback[chan] = val;
+
 	return insn->n;
 }
 
@@ -230,7 +250,8 @@ static int aio_aio12_8_attach(struct comedi_device *dev,
 
 	s = dev->subdevices + 2;
 	/* 8255 Digital i/o subdevice */
-	ret = subdev_8255_init(dev, s, NULL, dev->iobase + AIO12_8_DIO_0);
+	iobase = dev->iobase + AIO12_8_8255_BASE_REG;
+	ret = subdev_8255_init(dev, s, NULL, iobase);
 	if (ret)
 		return ret;
 
-- 
1.7.11

