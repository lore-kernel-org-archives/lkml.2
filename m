Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab2KACjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 22:39:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56309 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756791Ab2KACjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 22:39:23 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 3/3] staging/comedi: Use dev_ printks in drivers/ni_mio_cs.c
Date: Thu,  1 Nov 2012 11:39:18 +0900
Message-Id: <1351737558-7718-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351737466-7650-1-git-send-email-yamanetoshi@gmail.com>
References: <1351737466-7650-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
- WARNING: printk() should include KERN_ facility level

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/comedi/drivers/ni_mio_cs.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_mio_cs.c b/drivers/staging/comedi/drivers/ni_mio_cs.c
index f844684..76c6a13 100644
--- a/drivers/staging/comedi/drivers/ni_mio_cs.c
+++ b/drivers/staging/comedi/drivers/ni_mio_cs.c
@@ -340,13 +340,15 @@ static int mio_cs_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	irq = link->irq;
 
-	printk("comedi%d: %s: DAQCard: io 0x%04lx, irq %u, ",
-	       dev->minor, dev->driver->driver_name, dev->iobase, irq);
+	dev->board_ptr = ni_boards + ni_getboardtype(dev, link);
 
 #if 0
 	{
 		int i;
 
+		printk("comedi%d: %s: DAQCard: io 0x%04lx, irq %u, ",
+		       dev->minor, dev->driver->driver_name, dev->iobase, irq);
+
 		printk(" board fingerprint:");
 		for (i = 0; i < 32; i += 2) {
 			printk(" %04x %02x", inw(dev->iobase + i),
@@ -357,18 +359,17 @@ static int mio_cs_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		for (i = 0; i < 10; i++)
 			printk(" 0x%04x", win_in(i));
 		printk("\n");
+
+		printk("boardtype.name: %s\n", boardtype.name);
 	}
 #endif
 
-	dev->board_ptr = ni_boards + ni_getboardtype(dev, link);
-
-	printk(" %s", boardtype.name);
 	dev->board_name = boardtype.name;
 
 	ret = request_irq(irq, ni_E_interrupt, NI_E_IRQ_FLAGS,
 			  "ni_mio_cs", dev);
 	if (ret < 0) {
-		printk(" irq not available\n");
+		dev_err(dev->class_dev, "irq not available\n");
 		return -EINVAL;
 	}
 	dev->irq = irq;
@@ -401,7 +402,8 @@ static int ni_getboardtype(struct comedi_device *dev,
 			return i;
 	}
 
-	printk("unknown board 0x%04x -- pretend it is a ", link->card_id);
+	dev_err(dev->class_dev,
+		"unknown board 0x%04x -- pretend it is a ", link->card_id);
 
 	return 0;
 }
-- 
1.7.9.5

