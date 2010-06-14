Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab0FNI2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 04:28:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42522 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666Ab0FNI22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 04:28:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=OSNt8ctA+rFiPMLjlzlepbGxelEBc1aVm+klW3iQMUU4WQI4koTA/6EdZXipY5eq1y
         T9/GLoVYtcxNr+WZJ24URoB/uhV2/swi98bJHEQmZHh+MmUKkgjmn941b9QUX/MZOrEt
         uSYyBdwmbjKIXcwnRreVbgPOKgkncfifpj57k=
From: =?UTF-8?q?Henri=20H=C3=A4kkinen?= <henuxd@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, rich.folsom@gmail.com,
       mithlesh@linsyssoft.com, jirislaby@gmail.com, henuxd@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging:comedi: Fixed coding conventions on `adl_pci9111.c'
Date: Mon, 14 Jun 2010 11:04:51 +0300
Message-Id: <1276502691-5573-1-git-send-email-henuxd@gmail.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleaned up and fixed coding convention issues as reported by checkpatch.pl
on the file `drivers/adl_pci9111.c' as well as other minor changes for
consistency and clarity.

Signed-off-by: Henri Häkkinen <henuxd@gmail.com>
---
 drivers/staging/comedi/drivers/adl_pci9111.c |  423 ++++++++++++++------------
 1 files changed, 231 insertions(+), 192 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9111.c b/drivers/staging/comedi/drivers/adl_pci9111.c
index 36a254c..3328560 100644
--- a/drivers/staging/comedi/drivers/adl_pci9111.c
+++ b/drivers/staging/comedi/drivers/adl_pci9111.c
@@ -38,8 +38,8 @@ Supports:
   - do_insn read/write
   - ai_do_cmd mode with the following sources:
 
-    - start_src 		TRIG_NOW
-    - scan_begin_src 		TRIG_FOLLOW	TRIG_TIMER	TRIG_EXT
+    - start_src			TRIG_NOW
+    - scan_begin_src		TRIG_FOLLOW	TRIG_TIMER	TRIG_EXT
     - convert_src				TRIG_TIMER	TRIG_EXT
     - scan_end_src		TRIG_COUNT
     - stop_src			TRIG_COUNT	TRIG_NONE
@@ -68,8 +68,9 @@ CHANGELOG:
 TODO:
 
   - Really test implemented functionality.
-  - Add support for the PCI-9111DG with a probe routine to identify the card type
-    (perhaps with the help of the channel number readback of the A/D Data register).
+  - Add support for the PCI-9111DG with a probe routine to identify
+    the card type (perhaps with the help of the channel number readback
+    of the A/D Data register).
   - Add external multiplexer support.
 
 */
@@ -83,12 +84,12 @@ TODO:
 #include "comedi_pci.h"
 #include "comedi_fc.h"
 
-#define PCI9111_DRIVER_NAME 	"adl_pci9111"
-#define PCI9111_HR_DEVICE_ID 	0x9111
+#define PCI9111_DRIVER_NAME	"adl_pci9111"
+#define PCI9111_HR_DEVICE_ID	0x9111
 
-/*  TODO: Add other pci9111 board id */
+/* TODO: Add other pci9111 board id */
 
-#define PCI9111_IO_RANGE 	0x0100
+#define PCI9111_IO_RANGE	0x0100
 
 #define PCI9111_FIFO_HALF_SIZE	512
 
@@ -134,27 +135,29 @@ TODO:
 
 /* IO address map */
 
-#define PCI9111_REGISTER_AD_FIFO_VALUE 			0x00	/*  AD Data stored in FIFO */
-#define PCI9111_REGISTER_DA_OUTPUT 			0x00
-#define PCI9111_REGISTER_DIGITAL_IO 			0x02
-#define PCI9111_REGISTER_EXTENDED_IO_PORTS 		0x04
-#define PCI9111_REGISTER_AD_CHANNEL_CONTROL 		0x06	/*  Channel selection */
-#define PCI9111_REGISTER_AD_CHANNEL_READBACK 		0x06
-#define PCI9111_REGISTER_INPUT_SIGNAL_RANGE 		0x08
-#define PCI9111_REGISTER_RANGE_STATUS_READBACK 		0x08
-#define PCI9111_REGISTER_TRIGGER_MODE_CONTROL 		0x0A
-#define PCI9111_REGISTER_AD_MODE_INTERRUPT_READBACK 	0x0A
-#define PCI9111_REGISTER_SOFTWARE_TRIGGER 		0x0E
-#define PCI9111_REGISTER_INTERRUPT_CONTROL 		0x0C
+/* AD Data stored in FIFO */
+#define PCI9111_REGISTER_AD_FIFO_VALUE			0x00
+#define PCI9111_REGISTER_DA_OUTPUT			0x00
+#define PCI9111_REGISTER_DIGITAL_IO			0x02
+#define PCI9111_REGISTER_EXTENDED_IO_PORTS		0x04
+/* Channel selection */
+#define PCI9111_REGISTER_AD_CHANNEL_CONTROL		0x06
+#define PCI9111_REGISTER_AD_CHANNEL_READBACK		0x06
+#define PCI9111_REGISTER_INPUT_SIGNAL_RANGE		0x08
+#define PCI9111_REGISTER_RANGE_STATUS_READBACK		0x08
+#define PCI9111_REGISTER_TRIGGER_MODE_CONTROL		0x0A
+#define PCI9111_REGISTER_AD_MODE_INTERRUPT_READBACK	0x0A
+#define PCI9111_REGISTER_SOFTWARE_TRIGGER		0x0E
+#define PCI9111_REGISTER_INTERRUPT_CONTROL		0x0C
 #define PCI9111_REGISTER_8254_COUNTER_0			0x40
 #define PCI9111_REGISTER_8254_COUNTER_1			0x42
-#define PCI9111_REGISTER_8254_COUNTER_2 		0X44
+#define PCI9111_REGISTER_8254_COUNTER_2			0X44
 #define PCI9111_REGISTER_8254_CONTROL			0x46
-#define PCI9111_REGISTER_INTERRUPT_CLEAR 		0x48
+#define PCI9111_REGISTER_INTERRUPT_CLEAR		0x48
 
-#define PCI9111_TRIGGER_MASK 				0x0F
-#define PCI9111_PTRG_OFF 				(0 << 3)
-#define PCI9111_PTRG_ON 				(1 << 3)
+#define PCI9111_TRIGGER_MASK				0x0F
+#define PCI9111_PTRG_OFF				(0 << 3)
+#define PCI9111_PTRG_ON					(1 << 3)
 #define PCI9111_EITS_EXTERNAL				(1 << 2)
 #define PCI9111_EITS_INTERNAL				(0 << 2)
 #define PCI9111_TPST_SOFTWARE_TRIGGER			(0 << 1)
@@ -164,9 +167,9 @@ TODO:
 
 #define PCI9111_ISC0_SET_IRQ_ON_ENDING_OF_AD_CONVERSION (0 << 0)
 #define PCI9111_ISC0_SET_IRQ_ON_FIFO_HALF_FULL		(1 << 0)
-#define PCI9111_ISC1_SET_IRQ_ON_TIMER_TICK  		(0 << 1)
-#define PCI9111_ISC1_SET_IRQ_ON_EXT_TRG 		(1 << 1)
-#define PCI9111_FFEN_SET_FIFO_ENABLE 			(0 << 2)
+#define PCI9111_ISC1_SET_IRQ_ON_TIMER_TICK		(0 << 1)
+#define PCI9111_ISC1_SET_IRQ_ON_EXT_TRG			(1 << 1)
+#define PCI9111_FFEN_SET_FIFO_ENABLE			(0 << 2)
 #define PCI9111_FFEN_SET_FIFO_DISABLE			(1 << 2)
 
 #define PCI9111_CHANNEL_MASK				0x0F
@@ -177,90 +180,114 @@ TODO:
 #define PCI9111_FIFO_FULL_MASK				0x40
 #define PCI9111_AD_BUSY_MASK				0x80
 
-#define PCI9111_IO_BASE dev->iobase
+#define PCI9111_IO_BASE	dev->iobase
 
 /*
  * Define inlined function
  */
 
 #define pci9111_trigger_and_autoscan_get() \
-  (inb(PCI9111_IO_BASE+PCI9111_REGISTER_AD_MODE_INTERRUPT_READBACK)&0x0F)
+	(inb(PCI9111_IO_BASE + PCI9111_REGISTER_AD_MODE_INTERRUPT_READBACK) \
+	     & 0x0F)
 
 #define pci9111_trigger_and_autoscan_set(flags) \
-  outb(flags, PCI9111_IO_BASE+PCI9111_REGISTER_TRIGGER_MODE_CONTROL)
+	outb(flags, PCI9111_IO_BASE + PCI9111_REGISTER_TRIGGER_MODE_CONTROL)
 
 #define pci9111_interrupt_and_fifo_get() \
-  ((inb(PCI9111_IO_BASE+PCI9111_REGISTER_AD_MODE_INTERRUPT_READBACK) >> 4) &0x03)
+	((inb(PCI9111_IO_BASE + PCI9111_REGISTER_AD_MODE_INTERRUPT_READBACK) \
+	      >> 4) & 0x03)
 
 #define pci9111_interrupt_and_fifo_set(flags) \
-  outb(flags, PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL)
+	outb(flags, PCI9111_IO_BASE + PCI9111_REGISTER_INTERRUPT_CONTROL)
 
 #define pci9111_interrupt_clear() \
-  outb(0, PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CLEAR)
+	outb(0, PCI9111_IO_BASE + PCI9111_REGISTER_INTERRUPT_CLEAR)
 
 #define pci9111_software_trigger() \
-  outb(0, PCI9111_IO_BASE+PCI9111_REGISTER_SOFTWARE_TRIGGER)
+	outb(0, PCI9111_IO_BASE + PCI9111_REGISTER_SOFTWARE_TRIGGER)
 
 #define pci9111_fifo_reset() \
-  outb(PCI9111_FFEN_SET_FIFO_ENABLE, PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL); \
-  outb(PCI9111_FFEN_SET_FIFO_DISABLE, PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL); \
-  outb(PCI9111_FFEN_SET_FIFO_ENABLE, PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL)
+	outb(PCI9111_FFEN_SET_FIFO_ENABLE, \
+	     PCI9111_IO_BASE + PCI9111_REGISTER_INTERRUPT_CONTROL); \
+	outb(PCI9111_FFEN_SET_FIFO_DISABLE, \
+	     PCI9111_IO_BASE + PCI9111_REGISTER_INTERRUPT_CONTROL); \
+	outb(PCI9111_FFEN_SET_FIFO_ENABLE, \
+	     PCI9111_IO_BASE + PCI9111_REGISTER_INTERRUPT_CONTROL);
 
 #define pci9111_is_fifo_full() \
-  ((inb(PCI9111_IO_BASE+PCI9111_REGISTER_RANGE_STATUS_READBACK)& \
-    PCI9111_FIFO_FULL_MASK)==0)
+	((inb(PCI9111_IO_BASE + PCI9111_REGISTER_RANGE_STATUS_READBACK) & \
+	      PCI9111_FIFO_FULL_MASK) == 0)
 
 #define pci9111_is_fifo_half_full() \
-  ((inb(PCI9111_IO_BASE+PCI9111_REGISTER_RANGE_STATUS_READBACK)& \
-    PCI9111_FIFO_HALF_FULL_MASK)==0)
+	((inb(PCI9111_IO_BASE + PCI9111_REGISTER_RANGE_STATUS_READBACK) & \
+	      PCI9111_FIFO_HALF_FULL_MASK) == 0)
 
 #define pci9111_is_fifo_empty() \
-  ((inb(PCI9111_IO_BASE+PCI9111_REGISTER_RANGE_STATUS_READBACK)& \
-    PCI9111_FIFO_EMPTY_MASK)==0)
+	((inb(PCI9111_IO_BASE + PCI9111_REGISTER_RANGE_STATUS_READBACK) & \
+	      PCI9111_FIFO_EMPTY_MASK) == 0)
 
 #define pci9111_ai_channel_set(channel) \
-  outb((channel)&PCI9111_CHANNEL_MASK, PCI9111_IO_BASE+PCI9111_REGISTER_AD_CHANNEL_CONTROL)
+	outb((channel) & PCI9111_CHANNEL_MASK, PCI9111_IO_BASE + \
+	     PCI9111_REGISTER_AD_CHANNEL_CONTROL)
 
 #define pci9111_ai_channel_get() \
-  inb(PCI9111_IO_BASE+PCI9111_REGISTER_AD_CHANNEL_READBACK)&PCI9111_CHANNEL_MASK
+	inb(PCI9111_IO_BASE + PCI9111_REGISTER_AD_CHANNEL_READBACK) & \
+	    PCI9111_CHANNEL_MASK
 
 #define pci9111_ai_range_set(range) \
-  outb((range)&PCI9111_RANGE_MASK, PCI9111_IO_BASE+PCI9111_REGISTER_INPUT_SIGNAL_RANGE)
+	outb((range) & PCI9111_RANGE_MASK, PCI9111_IO_BASE + \
+	     PCI9111_REGISTER_INPUT_SIGNAL_RANGE)
 
 #define pci9111_ai_range_get() \
-  inb(PCI9111_IO_BASE+PCI9111_REGISTER_RANGE_STATUS_READBACK)&PCI9111_RANGE_MASK
+	inb(PCI9111_IO_BASE + PCI9111_REGISTER_RANGE_STATUS_READBACK) & \
+		PCI9111_RANGE_MASK
 
 #define pci9111_ai_get_data() \
-  ((inw(PCI9111_IO_BASE+PCI9111_REGISTER_AD_FIFO_VALUE)>>4)&PCI9111_AI_RESOLUTION_MASK) \
-  ^ PCI9111_AI_RESOLUTION_2_CMP_BIT
+	((inw(PCI9111_IO_BASE + PCI9111_REGISTER_AD_FIFO_VALUE) >> 4) & \
+		PCI9111_AI_RESOLUTION_MASK) ^ \
+		PCI9111_AI_RESOLUTION_2_CMP_BIT
 
 #define pci9111_hr_ai_get_data() \
-  (inw(PCI9111_IO_BASE+PCI9111_REGISTER_AD_FIFO_VALUE) & PCI9111_HR_AI_RESOLUTION_MASK) \
-  ^ PCI9111_HR_AI_RESOLUTION_2_CMP_BIT
+	(inw(PCI9111_IO_BASE + PCI9111_REGISTER_AD_FIFO_VALUE) & \
+	     PCI9111_HR_AI_RESOLUTION_MASK) ^ \
+	     PCI9111_HR_AI_RESOLUTION_2_CMP_BIT
 
 #define pci9111_ao_set_data(data) \
-  outw(data&PCI9111_AO_RESOLUTION_MASK, PCI9111_IO_BASE+PCI9111_REGISTER_DA_OUTPUT)
+	outw(data&PCI9111_AO_RESOLUTION_MASK, \
+	     PCI9111_IO_BASE + PCI9111_REGISTER_DA_OUTPUT)
 
 #define pci9111_di_get_bits() \
-  inw(PCI9111_IO_BASE+PCI9111_REGISTER_DIGITAL_IO)
+	inw(PCI9111_IO_BASE+PCI9111_REGISTER_DIGITAL_IO)
 
 #define pci9111_do_set_bits(bits) \
-  outw(bits, PCI9111_IO_BASE+PCI9111_REGISTER_DIGITAL_IO)
+	outw(bits, PCI9111_IO_BASE + PCI9111_REGISTER_DIGITAL_IO)
 
 #define pci9111_8254_control_set(flags) \
-  outb(flags, PCI9111_IO_BASE+PCI9111_REGISTER_8254_CONTROL)
+	outb(flags, PCI9111_IO_BASE + PCI9111_REGISTER_8254_CONTROL)
 
 #define pci9111_8254_counter_0_set(data) \
-  outb(data & 0xFF, PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_0); \
-  outb((data >> 8) & 0xFF, PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_0)
+	do { \
+		outb(data & 0xFF, \
+		     PCI9111_IO_BASE + PCI9111_REGISTER_8254_COUNTER_0); \
+		outb((data >> 8) & 0xFF, \
+		     PCI9111_IO_BASE + PCI9111_REGISTER_8254_COUNTER_0); \
+	} while (0)
 
 #define pci9111_8254_counter_1_set(data) \
-  outb(data & 0xFF, PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_1); \
-  outb((data >> 8) & 0xFF, PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_1)
+	do { \
+		outb(data & 0xFF, \
+		     PCI9111_IO_BASE + PCI9111_REGISTER_8254_COUNTER_1); \
+		outb((data >> 8) & 0xFF, \
+		     PCI9111_IO_BASE + PCI9111_REGISTER_8254_COUNTER_1); \
+	} while (0)
 
 #define pci9111_8254_counter_2_set(data) \
-  outb(data & 0xFF, PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_2); \
-  outb((data >> 8) & 0xFF, PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_2)
+	do { \
+		outb(data & 0xFF, \
+		     PCI9111_IO_BASE + PCI9111_REGISTER_8254_COUNTER_2); \
+		outb((data >> 8) & 0xFF, \
+		     PCI9111_IO_BASE + PCI9111_REGISTER_8254_COUNTER_2); \
+	} while (0)
 
 /*  Function prototypes */
 
@@ -280,16 +307,15 @@ static const struct comedi_lrange pci9111_hr_ai_range = {
 	 BIP_RANGE(2.5),
 	 BIP_RANGE(1.25),
 	 BIP_RANGE(0.625)
-	 }
+	}
 };
 
 static DEFINE_PCI_DEVICE_TABLE(pci9111_pci_table) = {
-	{
-	PCI_VENDOR_ID_ADLINK, PCI9111_HR_DEVICE_ID, PCI_ANY_ID,
-		    PCI_ANY_ID, 0, 0, 0},
-	    /* { PCI_VENDOR_ID_ADLINK, PCI9111_HG_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 }, */
-	{
-	0}
+	{PCI_VENDOR_ID_ADLINK, PCI9111_HR_DEVICE_ID, PCI_ANY_ID,
+	 PCI_ANY_ID, 0, 0, 0},
+	/* {PCI_VENDOR_ID_ADLINK, PCI9111_HG_DEVICE_ID, PCI_ANY_ID,
+	    PCI_ANY_ID, 0, 0, 0 }, */
+	{0}
 };
 
 MODULE_DEVICE_TABLE(pci, pci9111_pci_table);
@@ -339,13 +365,14 @@ static struct comedi_driver pci9111_driver = {
 
 COMEDI_PCI_INITCLEANUP(pci9111_driver, pci9111_pci_table);
 
-/*  Private data structure */
+/* Private data structure */
 
 struct pci9111_private_data {
 	struct pci_dev *pci_device;
-	unsigned long io_range;	/*  PCI6503 io range */
+	unsigned long io_range;	/* PCI6503 io range */
 
-	unsigned long lcr_io_base;	/*  Local configuration register base address */
+	/* Local configuration register base address */
+	unsigned long lcr_io_base;
 	unsigned long lcr_io_range;
 
 	int stop_counter;
@@ -356,17 +383,18 @@ struct pci9111_private_data {
 	unsigned int chunk_counter;
 	unsigned int chunk_num_samples;
 
-	int ao_readback;	/*  Last written analog output data */
+	int ao_readback;	/* Last written analog output data */
 
-	unsigned int timer_divisor_1;	/*  Divisor values for the 8254 timer pacer */
+	/* Divisor values for the 8254 timer pacer */
+	unsigned int timer_divisor_1;
 	unsigned int timer_divisor_2;
 
-	int is_valid;		/*  Is device valid */
+	int is_valid;		/* Is device valid */
 
 	short ai_bounce_buffer[2 * PCI9111_FIFO_HALF_SIZE];
 };
 
-#define dev_private 	((struct pci9111_private_data *)dev->private)
+#define dev_private	((struct pci9111_private_data *)dev->private)
 
 /*  ------------------------------------------------------------------ */
 /*  PLX9050 SECTION */
@@ -549,13 +577,17 @@ static int pci9111_ai_cancel(struct comedi_device *dev,
 /*  Test analog input command */
 
 #define pci9111_check_trigger_src(src, flags) \
-  tmp = src; \
-  src &= flags; \
-  if (!src || tmp != src) error++
+	do { \
+		tmp = src; \
+		src &= flags; \
+		if (!src || tmp != src) \
+			error++; \
+	} while (0)
 
 static int
 pci9111_ai_do_cmd_test(struct comedi_device *dev,
-		       struct comedi_subdevice *s, struct comedi_cmd *cmd)
+		       struct comedi_subdevice *s,
+		       struct comedi_cmd *cmd)
 {
 	int tmp;
 	int error = 0;
@@ -563,7 +595,7 @@ pci9111_ai_do_cmd_test(struct comedi_device *dev,
 	int i;
 	struct pci9111_board *board = (struct pci9111_board *)dev->board_ptr;
 
-	/*  Step 1 : check if trigger are trivialy valid */
+	/* Step 1 : check if trigger are trivialy valid */
 
 	pci9111_check_trigger_src(cmd->start_src, TRIG_NOW);
 	pci9111_check_trigger_src(cmd->scan_begin_src,
@@ -575,7 +607,8 @@ pci9111_ai_do_cmd_test(struct comedi_device *dev,
 	if (error)
 		return 1;
 
-	/*  step 2 : make sure trigger sources are unique and mutually compatible */
+	/* Step 2 : make sure trigger sources are unique and
+	 *          mutually compatible */
 
 	if (cmd->start_src != TRIG_NOW)
 		error++;
@@ -605,7 +638,7 @@ pci9111_ai_do_cmd_test(struct comedi_device *dev,
 	if (error)
 		return 2;
 
-	/*  Step 3 : make sure arguments are trivialy compatible */
+	/* Step 3 : make sure arguments are trivialy compatible */
 
 	if (cmd->chanlist_len < 1) {
 		cmd->chanlist_len = 1;
@@ -637,7 +670,8 @@ pci9111_ai_do_cmd_test(struct comedi_device *dev,
 		cmd->scan_begin_arg = board->ai_acquisition_period_min_ns;
 		error++;
 	}
-	if ((cmd->scan_begin_src == TRIG_FOLLOW) && (cmd->scan_begin_arg != 0)) {
+	if ((cmd->scan_begin_src == TRIG_FOLLOW) &&
+	    (cmd->scan_begin_arg != 0)) {
 		cmd->scan_begin_arg = 0;
 		error++;
 	}
@@ -664,7 +698,7 @@ pci9111_ai_do_cmd_test(struct comedi_device *dev,
 	if (error)
 		return 3;
 
-	/*  Step 4 : fix up any arguments */
+	/* Step 4 : fix up any arguments */
 
 	if (cmd->convert_src == TRIG_TIMER) {
 		tmp = cmd->convert_arg;
@@ -676,8 +710,8 @@ pci9111_ai_do_cmd_test(struct comedi_device *dev,
 		if (tmp != cmd->convert_arg)
 			error++;
 	}
-	/*  There's only one timer on this card, so the scan_begin timer must */
-	/*  be a multiple of chanlist_len*convert_arg */
+	/* There's only one timer on this card, so the scan_begin timer must
+	 * be a multiple of chanlist_len*convert_arg */
 
 	if (cmd->scan_begin_src == TRIG_TIMER) {
 
@@ -706,7 +740,7 @@ pci9111_ai_do_cmd_test(struct comedi_device *dev,
 	if (error)
 		return 4;
 
-	/*  Step 5 : check channel list */
+	/* Step 5 : check channel list */
 
 	if (cmd->chanlist) {
 
@@ -716,19 +750,15 @@ pci9111_ai_do_cmd_test(struct comedi_device *dev,
 		if (cmd->chanlist_len > 1) {
 			for (i = 0; i < cmd->chanlist_len; i++) {
 				if (CR_CHAN(cmd->chanlist[i]) != i) {
-					comedi_error(dev,
-						     "entries in chanlist must be consecutive "
-						     "channels,counting upwards from 0\n");
+					comedi_error(dev, "entries in chanlist must be consecutive channels,counting upwards from 0\n");
 					error++;
 				}
 				if (CR_RANGE(cmd->chanlist[i]) != range) {
-					comedi_error(dev,
-						     "entries in chanlist must all have the same gain\n");
+					comedi_error(dev, "entries in chanlist must all have the same gain\n");
 					error++;
 				}
 				if (CR_AREF(cmd->chanlist[i]) != reference) {
-					comedi_error(dev,
-						     "entries in chanlist must all have the same reference\n");
+					comedi_error(dev, "entries in chanlist must all have the same reference\n");
 					error++;
 				}
 			}
@@ -736,8 +766,7 @@ pci9111_ai_do_cmd_test(struct comedi_device *dev,
 			if ((CR_CHAN(cmd->chanlist[0]) >
 			     (board->ai_channel_nbr - 1))
 			    || (CR_CHAN(cmd->chanlist[0]) < 0)) {
-				comedi_error(dev,
-					     "channel number is out of limits\n");
+				comedi_error(dev, "channel number is out of limits\n");
 				error++;
 			}
 		}
@@ -750,7 +779,7 @@ pci9111_ai_do_cmd_test(struct comedi_device *dev,
 
 }
 
-/*  Analog input command */
+/* Analog input command */
 
 static int pci9111_ai_do_cmd(struct comedi_device *dev,
 			     struct comedi_subdevice *subdevice)
@@ -758,13 +787,12 @@ static int pci9111_ai_do_cmd(struct comedi_device *dev,
 	struct comedi_cmd *async_cmd = &subdevice->async->cmd;
 
 	if (!dev->irq) {
-		comedi_error(dev,
-			     "no irq assigned for PCI9111, cannot do hardware conversion");
+		comedi_error(dev, "no irq assigned for PCI9111, cannot do hardware conversion");
 		return -1;
 	}
-	/*  Set channel scan limit */
-	/*  PCI9111 allows only scanning from channel 0 to channel n */
-	/*  TODO: handle the case of an external multiplexer */
+	/* Set channel scan limit */
+	/* PCI9111 allows only scanning from channel 0 to channel n */
+	/* TODO: handle the case of an external multiplexer */
 
 	if (async_cmd->chanlist_len > 1) {
 		pci9111_ai_channel_set((async_cmd->chanlist_len) - 1);
@@ -774,8 +802,8 @@ static int pci9111_ai_do_cmd(struct comedi_device *dev,
 		pci9111_autoscan_set(dev, false);
 	}
 
-	/*  Set gain */
-	/*  This is the same gain on every channel */
+	/* Set gain */
+	/* This is the same gain on every channel */
 
 	pci9111_ai_range_set(CR_RANGE(async_cmd->chanlist[0]));
 
@@ -798,7 +826,7 @@ static int pci9111_ai_do_cmd(struct comedi_device *dev,
 		return -1;
 	}
 
-	/*  Set timer pacer */
+	/* Set timer pacer */
 
 	dev_private->scan_delay = 0;
 	switch (async_cmd->convert_src) {
@@ -831,7 +859,6 @@ static int pci9111_ai_do_cmd(struct comedi_device *dev,
 		break;
 
 	case TRIG_EXT:
-
 		pci9111_trigger_source_set(dev, external);
 		pci9111_fifo_reset();
 		pci9111_interrupt_source_set(dev, irq_on_fifo_half_full,
@@ -873,7 +900,8 @@ static int pci9111_ai_do_cmd(struct comedi_device *dev,
 }
 
 static void pci9111_ai_munge(struct comedi_device *dev,
-			     struct comedi_subdevice *s, void *data,
+			     struct comedi_subdevice *s,
+			     void *data,
 			     unsigned int num_bytes,
 			     unsigned int start_chan_index)
 {
@@ -894,9 +922,9 @@ static void pci9111_ai_munge(struct comedi_device *dev,
 	}
 }
 
-/*  ------------------------------------------------------------------ */
-/*  INTERRUPT SECTION */
-/*  ------------------------------------------------------------------ */
+/* ------------------------------------------------------------------ */
+/* INTERRUPT SECTION */
+/* ------------------------------------------------------------------ */
 
 #undef INTERRUPT_DEBUG
 
@@ -909,8 +937,8 @@ static irqreturn_t pci9111_interrupt(int irq, void *p_device)
 	unsigned char intcsr;
 
 	if (!dev->attached) {
-		/*  Ignore interrupt before device fully attached. */
-		/*  Might not even have allocated subdevices yet! */
+		/* Ignore interrupt before device fully attached.
+		 * Might not even have allocated subdevices yet! */
 		return IRQ_NONE;
 	}
 
@@ -918,7 +946,7 @@ static irqreturn_t pci9111_interrupt(int irq, void *p_device)
 
 	spin_lock_irqsave(&dev->spinlock, irq_flags);
 
-	/*  Check if we are source of interrupt */
+	/* Check if we are source of interrupt */
 	intcsr = inb(dev_private->lcr_io_base +
 		     PLX9050_REGISTER_INTERRUPT_CONTROL);
 	if (!(((intcsr & PLX9050_PCI_INTERRUPT_ENABLE) != 0)
@@ -926,15 +954,15 @@ static irqreturn_t pci9111_interrupt(int irq, void *p_device)
 		   == (PLX9050_LINTI1_ENABLE | PLX9050_LINTI1_STATUS))
 		  || ((intcsr & (PLX9050_LINTI2_ENABLE | PLX9050_LINTI2_STATUS))
 		      == (PLX9050_LINTI2_ENABLE | PLX9050_LINTI2_STATUS))))) {
-		/*  Not the source of the interrupt. */
-		/*  (N.B. not using PLX9050_SOFTWARE_INTERRUPT) */
+		/* Not the source of the interrupt.
+		 * (N.B. not using PLX9050_SOFTWARE_INTERRUPT) */
 		spin_unlock_irqrestore(&dev->spinlock, irq_flags);
 		return IRQ_NONE;
 	}
 
 	if ((intcsr & (PLX9050_LINTI1_ENABLE | PLX9050_LINTI1_STATUS)) ==
 	    (PLX9050_LINTI1_ENABLE | PLX9050_LINTI1_STATUS)) {
-		/*  Interrupt comes from fifo_half-full signal */
+		/* Interrupt comes from fifo_half-full signal */
 
 		if (pci9111_is_fifo_full()) {
 			spin_unlock_irqrestore(&dev->spinlock, irq_flags);
@@ -952,7 +980,8 @@ static irqreturn_t pci9111_interrupt(int irq, void *p_device)
 			unsigned int bytes_written = 0;
 
 #ifdef INTERRUPT_DEBUG
-			printk(PCI9111_DRIVER_NAME ": fifo is half full\n");
+			comedi_info(PCI9111_DRIVER_NAME
+				    ": fifo is half full\n");
 #endif
 
 			num_samples =
@@ -991,14 +1020,16 @@ static irqreturn_t pci9111_interrupt(int irq, void *p_device)
 						bytes_written +=
 						    cfc_write_array_to_buffer
 						    (subdevice,
-						     dev_private->ai_bounce_buffer
+						     dev_private->
+						     ai_bounce_buffer
 						     + position,
 						     to_read * sizeof(short));
 					} else {
 						to_read =
-						    dev_private->chunk_num_samples
-						    -
-						    dev_private->chunk_counter;
+						    dev_private->
+						    chunk_num_samples
+						    - dev_private->
+						    chunk_counter;
 						if (to_read >
 						    num_samples - position)
 							to_read =
@@ -1040,17 +1071,18 @@ static irqreturn_t pci9111_interrupt(int irq, void *p_device)
 	return IRQ_HANDLED;
 }
 
-/*  ------------------------------------------------------------------ */
-/*  INSTANT ANALOG INPUT OUTPUT SECTION */
-/*  ------------------------------------------------------------------ */
+/* ------------------------------------------------------------------ */
+/* INSTANT ANALOG INPUT OUTPUT SECTION */
+/* ------------------------------------------------------------------ */
 
-/*  analog instant input */
+/* analog instant input */
 
 #undef AI_INSN_DEBUG
 
 static int pci9111_ai_insn_read(struct comedi_device *dev,
 				struct comedi_subdevice *subdevice,
-				struct comedi_insn *insn, unsigned int *data)
+				struct comedi_insn *insn,
+				unsigned int *data)
 {
 	int resolution =
 	    ((struct pci9111_board *)dev->board_ptr)->ai_resolution;
@@ -1058,9 +1090,10 @@ static int pci9111_ai_insn_read(struct comedi_device *dev,
 	int timeout, i;
 
 #ifdef AI_INSN_DEBUG
-	printk(PCI9111_DRIVER_NAME ": ai_insn set c/r/n = %2x/%2x/%2x\n",
-	       CR_CHAN((&insn->chanspec)[0]),
-	       CR_RANGE((&insn->chanspec)[0]), insn->n);
+	comedi_info(PCI9111_DRIVER_NAME ": ai_insn set c/r/n = %2x/%2x/%2x\n",
+		    CR_CHAN((&insn->chanspec)[0]),
+		    CR_RANGE((&insn->chanspec)[0]),
+		    insn->n);
 #endif
 
 	pci9111_ai_channel_set(CR_CHAN((&insn->chanspec)[0]));
@@ -1094,19 +1127,21 @@ conversion_done:
 	}
 
 #ifdef AI_INSN_DEBUG
-	printk(PCI9111_DRIVER_NAME ": ai_insn get c/r/t = %2x/%2x/%2x\n",
-	       pci9111_ai_channel_get(),
-	       pci9111_ai_range_get(), pci9111_trigger_and_autoscan_get());
+	comedi_info(PCI9111_DRIVER_NAME ": ai_insn get c/r/t = %2x/%2x/%2x\n",
+		    pci9111_ai_channel_get(),
+		    pci9111_ai_range_get(),
+		    pci9111_trigger_and_autoscan_get());
 #endif
 
 	return i;
 }
 
-/*  Analog instant output */
+/* Analog instant output */
 
 static int
 pci9111_ao_insn_write(struct comedi_device *dev,
-		      struct comedi_subdevice *s, struct comedi_insn *insn,
+		      struct comedi_subdevice *s,
+		      struct comedi_insn *insn,
 		      unsigned int *data)
 {
 	int i;
@@ -1119,11 +1154,12 @@ pci9111_ao_insn_write(struct comedi_device *dev,
 	return i;
 }
 
-/*  Analog output readback */
+/* Analog output readback */
 
 static int pci9111_ao_insn_read(struct comedi_device *dev,
 				struct comedi_subdevice *s,
-				struct comedi_insn *insn, unsigned int *data)
+				struct comedi_insn *insn,
+				unsigned int *data)
 {
 	int i;
 
@@ -1133,15 +1169,16 @@ static int pci9111_ao_insn_read(struct comedi_device *dev,
 	return i;
 }
 
-/*  ------------------------------------------------------------------ */
-/*  DIGITAL INPUT OUTPUT SECTION */
-/*  ------------------------------------------------------------------ */
+/* ------------------------------------------------------------------ */
+/* DIGITAL INPUT OUTPUT SECTION */
+/* ------------------------------------------------------------------ */
 
-/*  Digital inputs */
+/* Digital inputs */
 
 static int pci9111_di_insn_bits(struct comedi_device *dev,
 				struct comedi_subdevice *subdevice,
-				struct comedi_insn *insn, unsigned int *data)
+				struct comedi_insn *insn,
+				unsigned int *data)
 {
 	unsigned int bits;
 
@@ -1151,17 +1188,18 @@ static int pci9111_di_insn_bits(struct comedi_device *dev,
 	return 2;
 }
 
-/*  Digital outputs */
+/* Digital outputs */
 
 static int pci9111_do_insn_bits(struct comedi_device *dev,
 				struct comedi_subdevice *subdevice,
-				struct comedi_insn *insn, unsigned int *data)
+				struct comedi_insn *insn,
+				unsigned int *data)
 {
 	unsigned int bits;
 
-	/*  Only set bits that have been masked */
-	/*  data[0] = mask */
-	/*  data[1] = bit state */
+	/* Only set bits that have been masked */
+	/* data[0] = mask */
+	/* data[1] = bit state */
 
 	data[0] &= PCI9111_DO_MASK;
 
@@ -1177,15 +1215,15 @@ static int pci9111_do_insn_bits(struct comedi_device *dev,
 	return 2;
 }
 
-/*  ------------------------------------------------------------------ */
-/*  INITIALISATION SECTION */
-/*  ------------------------------------------------------------------ */
+/* ------------------------------------------------------------------ */
+/* INITIALISATION SECTION */
+/* ------------------------------------------------------------------ */
 
-/*  Reset device */
+/* Reset device */
 
 static int pci9111_reset(struct comedi_device *dev)
 {
-	/*  Set trigger source to software */
+	/* Set trigger source to software */
 
 	plx9050_interrupt_control(dev_private->lcr_io_base, true, true, true,
 				  true, false);
@@ -1194,7 +1232,7 @@ static int pci9111_reset(struct comedi_device *dev)
 	pci9111_pretrigger_set(dev, false);
 	pci9111_autoscan_set(dev, false);
 
-	/*  Reset 8254 chip */
+	/* Reset 8254 chip */
 
 	dev_private->timer_divisor_1 = 0;
 	dev_private->timer_divisor_2 = 0;
@@ -1204,9 +1242,9 @@ static int pci9111_reset(struct comedi_device *dev)
 	return 0;
 }
 
-/*  Attach */
-/*       - Register PCI device */
-/*       - Declare device driver capability */
+/* Attach
+ * - Register PCI device
+ * - Declare device driver capability */
 
 static int pci9111_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
@@ -1219,9 +1257,9 @@ static int pci9111_attach(struct comedi_device *dev,
 
 	if (alloc_private(dev, sizeof(struct pci9111_private_data)) < 0)
 		return -ENOMEM;
-	/*  Probe the device to determine what device in the series it is. */
+	/* Probe the device to determine what device in the series it is. */
 
-	printk("comedi%d: " PCI9111_DRIVER_NAME " driver\n", dev->minor);
+	comedi_info("minor %d: " PCI9111_DRIVER_NAME " driver\n", dev->minor);
 
 	for (pci_device = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, NULL);
 	     pci_device != NULL;
@@ -1230,17 +1268,18 @@ static int pci9111_attach(struct comedi_device *dev,
 			for (i = 0; i < pci9111_board_nbr; i++) {
 				if (pci9111_boards[i].device_id ==
 				    pci_device->device) {
-					/*  was a particular bus/slot requested? */
+					/* was a particular bus/slot
+					 * requested? */
 					if ((it->options[0] != 0)
 					    || (it->options[1] != 0)) {
-						/*  are we on the wrong bus/slot? */
+						/* are we on the wrong
+						 * bus/slot? */
 						if (pci_device->bus->number !=
 						    it->options[0]
 						    ||
 						    PCI_SLOT(pci_device->devfn)
-						    != it->options[1]) {
+						    != it->options[1])
 							continue;
-						}
 					}
 
 					dev->board_ptr = pci9111_boards + i;
@@ -1254,44 +1293,44 @@ static int pci9111_attach(struct comedi_device *dev,
 		}
 	}
 
-	printk("comedi%d: no supported board found! (req. bus/slot : %d/%d)\n",
-	       dev->minor, it->options[0], it->options[1]);
+	comedi_info("minor %d: no supported board found! "
+		    "(req. bus/slot : %d/%d)\n",
+		    dev->minor, it->options[0], it->options[1]);
 	return -EIO;
 
 found:
 
-	printk("comedi%d: found %s (b:s:f=%d:%d:%d) , irq=%d\n",
-	       dev->minor,
-	       pci9111_boards[i].name,
-	       pci_device->bus->number,
-	       PCI_SLOT(pci_device->devfn),
-	       PCI_FUNC(pci_device->devfn), pci_device->irq);
+	comedi_info("minor %d: found %s (b:s:f=%d:%d:%d) , irq=%d\n",
+		    dev->minor,
+		    pci9111_boards[i].name,
+		    pci_device->bus->number,
+		    PCI_SLOT(pci_device->devfn),
+		    PCI_FUNC(pci_device->devfn), pci_device->irq);
 
-	/*  TODO: Warn about non-tested boards. */
+	/* TODO: Warn about non-tested boards. */
 
-	/*  Read local configuration register base address [PCI_BASE_ADDRESS #1]. */
+	/* Read local configuration register base address
+	 * [PCI_BASE_ADDRESS #1]. */
 
 	lcr_io_base = pci_resource_start(pci_device, 1);
 	lcr_io_range = pci_resource_len(pci_device, 1);
 
-	printk
-	    ("comedi%d: local configuration registers at address 0x%4lx [0x%4lx]\n",
-	     dev->minor, lcr_io_base, lcr_io_range);
+	comedi_info("minor %d: local configuration registers at address "
+		    "0x%4lx [0x%4lx]\n",
+		    dev->minor, lcr_io_base, lcr_io_range);
 
-	/*  Enable PCI device and request regions */
+	/* Enable PCI device and request regions */
 	if (comedi_pci_enable(pci_device, PCI9111_DRIVER_NAME) < 0) {
-		printk
-		    ("comedi%d: Failed to enable PCI device and request regions\n",
-		     dev->minor);
+		comedi_err("%d: Failed to enable PCI device and request regions\n", dev->minor);
 		return -EIO;
 	}
-	/*  Read PCI6308 register base address [PCI_BASE_ADDRESS #2]. */
+	/* Read PCI6308 register base address [PCI_BASE_ADDRESS #2]. */
 
 	io_base = pci_resource_start(pci_device, 2);
 	io_range = pci_resource_len(pci_device, 2);
 
-	printk("comedi%d: 6503 registers at address 0x%4lx [0x%4lx]\n",
-	       dev->minor, io_base, io_range);
+	comedi_info("minor %d: 6503 registers at address 0x%4lx [0x%4lx]\n",
+		    dev->minor, io_base, io_range);
 
 	dev->iobase = io_base;
 	dev->board_name = board->name;
@@ -1302,20 +1341,20 @@ found:
 
 	pci9111_reset(dev);
 
-	/*  Irq setup */
+	/* Irq setup */
 
 	dev->irq = 0;
 	if (pci_device->irq > 0) {
 		if (request_irq(pci_device->irq, pci9111_interrupt,
 				IRQF_SHARED, PCI9111_DRIVER_NAME, dev) != 0) {
-			printk("comedi%d: unable to allocate irq  %u\n",
-			       dev->minor, pci_device->irq);
+			comedi_err("minor %d: unable to allocate irq %u\n",
+				   dev->minor, pci_device->irq);
 			return -EINVAL;
 		}
 	}
 	dev->irq = pci_device->irq;
 
-	/*  TODO: Add external multiplexer setup (according to option[2]). */
+	/* TODO: Add external multiplexer setup (according to option[2]). */
 
 	error = alloc_subdevices(dev, 4);
 	if (error < 0)
@@ -1327,9 +1366,9 @@ found:
 	subdevice->type = COMEDI_SUBD_AI;
 	subdevice->subdev_flags = SDF_READABLE | SDF_COMMON | SDF_CMD_READ;
 
-	/*  TODO: Add external multiplexer data */
-	/*     if (devpriv->usemux) { subdevice->n_chan = devpriv->usemux; } */
-	/*     else { subdevice->n_chan = this_board->n_aichan; } */
+	/* TODO: Add external multiplexer data */
+	/* if (devpriv->usemux) { subdevice->n_chan = devpriv->usemux; }
+	 * else { subdevice->n_chan = this_board->n_aichan; } */
 
 	subdevice->n_chan = board->ai_channel_nbr;
 	subdevice->maxdata = board->ai_resolution_mask;
@@ -1372,18 +1411,18 @@ found:
 	return 0;
 }
 
-/*  Detach */
+/* Detach */
 
 static int pci9111_detach(struct comedi_device *dev)
 {
-	/*  Reset device */
+	/* Reset device */
 
 	if (dev->private != NULL) {
 		if (dev_private->is_valid)
 			pci9111_reset(dev);
 
 	}
-	/*  Release previously allocated irq */
+	/* Release previously allocated irq */
 
 	if (dev->irq != 0)
 		free_irq(dev->irq, dev);
-- 
1.7.1

