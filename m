Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab1JJKLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 06:11:21 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60234 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab1JJKLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 06:11:19 -0400
From: Nasir Abed <nasirabed@gmail.com>
To: gregkh@suse.de
Cc: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Nasir Abed <nasirabed+kernel@gmail.com>
Subject: [PATCH] Staging: comedi: c6xdigio: fixed missing KERN_* in printk
Date: Mon, 10 Oct 2011 12:09:52 +0200
Message-Id: <1318241392-11464-1-git-send-email-nasirabed+kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed missing KERN_* in printk statements.

Signed-off-by: Nasir Abed <nasirabed+kernel@gmail.com>
---
 drivers/staging/comedi/drivers/c6xdigio.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/c6xdigio.c b/drivers/staging/comedi/drivers/c6xdigio.c
index e0ac825..11cdaf2 100644
--- a/drivers/staging/comedi/drivers/c6xdigio.c
+++ b/drivers/staging/comedi/drivers/c6xdigio.c
@@ -343,7 +343,7 @@ static int c6xdigio_pwmo_insn_read(struct comedi_device *dev,
 				   struct comedi_subdevice *s,
 				   struct comedi_insn *insn, unsigned int *data)
 {
-	printk("c6xdigio_pwmo_insn_read %x\n", insn->n);
+	printk(KERN_DEBUG "c6xdigio_pwmo_insn_read %x\n", insn->n);
 	return insn->n;
 }
 
@@ -439,9 +439,9 @@ static int c6xdigio_attach(struct comedi_device *dev,
 	struct comedi_subdevice *s;
 
 	iobase = it->options[0];
-	printk("comedi%d: c6xdigio: 0x%04lx\n", dev->minor, iobase);
+	printk(KERN_DEBUG "comedi%d: c6xdigio: 0x%04lx\n", dev->minor, iobase);
 	if (!request_region(iobase, C6XDIGIO_SIZE, "c6xdigio")) {
-		printk("comedi%d: I/O port conflict\n", dev->minor);
+		printk(KERN_ERR "comedi%d: I/O port conflict\n", dev->minor);
 		return -EIO;
 	}
 	dev->iobase = iobase;
@@ -456,9 +456,10 @@ static int c6xdigio_attach(struct comedi_device *dev,
 
 	irq = it->options[1];
 	if (irq > 0)
-		printk("comedi%d: irq = %u ignored\n", dev->minor, irq);
+		printk(KERN_DEBUG "comedi%d: irq = %u ignored\n",
+				dev->minor, irq);
 	else if (irq == 0)
-		printk("comedi%d: no irq\n", dev->minor);
+		printk(KERN_DEBUG "comedi%d: no irq\n", dev->minor);
 
 	s = dev->subdevices + 0;
 	/* pwm output subdevice */
@@ -503,7 +504,7 @@ static int c6xdigio_detach(struct comedi_device *dev)
 {
 	/* board_halt(dev);  may not need this */
 
-	printk("comedi%d: c6xdigio: remove\n", dev->minor);
+	printk(KERN_DEBUG "comedi%d: c6xdigio: remove\n", dev->minor);
 
 	if (dev->iobase)
 		release_region(dev->iobase, C6XDIGIO_SIZE);
-- 
1.5.4.3

