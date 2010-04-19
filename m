Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab0DSQtX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 12:49:23 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:51991 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab0DSQtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 12:49:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=Rw/cLaUvBJnmActfGM+53BqGTFcGY9HVOo6Ln+xKL4kugxkGCyy0OUT9weWP76vkfw
         61gg7kDRGeAfYmwqg+9aSzXVkSuN/gqQo87Hk8vU2SO35d+cOvFEdSzQskXfB/WCeqIg
         3WFr/VexHQuA8rtjiy0CYfmtpyljP41rRs/nw=
From: Maurice Dawson <mauricedawson2699@googlemail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, mithlesh@linsyssoft.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 32/32] Staging: comedi: fix EXPORT_SYMBOL(FOO) coding style issues in ni_labpc.c
Date: Mon, 19 Apr 2010 17:49:08 +0100
Message-Id: <1271695748-3202-1-git-send-email-mauricedawson2699@googlemail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a re-submitted patch to the ni_labpc.c file that fixes EXPORT_SYMBOL(FOO) warnings found by the checkpatch.pl tool

Signed-off-by: Maurice Dawson <mauricedawson2699@googlemail.com>
---
 drivers/staging/comedi/drivers/ni_labpc.c |   31 +++++++++++++++--------------
 1 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index becbe47..26e02d9 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -314,7 +314,6 @@ const int labpc_1200_is_unipolar[NUM_LABPC_1200_AI_RANGES] = {
 	1,
 	1,
 };
-
 /* map range index to gain bits */
 const int labpc_1200_ai_gain_bits[NUM_LABPC_1200_AI_RANGES] = {
 	0x00,
@@ -332,7 +331,6 @@ const int labpc_1200_ai_gain_bits[NUM_LABPC_1200_AI_RANGES] = {
 	0x60,
 	0x70,
 };
-
 const struct comedi_lrange range_labpc_1200_ai = {
 	NUM_LABPC_1200_AI_RANGES,
 	{
@@ -352,7 +350,6 @@ const struct comedi_lrange range_labpc_1200_ai = {
 	UNI_RANGE(0.1),
 	}
 };
-
 /* analog output ranges */
 #define AO_RANGE_IS_UNIPOLAR 0x1
 static const struct comedi_lrange range_labpc_ao = {
@@ -424,6 +421,7 @@ static const struct labpc_board_struct labpc_boards[] = {
 	.ai_scan_up = 0,
 	.memory_mapped_io = 0,
 	},
+
 /* dummy entry so pci board works when comedi_config is passed driver name */
 #ifdef CONFIG_COMEDI_PCI
 	{
@@ -439,14 +437,12 @@ static const struct labpc_board_struct labpc_boards[] = {
 	.ai_scan_up = 1,
 	.memory_mapped_io = 1,
 	},
-
 	{
 	.name = DRV_NAME,
 	.bustype = pci_bustype,
 	},
 #endif
 };
-
 /* Useful for shorthand access to the particular board structure */
 #define thisboard ((struct labpc_board_struct *)dev->board_ptr)
 
@@ -464,12 +460,14 @@ static struct comedi_driver driver_labpc = {
 	.num_names = ARRAY_SIZE(labpc_boards),
 	.board_name = &labpc_boards[0].name,
 	.offset = sizeof(struct labpc_board_struct),
+
 };
 #ifdef CONFIG_COMEDI_PCI
 static DEFINE_PCI_DEVICE_TABLE(labpc_pci_table) = {
 	{
 	PCI_VENDOR_ID_NATINST, 0x161, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
 	0}
+
 };
 MODULE_DEVICE_TABLE(pci, labpc_pci_table);
 #endif /* CONFIG_COMEDI_PCI */
@@ -485,7 +483,7 @@ static inline int labpc_counter_load(struct comedi_device *dev,
 	else
 		return i8254_load(base_address, 0, counter_number, count, mode);
 }
-EXPORT_SYMBOL_GPL(labpc_1200_ai_gain_bits);
+
 int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 					unsigned int irq, unsigned int dma_chan)
 {
@@ -597,11 +595,11 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 
 	/* analog output */
 	s = dev->subdevices + 1;
-if (thisboard->has_ao) {
-	/*
-	 * Could provide command support, except it only has a one sample
-	 * hardware buffer for analog output and no underrun flag
-	 */
+	if (thisboard->has_ao) {
+		/*
+		 * Could provide command support, except it only has a one
+		 * sample hardware buffer for analog output and no underrun flag
+		 */
 		s->type = COMEDI_SUBD_AO;
 		s->subdev_flags = SDF_READABLE | SDF_WRITABLE | SDF_GROUND;
 		s->n_chan = NUM_AO_CHAN;
@@ -673,7 +671,6 @@ if (thisboard->has_ao) {
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(labpc_1200_is_unipolar);
 static int labpc_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	unsigned long iobase = 0;
@@ -725,6 +722,7 @@ static int labpc_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return labpc_common_attach(dev, iobase, irq, dma_chan);
 }
 EXPORT_SYMBOL_GPL(labpc_common_attach);
+
 /* adapted from ni_pcimio for finding mite based boards (pc-1200) */
 #ifdef CONFIG_COMEDI_PCI
 static int labpc_find_device(struct comedi_device *dev, int bus, int slot)
@@ -771,6 +769,8 @@ int labpc_common_detach(struct comedi_device *dev)
 		subdev_8255_cleanup(dev, dev->subdevices + 2);
 
 	/* only free stuff if it has been allocated by _attach */
 	if (devpriv->dma_chan)
 		free_dma(devpriv->dma_chan);
 	if (dev->irq)
@@ -2066,7 +2066,7 @@ static unsigned int labpc_eeprom_read_status(struct comedi_device *dev)
 
 	return value;
 }
-
+EXPORT_SYMBOL_GPL(range_labpc_1200_ai);
 /* writes to 8 bit calibration dacs */
 static void write_caldac(struct comedi_device *dev, unsigned int channel,
 					unsigned int value)
@@ -2094,10 +2094,11 @@ static void write_caldac(struct comedi_device *dev, unsigned int channel,
 	udelay(1);
 	devpriv->write_byte(devpriv->command5_bits, dev->iobase + COMMAND5_REG);
 }
-
+EXPORT_SYMBOL_GPL(labpc_1200_ai_gain_bits);
 #ifdef CONFIG_COMEDI_PCI
 COMEDI_PCI_INITCLEANUP(driver_labpc, labpc_pci_table);
 #else
 COMEDI_INITCLEANUP(driver_labpc);
 #endif
-EXPORT_SYMBOL_GPL(range_labpc_1200_ai);
+EXPORT_SYMBOL_GPL(labpc_1200_is_unipolar);
+
-- 
1.6.3.3

