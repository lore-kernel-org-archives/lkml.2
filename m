Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab1GIGMo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 02:12:44 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62053 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab1GIGMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 02:12:43 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 9/9] Staging: comedi: fix printk issue in pcmmio.c
Date: Sat,  9 Jul 2011 11:55:00 +0530
Message-Id: <1310192700-14603-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH 1/2]Staging: comedi: fix warning: printk()issue in pcmmio.c>
References: <[PATCH 1/2]Staging: comedi: fix warning: printk()issue in pcmmio.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the pcmmio.c file that fixes up a printk warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/pcmmio.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcmmio.c b/drivers/staging/comedi/drivers/pcmmio.c
index f2e88e5..0a7f07d 100644
--- a/drivers/staging/comedi/drivers/pcmmio.c
+++ b/drivers/staging/comedi/drivers/pcmmio.c
@@ -394,7 +394,7 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
  * convenient macro defined in comedidev.h.
  */
 	if (alloc_private(dev, sizeof(struct pcmmio_private)) < 0) {
-		printk("cannot allocate private data structure\n");
+		printk(KERN_ERR "cannot allocate private data structure\n");
 		return -ENOMEM;
 	}
 
@@ -417,7 +417,7 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	    kcalloc(n_subdevs, sizeof(struct pcmmio_subdev_private),
 		    GFP_KERNEL);
 	if (!devpriv->sprivs) {
-		printk("cannot allocate subdevice private data structures\n");
+		printk(KERN_ERR "cannot allocate subdevice private data structures\n");
 		return -ENOMEM;
 	}
 	/*
@@ -427,7 +427,7 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	 * Allocate 1 AI + 1 AO + 2 DIO subdevs (24 lines per DIO)
 	 */
 	if (alloc_subdevices(dev, n_subdevs) < 0) {
-		printk("cannot allocate subdevice data structures\n");
+		printk(KERN_ERR "cannot allocate subdevice data structures\n");
 		return -ENOMEM;
 	}
 
@@ -557,7 +557,7 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 				 */
 
 	if (irq[0]) {
-		printk("irq: %u ", irq[0]);
+		printk(KERN_INFO "irq: %u ", irq[0]);
 		if (thisboard->dio_num_asics == 2 && irq[1])
 			printk("second ASIC irq: %u ", irq[1]);
 	} else {
@@ -622,7 +622,7 @@ static int pcmmio_dio_insn_bits(struct comedi_device *dev,
 
 #ifdef DAMMIT_ITS_BROKEN
 	/* DEBUG */
-	printk("write mask: %08x  data: %08x\n", data[0], data[1]);
+	printk(KERN_DEBUG "write mask: %08x  data: %08x\n", data[0], data[1]);
 #endif
 
 	s->state = 0;
@@ -663,7 +663,7 @@ static int pcmmio_dio_insn_bits(struct comedi_device *dev,
 		}
 #ifdef DAMMIT_ITS_BROKEN
 		/* DEBUG */
-		printk("data_out_byte %02x\n", (unsigned)byte);
+	printk(KERN_DEBUG "data_out_byte %02x\n", (unsigned) byte);
 #endif
 		/* save the digital input lines for this byte.. */
 		s->state |= ((unsigned int)byte) << offset;
@@ -674,7 +674,7 @@ static int pcmmio_dio_insn_bits(struct comedi_device *dev,
 
 #ifdef DAMMIT_ITS_BROKEN
 	/* DEBUG */
-	printk("s->state %08x data_out %08x\n", s->state, data[1]);
+	printk(KERN_DEBUG "s->state %08x data_out %08x\n", s->state, data[1]);
 #endif
 
 	return 2;
-- 
1.6.5.2

