Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933384Ab1C3WKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:10:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:53540 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933167Ab1C3VGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673447158"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: abbotti@mev.co.uk, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [32/275] staging: comedi: ni_labpc: Use shared IRQ for PCMCIA card
Message-Id: <20110330210427.636113E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/staging/comedi/drivers/ni_labpc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/staging/comedi/drivers/ni_labpc.c
===================================================================
--- linux-2.6.35.y.orig/drivers/staging/comedi/drivers/ni_labpc.c	2011-03-29 22:51:55.939291822 -0700
+++ linux-2.6.35.y/drivers/staging/comedi/drivers/ni_labpc.c	2011-03-29 23:02:58.861329307 -0700
@@ -571,7 +571,8 @@
 	/* grab our IRQ */
 	if (irq) {
 		isr_flags = 0;
-		if (thisboard->bustype == pci_bustype)
+		if (thisboard->bustype == pci_bustype
+		    || thisboard->bustype == pcmcia_bustype)
 			isr_flags |= IRQF_SHARED;
 		if (request_irq(irq, labpc_interrupt, isr_flags,
 				driver_labpc.driver_name, dev)) {
