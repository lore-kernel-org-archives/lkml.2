Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066Ab2FZAMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 20:12:52 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:35445 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757958Ab2FZAMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 20:12:50 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-127.messagelabs.com!1340669569!6815967!2
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 23/33] staging: comedi: cb_das16_cs: remove the debug output of the "fingerprint"
Date: Mon, 25 Jun 2012 17:12:41 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206251712.41749.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the attach, all of the device i/o registers are read and
the data is output as a dev_dbg() "fingerprint". This just adds
a bunch of noise during the loading of the driver. Remove the
output.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index 20d77cf..2690228 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -446,7 +446,6 @@ static int das16cs_attach(struct comedi_device *dev,
 	struct pcmcia_device *link;
 	struct comedi_subdevice *s;
 	int ret;
-	int i;
 
 	dev_dbg(dev->class_dev, "cb_das16_cs: attach\n");
 
@@ -464,10 +463,6 @@ static int das16cs_attach(struct comedi_device *dev,
 	dev->iobase = link->resource[0]->start;
 	dev_dbg(dev->class_dev, "I/O base=0x%04lx\n", dev->iobase);
 
-	dev_dbg(dev->class_dev, "fingerprint:\n");
-	for (i = 0; i < 48; i += 2)
-		dev_dbg(dev->class_dev, "%04x\n", inw(dev->iobase + i));
-
 	ret = request_irq(link->irq, das16cs_interrupt,
 			  IRQF_SHARED, "cb_das16_cs", dev);
 	if (ret < 0)
-- 
1.7.11

