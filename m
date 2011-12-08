Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab1LHMxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 07:53:36 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44906 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab1LHMxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 07:53:32 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 08/30] Staging: comedi: fix line over 80 character issue in cb_pcimdda.c
Date: Thu,  8 Dec 2011 18:22:03 +0530
Message-Id: <1323348745-31477-8-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcimdda.c file that fixes up a
line over 80 character warning found by the checkpatch.pl tool.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcimdda.c |   24 +++++++++++++++++-------
 1 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index d2f3c3b..5d7a696 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -105,7 +105,8 @@ struct board_struct {
 	int ao_bits;
 	int dio_chans;
 	int dio_method;
-	int dio_offset;		/* how many bytes into the BADR are the DIO ports */
+	/* how many bytes into the BADR are the DIO ports */
+	int dio_offset;
 	int regs_badrindex;	/* IO Region for the control, analog output,
 				   and DIO registers */
 	int reg_sz;		/* number of bytes of registers in io region */
@@ -150,9 +151,12 @@ static DEFINE_PCI_DEVICE_TABLE(pci_table) = {
 
 MODULE_DEVICE_TABLE(pci, pci_table);
 
-/* this structure is for data unique to this hardware driver.  If
-   several hardware drivers keep similar information in this structure,
-   feel free to suggest moving the variable to the struct comedi_device struct.  */
+/*
+ * this structure is for data unique to this hardware driver.  If
+ * several hardware drivers keep similar information in this structure,
+ * feel free to suggest moving the variable to the struct comedi_device
+ * struct.
+ */
 struct board_private_struct {
 	unsigned long registers;	/* set by probe */
 	unsigned long dio_registers;
@@ -334,7 +338,10 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (thisboard->dio_chans) {
 		switch (thisboard->dio_method) {
 		case DIO_8255:
-			/* this is a straight 8255, so register us with the 8255 driver */
+			/*
+			 * this is a straight 8255, so register us with
+			 * the 8255 driver
+			 */
 			subdev_8255_init(dev, s, NULL, devpriv->dio_registers);
 			devpriv->attached_to_8255 = 1;
 			break;
@@ -433,8 +440,11 @@ static int ao_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 
 	for (i = 0; i < insn->n; i++) {
 		inw(devpriv->registers + chan * 2);
-		/* should I set data[i] to the result of the actual read on the register
-		   or the cached unsigned int in devpriv->ao_readback[]? */
+		/*
+		 * should I set data[i] to the result of the actual read
+		 * on the register or the cached unsigned int in
+		 * devpriv->ao_readback[]?
+		 */
 		data[i] = devpriv->ao_readback[chan];
 	}
 
-- 
1.7.0.4

