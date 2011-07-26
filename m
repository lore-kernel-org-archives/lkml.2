Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab1GZJQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 05:16:23 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38693 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab1GZJQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 05:16:16 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankr <ravishankarkm32@gmail.com>
Subject: [PATCH 1/1 v3] Staging: comedi: fix printk issue in c6xdigio.c
Date: Tue, 26 Jul 2011 14:59:43 +0530
Message-Id: <1311672583-3152-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH]Staging: Comedi: fix printk issue in c6xdigio.c>
References: <[PATCH]Staging: Comedi: fix printk issue in c6xdigio.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the c6xdigio.c file that fixes up a printk warning found by the checkpatch.pl tool

Signed-off-by: Ravishankr <ravishankarkm32@gmail.com>
---

 Added __func__ names to  printks.

 drivers/staging/comedi/drivers/c6xdigio.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/c6xdigio.c b/drivers/staging/comedi/drivers/c6xdigio.c
index e0ac825..b0b578c 100644
--- a/drivers/staging/comedi/drivers/c6xdigio.c
+++ b/drivers/staging/comedi/drivers/c6xdigio.c
@@ -343,7 +343,7 @@ static int c6xdigio_pwmo_insn_read(struct comedi_device *dev,
 				   struct comedi_subdevice *s,
 				   struct comedi_insn *insn, unsigned int *data)
 {
-	printk("c6xdigio_pwmo_insn_read %x\n", insn->n);
+	pr_info("%s %x\n", __func__, insn->n);
 	return insn->n;
 }
 
@@ -439,9 +439,9 @@ static int c6xdigio_attach(struct comedi_device *dev,
 	struct comedi_subdevice *s;
 
 	iobase = it->options[0];
-	printk("comedi%d: c6xdigio: 0x%04lx\n", dev->minor, iobase);
+	pr_info("%s: comedi%d: c6xdigio: 0x%04lx\n", __func__,
+	iobase);
 	if (!request_region(iobase, C6XDIGIO_SIZE, "c6xdigio")) {
-		printk("comedi%d: I/O port conflict\n", dev->minor);
+		pr_err("%s: comedi%d: I/O port conflict\n", __func__,
+		dev->minor);
 		return -EIO;
 	}
 	dev->iobase = iobase;
@@ -456,9 +456,9 @@ static int c6xdigio_attach(struct comedi_device *dev,
 
 	irq = it->options[1];
 	if (irq > 0)
-		printk("comedi%d: irq = %u ignored\n", dev->minor, irq);
+		pr_debug("%s: comedi%d: irq = %u ignored\n", __func__
+		dev->minor, irq);
 	else if (irq == 0)
-		printk("comedi%d: no irq\n", dev->minor);
+		pr_debug("%s: comedi%d: no irq\n", __func__, dev->minor);
 
 	s = dev->subdevices + 0;
 	/* pwm output subdevice */
@@ -503,7 +503,7 @@ static int c6xdigio_detach(struct comedi_device *dev)
 {
 	/* board_halt(dev);  may not need this */
 
-	printk("comedi%d: c6xdigio: remove\n", dev->minor);
+	pr_info("%s: comedi%d: c6xdigio: remove\n", __func__, dev->minor);
 
 	if (dev->iobase)
 		release_region(dev->iobase, C6XDIGIO_SIZE);
-- 
1.6.5.2

