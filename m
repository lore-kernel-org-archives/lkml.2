Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab0FYMPL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 08:15:11 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:64167 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab0FYMPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 08:15:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=KBd53/gPRDt6dEoDAwOgtxA4c2uF9SfTzuC+42e8sOPQfRmCdkUCwPryMG1ikRM2+4
         AVCYKaU8FZYKFtqpGL1etiGtbrc7WWzY5qOsCsEek3ewsbaFGcBMkACzvV5b7dA6ii+d
         nZZ6bcUipoC56A2RjYycpc+ra2nMhs1wSZCxc=
From: Mark <reodge@gmail.com>
To: gregkh@suse.de
Cc: Mark <reodge@gmail.com>, Arun Thomas <arun.thomas@gmail.com>,
       Jason Wong <tsanghan@gmail.com>, Ian Abbott <abbotti@mev.co.uk>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: comedi: Coding style cleanups in adv_pci_dio.c
Date: Fri, 25 Jun 2010 13:15:26 +0100
Message-Id: <1277468126-6571-1-git-send-email-reodge@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes up many coding style issues in adv_pci_dio.c found by
checkpatch.pl

Signed-off-by: Mark Rankilor <reodge@gmail.com>
---
 drivers/staging/comedi/drivers/adv_pci_dio.c |  307 +++++++++++++++-----------
 1 files changed, 180 insertions(+), 127 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
index d81bbfa..31a6388 100644
--- a/drivers/staging/comedi/drivers/adv_pci_dio.c
+++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
@@ -8,8 +8,8 @@
 /*
 Driver: adv_pci_dio
 Description: Advantech PCI-1730, PCI-1733, PCI-1734, PCI-1735U,
-             PCI-1736UP, PCI-1750, PCI-1751, PCI-1752, PCI-1753/E,
-             PCI-1754, PCI-1756, PCI-1762
+	PCI-1736UP, PCI-1750, PCI-1751, PCI-1752, PCI-1753/E,
+	PCI-1754, PCI-1756, PCI-1762
 Author: Michal Dobes <dobes@tesnet.cz>
 Devices: [Advantech] PCI-1730 (adv_pci_dio), PCI-1733,
   PCI-1734, PCI-1735U, PCI-1736UP, PCI-1750,
@@ -24,8 +24,8 @@ This driver supports now only insn interface for DI/DO/DIO.
 Configuration options:
   [0] - PCI bus of device (optional)
   [1] - PCI slot of device (optional)
-          If bus/slot is not specified, the first available PCI
-          device will be used.
+	If bus/slot is not specified, the first available PCI
+	device will be used.
 
 */
 
@@ -67,9 +67,12 @@ enum hw_io_access {
 
 #define MAX_DI_SUBDEVS	2	/* max number of DI subdevices per card */
 #define MAX_DO_SUBDEVS	2	/* max number of DO subdevices per card */
-#define MAX_DIO_SUBDEVG	2	/* max number of DIO subdevices group per card */
-#define MAX_8254_SUBDEVS   1	/* max number of 8254 counter subdevs per card */
-				/* (could be more than one 8254 per subdevice) */
+#define MAX_DIO_SUBDEVG	2	/* max number of DIO subdevices group per
+				 * card */
+#define MAX_8254_SUBDEVS   1	/* max number of 8254 counter subdevs per
+				 * card */
+				/* (could be more than one 8254 per
+				 * subdevice) */
 
 #define SIZE_8254	   4	/* 8254 IO space length */
 #define SIZE_8255	   4	/* 8255 IO space length */
@@ -84,7 +87,8 @@ enum hw_io_access {
 #define PCI1730_DO	   2	/* W:   Digital output 0-15 */
 #define PCI1733_IDI	   0	/* R:   Isolated digital input  0-31 */
 #define	PCI1730_3_INT_EN	0x08	/* R/W: enable/disable interrupts */
-#define	PCI1730_3_INT_RF	0x0c	/* R/W: set falling/raising edge for interrupts */
+#define	PCI1730_3_INT_RF	0x0c	/* R/W: set falling/raising edge for
+					 * interrupts */
 #define	PCI1730_3_INT_CLR	0x10	/* R/W: clear interrupts */
 #define PCI1734_IDO	   0	/* W:   Isolated digital output 0-31 */
 #define PCI173x_BOARDID	   4	/* R:   Board I/D switch for 1730/3/4 */
@@ -99,7 +103,8 @@ enum hw_io_access {
 #define PCI1736_IDI        0	/* R:   Isolated digital input  0-15 */
 #define PCI1736_IDO        0	/* W:   Isolated digital output 0-15 */
 #define PCI1736_3_INT_EN        0x08	/* R/W: enable/disable interrupts */
-#define PCI1736_3_INT_RF        0x0c	/* R/W: set falling/raising edge for interrupts */
+#define PCI1736_3_INT_RF        0x0c	/* R/W: set falling/raising edge for
+					 * interrupts */
 #define PCI1736_3_INT_CLR       0x10	/* R/W: clear interrupts */
 #define PCI1736_BOARDID    4	/* R:   Board I/D switch for 1736UP */
 #define PCI1736_MAINREG    0	/* Normal register (2) doesn't work */
@@ -161,37 +166,66 @@ enum hw_io_access {
 #define INTCSR3		0x3b
 
 /*  PCI-1760 mailbox commands */
-#define CMD_ClearIMB2		0x00	/* Clear IMB2 status and return actaul DI status in IMB3 */
+#define CMD_ClearIMB2		0x00	/* Clear IMB2 status and return actual
+					 * DI status in IMB3 */
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
+#define CMD_ReadCurrentStatus	0x07	/* Read the current status of the
+					 * register in OMB0, result in IMB0 */
+#define CMD_ReadFirmwareVersion	0x0e	/* Read the firmware ver., result in
+					 * IMB1.IMB0 */
+#define CMD_ReadHardwareVersion	0x0f	/* Read the hardware ver., result in
+					 * IMB1.IMB0 */
+#define CMD_EnableIDIFilters	0x20	/* Enable IDI filters based on bits in
+					 * OMB0 */
+#define CMD_EnableIDIPatternMatch 0x21	/* Enable IDI pattern match based on
+					 * bits in OMB0 */
+#define CMD_SetIDIPatternMatch	0x22	/* Enable IDI pattern match based on
+					 * bits in OMB0 */
+#define CMD_EnableIDICounters	0x28	/* Enable IDI counters based on bits in
+					 * OMB0 */
+#define CMD_ResetIDICounters	0x29	/* Reset IDI counters based on bits in
+					 * OMB0 to its reset values */
+#define CMD_OverflowIDICounters	0x2a	/* Enable IDI counters overflow
+					 * interrupts  based on bits in OMB0 */
+#define CMD_MatchIntIDICounters	0x2b	/* Enable IDI counters match value
+					 * interrupts  based on bits in OMB0 */
+#define CMD_EdgeIDICounters	0x2c	/* Set IDI up counters count edge (bit=0
+					 * - rising, =1 - falling) */
+#define CMD_GetIDICntCurValue	0x2f	/* Read IDI{OMB0} up counter current
+					 * value */
+#define CMD_SetIDI0CntResetValue 0x40	/* Set IDI0 Counter Reset Value
+					 * 256*OMB1+OMB0 */
+#define CMD_SetIDI1CntResetValue 0x41	/* Set IDI1 Counter Reset Value
+					 * 256*OMB1+OMB0 */
+#define CMD_SetIDI2CntResetValue 0x42	/* Set IDI2 Counter Reset Value
+					 * 256*OMB1+OMB0 */
+#define CMD_SetIDI3CntResetValue 0x43	/* Set IDI3 Counter Reset Value
+					 * 256*OMB1+OMB0 */
+#define CMD_SetIDI4CntResetValue 0x44	/* Set IDI4 Counter Reset Value
+					 * 256*OMB1+OMB0 */
+#define CMD_SetIDI5CntResetValue 0x45	/* Set IDI5 Counter Reset Value
+					 * 256*OMB1+OMB0 */
+#define CMD_SetIDI6CntResetValue 0x46	/* Set IDI6 Counter Reset Value
+					 * 256*OMB1+OMB0 */
+#define CMD_SetIDI7CntResetValue 0x47	/* Set IDI7 Counter Reset Value
+					 * 256*OMB1+OMB0 */
+#define CMD_SetIDI0CntMatchValue 0x48	/* Set IDI0 Counter Match Value
+					 * 256*OMB1+OMB0 */
+#define CMD_SetIDI1CntMatchValue 0x49	/* Set IDI1 Counter Match Value
+					 * 256*OMB1+OMB0 */
+#define CMD_SetIDI2CntMatchValue 0x4a	/* Set IDI2 Counter Match Value
+					 * 256*OMB1+OMB0 */
+#define CMD_SetIDI3CntMatchValue 0x4b	/* Set IDI3 Counter Match Value
+					 * 256*OMB1+OMB0 */
+#define CMD_SetIDI4CntMatchValue 0x4c	/* Set IDI4 Counter Match Value
+					 * 256*OMB1+OMB0 */
+#define CMD_SetIDI5CntMatchValue 0x4d	/* Set IDI5 Counter Match Value
+					 * 256*OMB1+OMB0 */
+#define CMD_SetIDI6CntMatchValue 0x4e	/* Set IDI6 Counter Match Value
+					 * 256*OMB1+OMB0 */
+#define CMD_SetIDI7CntMatchValue 0x4f	/* Set IDI7 Counter Match Value
+					 * 256*OMB1+OMB0 */
 
 #define OMBCMD_RETRY	0x03	/* 3 times try request before error */
 
@@ -244,115 +278,115 @@ MODULE_DEVICE_TABLE(pci, pci_dio_pci_table);
 static const struct dio_boardtype boardtypes[] = {
 	{"pci1730", PCI_VENDOR_ID_ADVANTECH, 0x1730, PCIDIO_MAINREG,
 	 TYPE_PCI1730,
-	 {{16, PCI1730_DI, 2, 0}, {16, PCI1730_IDI, 2, 0}},
-	 {{16, PCI1730_DO, 2, 0}, {16, PCI1730_IDO, 2, 0}},
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
+	 { {16, PCI1730_DI, 2, 0}, {16, PCI1730_IDI, 2, 0} },
+	 { {16, PCI1730_DO, 2, 0}, {16, PCI1730_IDO, 2, 0} },
+	 { {0, 0, 0, 0}, {0, 0, 0, 0} },
 	 {4, PCI173x_BOARDID, 1, SDF_INTERNAL},
-	 {{0, 0, 0, 0}},
+	 { {0, 0, 0, 0} },
 	 IO_8b},
 	{"pci1733", PCI_VENDOR_ID_ADVANTECH, 0x1733, PCIDIO_MAINREG,
 	 TYPE_PCI1733,
-	 {{0, 0, 0, 0}, {32, PCI1733_IDI, 4, 0}},
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
+	 { {0, 0, 0, 0}, {32, PCI1733_IDI, 4, 0} },
+	 { {0, 0, 0, 0}, {0, 0, 0, 0} },
+	 { {0, 0, 0, 0}, {0, 0, 0, 0} },
 	 {4, PCI173x_BOARDID, 1, SDF_INTERNAL},
-	 {{0, 0, 0, 0}},
+	 { {0, 0, 0, 0} },
 	 IO_8b},
 	{"pci1734", PCI_VENDOR_ID_ADVANTECH, 0x1734, PCIDIO_MAINREG,
 	 TYPE_PCI1734,
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
-	 {{0, 0, 0, 0}, {32, PCI1734_IDO, 4, 0}},
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
+	 { {0, 0, 0, 0}, {0, 0, 0, 0} },
+	 { {0, 0, 0, 0}, {32, PCI1734_IDO, 4, 0} },
+	 { {0, 0, 0, 0}, {0, 0, 0, 0} },
 	 {4, PCI173x_BOARDID, 1, SDF_INTERNAL},
-	 {{0, 0, 0, 0}},
+	 { {0, 0, 0, 0} },
 	 IO_8b},
 	{"pci1735", PCI_VENDOR_ID_ADVANTECH, 0x1735, PCIDIO_MAINREG,
 	 TYPE_PCI1735,
-	 {{32, PCI1735_DI, 4, 0}, {0, 0, 0, 0}},
-	 {{32, PCI1735_DO, 4, 0}, {0, 0, 0, 0}},
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
+	 { {32, PCI1735_DI, 4, 0}, {0, 0, 0, 0} },
+	 { {32, PCI1735_DO, 4, 0}, {0, 0, 0, 0} },
+	 { {0, 0, 0, 0}, {0, 0, 0, 0} },
 	 { 4, PCI1735_BOARDID, 1, SDF_INTERNAL},
-	 {{3, PCI1735_C8254, 1, 0}},
+	 { {3, PCI1735_C8254, 1, 0} },
 	 IO_8b},
 	{"pci1736", PCI_VENDOR_ID_ADVANTECH, 0x1736, PCI1736_MAINREG,
 	 TYPE_PCI1736,
-	 {{0, 0, 0, 0}, {16, PCI1736_IDI, 2, 0}},
-	 {{0, 0, 0, 0}, {16, PCI1736_IDO, 2, 0}},
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
+	 { {0, 0, 0, 0}, {16, PCI1736_IDI, 2, 0} },
+	 { {0, 0, 0, 0}, {16, PCI1736_IDO, 2, 0} },
+	 { {0, 0, 0, 0}, {0, 0, 0, 0} },
 	 {4, PCI1736_BOARDID, 1, SDF_INTERNAL},
-	 {{0, 0, 0, 0}},
+	 { {0, 0, 0, 0} },
 	 IO_8b},
 	{"pci1750", PCI_VENDOR_ID_ADVANTECH, 0x1750, PCIDIO_MAINREG,
 	 TYPE_PCI1750,
-	 {{0, 0, 0, 0}, {16, PCI1750_IDI, 2, 0}},
-	 {{0, 0, 0, 0}, {16, PCI1750_IDO, 2, 0}},
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
+	 { {0, 0, 0, 0}, {16, PCI1750_IDI, 2, 0} },
+	 { {0, 0, 0, 0}, {16, PCI1750_IDO, 2, 0} },
+	 { {0, 0, 0, 0}, {0, 0, 0, 0} },
 	 {0, 0, 0, 0},
-	 {{0, 0, 0, 0}},
+	 { {0, 0, 0, 0} },
 	 IO_8b},
 	{"pci1751", PCI_VENDOR_ID_ADVANTECH, 0x1751, PCIDIO_MAINREG,
 	 TYPE_PCI1751,
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
-	 {{48, PCI1751_DIO, 2, 0}, {0, 0, 0, 0}},
+	 { {0, 0, 0, 0}, {0, 0, 0, 0} },
+	 { {0, 0, 0, 0}, {0, 0, 0, 0} },
+	 { {48, PCI1751_DIO, 2, 0}, {0, 0, 0, 0} },
 	 {0, 0, 0, 0},
-	 {{0, 0, 0, 0}},
+	 { {0, 0, 0, 0} },
 	 IO_8b},
 	{"pci1752", PCI_VENDOR_ID_ADVANTECH, 0x1752, PCIDIO_MAINREG,
 	 TYPE_PCI1752,
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
-	 {{32, PCI1752_IDO, 2, 0}, {32, PCI1752_IDO2, 2, 0}},
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
+	 { {0, 0, 0, 0}, {0, 0, 0, 0} },
+	 { {32, PCI1752_IDO, 2, 0}, {32, PCI1752_IDO2, 2, 0} },
+	 { {0, 0, 0, 0}, {0, 0, 0, 0} },
 	 {4, PCI175x_BOARDID, 1, SDF_INTERNAL},
-	 {{0, 0, 0, 0}},
+	 { {0, 0, 0, 0} },
 	 IO_16b},
 	{"pci1753", PCI_VENDOR_ID_ADVANTECH, 0x1753, PCIDIO_MAINREG,
 	 TYPE_PCI1753,
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
-	 {{96, PCI1753_DIO, 4, 0}, {0, 0, 0, 0}},
+	 { {0, 0, 0, 0}, {0, 0, 0, 0} },
+	 { {0, 0, 0, 0}, {0, 0, 0, 0} },
+	 { {96, PCI1753_DIO, 4, 0}, {0, 0, 0, 0} },
 	 {0, 0, 0, 0},
-	 {{0, 0, 0, 0}},
+	 { {0, 0, 0, 0} },
 	 IO_8b},
 	{"pci1753e", PCI_VENDOR_ID_ADVANTECH, 0x1753, PCIDIO_MAINREG,
 	 TYPE_PCI1753E,
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
-	 {{96, PCI1753_DIO, 4, 0}, {96, PCI1753E_DIO, 4, 0}},
+	 { {0, 0, 0, 0}, {0, 0, 0, 0} },
+	 { {0, 0, 0, 0}, {0, 0, 0, 0} },
+	 { {96, PCI1753_DIO, 4, 0}, {96, PCI1753E_DIO, 4, 0} },
 	 {0, 0, 0, 0},
-	 {{0, 0, 0, 0}},
+	 { {0, 0, 0, 0} },
 	 IO_8b},
 	{"pci1754", PCI_VENDOR_ID_ADVANTECH, 0x1754, PCIDIO_MAINREG,
 	 TYPE_PCI1754,
-	 {{32, PCI1754_IDI, 2, 0}, {32, PCI1754_IDI2, 2, 0}},
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
+	 { {32, PCI1754_IDI, 2, 0}, {32, PCI1754_IDI2, 2, 0} },
+	 { {0, 0, 0, 0}, {0, 0, 0, 0} },
+	 { {0, 0, 0, 0}, {0, 0, 0, 0} },
 	 {4, PCI175x_BOARDID, 1, SDF_INTERNAL},
-	 {{0, 0, 0, 0}},
+	 { {0, 0, 0, 0} },
 	 IO_16b},
 	{"pci1756", PCI_VENDOR_ID_ADVANTECH, 0x1756, PCIDIO_MAINREG,
 	 TYPE_PCI1756,
-	 {{0, 0, 0, 0}, {32, PCI1756_IDI, 2, 0}},
-	 {{0, 0, 0, 0}, {32, PCI1756_IDO, 2, 0}},
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
+	 { {0, 0, 0, 0}, {32, PCI1756_IDI, 2, 0} },
+	 { {0, 0, 0, 0}, {32, PCI1756_IDO, 2, 0} },
+	 { {0, 0, 0, 0}, {0, 0, 0, 0} },
 	 {4, PCI175x_BOARDID, 1, SDF_INTERNAL},
-	 {{0, 0, 0, 0}},
+	 { {0, 0, 0, 0} },
 	 IO_16b},
 	{"pci1760", PCI_VENDOR_ID_ADVANTECH, 0x1760, 0,
 	 TYPE_PCI1760,
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},	/*  This card have own setup work */
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
+	 { {0, 0, 0, 0}, {0, 0, 0, 0} }, /* This card have own setup work */
+	 { {0, 0, 0, 0}, {0, 0, 0, 0} },
+	 { {0, 0, 0, 0}, {0, 0, 0, 0} },
 	 {0, 0, 0, 0},
-	 {{0, 0, 0, 0}},
+	 { {0, 0, 0, 0} },
 	 IO_8b},
 	{"pci1762", PCI_VENDOR_ID_ADVANTECH, 0x1762, PCIDIO_MAINREG,
 	 TYPE_PCI1762,
-	 {{0, 0, 0, 0}, {16, PCI1762_IDI, 1, 0}},
-	 {{0, 0, 0, 0}, {16, PCI1762_RO, 1, 0}},
-	 {{0, 0, 0, 0}, {0, 0, 0, 0}},
+	 { {0, 0, 0, 0}, {16, PCI1762_IDI, 1, 0} },
+	 { {0, 0, 0, 0}, {16, PCI1762_RO, 1, 0} },
+	 { {0, 0, 0, 0}, {0, 0, 0, 0} },
 	 {4, PCI1762_BOARDID, 1, SDF_INTERNAL},
-	 {{0, 0, 0, 0}},
+	 { {0, 0, 0, 0} },
 	 IO_16b}
 };
 
@@ -372,13 +406,16 @@ struct pci_dio_private {
 	char valid;		/*  card is usable */
 	char GlobalIrqEnabled;	/*  1= any IRQ source is enabled */
 	/*  PCI-1760 specific data */
-	unsigned char IDICntEnable;	/*  counter's counting enable status */
-	unsigned char IDICntOverEnable;	/*  counter's overflow interrupts enable status */
-	unsigned char IDICntMatchEnable;	/*  counter's match interrupts enable status */
-	unsigned char IDICntEdge;	/*  counter's count edge value (bit=0 - rising, =1 - falling) */
+	unsigned char IDICntEnable;	/* counter's counting enable status */
+	unsigned char IDICntOverEnable;	/* counter's overflow interrupts enable
+					 * status */
+	unsigned char IDICntMatchEnable;	/* counter's match interrupts
+						 * enable status */
+	unsigned char IDICntEdge;	/* counter's count edge value
+					 * (bit=0 - rising, =1 - falling) */
 	unsigned short CntResValue[8];	/*  counters' reset value */
-	unsigned short CntMatchValue[8];	/*  counters' match interrupt value */
-	unsigned char IDIFiltersEn;	/*  IDI's digital filters enable status */
+	unsigned short CntMatchValue[8]; /*  counters' match interrupt value */
+	unsigned char IDIFiltersEn; /*  IDI's digital filters enable status */
 	unsigned char IDIPatMatchEn;	/*  IDI's pattern match enable status */
 	unsigned char IDIPatMatchValue;	/*  IDI's pattern match value */
 	unsigned short IDIFiltrLow[8];	/*  IDI's filter value low signal */
@@ -691,7 +728,8 @@ static int pci1760_insn_cnt_write(struct comedi_device *dev,
 	};
 	unsigned char imb[4];
 
-	if (devpriv->CntResValue[chan] != (data[0] & 0xffff)) {	/*  Set reset value if different */
+	/* Set reset value if different */
+	if (devpriv->CntResValue[chan] != (data[0] & 0xffff)) {
 		ret = pci1760_mbxrequest(dev, omb, imb);
 		if (!ret)
 			return ret;
@@ -704,7 +742,8 @@ static int pci1760_insn_cnt_write(struct comedi_device *dev,
 	if (!ret)
 		return ret;
 
-	if (!(bitmask & devpriv->IDICntEnable)) {	/*  start counter if it don't run */
+	/*  start counter if it don't run */
+	if (!(bitmask & devpriv->IDICntEnable)) {
 		omb[0] = bitmask;
 		omb[2] = CMD_EnableIDICounters;
 		ret = pci1760_mbxrequest(dev, omb, imb);
@@ -740,12 +779,14 @@ static int pci1760_reset(struct comedi_device *dev)
 	devpriv->IDICntEnable = 0;
 
 	omb[0] = 0x00;
-	omb[2] = CMD_OverflowIDICounters;	/*  disable counters overflow interrupts */
+	omb[2] = CMD_OverflowIDICounters; /* disable counters overflow
+					   * interrupts */
 	pci1760_mbxrequest(dev, omb, imb);
 	devpriv->IDICntOverEnable = 0;
 
 	omb[0] = 0x00;
-	omb[2] = CMD_MatchIntIDICounters;	/*  disable counters match value interrupts */
+	omb[2] = CMD_MatchIntIDICounters; /* disable counters match value
+					   * interrupts */
 	pci1760_mbxrequest(dev, omb, imb);
 	devpriv->IDICntMatchEnable = 0;
 
@@ -766,7 +807,8 @@ static int pci1760_reset(struct comedi_device *dev)
 	}
 
 	omb[0] = 0xff;
-	omb[2] = CMD_ResetIDICounters;	/*  reset IDI up counters to reset values */
+	omb[2] = CMD_ResetIDICounters; /* reset IDI up counters to reset
+					* values */
 	pci1760_mbxrequest(dev, omb, imb);
 
 	omb[0] = 0x00;
@@ -807,9 +849,12 @@ static int pci_dio_reset(struct comedi_device *dev)
 		outb(0, dev->iobase + PCI1730_IDO + 1);
 		/* NO break there! */
 	case TYPE_PCI1733:
-		outb(0, dev->iobase + PCI1730_3_INT_EN);	/*  disable interrupts */
-		outb(0x0f, dev->iobase + PCI1730_3_INT_CLR);	/*  clear interrupts */
-		outb(0, dev->iobase + PCI1730_3_INT_RF);	/*  set rising edge trigger */
+		/* disable interrupts */
+		outb(0, dev->iobase + PCI1730_3_INT_EN);
+		/* clear interrupts */
+		outb(0x0f, dev->iobase + PCI1730_3_INT_CLR);
+		/* set rising edge trigger */
+		outb(0, dev->iobase + PCI1730_3_INT_RF);
 		break;
 	case TYPE_PCI1734:
 		outb(0, dev->iobase + PCI1734_IDO);	/*  clear outputs */
@@ -830,43 +875,53 @@ static int pci_dio_reset(struct comedi_device *dev)
 	case TYPE_PCI1736:
 		outb(0, dev->iobase + PCI1736_IDO);
 		outb(0, dev->iobase + PCI1736_IDO + 1);
-		outb(0, dev->iobase + PCI1736_3_INT_EN);	/*  disable interrupts */
-		outb(0x0f, dev->iobase + PCI1736_3_INT_CLR);	/*  clear interrupts */
-		outb(0, dev->iobase + PCI1736_3_INT_RF);	/*  set rising edge trigger */
+		/* disable interrupts */
+		outb(0, dev->iobase + PCI1736_3_INT_EN);
+		/* clear interrupts */
+		outb(0x0f, dev->iobase + PCI1736_3_INT_CLR);
+		/* set rising edge trigger */
+		outb(0, dev->iobase + PCI1736_3_INT_RF);
 		break;
 
 	case TYPE_PCI1750:
 	case TYPE_PCI1751:
-		outb(0x88, dev->iobase + PCI1750_ICR);	/*  disable & clear interrupts */
+		/* disable & clear interrupts */
+		outb(0x88, dev->iobase + PCI1750_ICR);
 		break;
 	case TYPE_PCI1752:
-		outw(0, dev->iobase + PCI1752_6_CFC);	/*  disable channel freeze function */
+		outw(0, dev->iobase + PCI1752_6_CFC); /* disable channel freeze
+						       * function */
 		outw(0, dev->iobase + PCI1752_IDO);	/*  clear outputs */
 		outw(0, dev->iobase + PCI1752_IDO + 2);
 		outw(0, dev->iobase + PCI1752_IDO2);
 		outw(0, dev->iobase + PCI1752_IDO2 + 2);
 		break;
 	case TYPE_PCI1753E:
-		outb(0x88, dev->iobase + PCI1753E_ICR0);	/*  disable & clear interrupts */
+		outb(0x88, dev->iobase + PCI1753E_ICR0); /* disable & clear
+							  * interrupts */
 		outb(0x80, dev->iobase + PCI1753E_ICR1);
 		outb(0x80, dev->iobase + PCI1753E_ICR2);
 		outb(0x80, dev->iobase + PCI1753E_ICR3);
 		/* NO break there! */
 	case TYPE_PCI1753:
-		outb(0x88, dev->iobase + PCI1753_ICR0);	/*  disable & clear interrupts */
+		outb(0x88, dev->iobase + PCI1753_ICR0); /* disable & clear
+							 * interrupts */
 		outb(0x80, dev->iobase + PCI1753_ICR1);
 		outb(0x80, dev->iobase + PCI1753_ICR2);
 		outb(0x80, dev->iobase + PCI1753_ICR3);
 		break;
 	case TYPE_PCI1754:
-		outw(0x08, dev->iobase + PCI1754_6_ICR0);	/*  disable and clear interrupts */
+		outw(0x08, dev->iobase + PCI1754_6_ICR0); /* disable and clear
+							   * interrupts */
 		outw(0x08, dev->iobase + PCI1754_6_ICR1);
 		outw(0x08, dev->iobase + PCI1754_ICR2);
 		outw(0x08, dev->iobase + PCI1754_ICR3);
 		break;
 	case TYPE_PCI1756:
-		outw(0, dev->iobase + PCI1752_6_CFC);	/*  disable channel freeze function */
-		outw(0x08, dev->iobase + PCI1754_6_ICR0);	/*  disable and clear interrupts */
+		outw(0, dev->iobase + PCI1752_6_CFC); /* disable channel freeze
+						       * function */
+		outw(0x08, dev->iobase + PCI1754_6_ICR0); /* disable and clear
+							   * interrupts */
 		outw(0x08, dev->iobase + PCI1754_6_ICR1);
 		outw(0, dev->iobase + PCI1756_IDO);	/*  clear outputs */
 		outw(0, dev->iobase + PCI1756_IDO + 2);
@@ -875,7 +930,8 @@ static int pci_dio_reset(struct comedi_device *dev)
 		pci1760_reset(dev);
 		break;
 	case TYPE_PCI1762:
-		outw(0x0101, dev->iobase + PCI1762_ICR);	/*  disable & clear interrupts */
+		outw(0x0101, dev->iobase + PCI1762_ICR); /* disable & clear
+							  * interrupts */
 		break;
 	}
 
@@ -996,7 +1052,7 @@ static int pci_dio_add_do(struct comedi_device *dev, struct comedi_subdevice *s,
 ==============================================================================
 */
 static int pci_dio_add_8254(struct comedi_device *dev,
-			    struct comedi_subdevice * s,
+			    struct comedi_subdevice *s,
 			    const struct diosubd_data *d, int subdev)
 {
 	s->type = COMEDI_SUBD_COUNTER;
@@ -1023,7 +1079,7 @@ static int CheckAndAllocCard(struct comedi_device *dev,
 
 	for (pr = pci_priv, prev = NULL; pr != NULL; prev = pr, pr = pr->next) {
 		if (pr->pcidev == pcidev)
-			return 0;	/*  this card is used, look for another */
+			return 0; /* this card is used, look for another */
 
 	}
 
@@ -1215,15 +1271,12 @@ static int pci_dio_detach(struct comedi_device *dev)
 			}
 		}
 
-		if (this_board->boardid.chans) {
+		if (this_board->boardid.chans)
 			subdev++;
-		}
 
-		for (i = 0; i < MAX_8254_SUBDEVS; i++) {
-			if (this_board->s8254[i].chans) {
+		for (i = 0; i < MAX_8254_SUBDEVS; i++)
+			if (this_board->s8254[i].chans)
 				subdev++;
-			}
-		}
 
 		for (i = 0; i < dev->n_subdevices; i++) {
 			s = dev->subdevices + i;
-- 
1.7.1

