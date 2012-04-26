Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab2DZKDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 06:03:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44048 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437Ab2DZKDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 06:03:00 -0400
From: Ravishankar Karkala Mallikarjunayya <ravishankarkm32@gmail.com>
To: gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 3/4] Staging: comedi: fix line over 80 character issue in cb_pcimdas.c.
Date: Thu, 26 Apr 2012 15:32:19 +0530
Message-Id: <1335434540-13286-4-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1335434540-13286-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1335434540-13286-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcimdas.c file that fixes up a line
over 80 character warning found by the checkpatch.pl tool.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcimdas.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index 8ba6942..dd34b1a 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdas.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
@@ -139,9 +139,12 @@ MODULE_DEVICE_TABLE(pci, cb_pcimdas_pci_table);
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
 
@@ -317,7 +320,8 @@ found:
 	s->subdev_flags = SDF_WRITABLE;
 	s->n_chan = thisboard->ao_nchan;
 	s->maxdata = 1 << thisboard->ao_bits;
-	s->range_table = &range_unknown;	/* ranges are hardware settable, but not software readable. */
+	/* ranges are hardware settable, but not software readable. */
+	s->range_table = &range_unknown;
 	s->insn_write = &cb_pcimdas_ao_winsn;
 	s->insn_read = &cb_pcimdas_ao_rinsn;
 
@@ -402,7 +406,10 @@ static int cb_pcimdas_ai_rinsn(struct comedi_device *dev,
 	outb(0x01, devpriv->BADR3 + 6);	/* set bursting off, conversions on */
 	outb(0x00, devpriv->BADR3 + 7);	/* set range to 10V. UP/BP is controlled by a switch on the board */
 
-	/*  write channel limits to multiplexer, set Low (bits 0-3) and High (bits 4-7) channels to chan. */
+	/*
+	 * write channel limits to multiplexer, set Low (bits 0-3) and
+	 * High (bits 4-7) channels to chan.
+	 */
 	chanlims = chan | (chan << 4);
 	outb(chanlims, devpriv->BADR3 + 0);
 
-- 
1.7.0.4

