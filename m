Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab0DGNM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 09:12:29 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50042 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757884Ab0DGNM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 09:12:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=DArZiWZ2CMoHnUfi7nUONtbE24NJYrvrTTO/u3vBEezxN0OlXxP0nuc5Sx7BwoNm+T
         LveWQb5ts/RUEGFc+LxQ5HG4m0DW2aiqBno01A7y8DkM/Xbhyj88q2c0CQG68qjhpTXg
         4q8iFVUw1QRLJkZ3lN2gETnnO99huap4RTgA8=
From: Maurice Dawson <mauricedawson2699@googlemail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, mithlesh@linsyssoft.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 27/27] Staging: comedi: fix brace, print(k), indent and over 80 characters coding style issues in adv_pci_dio.c
Date: Wed,  7 Apr 2010 14:12:05 +0100
Message-Id: <1270645926-3357-1-git-send-email-mauricedawson2699@googlemail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the adv_pci_dio.c file that fixes up brace, print(k), indent and over 80 character warnings found by the checkpatch.pl tool

Signed-off-by: Maurice Dawson <mauricedawson2699@googlemail.com>
---
 drivers/staging/comedi/drivers/adv_pci_dio.c |  399 +++++++++++++++-----------
 1 files changed, 226 insertions(+), 173 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
index 61d35fe..b768ea5 100644
--- a/drivers/staging/comedi/drivers/adv_pci_dio.c
+++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
@@ -8,8 +8,8 @@
 /*
 Driver: adv_pci_dio
 Description: Advantech PCI-1730, PCI-1733, PCI-1734, PCI-1736UP,
-             PCI-1750, PCI-1751, PCI-1752, PCI-1753/E, PCI-1754,
-             PCI-1756, PCI-1762
+		PCI-1750, PCI-1751, PCI-1752, PCI-1753/E, PCI-1754,
+		PCI-1756, PCI-1762
 Author: Michal Dobes <dobes@tesnet.cz>
 Devices: [Advantech] PCI-1730 (adv_pci_dio), PCI-1733,
   PCI-1734, PCI-1736UP, PCI-1750,
@@ -24,9 +24,8 @@ This driver supports now only insn interface for DI/DO/DIO.
 Configuration options:
   [0] - PCI bus of device (optional)
   [1] - PCI slot of device (optional)
-          If bus/slot is not specified, the first available PCI
-          device will be used.
-
+	If bus/slot is not specified, the first available PCI
+	device will be used.
 */
 
 #include "../comedidev.h"
@@ -64,41 +63,44 @@ enum hw_io_access {
 
 #define MAX_DI_SUBDEVS	2	/* max number of DI subdevices per card */
 #define MAX_DO_SUBDEVS	2	/* max number of DO subdevices per card */
-#define MAX_DIO_SUBDEVG	2	/* max number of DIO subdevices group per card */
+#define MAX_DIO_SUBDEVG	2
+			/* max number of DIO subdevices group per card */
 
 #define SIZE_8255	   4	/* 8255 IO space length */
 
 #define PCIDIO_MAINREG	   2	/* main I/O region for all Advantech cards? */
 
 /* Register offset definitions */
-/*  Advantech PCI-1730/3/4 */
+/* Advantech PCI-1730/3/4 */
 #define PCI1730_IDI	   0	/* R:   Isolated digital input  0-15 */
 #define PCI1730_IDO	   0	/* W:   Isolated digital output 0-15 */
 #define PCI1730_DI	   2	/* R:   Digital input  0-15 */
 #define PCI1730_DO	   2	/* W:   Digital output 0-15 */
 #define PCI1733_IDI	   0	/* R:   Isolated digital input  0-31 */
 #define	PCI1730_3_INT_EN	0x08	/* R/W: enable/disable interrupts */
-#define	PCI1730_3_INT_RF	0x0c	/* R/W: set falling/raising edge for interrupts */
+#define	PCI1730_3_INT_RF	0x0c
+			/* R/W: set falling/raising edge for interrupts */
 #define	PCI1730_3_INT_CLR	0x10	/* R/W: clear interrupts */
 #define PCI1734_IDO	   0	/* W:   Isolated digital output 0-31 */
 #define PCI173x_BOARDID	   4	/* R:   Board I/D switch for 1730/3/4 */
 
-/*  Advantech PCI-1736UP */
+/* Advantech PCI-1736UP */
 #define PCI1736_IDI        0	/* R:   Isolated digital input  0-15 */
 #define PCI1736_IDO        0	/* W:   Isolated digital output 0-15 */
 #define PCI1736_3_INT_EN        0x08	/* R/W: enable/disable interrupts */
-#define PCI1736_3_INT_RF        0x0c	/* R/W: set falling/raising edge for interrupts */
+#define PCI1736_3_INT_RF        0x0c
+			/* R/W: set falling/raising edge for interrupts */
 #define PCI1736_3_INT_CLR       0x10	/* R/W: clear interrupts */
 #define PCI1736_BOARDID    4	/* R:   Board I/D switch for 1736UP */
 #define PCI1736_MAINREG    0	/* Normal register (2) doesn't work */
 
-/*  Advantech PCI-1750 */
+/* Advantech PCI-1750 */
 #define PCI1750_IDI	   0	/* R:   Isolated digital input  0-15 */
 #define PCI1750_IDO	   0	/* W:   Isolated digital output 0-15 */
 #define PCI1750_ICR	  32	/* W:   Interrupt control register */
 #define PCI1750_ISR	  32	/* R:   Interrupt status register */
 
-/*  Advantech PCI-1751/3/3E */
+/* Advantech PCI-1751/3/3E */
 #define PCI1751_DIO	   0	/* R/W: begin of 8255 registers block */
 #define PCI1751_ICR	  32	/* W:   Interrupt control register */
 #define PCI1751_ISR	  32	/* R:   Interrupt status register */
@@ -113,7 +115,7 @@ enum hw_io_access {
 #define PCI1753E_ICR2	  50	/* R/W: Interrupt control register group 2 */
 #define PCI1753E_ICR3	  51	/* R/W: Interrupt control register group 3 */
 
-/*  Advantech PCI-1752/4/6 */
+/* Advantech PCI-1752/4/6 */
 #define PCI1752_IDO	   0	/* R/W: Digital output  0-31 */
 #define PCI1752_IDO2	   4	/* R/W: Digital output 32-63 */
 #define PCI1754_IDI	   0	/* R:   Digital input   0-31 */
@@ -127,14 +129,14 @@ enum hw_io_access {
 #define PCI1752_6_CFC	0x12	/* R/W: set/read channel freeze function */
 #define PCI175x_BOARDID	0x10	/* R:   Board I/D switch for 1752/4/6 */
 
-/*  Advantech PCI-1762 registers */
+/* Advantech PCI-1762 registers */
 #define PCI1762_RO	   0	/* R/W: Relays status/output */
 #define PCI1762_IDI	   2	/* R:   Isolated input status */
 #define PCI1762_BOARDID	   4	/* R:   Board I/D switch */
 #define PCI1762_ICR	   6	/* W:   Interrupt control register */
 #define PCI1762_ISR	   6	/* R:   Interrupt status register */
 
-/*  Advantech PCI-1760 registers */
+/* Advantech PCI-1760 registers */
 #define OMB0		0x0c	/* W:   Mailbox outgoing registers */
 #define OMB1		0x0d
 #define OMB2		0x0e
@@ -148,38 +150,71 @@ enum hw_io_access {
 #define INTCSR2		0x3a
 #define INTCSR3		0x3b
 
-/*  PCI-1760 mailbox commands */
-#define CMD_ClearIMB2		0x00	/* Clear IMB2 status and return actaul DI status in IMB3 */
+/* PCI-1760 mailbox commands */
+#define CMD_ClearIMB2		0x00
+		/* Clear IMB2 status and return actual DI status in IMB3 */
 #define CMD_SetRelaysOutput	0x01	/* Set relay output from OMB0 */
 #define CMD_GetRelaysStatus	0x02	/* Get relay status to IMB0 */
-#define CMD_ReadCurrentStatus	0x07	/* Read the current status of the register in OMB0, result in IMB0 */
-#define CMD_ReadFirmwareVersion	0x0e	/* Read the firmware ver., result in IMB1.IMB0 */
-#define CMD_ReadHardwareVersion	0x0f	/* Read the hardware ver., result in IMB1.IMB0 */
-#define CMD_EnableIDIFilters	0x20	/* Enable IDI filters based on bits in OMB0 */
-#define CMD_EnableIDIPatternMatch 0x21	/* Enable IDI pattern match based on bits in OMB0 */
-#define CMD_SetIDIPatternMatch	0x22	/* Enable IDI pattern match based on bits in OMB0 */
-#define CMD_EnableIDICounters	0x28	/* Enable IDI counters based on bits in OMB0 */
-#define CMD_ResetIDICounters	0x29	/* Reset IDI counters based on bits in OMB0 to its reset values */
-#define CMD_OverflowIDICounters	0x2a	/* Enable IDI counters overflow interrupts  based on bits in OMB0 */
-#define CMD_MatchIntIDICounters	0x2b	/* Enable IDI counters match value interrupts  based on bits in OMB0 */
-#define CMD_EdgeIDICounters	0x2c	/* Set IDI up counters count edge (bit=0 - rising, =1 - falling) */
-#define CMD_GetIDICntCurValue	0x2f	/* Read IDI{OMB0} up counter current value */
-#define CMD_SetIDI0CntResetValue 0x40	/* Set IDI0 Counter Reset Value 256*OMB1+OMB0 */
-#define CMD_SetIDI1CntResetValue 0x41	/* Set IDI1 Counter Reset Value 256*OMB1+OMB0 */
-#define CMD_SetIDI2CntResetValue 0x42	/* Set IDI2 Counter Reset Value 256*OMB1+OMB0 */
-#define CMD_SetIDI3CntResetValue 0x43	/* Set IDI3 Counter Reset Value 256*OMB1+OMB0 */
-#define CMD_SetIDI4CntResetValue 0x44	/* Set IDI4 Counter Reset Value 256*OMB1+OMB0 */
-#define CMD_SetIDI5CntResetValue 0x45	/* Set IDI5 Counter Reset Value 256*OMB1+OMB0 */
-#define CMD_SetIDI6CntResetValue 0x46	/* Set IDI6 Counter Reset Value 256*OMB1+OMB0 */
-#define CMD_SetIDI7CntResetValue 0x47	/* Set IDI7 Counter Reset Value 256*OMB1+OMB0 */
-#define CMD_SetIDI0CntMatchValue 0x48	/* Set IDI0 Counter Match Value 256*OMB1+OMB0 */
-#define CMD_SetIDI1CntMatchValue 0x49	/* Set IDI1 Counter Match Value 256*OMB1+OMB0 */
-#define CMD_SetIDI2CntMatchValue 0x4a	/* Set IDI2 Counter Match Value 256*OMB1+OMB0 */
-#define CMD_SetIDI3CntMatchValue 0x4b	/* Set IDI3 Counter Match Value 256*OMB1+OMB0 */
-#define CMD_SetIDI4CntMatchValue 0x4c	/* Set IDI4 Counter Match Value 256*OMB1+OMB0 */
-#define CMD_SetIDI5CntMatchValue 0x4d	/* Set IDI5 Counter Match Value 256*OMB1+OMB0 */
-#define CMD_SetIDI6CntMatchValue 0x4e	/* Set IDI6 Counter Match Value 256*OMB1+OMB0 */
-#define CMD_SetIDI7CntMatchValue 0x4f	/* Set IDI7 Counter Match Value 256*OMB1+OMB0 */
+#define CMD_ReadCurrentStatus	0x07
+	/* Read the current status of the register in OMB0, result in IMB0 */
+#define CMD_ReadFirmwareVersion	0x0e
+			/* Read the firmware ver., result in IMB1.IMB0 */
+#define CMD_ReadHardwareVersion	0x0f
+			/* Read the hardware ver., result in IMB1.IMB0 */
+#define CMD_EnableIDIFilters	0x20
+				/* Enable IDI filters based on bits in OMB0 */
+#define CMD_EnableIDIPatternMatch 0x21
+			/* Enable IDI pattern match based on bits in OMB0 */
+#define CMD_SetIDIPatternMatch	0x22
+			/* Enable IDI pattern match based on bits in OMB0 */
+#define CMD_EnableIDICounters	0x28
+				/* Enable IDI counters based on bits in OMB0 */
+#define CMD_ResetIDICounters	0x29
+	/* Reset IDI counters based on bits in OMB0 to its reset values */
+
+#define CMD_OverflowIDICounters	0x2a
+	/* Enable IDI counters overflow interrupts based on bits in OMB0 */
+
+#define CMD_MatchIntIDICounters	0x2b
+	/* Enable IDI counters match value interrupts based on bits in OMB0 */
+
+#define CMD_EdgeIDICounters	0x2c
+	/* Set IDI up counters count edge (bit=0 - rising, =1 - falling) */
+
+#define CMD_GetIDICntCurValue	0x2f
+				/* Read IDI{OMB0} up counter current value */
+#define CMD_SetIDI0CntResetValue 0x40
+				/* Set IDI0 Counter Reset Value 256*OMB1+OMB0 */
+#define CMD_SetIDI1CntResetValue 0x41
+				/* Set IDI1 Counter Reset Value 256*OMB1+OMB0 */
+#define CMD_SetIDI2CntResetValue 0x42
+				/* Set IDI2 Counter Reset Value 256*OMB1+OMB0 */
+#define CMD_SetIDI3CntResetValue 0x43
+				/* Set IDI3 Counter Reset Value 256*OMB1+OMB0 */
+#define CMD_SetIDI4CntResetValue 0x44
+				/* Set IDI4 Counter Reset Value 256*OMB1+OMB0 */
+#define CMD_SetIDI5CntResetValue 0x45
+				/* Set IDI5 Counter Reset Value 256*OMB1+OMB0 */
+#define CMD_SetIDI6CntResetValue 0x46
+				/* Set IDI6 Counter Reset Value 256*OMB1+OMB0 */
+#define CMD_SetIDI7CntResetValue 0x47
+				/* Set IDI7 Counter Reset Value 256*OMB1+OMB0 */
+#define CMD_SetIDI0CntMatchValue 0x48
+				/* Set IDI0 Counter Match Value 256*OMB1+OMB0 */
+#define CMD_SetIDI1CntMatchValue 0x49
+				/* Set IDI1 Counter Match Value 256*OMB1+OMB0 */
+#define CMD_SetIDI2CntMatchValue 0x4a
+				/* Set IDI2 Counter Match Value 256*OMB1+OMB0 */
+#define CMD_SetIDI3CntMatchValue 0x4b
+				/* Set IDI3 Counter Match Value 256*OMB1+OMB0 */
+#define CMD_SetIDI4CntMatchValue 0x4c
+				/* Set IDI4 Counter Match Value 256*OMB1+OMB0 */
+#define CMD_SetIDI5CntMatchValue 0x4d
+				/* Set IDI5 Counter Match Value 256*OMB1+OMB0 */
+#define CMD_SetIDI6CntMatchValue 0x4e
+				/* Set IDI6 Counter Match Value 256*OMB1+OMB0 */
+#define CMD_SetIDI7CntMatchValue 0x4f
+				/* Set IDI7 Counter Match Value 256*OMB1+OMB0 */
 
 #define OMBCMD_RETRY	0x03	/* 3 times try request before error */
 
@@ -188,22 +223,23 @@ static int pci_dio_attach(struct comedi_device *dev,
 static int pci_dio_detach(struct comedi_device *dev);
 
 struct diosubd_data {
-	int chans;		/*  num of chans */
-	int addr;		/*  PCI address ofset */
-	int regs;		/*  number of registers to read or 8255 subdevices */
-	unsigned int specflags;	/*  addon subdevice flags */
+	int chans;		/* num of chans */
+	int addr;		/* PCI address ofset */
+	int regs;
+		/* number of registers to read or 8255 subdevices */
+	unsigned int specflags;	/* addon subdevice flags */
 };
 
 struct dio_boardtype {
-	const char *name;	/*  board name */
-	int vendor_id;		/*  vendor/device PCI ID */
+	const char *name;	/* board name */
+	int vendor_id;		/* vendor/device PCI ID */
 	int device_id;
-	int main_pci_region;	/*  main I/O PCI region */
+	int main_pci_region;	/* main I/O PCI region */
 	enum hw_cards_id cardtype;
-	struct diosubd_data sdi[MAX_DI_SUBDEVS];	/*  DI chans */
-	struct diosubd_data sdo[MAX_DO_SUBDEVS];	/*  DO chans */
-	struct diosubd_data sdio[MAX_DIO_SUBDEVG];	/*  DIO 8255 chans */
-	struct diosubd_data boardid;	/*  card supports board ID switch */
+	struct diosubd_data sdi[MAX_DI_SUBDEVS];	/* DI chans */
+	struct diosubd_data sdo[MAX_DO_SUBDEVS];	/* DO chans */
+	struct diosubd_data sdio[MAX_DIO_SUBDEVG];	/* DIO 8255 chans */
+	struct diosubd_data boardid;	/* card supports board ID switch */
 	enum hw_io_access io_access;
 };
 
@@ -229,95 +265,95 @@ MODULE_DEVICE_TABLE(pci, pci_dio_pci_table);
 static const struct dio_boardtype boardtypes[] = {
 	{"pci1730", PCI_VENDOR_ID_ADVANTECH, 0x1730, PCIDIO_MAINREG,
 	 TYPE_PCI1730,
-	 {{16, PCI1730_DI, 2, 0}, {16, PCI1730_IDI, 2, 0}},
-	 {{16, PCI1730_DO, 2, 0}, {16, PCI1730_IDO, 2, 0}},
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
+	 {{16, PCI1730_DI, 2, 0}, {16, PCI1730_IDI, 2, 0} },
+	 {{16, PCI1730_DO, 2, 0}, {16, PCI1730_IDO, 2, 0} },
+	 {{0, 0, 0, 0}, {0, 0, 0, 0} },
 	 {4, PCI173x_BOARDID, 1, SDF_INTERNAL},
 	 IO_8b,
 	 },
 	{"pci1733", PCI_VENDOR_ID_ADVANTECH, 0x1733, PCIDIO_MAINREG,
 	 TYPE_PCI1733,
-	 {{0, 0, 0, 0}, {32, PCI1733_IDI, 4, 0}},
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
+	 {{0, 0, 0, 0}, {32, PCI1733_IDI, 4, 0} },
+	 {{0, 0, 0, 0}, {0, 0, 0, 0} },
+	 {{0, 0, 0, 0}, {0, 0, 0, 0} },
 	 {4, PCI173x_BOARDID, 1, SDF_INTERNAL},
 	 IO_8b},
 	{"pci1734", PCI_VENDOR_ID_ADVANTECH, 0x1734, PCIDIO_MAINREG,
 	 TYPE_PCI1734,
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
-	 {{0, 0, 0, 0}, {32, PCI1734_IDO, 4, 0}},
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
+	 {{0, 0, 0, 0}, {0, 0, 0, 0} },
+	 {{0, 0, 0, 0}, {32, PCI1734_IDO, 4, 0} },
+	 {{0, 0, 0, 0}, {0, 0, 0, 0} },
 	 {4, PCI173x_BOARDID, 1, SDF_INTERNAL},
 	 IO_8b},
 	{"pci1736", PCI_VENDOR_ID_ADVANTECH, 0x1736, PCI1736_MAINREG,
 	 TYPE_PCI1736,
-	 {{0, 0, 0, 0}, {16, PCI1736_IDI, 2, 0}},
-	 {{0, 0, 0, 0}, {16, PCI1736_IDO, 2, 0}},
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
+	 {{0, 0, 0, 0}, {16, PCI1736_IDI, 2, 0} },
+	 {{0, 0, 0, 0}, {16, PCI1736_IDO, 2, 0} },
+	 {{0, 0, 0, 0}, {0, 0, 0, 0} },
 	 {4, PCI1736_BOARDID, 1, SDF_INTERNAL},
 	 IO_8b,
 	 },
 	{"pci1750", PCI_VENDOR_ID_ADVANTECH, 0x1750, PCIDIO_MAINREG,
 	 TYPE_PCI1750,
-	 {{0, 0, 0, 0}, {16, PCI1750_IDI, 2, 0}},
-	 {{0, 0, 0, 0}, {16, PCI1750_IDO, 2, 0}},
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
+	 {{0, 0, 0, 0}, {16, PCI1750_IDI, 2, 0} },
+	 {{0, 0, 0, 0}, {16, PCI1750_IDO, 2, 0} },
+	 {{0, 0, 0, 0}, {0, 0, 0, 0} },
 	 {0, 0, 0, 0},
 	 IO_8b},
 	{"pci1751", PCI_VENDOR_ID_ADVANTECH, 0x1751, PCIDIO_MAINREG,
 	 TYPE_PCI1751,
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
-	 {{48, PCI1751_DIO, 2, 0}, {0, 0, 0, 0}},
+	 {{0, 0, 0, 0}, {0, 0, 0, 0} },
+	 {{0, 0, 0, 0}, {0, 0, 0, 0} },
+	 {{48, PCI1751_DIO, 2, 0}, {0, 0, 0, 0} },
 	 {0, 0, 0, 0},
 	 IO_8b},
 	{"pci1752", PCI_VENDOR_ID_ADVANTECH, 0x1752, PCIDIO_MAINREG,
 	 TYPE_PCI1752,
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
-	 {{32, PCI1752_IDO, 2, 0}, {32, PCI1752_IDO2, 2, 0}},
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
+	 {{0, 0, 0, 0}, {0, 0, 0, 0} },
+	 {{32, PCI1752_IDO, 2, 0}, {32, PCI1752_IDO2, 2, 0} },
+	 {{0, 0, 0, 0}, {0, 0, 0, 0} },
 	 {4, PCI175x_BOARDID, 1, SDF_INTERNAL},
 	 IO_16b},
 	{"pci1753", PCI_VENDOR_ID_ADVANTECH, 0x1753, PCIDIO_MAINREG,
 	 TYPE_PCI1753,
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
-	 {{96, PCI1753_DIO, 4, 0}, {0, 0, 0, 0}},
+	 {{0, 0, 0, 0}, {0, 0, 0, 0} },
+	 {{0, 0, 0, 0}, {0, 0, 0, 0} },
+	 {{96, PCI1753_DIO, 4, 0}, {0, 0, 0, 0} },
 	 {0, 0, 0, 0},
 	 IO_8b},
 	{"pci1753e", PCI_VENDOR_ID_ADVANTECH, 0x1753, PCIDIO_MAINREG,
 	 TYPE_PCI1753E,
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
-	 {{96, PCI1753_DIO, 4, 0}, {96, PCI1753E_DIO, 4, 0}},
+	 {{0, 0, 0, 0}, {0, 0, 0, 0} },
+	 {{0, 0, 0, 0}, {0, 0, 0, 0} },
+	 {{96, PCI1753_DIO, 4, 0}, {96, PCI1753E_DIO, 4, 0} },
 	 {0, 0, 0, 0},
 	 IO_8b},
 	{"pci1754", PCI_VENDOR_ID_ADVANTECH, 0x1754, PCIDIO_MAINREG,
 	 TYPE_PCI1754,
-	 {{32, PCI1754_IDI, 2, 0}, {32, PCI1754_IDI2, 2, 0}},
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
+	 {{32, PCI1754_IDI, 2, 0}, {32, PCI1754_IDI2, 2, 0} },
+	 {{0, 0, 0, 0}, {0, 0, 0, 0} },
+	 {{0, 0, 0, 0}, {0, 0, 0, 0} },
 	 {4, PCI175x_BOARDID, 1, SDF_INTERNAL},
 	 IO_16b},
 	{"pci1756", PCI_VENDOR_ID_ADVANTECH, 0x1756, PCIDIO_MAINREG,
 	 TYPE_PCI1756,
-	 {{0, 0, 0, 0}, {32, PCI1756_IDI, 2, 0}},
-	 {{0, 0, 0, 0}, {32, PCI1756_IDO, 2, 0}},
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
+	 {{0, 0, 0, 0}, {32, PCI1756_IDI, 2, 0} },
+	 {{0, 0, 0, 0}, {32, PCI1756_IDO, 2, 0} },
+	 {{0, 0, 0, 0}, {0, 0, 0, 0} },
 	 {4, PCI175x_BOARDID, 1, SDF_INTERNAL},
 	 IO_16b},
 	{"pci1760", PCI_VENDOR_ID_ADVANTECH, 0x1760, 0,
 	 TYPE_PCI1760,
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},	/*  This card have own setup work */
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
+	 {{0, 0, 0, 0}, {0, 0, 0, 0} },	/* This card has own setup work */
+	 {{0, 0, 0, 0}, {0, 0, 0, 0} },
+	 {{0, 0, 0, 0}, {0, 0, 0, 0} },
 	 {0, 0, 0, 0},
 	 IO_8b},
 	{"pci1762", PCI_VENDOR_ID_ADVANTECH, 0x1762, PCIDIO_MAINREG,
 	 TYPE_PCI1762,
-	 {{0, 0, 0, 0}, {16, PCI1762_IDI, 1, 0}},
-	 {{0, 0, 0, 0}, {16, PCI1762_RO, 1, 0}},
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
+	 {{0, 0, 0, 0}, {16, PCI1762_IDI, 1, 0} },
+	 {{0, 0, 0, 0}, {16, PCI1762_RO, 1, 0} },
+	 {{0, 0, 0, 0}, {0, 0, 0, 0} },
 	 {4, PCI1762_BOARDID, 1, SDF_INTERNAL},
 	 IO_16b}
 };
@@ -332,26 +368,29 @@ static struct comedi_driver driver_pci_dio = {
 };
 
 struct pci_dio_private {
-	struct pci_dio_private *prev;	/*  previous private struct */
-	struct pci_dio_private *next;	/*  next private struct */
-	struct pci_dev *pcidev;	/*  pointer to board's pci_dev */
-	char valid;		/*  card is usable */
-	char GlobalIrqEnabled;	/*  1= any IRQ source is enabled */
-	/*  PCI-1760 specific data */
-	unsigned char IDICntEnable;	/*  counter's counting enable status */
-	unsigned char IDICntOverEnable;	/*  counter's overflow interrupts enable status */
-	unsigned char IDICntMatchEnable;	/*  counter's match interrupts enable status */
-	unsigned char IDICntEdge;	/*  counter's count edge value (bit=0 - rising, =1 - falling) */
-	unsigned short CntResValue[8];	/*  counters' reset value */
-	unsigned short CntMatchValue[8];	/*  counters' match interrupt value */
-	unsigned char IDIFiltersEn;	/*  IDI's digital filters enable status */
-	unsigned char IDIPatMatchEn;	/*  IDI's pattern match enable status */
-	unsigned char IDIPatMatchValue;	/*  IDI's pattern match value */
-	unsigned short IDIFiltrLow[8];	/*  IDI's filter value low signal */
-	unsigned short IDIFiltrHigh[8];	/*  IDI's filter value high signal */
+	struct pci_dio_private *prev;	/* previous private struct */
+	struct pci_dio_private *next;	/* next private struct */
+	struct pci_dev *pcidev;		/* pointer to board's pci_dev */
+	char valid;			/* card is usable */
+	char GlobalIrqEnabled;		/* 1= any IRQ source is enabled */
+	/* PCI-1760 specific data */
+	unsigned char IDICntEnable;	/* counter's counting enable status */
+	unsigned char IDICntOverEnable;
+			/* counter's overflow interrupts enable status */
+	unsigned char IDICntMatchEnable;
+				/* counter's match interrupts enable status */
+	unsigned char IDICntEdge;
+		/* counter's count edge value (bit=0 - rising, =1 - falling) */
+	unsigned short CntResValue[8];	 /* counters' reset value */
+	unsigned short CntMatchValue[8]; /* counters' match interrupt value */
+	unsigned char IDIFiltersEn;    /* IDI's digital filters enable status */
+	unsigned char IDIPatMatchEn;	 /* IDI's pattern match enable status */
+	unsigned char IDIPatMatchValue;	 /* IDI's pattern match value */
+	unsigned short IDIFiltrLow[8];	 /* IDI's filter value low signal */
+	unsigned short IDIFiltrHigh[8];	 /* IDI's filter value high signal */
 };
 
-static struct pci_dio_private *pci_priv = NULL;	/* list of allocated cards */
+static struct pci_dio_private *pci_priv;	/* list of allocated cards */
 
 #define devpriv ((struct pci_dio_private *)dev->private)
 #define this_board ((const struct dio_boardtype *)dev->board_ptr)
@@ -367,9 +406,8 @@ static int pci_dio_insn_bits_di_b(struct comedi_device *dev,
 	int i;
 
 	data[1] = 0;
-	for (i = 0; i < d->regs; i++) {
+	for (i = 0; i < d->regs; i++)
 		data[1] |= inb(dev->iobase + d->addr + i) << (8 * i);
-	}
 
 	return 2;
 }
@@ -482,8 +520,8 @@ static int pci1760_mbxrequest(struct comedi_device *dev,
 			      unsigned char *omb, unsigned char *imb)
 {
 	if (omb[2] == CMD_ClearIMB2) {
-		comedi_error(dev,
-			     "bug! this function should not be used for CMD_ClearIMB2 command");
+		comedi_error(dev, "bug! this function should not be used for "
+						       "CMD_ClearIMB2 command");
 		return -EINVAL;
 	}
 	if (inb(dev->iobase + IMB2) == omb[2]) {
@@ -580,20 +618,22 @@ static int pci1760_insn_cnt_write(struct comedi_device *dev,
 	};
 	unsigned char imb[4];
 
-	if (devpriv->CntResValue[chan] != (data[0] & 0xffff)) {	/*  Set reset value if different */
+	if (devpriv->CntResValue[chan] != (data[0] & 0xffff)) {
+					/* Set reset value if different */
 		ret = pci1760_mbxrequest(dev, omb, imb);
 		if (!ret)
 			return ret;
 		devpriv->CntResValue[chan] = data[0] & 0xffff;
 	}
 
-	omb[0] = bitmask;	/*  reset counter to it reset value */
+	omb[0] = bitmask;	/* reset counter to it reset value */
 	omb[2] = CMD_ResetIDICounters;
 	ret = pci1760_mbxrequest(dev, omb, imb);
 	if (!ret)
 		return ret;
 
-	if (!(bitmask & devpriv->IDICntEnable)) {	/*  start counter if it don't run */
+	if (!(bitmask & devpriv->IDICntEnable)) {
+					/* start counter if it don't run */
 		omb[0] = bitmask;
 		omb[2] = CMD_EnableIDICounters;
 		ret = pci1760_mbxrequest(dev, omb, imb);
@@ -613,34 +653,36 @@ static int pci1760_reset(struct comedi_device *dev)
 	unsigned char omb[4] = { 0x00, 0x00, 0x00, 0x00 };
 	unsigned char imb[4];
 
-	outb(0, dev->iobase + INTCSR0);	/*  disable IRQ */
+	outb(0, dev->iobase + INTCSR0);	/* disable IRQ */
 	outb(0, dev->iobase + INTCSR1);
 	outb(0, dev->iobase + INTCSR2);
 	outb(0, dev->iobase + INTCSR3);
 	devpriv->GlobalIrqEnabled = 0;
 
 	omb[0] = 0x00;
-	omb[2] = CMD_SetRelaysOutput;	/*  reset relay outputs */
+	omb[2] = CMD_SetRelaysOutput;	/* reset relay outputs */
 	pci1760_mbxrequest(dev, omb, imb);
 
 	omb[0] = 0x00;
-	omb[2] = CMD_EnableIDICounters;	/*  disable IDI up counters */
+	omb[2] = CMD_EnableIDICounters;	/* disable IDI up counters */
 	pci1760_mbxrequest(dev, omb, imb);
 	devpriv->IDICntEnable = 0;
 
 	omb[0] = 0x00;
-	omb[2] = CMD_OverflowIDICounters;	/*  disable counters overflow interrupts */
+	omb[2] = CMD_OverflowIDICounters;
+				/* disable counters overflow interrupts */
 	pci1760_mbxrequest(dev, omb, imb);
 	devpriv->IDICntOverEnable = 0;
 
 	omb[0] = 0x00;
-	omb[2] = CMD_MatchIntIDICounters;	/*  disable counters match value interrupts */
+	omb[2] = CMD_MatchIntIDICounters;
+				/* disable counters match value interrupts */
 	pci1760_mbxrequest(dev, omb, imb);
 	devpriv->IDICntMatchEnable = 0;
 
 	omb[0] = 0x00;
 	omb[1] = 0x80;
-	for (i = 0; i < 8; i++) {	/*  set IDI up counters match value */
+	for (i = 0; i < 8; i++) {	/* set IDI up counters match value */
 		omb[2] = CMD_SetIDI0CntMatchValue + i;
 		pci1760_mbxrequest(dev, omb, imb);
 		devpriv->CntMatchValue[i] = 0x8000;
@@ -648,33 +690,34 @@ static int pci1760_reset(struct comedi_device *dev)
 
 	omb[0] = 0x00;
 	omb[1] = 0x00;
-	for (i = 0; i < 8; i++) {	/*  set IDI up counters reset value */
+	for (i = 0; i < 8; i++) {	/* set IDI up counters reset value */
 		omb[2] = CMD_SetIDI0CntResetValue + i;
 		pci1760_mbxrequest(dev, omb, imb);
 		devpriv->CntResValue[i] = 0x0000;
 	}
 
 	omb[0] = 0xff;
-	omb[2] = CMD_ResetIDICounters;	/*  reset IDI up counters to reset values */
+	omb[2] = CMD_ResetIDICounters;
+				/* reset IDI up counters to reset values */
 	pci1760_mbxrequest(dev, omb, imb);
 
 	omb[0] = 0x00;
-	omb[2] = CMD_EdgeIDICounters;	/*  set IDI up counters count edge */
+	omb[2] = CMD_EdgeIDICounters;	/* set IDI up counters count edge */
 	pci1760_mbxrequest(dev, omb, imb);
 	devpriv->IDICntEdge = 0x00;
 
 	omb[0] = 0x00;
-	omb[2] = CMD_EnableIDIFilters;	/*  disable all digital in filters */
+	omb[2] = CMD_EnableIDIFilters;	/* disable all digital in filters */
 	pci1760_mbxrequest(dev, omb, imb);
 	devpriv->IDIFiltersEn = 0x00;
 
 	omb[0] = 0x00;
-	omb[2] = CMD_EnableIDIPatternMatch;	/*  disable pattern matching */
+	omb[2] = CMD_EnableIDIPatternMatch;	/* disable pattern matching */
 	pci1760_mbxrequest(dev, omb, imb);
 	devpriv->IDIPatMatchEn = 0x00;
 
 	omb[0] = 0x00;
-	omb[2] = CMD_SetIDIPatternMatch;	/*  set pattern match value */
+	omb[2] = CMD_SetIDIPatternMatch;	/* set pattern match value */
 	pci1760_mbxrequest(dev, omb, imb);
 	devpriv->IDIPatMatchValue = 0x00;
 
@@ -690,18 +733,21 @@ static int pci_dio_reset(struct comedi_device *dev)
 
 	switch (this_board->cardtype) {
 	case TYPE_PCI1730:
-		outb(0, dev->iobase + PCI1730_DO);	/*  clear outputs */
+		outb(0, dev->iobase + PCI1730_DO);	/* clear outputs */
 		outb(0, dev->iobase + PCI1730_DO + 1);
 		outb(0, dev->iobase + PCI1730_IDO);
 		outb(0, dev->iobase + PCI1730_IDO + 1);
 		/* NO break there! */
 	case TYPE_PCI1733:
-		outb(0, dev->iobase + PCI1730_3_INT_EN);	/*  disable interrupts */
-		outb(0x0f, dev->iobase + PCI1730_3_INT_CLR);	/*  clear interrupts */
-		outb(0, dev->iobase + PCI1730_3_INT_RF);	/*  set rising edge trigger */
+		outb(0, dev->iobase + PCI1730_3_INT_EN);
+							/* disable interrupts */
+		outb(0x0f, dev->iobase + PCI1730_3_INT_CLR);
+							/* clear interrupts */
+		outb(0, dev->iobase + PCI1730_3_INT_RF);
+						/* set rising edge trigger */
 		break;
 	case TYPE_PCI1734:
-		outb(0, dev->iobase + PCI1734_IDO);	/*  clear outputs */
+		outb(0, dev->iobase + PCI1734_IDO);	/* clear outputs */
 		outb(0, dev->iobase + PCI1734_IDO + 1);
 		outb(0, dev->iobase + PCI1734_IDO + 2);
 		outb(0, dev->iobase + PCI1734_IDO + 3);
@@ -710,52 +756,64 @@ static int pci_dio_reset(struct comedi_device *dev)
 	case TYPE_PCI1736:
 		outb(0, dev->iobase + PCI1736_IDO);
 		outb(0, dev->iobase + PCI1736_IDO + 1);
-		outb(0, dev->iobase + PCI1736_3_INT_EN);	/*  disable interrupts */
-		outb(0x0f, dev->iobase + PCI1736_3_INT_CLR);	/*  clear interrupts */
-		outb(0, dev->iobase + PCI1736_3_INT_RF);	/*  set rising edge trigger */
+		outb(0, dev->iobase + PCI1736_3_INT_EN);
+							/* disable interrupts */
+		outb(0x0f, dev->iobase + PCI1736_3_INT_CLR);
+							/* clear interrupts */
+		outb(0, dev->iobase + PCI1736_3_INT_RF);
+						/* set rising edge trigger */
 		break;
 
 	case TYPE_PCI1750:
 	case TYPE_PCI1751:
-		outb(0x88, dev->iobase + PCI1750_ICR);	/*  disable & clear interrupts */
+		outb(0x88, dev->iobase + PCI1750_ICR);
+						/* disable & clear interrupts */
 		break;
 	case TYPE_PCI1752:
-		outw(0, dev->iobase + PCI1752_6_CFC);	/*  disable channel freeze function */
-		outw(0, dev->iobase + PCI1752_IDO);	/*  clear outputs */
+		outw(0, dev->iobase + PCI1752_6_CFC);
+					/* disable channel freeze function */
+		outw(0, dev->iobase + PCI1752_IDO);
+						/* clear outputs */
 		outw(0, dev->iobase + PCI1752_IDO + 2);
 		outw(0, dev->iobase + PCI1752_IDO2);
 		outw(0, dev->iobase + PCI1752_IDO2 + 2);
 		break;
 	case TYPE_PCI1753E:
-		outb(0x88, dev->iobase + PCI1753E_ICR0);	/*  disable & clear interrupts */
+		outb(0x88, dev->iobase + PCI1753E_ICR0);
+						/* disable & clear interrupts */
 		outb(0x80, dev->iobase + PCI1753E_ICR1);
 		outb(0x80, dev->iobase + PCI1753E_ICR2);
 		outb(0x80, dev->iobase + PCI1753E_ICR3);
 		/* NO break there! */
 	case TYPE_PCI1753:
-		outb(0x88, dev->iobase + PCI1753_ICR0);	/*  disable & clear interrupts */
+		outb(0x88, dev->iobase + PCI1753_ICR0);
+						/* disable & clear interrupts */
 		outb(0x80, dev->iobase + PCI1753_ICR1);
 		outb(0x80, dev->iobase + PCI1753_ICR2);
 		outb(0x80, dev->iobase + PCI1753_ICR3);
 		break;
 	case TYPE_PCI1754:
-		outw(0x08, dev->iobase + PCI1754_6_ICR0);	/*  disable and clear interrupts */
+		outw(0x08, dev->iobase + PCI1754_6_ICR0);
+						/* disable & clear interrupts */
 		outw(0x08, dev->iobase + PCI1754_6_ICR1);
 		outw(0x08, dev->iobase + PCI1754_ICR2);
 		outw(0x08, dev->iobase + PCI1754_ICR3);
 		break;
 	case TYPE_PCI1756:
-		outw(0, dev->iobase + PCI1752_6_CFC);	/*  disable channel freeze function */
-		outw(0x08, dev->iobase + PCI1754_6_ICR0);	/*  disable and clear interrupts */
+		outw(0, dev->iobase + PCI1752_6_CFC);
+					/* disable channel freeze function */
+		outw(0x08, dev->iobase + PCI1754_6_ICR0);
+						/* disable & clear interrupts */
 		outw(0x08, dev->iobase + PCI1754_6_ICR1);
-		outw(0, dev->iobase + PCI1756_IDO);	/*  clear outputs */
+		outw(0, dev->iobase + PCI1756_IDO);	/* clear outputs */
 		outw(0, dev->iobase + PCI1756_IDO + 2);
 		break;
 	case TYPE_PCI1760:
 		pci1760_reset(dev);
 		break;
 	case TYPE_PCI1762:
-		outw(0x0101, dev->iobase + PCI1762_ICR);	/*  disable & clear interrupts */
+		outw(0x0101, dev->iobase + PCI1762_ICR);
+						/* disable & clear interrupts */
 		break;
 	}
 
@@ -882,9 +940,9 @@ static int CheckAndAllocCard(struct comedi_device *dev,
 	struct pci_dio_private *pr, *prev;
 
 	for (pr = pci_priv, prev = NULL; pr != NULL; prev = pr, pr = pr->next) {
-		if (pr->pcidev == pcidev) {
-			return 0;	/*  this card is used, look for another */
-		}
+		if (pr->pcidev == pcidev)
+			return 0;
+				/* this card is used, look for another */
 	}
 
 	if (prev) {
@@ -921,15 +979,15 @@ static int pci_dio_attach(struct comedi_device *dev,
 	for (pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, NULL);
 	     pcidev != NULL;
 	     pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, pcidev)) {
-		/*  loop through cards supported by this driver */
+		/* loop through cards supported by this driver */
 		for (i = 0; i < n_boardtypes; ++i) {
 			if (boardtypes[i].vendor_id != pcidev->vendor)
 				continue;
 			if (boardtypes[i].device_id != pcidev->device)
 				continue;
-			/*  was a particular bus/slot requested? */
+			/* was a particular bus/slot requested? */
 			if (it->options[0] || it->options[1]) {
-				/*  are we on the wrong bus/slot? */
+				/* are we on the wrong bus/slot? */
 				if (pcidev->bus->number != it->options[0] ||
 				    PCI_SLOT(pcidev->devfn) != it->options[1]) {
 					continue;
@@ -946,7 +1004,8 @@ static int pci_dio_attach(struct comedi_device *dev,
 	}
 
 	if (!dev->board_ptr) {
-		printk(", Error: Requested type of the card was not found!\n");
+		printk(KERN_ERR ", Error: Requested type of the card "
+							"was not found!\n");
 		return -EIO;
 	}
 
@@ -956,7 +1015,7 @@ static int pci_dio_attach(struct comedi_device *dev,
 		return -EIO;
 	}
 	iobase = pci_resource_start(pcidev, this_board->main_pci_region);
-	printk(", b:s:f=%d:%d:%d, io=0x%4lx",
+	printk(KERN_ERR ", b:s:f=%d:%d:%d, io=0x%4lx",
 	       pcidev->bus->number, PCI_SLOT(pcidev->devfn),
 	       PCI_FUNC(pcidev->devfn), iobase);
 
@@ -964,7 +1023,7 @@ static int pci_dio_attach(struct comedi_device *dev,
 	dev->board_name = this_board->name;
 
 	if (this_board->cardtype == TYPE_PCI1760) {
-		n_subdevices = 4;	/*  8 IDI, 8 IDO, 2 PWM, 8 CNT */
+		n_subdevices = 4;	/* 8 IDI, 8 IDO, 2 PWM, 8 CNT */
 	} else {
 		n_subdevices = 0;
 		for (i = 0; i < MAX_DI_SUBDEVS; i++)
@@ -985,7 +1044,7 @@ static int pci_dio_attach(struct comedi_device *dev,
 		return ret;
 	}
 
-	printk(".\n");
+	printk(KERN_ERR ".\n");
 
 	subdev = 0;
 
@@ -1040,22 +1099,19 @@ static int pci_dio_detach(struct comedi_device *dev)
 	int subdev;
 
 	if (dev->private) {
-		if (devpriv->valid) {
+		if (devpriv->valid)
 			pci_dio_reset(dev);
-		}
 
 		/* This shows the silliness of using this kind of
 		 * scheme for numbering subdevices.  Don't do it.  --ds */
 		subdev = 0;
 		for (i = 0; i < MAX_DI_SUBDEVS; i++) {
-			if (this_board->sdi[i].chans) {
+			if (this_board->sdi[i].chans)
 				subdev++;
-			}
 		}
 		for (i = 0; i < MAX_DO_SUBDEVS; i++) {
-			if (this_board->sdo[i].chans) {
+			if (this_board->sdo[i].chans)
 				subdev++;
-			}
 		}
 		for (i = 0; i < MAX_DIO_SUBDEVG; i++) {
 			for (j = 0; j < this_board->sdio[i].regs; j++) {
@@ -1071,20 +1127,17 @@ static int pci_dio_detach(struct comedi_device *dev)
 		}
 
 		if (devpriv->pcidev) {
-			if (dev->iobase) {
+			if (dev->iobase)
 				comedi_pci_disable(devpriv->pcidev);
-			}
 			pci_dev_put(devpriv->pcidev);
 		}
 
-		if (devpriv->prev) {
+		if (devpriv->prev)
 			devpriv->prev->next = devpriv->next;
-		} else {
+		else
 			pci_priv = devpriv->next;
-		}
-		if (devpriv->next) {
+		if (devpriv->next)
 			devpriv->next->prev = devpriv->prev;
-		}
 	}
 
 	return 0;
-- 
1.6.3.3

