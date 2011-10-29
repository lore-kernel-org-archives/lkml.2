Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115Ab1J2N0B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 09:26:01 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38279 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933008Ab1J2NZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 09:25:59 -0400
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 3/7] Staging: comedi: fix printk issue in c6xdigio.c
Date: Sat, 29 Oct 2011 18:55:25 +0530
Message-Id: <1319894729-1744-3-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319894729-1744-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1319894729-1744-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the c6xdigio.c file that fixes up a printk
warning found by the checkpatch.pl tool.

Converted printks to dev_version.
Function name is converted to %s, __func__ format.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/c6xdigio.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/c6xdigio.c b/drivers/staging/comedi/drivers/c6xdigio.c
index e0ac825..f8352bf 100644
--- a/drivers/staging/comedi/drivers/c6xdigio.c
+++ b/drivers/staging/comedi/drivers/c6xdigio.c
@@ -343,7 +343,7 @@ static int c6xdigio_pwmo_insn_read(struct comedi_device *dev,
 				   struct comedi_subdevice *s,
 				   struct comedi_insn *insn, unsigned int *data)
 {
-	printk("c6xdigio_pwmo_insn_read %x\n", insn->n);
+	dev_dbg(dev->hw_dev, "%s: %x\n", __func__, insn->n);
 	return insn->n;
 }
 
@@ -439,9 +439,11 @@ static int c6xdigio_attach(struct comedi_device *dev,
 	struct comedi_subdevice *s;
 
 	iobase = it->options[0];
-	printk("comedi%d: c6xdigio: 0x%04lx\n", dev->minor, iobase);
+	dev_dbg(dev->hw_dev, "comedi%d: c6xdigio: 0x%04lx\n", dev->minor,
+		iobase);
 	if (!request_region(iobase, C6XDIGIO_SIZE, "c6xdigio")) {
-		printk("comedi%d: I/O port conflict\n", dev->minor);
+		dev_err(dev->hw_dev, "comedi%d: I/O port conflict\n",
+			dev->minor);
 		return -EIO;
 	}
 	dev->iobase = iobase;
@@ -456,9 +458,10 @@ static int c6xdigio_attach(struct comedi_device *dev,
 
 	irq = it->options[1];
 	if (irq > 0)
-		printk("comedi%d: irq = %u ignored\n", dev->minor, irq);
+		dev_dbg(dev->hw_dev, "comedi%d: irq = %u ignored\n",
+			dev->minor, irq);
 	else if (irq == 0)
-		printk("comedi%d: no irq\n", dev->minor);
+		dev_dbg(dev->hw_dev, "comedi%d: no irq\n", dev->minor);
 
 	s = dev->subdevices + 0;
 	/* pwm output subdevice */
@@ -503,7 +506,7 @@ static int c6xdigio_detach(struct comedi_device *dev)
 {
 	/* board_halt(dev);  may not need this */
 
-	printk("comedi%d: c6xdigio: remove\n", dev->minor);
+	dev_dbg(dev->hw_dev, "comedi%d: c6xdigio: remove\n", dev->minor);
 
 	if (dev->iobase)
 		release_region(dev->iobase, C6XDIGIO_SIZE);
-- 
1.7.0.4

