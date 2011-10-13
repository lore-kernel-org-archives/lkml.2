Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab1JMGs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 02:48:59 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37210 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab1JMGs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 02:48:58 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, joe@perches.com,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 5/5] Staging: comedi: fix printk issue in c6xdigio.c
Date: Thu, 13 Oct 2011 12:18:05 +0530
Message-Id: <1318488485-15318-1-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the c6xdigio.c file that fixes up a printk warning
found by the checkpatch.pl tool

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
Converted embedded function names to "%s", __func__ as Joe Perches
suggested and printk to pr_<level>.
	
 drivers/staging/comedi/drivers/c6xdigio.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/c6xdigio.c b/drivers/staging/comedi/drivers/c6xdigio.c
index e0ac825..a372a64 100644
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
 
@@ -439,9 +439,8 @@ static int c6xdigio_attach(struct comedi_device *dev,
 	struct comedi_subdevice *s;
 
 	iobase = it->options[0];
-	printk("comedi%d: c6xdigio: 0x%04lx\n", dev->minor, iobase);
 	if (!request_region(iobase, C6XDIGIO_SIZE, "c6xdigio")) {
-		printk("comedi%d: I/O port conflict\n", dev->minor);
+		pr_err("comedi%d: I/O port conflict\n", dev->minor);
 		return -EIO;
 	}
 	dev->iobase = iobase;
@@ -456,9 +455,9 @@ static int c6xdigio_attach(struct comedi_device *dev,
 
 	irq = it->options[1];
 	if (irq > 0)
-		printk("comedi%d: irq = %u ignored\n", dev->minor, irq);
+		pr_debug("comedi%d: irq = %u ignored\n", dev->minor, irq);
 	else if (irq == 0)
-		printk("comedi%d: no irq\n", dev->minor);
+		pr_debug("comedi%d: no irq\n", dev->minor);
 
 	s = dev->subdevices + 0;
 	/* pwm output subdevice */
@@ -503,8 +502,6 @@ static int c6xdigio_detach(struct comedi_device *dev)
 {
 	/* board_halt(dev);  may not need this */
 
-	printk("comedi%d: c6xdigio: remove\n", dev->minor);
-
 	if (dev->iobase)
 		release_region(dev->iobase, C6XDIGIO_SIZE);
 
-- 
1.7.6.4

