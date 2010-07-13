Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025Ab0GMQYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 12:24:09 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52319 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab0GMQYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 12:24:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=dn8diwQR2wIZ44q9WxIeyIrU8eH59X423mMm4uqfKx7at07HuOe3l/KgsH1VzSFew8
         dUfztrPLmbSy3aZCTTV6V48jCzc/AcoQ3uv4w+QbzjOTwYR9Jow72ou/ehEk50nS/+GP
         F2aBFqsjAuREYSyfh9C22pLDWTfyy8+Lfp+5U=
From: Mark <reodge@gmail.com>
To: gregkh@suse.de
Cc: Mark <reodge@gmail.com>, Arun Thomas <arun.thomas@gmail.com>,
        Kulikov Vasiliy <segooon@gmail.com>,
        Rich Folsom <rich.folsom@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: comedi: Cleanup style issues in adl_pci9111.c
Date: Tue, 13 Jul 2010 17:24:17 +0100
Message-Id: <1279038257-18055-1-git-send-email-reodge@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes some coding style issues in adl_pci9111.c from checkpatch.pl

Signed-off-by: Mark Rankilor <reodge@gmail.com>
---
 drivers/staging/comedi/drivers/adl_pci9111.c |   60 +++++++++++++++-----------
 1 files changed, 35 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9111.c b/drivers/staging/comedi/drivers/adl_pci9111.c
index 896fec6..b2a02b0 100644
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
@@ -247,12 +247,14 @@ TODO:
     &PCI9111_AI_RESOLUTION_MASK)					\
    ^ PCI9111_AI_RESOLUTION_2_CMP_BIT)
 
-#define pci9111_hr_ai_get_data() \
-  (inw(PCI9111_IO_BASE+PCI9111_REGISTER_AD_FIFO_VALUE) & PCI9111_HR_AI_RESOLUTION_MASK) \
-  ^ PCI9111_HR_AI_RESOLUTION_2_CMP_BIT
+#define pci9111_hr_ai_get_data()					\
+  ((inw(PCI9111_IO_BASE+PCI9111_REGISTER_AD_FIFO_VALUE)			\
+    & PCI9111_HR_AI_RESOLUTION_MASK)					\
+   ^ PCI9111_HR_AI_RESOLUTION_2_CMP_BIT)
 
-#define pci9111_ao_set_data(data) \
-  outw(data&PCI9111_AO_RESOLUTION_MASK, PCI9111_IO_BASE+PCI9111_REGISTER_DA_OUTPUT)
+#define pci9111_ao_set_data(data)					\
+  outw(data&PCI9111_AO_RESOLUTION_MASK,					\
+       PCI9111_IO_BASE+PCI9111_REGISTER_DA_OUTPUT)
 
 #define pci9111_di_get_bits() \
   inw(PCI9111_IO_BASE+PCI9111_REGISTER_DIGITAL_IO)
@@ -297,12 +299,11 @@ static const struct comedi_lrange pci9111_hr_ai_range = {
 };
 
 static DEFINE_PCI_DEVICE_TABLE(pci9111_pci_table) = {
-	{
-	PCI_VENDOR_ID_ADLINK, PCI9111_HR_DEVICE_ID, PCI_ANY_ID,
-		    PCI_ANY_ID, 0, 0, 0},
-	    /* { PCI_VENDOR_ID_ADLINK, PCI9111_HG_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 }, */
-	{
-	0}
+	{ PCI_VENDOR_ID_ADLINK, PCI9111_HR_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID,
+	  0, 0, 0 },
+	/* { PCI_VENDOR_ID_ADLINK, PCI9111_HG_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID,
+	 *   0, 0, 0 }, */
+	{ 0 }
 };
 
 MODULE_DEVICE_TABLE(pci, pci9111_pci_table);
@@ -394,7 +395,8 @@ struct pci9111_private_data {
 	struct pci_dev *pci_device;
 	unsigned long io_range;	/*  PCI6503 io range */
 
-	unsigned long lcr_io_base;	/*  Local configuration register base address */
+	unsigned long lcr_io_base; /* Local configuration register base
+				    * address */
 	unsigned long lcr_io_range;
 
 	int stop_counter;
@@ -407,7 +409,8 @@ struct pci9111_private_data {
 
 	int ao_readback;	/*  Last written analog output data */
 
-	unsigned int timer_divisor_1;	/*  Divisor values for the 8254 timer pacer */
+	unsigned int timer_divisor_1; /* Divisor values for the 8254 timer
+				       * pacer */
 	unsigned int timer_divisor_2;
 
 	int is_valid;		/*  Is device valid */
@@ -415,7 +418,7 @@ struct pci9111_private_data {
 	short ai_bounce_buffer[2 * PCI9111_FIFO_HALF_SIZE];
 };
 
-#define dev_private 	((struct pci9111_private_data *)dev->private)
+#define dev_private	((struct pci9111_private_data *)dev->private)
 
 /*  ------------------------------------------------------------------ */
 /*  PLX9050 SECTION */
@@ -597,10 +600,12 @@ static int pci9111_ai_cancel(struct comedi_device *dev,
 
 /*  Test analog input command */
 
-#define pci9111_check_trigger_src(src, flags) \
-  tmp = src; \
-  src &= flags; \
-  if (!src || tmp != src) error++
+#define pci9111_check_trigger_src(src, flags)	do {			\
+		tmp = src;						\
+		src &= flags;						\
+		if (!src || tmp != src)					\
+			error++;					\
+	} while (false);
 
 static int
 pci9111_ai_do_cmd_test(struct comedi_device *dev,
@@ -624,7 +629,8 @@ pci9111_ai_do_cmd_test(struct comedi_device *dev,
 	if (error)
 		return 1;
 
-	/*  step 2 : make sure trigger sources are unique and mutually compatible */
+	/*  step 2 : make sure trigger sources are unique and mutually
+	 *  compatible */
 
 	if (cmd->start_src != TRIG_NOW)
 		error++;
@@ -686,7 +692,8 @@ pci9111_ai_do_cmd_test(struct comedi_device *dev,
 		cmd->scan_begin_arg = board->ai_acquisition_period_min_ns;
 		error++;
 	}
-	if ((cmd->scan_begin_src == TRIG_FOLLOW) && (cmd->scan_begin_arg != 0)) {
+	if ((cmd->scan_begin_src == TRIG_FOLLOW)
+	    && (cmd->scan_begin_arg != 0)) {
 		cmd->scan_begin_arg = 0;
 		error++;
 	}
@@ -1280,10 +1287,12 @@ static int pci9111_attach(struct comedi_device *dev,
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
@@ -1319,7 +1328,8 @@ found:
 
 	/*  TODO: Warn about non-tested boards. */
 
-	/*  Read local configuration register base address [PCI_BASE_ADDRESS #1]. */
+	/*  Read local configuration register base address
+	 *  [PCI_BASE_ADDRESS #1]. */
 
 	lcr_io_base = pci_resource_start(pci_device, 1);
 	lcr_io_range = pci_resource_len(pci_device, 1);
-- 
1.7.1

