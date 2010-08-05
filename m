Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760657Ab0HEPBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 11:01:52 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58776 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759128Ab0HEPBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 11:01:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=GazXgVcUkGdRQahFszxFePXkQ7MWx8t/yRoGrvbdAkR9XPge3YDK9MzwGF7X0Po6WL
         M6Vh+m0WAXlL1Ne34yNbI8+JjTxBV3i85HVZXwsmqqOZ+6Bqt7UpVKAekvoNMem46/ZT
         cqJVMww/LWcXsHlxYcLSZX5759ziP0hHKxu3g=
From: Maurice Dawson <mauricedawson2699@gmail.com>
To: gregkh@suse.de, rich.folsom@gmail.com, mithlesh@linsyssoft.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Staging: comedi: fix over 80 characters coding style issue in adl_pci9111.c
Date: Thu,  5 Aug 2010 16:01:28 +0100
Message-Id: <1281020488-2696-1-git-send-email-mauricedawson2699@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the adl_pci9111.c file that fixes up most over 80 characters warnings found by the checkpatch.pl tool. The lines that are still over 80 characters are either strings or, by changing them their readability would be unacceptably reduced.

Signed-off-by: Maurice Dawson <mauricedawson2699@gmail.com>
---
 drivers/staging/comedi/drivers/adl_pci9111.c |   54 +++++++++++++++++---------
 1 files changed, 36 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9111.c b/drivers/staging/comedi/drivers/adl_pci9111.c
index 36a254c..6cd245d 100755
--- a/drivers/staging/comedi/drivers/adl_pci9111.c
+++ b/drivers/staging/comedi/drivers/adl_pci9111.c
@@ -133,12 +133,13 @@ TODO:
 #define PCI9111_8254_BCD_COUNTER		0x01
 
 /* IO address map */
-
-#define PCI9111_REGISTER_AD_FIFO_VALUE 			0x00	/*  AD Data stored in FIFO */
+	/* AD Data stored in FIFO */
+#define PCI9111_REGISTER_AD_FIFO_VALUE			0x00
 #define PCI9111_REGISTER_DA_OUTPUT 			0x00
 #define PCI9111_REGISTER_DIGITAL_IO 			0x02
 #define PCI9111_REGISTER_EXTENDED_IO_PORTS 		0x04
-#define PCI9111_REGISTER_AD_CHANNEL_CONTROL 		0x06	/*  Channel selection */
+	/* Channel selection */
+#define PCI9111_REGISTER_AD_CHANNEL_CONTROL		0x06
 #define PCI9111_REGISTER_AD_CHANNEL_READBACK 		0x06
 #define PCI9111_REGISTER_INPUT_SIGNAL_RANGE 		0x08
 #define PCI9111_REGISTER_RANGE_STATUS_READBACK 		0x08
@@ -202,9 +203,12 @@ TODO:
   outb(0, PCI9111_IO_BASE+PCI9111_REGISTER_SOFTWARE_TRIGGER)
 
 #define pci9111_fifo_reset() \
-  outb(PCI9111_FFEN_SET_FIFO_ENABLE, PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL); \
-  outb(PCI9111_FFEN_SET_FIFO_DISABLE, PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL); \
-  outb(PCI9111_FFEN_SET_FIFO_ENABLE, PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL)
+  outb(PCI9111_FFEN_SET_FIFO_ENABLE, \
+			PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL); \
+  outb(PCI9111_FFEN_SET_FIFO_DISABLE, \
+			PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL); \
+  outb(PCI9111_FFEN_SET_FIFO_ENABLE, \
+			PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL)
 
 #define pci9111_is_fifo_full() \
   ((inb(PCI9111_IO_BASE+PCI9111_REGISTER_RANGE_STATUS_READBACK)& \
@@ -219,27 +223,30 @@ TODO:
     PCI9111_FIFO_EMPTY_MASK)==0)
 
 #define pci9111_ai_channel_set(channel) \
-  outb((channel)&PCI9111_CHANNEL_MASK, PCI9111_IO_BASE+PCI9111_REGISTER_AD_CHANNEL_CONTROL)
+  outb((channel)&PCI9111_CHANNEL_MASK, \
+			PCI9111_IO_BASE+PCI9111_REGISTER_AD_CHANNEL_CONTROL)
 
 #define pci9111_ai_channel_get() \
   inb(PCI9111_IO_BASE+PCI9111_REGISTER_AD_CHANNEL_READBACK)&PCI9111_CHANNEL_MASK
 
 #define pci9111_ai_range_set(range) \
-  outb((range)&PCI9111_RANGE_MASK, PCI9111_IO_BASE+PCI9111_REGISTER_INPUT_SIGNAL_RANGE)
+  outb((range)&PCI9111_RANGE_MASK, \
+			PCI9111_IO_BASE+PCI9111_REGISTER_INPUT_SIGNAL_RANGE)
 
 #define pci9111_ai_range_get() \
   inb(PCI9111_IO_BASE+PCI9111_REGISTER_RANGE_STATUS_READBACK)&PCI9111_RANGE_MASK
 
 #define pci9111_ai_get_data() \
-  ((inw(PCI9111_IO_BASE+PCI9111_REGISTER_AD_FIFO_VALUE)>>4)&PCI9111_AI_RESOLUTION_MASK) \
-  ^ PCI9111_AI_RESOLUTION_2_CMP_BIT
+  ((inw(PCI9111_IO_BASE+PCI9111_REGISTER_AD_FIFO_VALUE)>>4) & \
+	PCI9111_AI_RESOLUTION_MASK) ^ PCI9111_AI_RESOLUTION_2_CMP_BIT
 
 #define pci9111_hr_ai_get_data() \
-  (inw(PCI9111_IO_BASE+PCI9111_REGISTER_AD_FIFO_VALUE) & PCI9111_HR_AI_RESOLUTION_MASK) \
-  ^ PCI9111_HR_AI_RESOLUTION_2_CMP_BIT
+  (inw(PCI9111_IO_BASE+PCI9111_REGISTER_AD_FIFO_VALUE) & \
+	PCI9111_HR_AI_RESOLUTION_MASK) ^ PCI9111_HR_AI_RESOLUTION_2_CMP_BIT
 
 #define pci9111_ao_set_data(data) \
-  outw(data&PCI9111_AO_RESOLUTION_MASK, PCI9111_IO_BASE+PCI9111_REGISTER_DA_OUTPUT)
+  outw(data&PCI9111_AO_RESOLUTION_MASK, \
+				PCI9111_IO_BASE+PCI9111_REGISTER_DA_OUTPUT)
 
 #define pci9111_di_get_bits() \
   inw(PCI9111_IO_BASE+PCI9111_REGISTER_DIGITAL_IO)
@@ -287,7 +294,10 @@ static DEFINE_PCI_DEVICE_TABLE(pci9111_pci_table) = {
 	{
 	PCI_VENDOR_ID_ADLINK, PCI9111_HR_DEVICE_ID, PCI_ANY_ID,
 		    PCI_ANY_ID, 0, 0, 0},
-	    /* { PCI_VENDOR_ID_ADLINK, PCI9111_HG_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 }, */
+	/*
+	 * { PCI_VENDOR_ID_ADLINK, PCI9111_HG_DEVICE_ID,
+	 * PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
+	 */
 	{
 	0}
 };
@@ -345,7 +355,8 @@ struct pci9111_private_data {
 	struct pci_dev *pci_device;
 	unsigned long io_range;	/*  PCI6503 io range */
 
-	unsigned long lcr_io_base;	/*  Local configuration register base address */
+	/* Local configuration register base address */
+	unsigned long lcr_io_base;
 	unsigned long lcr_io_range;
 
 	int stop_counter;
@@ -358,7 +369,8 @@ struct pci9111_private_data {
 
 	int ao_readback;	/*  Last written analog output data */
 
-	unsigned int timer_divisor_1;	/*  Divisor values for the 8254 timer pacer */
+	/* Divisor values for the 8254 timer pacer */
+	unsigned int timer_divisor_1;
 	unsigned int timer_divisor_2;
 
 	int is_valid;		/*  Is device valid */
@@ -575,7 +587,10 @@ pci9111_ai_do_cmd_test(struct comedi_device *dev,
 	if (error)
 		return 1;
 
-	/*  step 2 : make sure trigger sources are unique and mutually compatible */
+	/*  step 2 :
+	 * make sure trigger sources are unique
+	 * and mutually compatible
+	 */
 
 	if (cmd->start_src != TRIG_NOW)
 		error++;
@@ -1269,7 +1284,10 @@ found:
 
 	/*  TODO: Warn about non-tested boards. */
 
-	/*  Read local configuration register base address [PCI_BASE_ADDRESS #1]. */
+	/*
+	 * Read local configuration register base address
+	 * [PCI_BASE_ADDRESS #1].
+	 */
 
 	lcr_io_base = pci_resource_start(pci_device, 1);
 	lcr_io_range = pci_resource_len(pci_device, 1);
-- 
1.7.0.4

