Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759157Ab1JFThG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 15:37:06 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44548 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758737Ab1JFThF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 15:37:05 -0400
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Robert Schwebel <r.schwebel@pengutronix.de>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
Subject: [PATCH] at91_udc: change french comments to english
Date: Thu,  6 Oct 2011 21:36:26 +0200
Message-Id: <1317929786-27744-1-git-send-email-r.schwebel@pengutronix.de>
X-Mailer: git-send-email 1.7.6.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While being there, change C++ style comments to /* */.

Signed-off-by: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/gadget/at91_udc.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index ddb118a..0059216 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -460,7 +460,7 @@ static void nuke(struct at91_ep *ep, int status)
 {
 	struct at91_request *req;
 
-	// terminer chaque requete dans la queue
+	/* terminate any request in the queue */
 	ep->stopped = 1;
 	if (list_empty(&ep->queue))
 		return;
@@ -788,7 +788,7 @@ static const struct usb_ep_ops at91_ep_ops = {
 	.queue		= at91_ep_queue,
 	.dequeue	= at91_ep_dequeue,
 	.set_halt	= at91_ep_set_halt,
-	// there's only imprecise fifo status reporting
+	/* there's only imprecise fifo status reporting */
 };
 
 /*-------------------------------------------------------------------------*/
@@ -846,7 +846,7 @@ static void udc_reinit(struct at91_udc *udc)
 		ep->fifo_bank = 0;
 		ep->ep.maxpacket = ep->maxpacket;
 		ep->creg = (void __iomem *) udc->udp_baseaddr + AT91_UDP_CSR(i);
-		// initialiser une queue par endpoint
+		/* initialize one queue per endpoint */
 		INIT_LIST_HEAD(&ep->queue);
 	}
 }
@@ -952,7 +952,7 @@ static int at91_vbus_session(struct usb_gadget *gadget, int is_active)
 	struct at91_udc	*udc = to_udc(gadget);
 	unsigned long	flags;
 
-	// VDBG("vbus %s\n", is_active ? "on" : "off");
+	/* VDBG("vbus %s\n", is_active ? "on" : "off"); */
 	spin_lock_irqsave(&udc->lock, flags);
 	udc->vbus = (is_active != 0);
 	if (udc->driver)
@@ -1003,7 +1003,7 @@ static const struct usb_gadget_ops at91_udc_ops = {
 	 * VBUS-powered devices may also also want to support bigger
 	 * power budgets after an appropriate SET_CONFIGURATION.
 	 */
-	// .vbus_power		= at91_vbus_power,
+	/* .vbus_power		= at91_vbus_power, */
 };
 
 /*-------------------------------------------------------------------------*/
@@ -1072,7 +1072,7 @@ static void handle_setup(struct at91_udc *udc, struct at91_ep *ep, u32 csr)
 			ep->is_in = 0;
 		}
 	} else {
-		// REVISIT this happens sometimes under load; why??
+		/* REVISIT this happens sometimes under load; why?? */
 		ERR("SETUP len %d, csr %08x\n", rxcount, csr);
 		status = -EINVAL;
 	}
@@ -1451,7 +1451,7 @@ static irqreturn_t at91_udc_irq (int irq, void *_udc)
 			at91_udp_write(udc, AT91_UDP_IDR, AT91_UDP_RXSUSP);
 			at91_udp_write(udc, AT91_UDP_IER, AT91_UDP_RXRSM);
 			at91_udp_write(udc, AT91_UDP_ICR, AT91_UDP_RXSUSP);
-			// VDBG("bus suspend\n");
+			/* VDBG("bus suspend\n"); */
 			if (udc->suspended)
 				continue;
 			udc->suspended = 1;
@@ -1473,7 +1473,7 @@ static irqreturn_t at91_udc_irq (int irq, void *_udc)
 			at91_udp_write(udc, AT91_UDP_IDR, AT91_UDP_RXRSM);
 			at91_udp_write(udc, AT91_UDP_IER, AT91_UDP_RXSUSP);
 			at91_udp_write(udc, AT91_UDP_ICR, AT91_UDP_RXRSM);
-			// VDBG("bus resume\n");
+			/* VDBG("bus resume\n"); */
 			if (!udc->suspended)
 				continue;
 			udc->suspended = 0;
-- 
1.7.6.3

