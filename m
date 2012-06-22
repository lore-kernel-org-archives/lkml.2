Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762830Ab2FVXbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:31:37 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:27413 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459Ab2FVXbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:31:35 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-132.messagelabs.com!1340407894!12233325!2
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 21/31] staging: comedi: ni_daq_700: remove the #ifdef'ed out irq code
Date: Fri, 22 Jun 2012 16:31:15 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206221631.16091.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The irq code is not compiled in due to the '#ifdef incomplete'.
And, as stated, it's not even complete. Just remove it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_daq_700.c | 25 ++-----------------------
 1 file changed, 2 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index 206a0c4..94cb346 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -37,8 +37,6 @@ port, bit 0; channel 8 corresponds to the input port, bit 0.
 
 Direction configuration: channels 0-7 output, 8-15 input (8225 device
 emu as port A output, port B input, port C N/A).
-
-IRQ is assigned but not used.
 */
 
 #include <linux/interrupt.h>
@@ -107,9 +105,6 @@ static int dio700_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	const struct dio700_board *thisboard = comedi_board(dev);
 	struct comedi_subdevice *s;
 	unsigned long iobase = 0;
-#ifdef incomplete
-	unsigned int irq = 0;
-#endif
 	struct pcmcia_device *link;
 	int ret;
 
@@ -117,19 +112,9 @@ static int dio700_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (!link)
 		return -EIO;
 	iobase = link->resource[0]->start;
-#ifdef incomplete
-	irq = link->irq;
-#endif
 
-	printk(KERN_ERR "comedi%d: ni_daq_700: %s, io 0x%lx", dev->minor,
+	printk(KERN_ERR "comedi%d: ni_daq_700: %s, io 0x%lx\n", dev->minor,
 	       thisboard->name, iobase);
-#ifdef incomplete
-	if (irq)
-		printk(", irq %u", irq);
-
-#endif
-
-	printk("\n");
 
 	if (iobase == 0) {
 		printk(KERN_ERR "io base address is zero!\n");
@@ -138,11 +123,6 @@ static int dio700_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	dev->iobase = iobase;
 
-#ifdef incomplete
-	/* grab our IRQ */
-	dev->irq = irq;
-#endif
-
 	dev->board_name = thisboard->name;
 
 	ret = comedi_alloc_subdevices(dev, 1);
@@ -167,8 +147,7 @@ static int dio700_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static void dio700_detach(struct comedi_device *dev)
 {
-	if (dev->irq)
-		free_irq(dev->irq, dev);
+	/* nothing to cleanup */
 };
 
 static const struct dio700_board dio700_boards[] = {
-- 
1.7.11

