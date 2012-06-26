Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090Ab2FZAPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 20:15:39 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:32867 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757958Ab2FZAPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 20:15:38 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-132.messagelabs.com!1340669586!12509016!53
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 25/33] staging: comedi: cb_das16_cs: consolidate the attach messages
Date: Mon, 25 Jun 2012 17:15:21 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206251715.21404.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidate all the attach messages into one dev_info() output
at the end of the successful attach.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index f90c12b..155f742 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -446,8 +446,6 @@ static int das16cs_attach(struct comedi_device *dev,
 	struct comedi_subdevice *s;
 	int ret;
 
-	dev_dbg(dev->class_dev, "cb_das16_cs: attach\n");
-
 	link = cur_dev;		/* XXX hack */
 	if (!link)
 		return -EIO;
@@ -460,7 +458,6 @@ static int das16cs_attach(struct comedi_device *dev,
 	dev->board_name = thisboard->name;
 
 	dev->iobase = link->resource[0]->start;
-	dev_dbg(dev->class_dev, "I/O base=0x%04lx\n", dev->iobase);
 
 	ret = request_irq(link->irq, das16cs_interrupt,
 			  IRQF_SHARED, "cb_das16_cs", dev);
@@ -468,8 +465,6 @@ static int das16cs_attach(struct comedi_device *dev,
 		return ret;
 	dev->irq = link->irq;
 
-	dev_dbg(dev->class_dev, "irq=%u\n", dev->irq);
-
 	if (alloc_private(dev, sizeof(struct das16cs_private)) < 0)
 		return -ENOMEM;
 
@@ -514,6 +509,10 @@ static int das16cs_attach(struct comedi_device *dev,
 	s->insn_bits = das16cs_dio_insn_bits;
 	s->insn_config = das16cs_dio_insn_config;
 
+	dev_info(dev->class_dev, "%s: %s, I/O base=0x%04lx, irq=%u\n",
+		dev->driver->driver_name, dev->board_name,
+		dev->iobase, dev->irq);
+
 	return 1;
 }
 
-- 
1.7.11

