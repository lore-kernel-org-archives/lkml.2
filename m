Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab2FHAZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 20:25:42 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:49941 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab2FHAZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 20:25:41 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-132.messagelabs.com!1339115139!14021512!1
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: pcl816: if test should use logical OR not bitwise OR
Date: Thu, 7 Jun 2012 17:25:35 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206071725.35720.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This quiets a couple sparse warnings about:

warning: dubious: !x | !y
warning: dubious: x | !y

Also, remove the unnecessary parentheses abound the variables.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/pcl816.c b/drivers/staging/comedi/drivers/pcl816.c
index 277a23e..845039c 100644
--- a/drivers/staging/comedi/drivers/pcl816.c
+++ b/drivers/staging/comedi/drivers/pcl816.c
@@ -414,8 +414,8 @@ static irqreturn_t interrupt_pcl816(int irq, void *d)
 	}
 
 	outb(0, dev->iobase + PCL816_CLRINT);	/* clear INT request */
-	if ((!dev->irq) | (!devpriv->irq_free) | (!devpriv->irq_blocked) |
-	    (!devpriv->int816_mode)) {
+	if (!dev->irq || !devpriv->irq_free || !devpriv->irq_blocked ||
+	    !devpriv->int816_mode) {
 		if (devpriv->irq_was_now_closed) {
 			devpriv->irq_was_now_closed = 0;
 			/*  comedi_error(dev,"last IRQ.."); */
