Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab2IMBqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 21:46:49 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60775 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab2IMBqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 21:46:47 -0400
From: Bruce Humphrey <brucehum@gmail.com>
To: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        gregkh@linuxfoundation.org
Cc: hsweeten@visionengravers.com, standby24x7@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Bruce Humphrey <brucehum@gmail.com>
Subject: [PATCH 2/2] Staging: comedi: fl512: Replace printk with dev_info et al
Date: Thu, 13 Sep 2012 03:46:36 +0200
Message-Id: <1347500796-4432-1-git-send-email-brucehum@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace printk(KERN_XXX with the appropiate dev_info, dev_warn, dev_dbg in fl512.c

Signed-off-by: Bruce Humphrey Ventura <brucehum@gmail.com>
---
 drivers/staging/comedi/drivers/fl512.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/fl512.c b/drivers/staging/comedi/drivers/fl512.c
index d1da809..5a8e0ae 100644
--- a/drivers/staging/comedi/drivers/fl512.c
+++ b/drivers/staging/comedi/drivers/fl512.c
@@ -118,9 +118,9 @@ static int fl512_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	struct comedi_subdevice *s;
 
 	iobase = it->options[0];
-	printk(KERN_INFO "comedi:%d fl512: 0x%04lx", dev->minor, iobase);
+	dev_info(dev->class_dev, "%s: 0x%04lx\n", dev->board_name, iobase);
 	if (!request_region(iobase, FL512_SIZE, "fl512")) {
-		printk(KERN_WARNING " I/O port conflict\n");
+		dev_warn(dev->class_dev, " I/O port conflict\n");
 		return -EIO;
 	}
 	dev->iobase = iobase;
@@ -129,7 +129,7 @@ static int fl512_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		return -ENOMEM;
 
 #if DEBUG
-	printk(KERN_DEBUG "malloc ok\n");
+	dev_dbg(dev->class_dev, "malloc ok\n");
 #endif
 
 	ret = comedi_alloc_subdevices(dev, 2);
@@ -153,7 +153,8 @@ static int fl512_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->range_table = &range_fl512;
 	/* function to call when read AD */
 	s->insn_read = fl512_ai_insn;
-	printk(KERN_INFO "comedi: fl512: subdevice 0 initialized\n");
+	dev_info(dev->class_dev, "%s: subdevice 0 initialized\n",
+		dev->board_name);
 
 	/* Analog output */
 	s = dev->subdevices + 1;
@@ -171,7 +172,8 @@ static int fl512_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->insn_write = fl512_ao_insn;
 	/* function to call when reading DA */
 	s->insn_read = fl512_ao_insn_readback;
-	printk(KERN_INFO "comedi: fl512: subdevice 1 initialized\n");
+	dev_info(dev->class_dev, "%s: subdevice 1 initialized\n",
+		dev->board_name);
 
 	return 1;
 }
-- 
1.7.9.5

