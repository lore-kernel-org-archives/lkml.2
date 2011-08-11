Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816Ab1HKMvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 08:51:45 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:63255 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761Ab1HKMvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 08:51:39 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH] Staging: comedi: fix printk issue in c6xdigio.c
Date: Thu, 11 Aug 2011 18:36:07 +0530
Message-Id: <1313067967-19408-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH]Staging: comedi:fix printk warning issue in c6xdigio.c>
References: <[PATCH]Staging: comedi:fix printk warning issue in c6xdigio.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the c6xdigio.c file that fixes up a printk() warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/c6xdigio.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/c6xdigio.c b/drivers/staging/comedi/drivers/c6xdigio.c
index e0ac825..f566ee7 100644
--- a/drivers/staging/comedi/drivers/c6xdigio.c
+++ b/drivers/staging/comedi/drivers/c6xdigio.c
@@ -343,7 +343,7 @@ static int c6xdigio_pwmo_insn_read(struct comedi_device *dev,
 				   struct comedi_subdevice *s,
 				   struct comedi_insn *insn, unsigned int *data)
 {
-	printk("c6xdigio_pwmo_insn_read %x\n", insn->n);
+	pr_debug("%s: %x\n", __func__, insn->n);
 	return insn->n;
 }
 
@@ -439,9 +439,9 @@ static int c6xdigio_attach(struct comedi_device *dev,
 	struct comedi_subdevice *s;
 
 	iobase = it->options[0];
-	printk("comedi%d: c6xdigio: 0x%04lx\n", dev->minor, iobase);
+	pr_debug("comedi%d: c6xdigio: 0x%04lx\n", dev->minor, iobase);
 	if (!request_region(iobase, C6XDIGIO_SIZE, "c6xdigio")) {
-		printk("comedi%d: I/O port conflict\n", dev->minor);
+		pr_warn("comedi%d: I/O port conflict\n", dev->minor);
 		return -EIO;
 	}
 	dev->iobase = iobase;
@@ -456,9 +456,9 @@ static int c6xdigio_attach(struct comedi_device *dev,
 
 	irq = it->options[1];
 	if (irq > 0)
-		printk("comedi%d: irq = %u ignored\n", dev->minor, irq);
+		pr_warn("comedi%d: irq = %u ignored\n", dev->minor, irq);
 	else if (irq == 0)
-		printk("comedi%d: no irq\n", dev->minor);
+		pr_warn("comedi%d: no irq\n", dev->minor);
 
 	s = dev->subdevices + 0;
 	/* pwm output subdevice */
@@ -503,7 +503,7 @@ static int c6xdigio_detach(struct comedi_device *dev)
 {
 	/* board_halt(dev);  may not need this */
 
-	printk("comedi%d: c6xdigio: remove\n", dev->minor);
+	pr_debug("comedi%d: c6xdigio: remove\n", dev->minor);
 
 	if (dev->iobase)
 		release_region(dev->iobase, C6XDIGIO_SIZE);
-- 
1.6.5.2

