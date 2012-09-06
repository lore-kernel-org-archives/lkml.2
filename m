Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759200Ab2IFQuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 12:50:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53477 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759049Ab2IFQuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 12:50:37 -0400
Subject: [PATCH] USB: XHCI: xhci-ring: Remove unused dma address
 calculation in inc_enq and inc_deq function
From: Girish Verma <girish@circuitsutra.com>
To: kernel-janitors@vger.kernel.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        sarah.a.sharp@linux.intel.com, gregkh@linuxfoundation.org
In-Reply-To: <1336922942.3945.12.camel@cst-girish-laptop>
References: <1336922942.3945.12.camel@cst-girish-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Sep 2012 21:17:33 +0530
Message-ID: <1346946453.5012.1.camel@cst-girish-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending patch with latest kernel code:
In xhci-ring.c, function inc_enq and inc_deq calculate the dma address
of trb but never used. 



Signed-off-by: Girish Verma <girish@circuitsutra.com>
---
 drivers/usb/host/xhci-ring.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 643c2f3..5c5c47b 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -145,7 +145,6 @@ static void next_trb(struct xhci_hcd *xhci,
  */
 static void inc_deq(struct xhci_hcd *xhci, struct xhci_ring *ring)
 {
-	unsigned long long addr;
 
 	ring->deq_updates++;
 
@@ -176,7 +175,6 @@ static void inc_deq(struct xhci_hcd *xhci, struct
xhci_ring *ring)
 		}
 	} while (last_trb(xhci, ring, ring->deq_seg, ring->dequeue));
 
-	addr = (unsigned long long) xhci_trb_virt_to_dma(ring->deq_seg,
ring->dequeue);
 }
 
 /*
@@ -201,7 +199,6 @@ static void inc_enq(struct xhci_hcd *xhci, struct
xhci_ring *ring,
 {
 	u32 chain;
 	union xhci_trb *next;
-	unsigned long long addr;
 
 	chain = le32_to_cpu(ring->enqueue->generic.field[3]) & TRB_CHAIN;
 	/* If this is not event ring, there is one less usable TRB */
@@ -253,7 +250,6 @@ static void inc_enq(struct xhci_hcd *xhci, struct
xhci_ring *ring,
 		ring->enqueue = ring->enq_seg->trbs;
 		next = ring->enqueue;
 	}
-	addr = (unsigned long long) xhci_trb_virt_to_dma(ring->enq_seg,
ring->enqueue);
 }
 
 /*
-- 
1.7.0.4


