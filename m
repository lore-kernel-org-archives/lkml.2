Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab0DMMzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 08:55:22 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:62241 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab0DMMzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 08:55:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=GcBA8e54Uw+d7nOytkXtp4HcDsRrgJRf9zoi3luQff0uCLzFmT6HUIqyx6i7U0D45U
         y8wHLzUTXXe31VKzSuXSJ/96q0HU3784VKvN2dbn4G6kQJ8gQo6F7iOTj7wFgitnw8KJ
         zSTWPKclPhwG8gatdZ4nVDl1GlViBlCsmqsB0=
From: Maurice Dawson <mauricedawson2699@googlemail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, mithlesh@linsyssoft.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 31/31] Staging: comedi: fix over 80 characters coding style issues in adv_pci_dio.c
Date: Tue, 13 Apr 2010 13:55:07 +0100
Message-Id: <1271163307-3424-1-git-send-email-mauricedawson2699@googlemail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a re-submission of a previous patch to the adv_pci_dio.c file that fixes up over 80 character warnings found by the checkpatch.pl tool

Signed-off-by: Maurice Dawson <mauricedawson2699@googlemail.com>
---
 drivers/staging/comedi/drivers/adv_pci_dio.c |  124 ++++++++++++-------------
 1 files changed, 60 insertions(+), 64 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
index b768ea5..3238e1a 100644
--- a/drivers/staging/comedi/drivers/adv_pci_dio.c
+++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
@@ -63,8 +63,8 @@ enum hw_io_access {
 
 #define MAX_DI_SUBDEVS	2	/* max number of DI subdevices per card */
 #define MAX_DO_SUBDEVS	2	/* max number of DO subdevices per card */
-#define MAX_DIO_SUBDEVG	2
 			/* max number of DIO subdevices group per card */
+#define MAX_DIO_SUBDEVG	2
 
 #define SIZE_8255	   4	/* 8255 IO space length */
 
@@ -78,8 +78,8 @@ enum hw_io_access {
 #define PCI1730_DO	   2	/* W:   Digital output 0-15 */
 #define PCI1733_IDI	   0	/* R:   Isolated digital input  0-31 */
 #define	PCI1730_3_INT_EN	0x08	/* R/W: enable/disable interrupts */
-#define	PCI1730_3_INT_RF	0x0c
 			/* R/W: set falling/raising edge for interrupts */
+#define	PCI1730_3_INT_RF	0x0c
 #define	PCI1730_3_INT_CLR	0x10	/* R/W: clear interrupts */
 #define PCI1734_IDO	   0	/* W:   Isolated digital output 0-31 */
 #define PCI173x_BOARDID	   4	/* R:   Board I/D switch for 1730/3/4 */
@@ -88,8 +88,8 @@ enum hw_io_access {
 #define PCI1736_IDI        0	/* R:   Isolated digital input  0-15 */
 #define PCI1736_IDO        0	/* W:   Isolated digital output 0-15 */
 #define PCI1736_3_INT_EN        0x08	/* R/W: enable/disable interrupts */
-#define PCI1736_3_INT_RF        0x0c
 			/* R/W: set falling/raising edge for interrupts */
+#define PCI1736_3_INT_RF        0x0c
 #define PCI1736_3_INT_CLR       0x10	/* R/W: clear interrupts */
 #define PCI1736_BOARDID    4	/* R:   Board I/D switch for 1736UP */
 #define PCI1736_MAINREG    0	/* Normal register (2) doesn't work */
@@ -151,70 +151,66 @@ enum hw_io_access {
 #define INTCSR3		0x3b
 
 /* PCI-1760 mailbox commands */
-#define CMD_ClearIMB2		0x00
 		/* Clear IMB2 status and return actual DI status in IMB3 */
+#define CMD_ClearIMB2		0x00
 #define CMD_SetRelaysOutput	0x01	/* Set relay output from OMB0 */
 #define CMD_GetRelaysStatus	0x02	/* Get relay status to IMB0 */
-#define CMD_ReadCurrentStatus	0x07
 	/* Read the current status of the register in OMB0, result in IMB0 */
-#define CMD_ReadFirmwareVersion	0x0e
+#define CMD_ReadCurrentStatus	0x07
 			/* Read the firmware ver., result in IMB1.IMB0 */
-#define CMD_ReadHardwareVersion	0x0f
+#define CMD_ReadFirmwareVersion	0x0e
 			/* Read the hardware ver., result in IMB1.IMB0 */
+#define CMD_ReadHardwareVersion	0x0f
+			/* Enable IDI filters based on bits in OMB0 */
 #define CMD_EnableIDIFilters	0x20
-				/* Enable IDI filters based on bits in OMB0 */
+			/* Enable IDI pattern match based on bits in OMB0 */
 #define CMD_EnableIDIPatternMatch 0x21
 			/* Enable IDI pattern match based on bits in OMB0 */
 #define CMD_SetIDIPatternMatch	0x22
-			/* Enable IDI pattern match based on bits in OMB0 */
+			/* Enable IDI counters based on bits in OMB0 */
 #define CMD_EnableIDICounters	0x28
-				/* Enable IDI counters based on bits in OMB0 */
-#define CMD_ResetIDICounters	0x29
 	/* Reset IDI counters based on bits in OMB0 to its reset values */
-
-#define CMD_OverflowIDICounters	0x2a
+#define CMD_ResetIDICounters	0x29
 	/* Enable IDI counters overflow interrupts based on bits in OMB0 */
-
-#define CMD_MatchIntIDICounters	0x2b
+#define CMD_OverflowIDICounters	0x2a
 	/* Enable IDI counters match value interrupts based on bits in OMB0 */
-
-#define CMD_EdgeIDICounters	0x2c
+#define CMD_MatchIntIDICounters	0x2b
 	/* Set IDI up counters count edge (bit=0 - rising, =1 - falling) */
-
-#define CMD_GetIDICntCurValue	0x2f
+#define CMD_EdgeIDICounters	0x2c
 				/* Read IDI{OMB0} up counter current value */
-#define CMD_SetIDI0CntResetValue 0x40
+#define CMD_GetIDICntCurValue	0x2f
 				/* Set IDI0 Counter Reset Value 256*OMB1+OMB0 */
-#define CMD_SetIDI1CntResetValue 0x41
+#define CMD_SetIDI0CntResetValue 0x40
 				/* Set IDI1 Counter Reset Value 256*OMB1+OMB0 */
-#define CMD_SetIDI2CntResetValue 0x42
+#define CMD_SetIDI1CntResetValue 0x41
 				/* Set IDI2 Counter Reset Value 256*OMB1+OMB0 */
-#define CMD_SetIDI3CntResetValue 0x43
+#define CMD_SetIDI2CntResetValue 0x42
 				/* Set IDI3 Counter Reset Value 256*OMB1+OMB0 */
-#define CMD_SetIDI4CntResetValue 0x44
+#define CMD_SetIDI3CntResetValue 0x43
 				/* Set IDI4 Counter Reset Value 256*OMB1+OMB0 */
-#define CMD_SetIDI5CntResetValue 0x45
+#define CMD_SetIDI4CntResetValue 0x44
 				/* Set IDI5 Counter Reset Value 256*OMB1+OMB0 */
-#define CMD_SetIDI6CntResetValue 0x46
+#define CMD_SetIDI5CntResetValue 0x45
 				/* Set IDI6 Counter Reset Value 256*OMB1+OMB0 */
-#define CMD_SetIDI7CntResetValue 0x47
+#define CMD_SetIDI6CntResetValue 0x46
 				/* Set IDI7 Counter Reset Value 256*OMB1+OMB0 */
-#define CMD_SetIDI0CntMatchValue 0x48
+#define CMD_SetIDI7CntResetValue 0x47
 				/* Set IDI0 Counter Match Value 256*OMB1+OMB0 */
-#define CMD_SetIDI1CntMatchValue 0x49
+#define CMD_SetIDI0CntMatchValue 0x48
 				/* Set IDI1 Counter Match Value 256*OMB1+OMB0 */
-#define CMD_SetIDI2CntMatchValue 0x4a
+#define CMD_SetIDI1CntMatchValue 0x49
 				/* Set IDI2 Counter Match Value 256*OMB1+OMB0 */
-#define CMD_SetIDI3CntMatchValue 0x4b
+#define CMD_SetIDI2CntMatchValue 0x4a
 				/* Set IDI3 Counter Match Value 256*OMB1+OMB0 */
-#define CMD_SetIDI4CntMatchValue 0x4c
+#define CMD_SetIDI3CntMatchValue 0x4b
 				/* Set IDI4 Counter Match Value 256*OMB1+OMB0 */
-#define CMD_SetIDI5CntMatchValue 0x4d
+#define CMD_SetIDI4CntMatchValue 0x4c
 				/* Set IDI5 Counter Match Value 256*OMB1+OMB0 */
-#define CMD_SetIDI6CntMatchValue 0x4e
+#define CMD_SetIDI5CntMatchValue 0x4d
 				/* Set IDI6 Counter Match Value 256*OMB1+OMB0 */
-#define CMD_SetIDI7CntMatchValue 0x4f
+#define CMD_SetIDI6CntMatchValue 0x4e
 				/* Set IDI7 Counter Match Value 256*OMB1+OMB0 */
+#define CMD_SetIDI7CntMatchValue 0x4f
 
 #define OMBCMD_RETRY	0x03	/* 3 times try request before error */
 
@@ -225,8 +221,7 @@ static int pci_dio_detach(struct comedi_device *dev);
 struct diosubd_data {
 	int chans;		/* num of chans */
 	int addr;		/* PCI address ofset */
-	int regs;
-		/* number of registers to read or 8255 subdevices */
+	int regs;	/* number of registers to read or 8255 subdevices */
 	unsigned int specflags;	/* addon subdevice flags */
 };
 
@@ -375,12 +370,13 @@ struct pci_dio_private {
 	char GlobalIrqEnabled;		/* 1= any IRQ source is enabled */
 	/* PCI-1760 specific data */
 	unsigned char IDICntEnable;	/* counter's counting enable status */
-	unsigned char IDICntOverEnable;
 			/* counter's overflow interrupts enable status */
+	unsigned char IDICntOverEnable;
+			/* counter's match interrupts enable status */
 	unsigned char IDICntMatchEnable;
-				/* counter's match interrupts enable status */
-	unsigned char IDICntEdge;
 		/* counter's count edge value (bit=0 - rising, =1 - falling) */
+	unsigned char IDICntEdge;
+
 	unsigned short CntResValue[8];	 /* counters' reset value */
 	unsigned short CntMatchValue[8]; /* counters' match interrupt value */
 	unsigned char IDIFiltersEn;    /* IDI's digital filters enable status */
@@ -618,8 +614,8 @@ static int pci1760_insn_cnt_write(struct comedi_device *dev,
 	};
 	unsigned char imb[4];
 
+				/* Set reset value if different */
 	if (devpriv->CntResValue[chan] != (data[0] & 0xffff)) {
-					/* Set reset value if different */
 		ret = pci1760_mbxrequest(dev, omb, imb);
 		if (!ret)
 			return ret;
@@ -632,8 +628,8 @@ static int pci1760_insn_cnt_write(struct comedi_device *dev,
 	if (!ret)
 		return ret;
 
+				/* start counter if it don't run */
 	if (!(bitmask & devpriv->IDICntEnable)) {
-					/* start counter if it don't run */
 		omb[0] = bitmask;
 		omb[2] = CMD_EnableIDICounters;
 		ret = pci1760_mbxrequest(dev, omb, imb);
@@ -669,14 +665,14 @@ static int pci1760_reset(struct comedi_device *dev)
 	devpriv->IDICntEnable = 0;
 
 	omb[0] = 0x00;
-	omb[2] = CMD_OverflowIDICounters;
 				/* disable counters overflow interrupts */
+	omb[2] = CMD_OverflowIDICounters;
 	pci1760_mbxrequest(dev, omb, imb);
 	devpriv->IDICntOverEnable = 0;
 
 	omb[0] = 0x00;
-	omb[2] = CMD_MatchIntIDICounters;
 				/* disable counters match value interrupts */
+	omb[2] = CMD_MatchIntIDICounters;
 	pci1760_mbxrequest(dev, omb, imb);
 	devpriv->IDICntMatchEnable = 0;
 
@@ -697,8 +693,8 @@ static int pci1760_reset(struct comedi_device *dev)
 	}
 
 	omb[0] = 0xff;
-	omb[2] = CMD_ResetIDICounters;
 				/* reset IDI up counters to reset values */
+	omb[2] = CMD_ResetIDICounters;
 	pci1760_mbxrequest(dev, omb, imb);
 
 	omb[0] = 0x00;
@@ -739,12 +735,12 @@ static int pci_dio_reset(struct comedi_device *dev)
 		outb(0, dev->iobase + PCI1730_IDO + 1);
 		/* NO break there! */
 	case TYPE_PCI1733:
+						/* disable interrupts */
 		outb(0, dev->iobase + PCI1730_3_INT_EN);
-							/* disable interrupts */
+						/* clear interrupts */
 		outb(0x0f, dev->iobase + PCI1730_3_INT_CLR);
-							/* clear interrupts */
-		outb(0, dev->iobase + PCI1730_3_INT_RF);
 						/* set rising edge trigger */
+		outb(0, dev->iobase + PCI1730_3_INT_RF);
 		break;
 	case TYPE_PCI1734:
 		outb(0, dev->iobase + PCI1734_IDO);	/* clear outputs */
@@ -752,58 +748,56 @@ static int pci_dio_reset(struct comedi_device *dev)
 		outb(0, dev->iobase + PCI1734_IDO + 2);
 		outb(0, dev->iobase + PCI1734_IDO + 3);
 		break;
-
 	case TYPE_PCI1736:
 		outb(0, dev->iobase + PCI1736_IDO);
 		outb(0, dev->iobase + PCI1736_IDO + 1);
+						/* disable interrupts */
 		outb(0, dev->iobase + PCI1736_3_INT_EN);
-							/* disable interrupts */
+						/* clear interrupts */
 		outb(0x0f, dev->iobase + PCI1736_3_INT_CLR);
-							/* clear interrupts */
-		outb(0, dev->iobase + PCI1736_3_INT_RF);
 						/* set rising edge trigger */
+		outb(0, dev->iobase + PCI1736_3_INT_RF);
 		break;
-
 	case TYPE_PCI1750:
 	case TYPE_PCI1751:
-		outb(0x88, dev->iobase + PCI1750_ICR);
 						/* disable & clear interrupts */
+		outb(0x88, dev->iobase + PCI1750_ICR);
 		break;
 	case TYPE_PCI1752:
-		outw(0, dev->iobase + PCI1752_6_CFC);
 					/* disable channel freeze function */
-		outw(0, dev->iobase + PCI1752_IDO);
+		outw(0, dev->iobase + PCI1752_6_CFC);
 						/* clear outputs */
+		outw(0, dev->iobase + PCI1752_IDO);
 		outw(0, dev->iobase + PCI1752_IDO + 2);
 		outw(0, dev->iobase + PCI1752_IDO2);
 		outw(0, dev->iobase + PCI1752_IDO2 + 2);
 		break;
 	case TYPE_PCI1753E:
-		outb(0x88, dev->iobase + PCI1753E_ICR0);
 						/* disable & clear interrupts */
+		outb(0x88, dev->iobase + PCI1753E_ICR0);
 		outb(0x80, dev->iobase + PCI1753E_ICR1);
 		outb(0x80, dev->iobase + PCI1753E_ICR2);
 		outb(0x80, dev->iobase + PCI1753E_ICR3);
 		/* NO break there! */
 	case TYPE_PCI1753:
-		outb(0x88, dev->iobase + PCI1753_ICR0);
 						/* disable & clear interrupts */
+		outb(0x88, dev->iobase + PCI1753_ICR0);
 		outb(0x80, dev->iobase + PCI1753_ICR1);
 		outb(0x80, dev->iobase + PCI1753_ICR2);
 		outb(0x80, dev->iobase + PCI1753_ICR3);
 		break;
 	case TYPE_PCI1754:
-		outw(0x08, dev->iobase + PCI1754_6_ICR0);
 						/* disable & clear interrupts */
+		outw(0x08, dev->iobase + PCI1754_6_ICR0);
 		outw(0x08, dev->iobase + PCI1754_6_ICR1);
 		outw(0x08, dev->iobase + PCI1754_ICR2);
 		outw(0x08, dev->iobase + PCI1754_ICR3);
 		break;
 	case TYPE_PCI1756:
-		outw(0, dev->iobase + PCI1752_6_CFC);
 					/* disable channel freeze function */
-		outw(0x08, dev->iobase + PCI1754_6_ICR0);
+		outw(0, dev->iobase + PCI1752_6_CFC);
 						/* disable & clear interrupts */
+		outw(0x08, dev->iobase + PCI1754_6_ICR0);
 		outw(0x08, dev->iobase + PCI1754_6_ICR1);
 		outw(0, dev->iobase + PCI1756_IDO);	/* clear outputs */
 		outw(0, dev->iobase + PCI1756_IDO + 2);
@@ -812,8 +806,8 @@ static int pci_dio_reset(struct comedi_device *dev)
 		pci1760_reset(dev);
 		break;
 	case TYPE_PCI1762:
-		outw(0x0101, dev->iobase + PCI1762_ICR);
 						/* disable & clear interrupts */
+		outw(0x0101, dev->iobase + PCI1762_ICR);
 		break;
 	}
 
@@ -1102,8 +1096,10 @@ static int pci_dio_detach(struct comedi_device *dev)
 		if (devpriv->valid)
 			pci_dio_reset(dev);
 
-		/* This shows the silliness of using this kind of
-		 * scheme for numbering subdevices.  Don't do it.  --ds */
+		/*
+		 * This shows the silliness of using this kind of
+		 * scheme for numbering subdevices.  Don't do it.  --ds
+		 */
 		subdev = 0;
 		for (i = 0; i < MAX_DI_SUBDEVS; i++) {
 			if (this_board->sdi[i].chans)
-- 
1.6.3.3

