Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113Ab1BPCLK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 21:11:10 -0500
Received: from kroah.org ([198.145.64.141]:48795 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758023Ab1BPBtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:49:33 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:46:57 2011
Message-Id: <20110216014656.920446428@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:44:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [026/115] staging: comedi: ni_labpc: Use shared IRQ for PCMCIA card
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit d1ce318496f5943d2cc5e20171fc383a59a1421f upstream.

The ni_labpc driver module only requests a shared IRQ for PCI devices,
requesting a non-shared IRQ for non-PCI devices.
As this module is also used by the ni_labpc_cs module for certain
National Instruments PCMCIA cards, it also needs to request a shared IRQ
for PCMCIA devices, otherwise you get a IRQ mismatch with the CardBus
controller.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/comedi/drivers/ni_labpc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -528,7 +528,8 @@ int labpc_common_attach(struct comedi_de
 	/* grab our IRQ */
 	if (irq) {
 		isr_flags = 0;
-		if (thisboard->bustype == pci_bustype)
+		if (thisboard->bustype == pci_bustype
+		    || thisboard->bustype == pcmcia_bustype)
 			isr_flags |= IRQF_SHARED;
 		if (request_irq(irq, labpc_interrupt, isr_flags,
 				driver_labpc.driver_name, dev)) {


