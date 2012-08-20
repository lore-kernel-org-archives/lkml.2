Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab2HTVbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 17:31:20 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:63566 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab2HTVbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 17:31:18 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-132.messagelabs.com!1345498268!10941713!17
X-Originating-IP: [216.166.12.99]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] staging: comedi: comedi_parport: remove the printk noise
Date: Mon, 20 Aug 2012 14:31:10 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208201431.10581.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function trace message in parport_intr_cancel() and the
"bogus irq..." message is parport_interrupt(). They are just added
noise.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/comedi_parport.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/comedi_parport.c b/drivers/staging/comedi/drivers/comedi_parport.c
index 48d529e..2dce9df 100644
--- a/drivers/staging/comedi/drivers/comedi_parport.c
+++ b/drivers/staging/comedi/drivers/comedi_parport.c
@@ -265,8 +265,6 @@ static int parport_intr_cancel(struct comedi_device *dev,
 {
 	struct parport_private *devpriv = dev->private;
 
-	printk(KERN_DEBUG "parport_intr_cancel()\n");
-
 	devpriv->c_data &= ~0x10;
 	outb(devpriv->c_data, dev->iobase + PARPORT_C);
 
@@ -281,10 +279,8 @@ static irqreturn_t parport_interrupt(int irq, void *d)
 	struct parport_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->subdevices + 3;
 
-	if (!devpriv->enable_irq) {
-		printk(KERN_ERR "comedi_parport: bogus irq, ignored\n");
+	if (!devpriv->enable_irq)
 		return IRQ_NONE;
-	}
 
 	comedi_buf_put(s->async, 0);
 	s->async->events |= COMEDI_CB_BLOCK | COMEDI_CB_EOS;
-- 
1.7.11

