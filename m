Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab2ADMk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 07:40:59 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:45813 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755420Ab2ADMkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 07:40:41 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, rmallon@gmail.com, joe@perches.com,
        valdis.kletnieks@vt.edu,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 03/11] Staging: comedi: fix line over 80 character issue in cb_pcimdas.c
Date: Wed,  4 Jan 2012 18:09:58 +0530
Message-Id: <1325680806-10917-3-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1325680806-10917-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1325680806-10917-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcimdas.c file that fixes up a line
over 80 character warning found by the checkpatch.pl tool.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcimdas.c |   29 +++++++++++++++++++-------
 1 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index 8ba6942..26b082b 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdas.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
@@ -96,7 +96,10 @@ struct cb_pcimdas_board {
 	int ao_nchan;		/*  number of analog out channels */
 	int ao_bits;		/*  analogue output resolution */
 	int has_ao_fifo;	/*  analog output has fifo */
-	int ao_scan_speed;	/*  analog output speed for 1602 series (for a scan, not conversion) */
+	int ao_scan_speed;	/*
+				 * analog output speed for 1602 series
+				 * (for a scan, not conversion)
+				 */
 	int fifo_size;		/*  number of samples fifo can hold */
 	int dio_bits;		/*  number of dio bits */
 	int has_dio;		/*  has DIO */
@@ -139,9 +142,12 @@ MODULE_DEVICE_TABLE(pci, cb_pcimdas_pci_table);
  */
 #define thisboard ((const struct cb_pcimdas_board *)dev->board_ptr)
 
-/* this structure is for data unique to this hardware driver.  If
-   several hardware drivers keep similar information in this structure,
-   feel free to suggest moving the variable to the struct comedi_device struct.  */
+/*
+ * this structure is for data unique to this hardware driver.  If
+ * several hardware drivers keep similar information in this structure,
+ * feel free to suggest moving the variable to the struct comedi_device
+ * struct.
+ */
 struct cb_pcimdas_private {
 	int data;
 
@@ -317,7 +323,8 @@ found:
 	s->subdev_flags = SDF_WRITABLE;
 	s->n_chan = thisboard->ao_nchan;
 	s->maxdata = 1 << thisboard->ao_bits;
-	s->range_table = &range_unknown;	/* ranges are hardware settable, but not software readable. */
+	/* ranges are hardware settable, but not software readable. */
+	s->range_table = &range_unknown;
 	s->insn_write = &cb_pcimdas_ao_winsn;
 	s->insn_read = &cb_pcimdas_ao_rinsn;
 
@@ -400,9 +407,15 @@ static int cb_pcimdas_ai_rinsn(struct comedi_device *dev,
 		outb(d, devpriv->BADR3 + 5);
 	}
 	outb(0x01, devpriv->BADR3 + 6);	/* set bursting off, conversions on */
-	outb(0x00, devpriv->BADR3 + 7);	/* set range to 10V. UP/BP is controlled by a switch on the board */
-
-	/*  write channel limits to multiplexer, set Low (bits 0-3) and High (bits 4-7) channels to chan. */
+	outb(0x00, devpriv->BADR3 + 7);	/*
+					 * set range to 10V. UP/BP is
+					 * controlled by a switch on the board
+					 */
+
+	/*
+	 * write channel limits to multiplexer, set Low (bits 0-3)
+	 * and High (bits 4-7) channels to chan.
+	 */
 	chanlims = chan | (chan << 4);
 	outb(chanlims, devpriv->BADR3 + 0);
 
-- 
1.7.0.4

