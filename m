Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab1LHMxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 07:53:43 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36787 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab1LHMxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 07:53:39 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 10/30] Staging: comedi: fix printk issue in pcmuio.c
Date: Thu,  8 Dec 2011 18:22:05 +0530
Message-Id: <1323348745-31477-10-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the pcmuio.c file that fixes up a
printk warning found by the checkpatch.pl tool.

Removed ifdef DAMMIT_ITS_BROKEN.
Converted printks to pr_<levels>.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/pcmuio.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcmuio.c b/drivers/staging/comedi/drivers/pcmuio.c
index 1de663e..a005e2d 100644
--- a/drivers/staging/comedi/drivers/pcmuio.c
+++ b/drivers/staging/comedi/drivers/pcmuio.c
@@ -498,11 +498,8 @@ static int pcmuio_dio_insn_bits(struct comedi_device *dev,
 	/* The insn data is a mask in data[0] and the new data
 	 * in data[1], each channel cooresponding to a bit. */
 
-#ifdef DAMMIT_ITS_BROKEN
 	/* DEBUG */
-	printk("write mask: %08x  data: %08x\n", data[0], data[1]);
-#endif
-
+	pr_debug("write mask: %08x  data: %08x\n", data[0], data[1]);
 	s->state = 0;
 
 	for (byte_no = 0; byte_no < s->n_chan / CHANS_PER_PORT; ++byte_no) {
@@ -534,10 +531,8 @@ static int pcmuio_dio_insn_bits(struct comedi_device *dev,
 			/* Write out the new digital output state */
 			outb(byte, ioaddr);
 		}
-#ifdef DAMMIT_ITS_BROKEN
 		/* DEBUG */
-		printk("data_out_byte %02x\n", (unsigned)byte);
-#endif
+		pr_debug("data_out_byte %02x\n", (unsigned)byte);
 		/* save the digital input lines for this byte.. */
 		s->state |= ((unsigned int)byte) << offset;
 	}
@@ -545,10 +540,8 @@ static int pcmuio_dio_insn_bits(struct comedi_device *dev,
 	/* now return the DIO lines to data[1] - note they came inverted! */
 	data[1] = ~s->state;
 
-#ifdef DAMMIT_ITS_BROKEN
 	/* DEBUG */
-	printk("s->state %08x data_out %08x\n", s->state, data[1]);
-#endif
+	pr_debug("s->state %08x data_out %08x\n", s->state, data[1]);
 
 	return 2;
 }
-- 
1.7.0.4

