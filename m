Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932851Ab0G3R55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:57:57 -0400
Received: from kroah.org ([198.145.64.141]:58854 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760039Ab0G3R4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:56:43 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:45 2010
Message-Id: <20100730175145.521713681@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:52:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Maulik Mankad <x0082077@ti.com>, David Brownell <david-b@pacbell.net>,
        Felipe Balbi <felipe.balbi@nokia.com>
Subject: [127/205] usb: musb: Fix a bug by making suspend interrupt available in device mode
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Maulik Mankad <x0082077@ti.com>

commit 2bb14cbf04ded4b9e394a6ba9e4f06b82fbac8b2 upstream.

As a part of aligning the ISR code for MUSB with the specs, the
ISR code was re-written.

See Commit 1c25fda4a09e8229800979986ef399401053b46e (usb: musb: handle
irqs in the order dictated by programming guide)

With this the suspend interrupt came accidently under CONFIG_USB_MUSB_HDRC_HCD.

The fix brings suspend interrupt handling outside
CONFIG_USB_MUSB_HDRC_HCD.

Signed-off-by: Maulik Mankad <x0082077@ti.com>
Cc: David Brownell <david-b@pacbell.net>
Acked-by: Felipe Balbi <felipe.balbi@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/musb/musb_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -562,7 +562,7 @@ static irqreturn_t musb_stage0_irq(struc
 		handled = IRQ_HANDLED;
 	}
 
-
+#endif
 	if (int_usb & MUSB_INTR_SUSPEND) {
 		DBG(1, "SUSPEND (%s) devctl %02x power %02x\n",
 				otg_state_string(musb), devctl, power);
@@ -625,6 +625,7 @@ static irqreturn_t musb_stage0_irq(struc
 		}
 	}
 
+#ifdef CONFIG_USB_MUSB_HDRC_HCD
 	if (int_usb & MUSB_INTR_CONNECT) {
 		struct usb_hcd *hcd = musb_to_hcd(musb);
 		void __iomem *mbase = musb->mregs;


