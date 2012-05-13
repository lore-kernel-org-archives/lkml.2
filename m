Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab2EMP3Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 11:29:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63728 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab2EMP3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 11:29:22 -0400
Subject: [PATCH] USB: XHCI: xhci-ring: Remove unused dma address
 calculation in inc_enq and inc_deq function
From: Girish Verma <girish@circuitsutra.com>
To: kernel-janitors@vger.kernel.org, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, sarah.a.sharp@linux.intel.com,
        gregkh@linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 May 2012 20:59:02 +0530
Message-ID: <1336922942.3945.12.camel@cst-girish-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In xhci-ring.c, function inc_enq and inc_deq calculate the dma address
of trb but never used. 

Signed-off-by: Girish Verma <girish@circuitsutra.com>
---
 drivers/usb/host/xhci-ring.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 3d9422f..dcd67c1 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -146,7 +146,6 @@ static void next_trb(struct xhci_hcd *xhci,
 static void inc_deq(struct xhci_hcd *xhci, struct xhci_ring *ring)
 {
 	union xhci_trb *next;
-	unsigned long long addr;
 
 	ring->deq_updates++;
 
@@ -168,7 +167,6 @@ static void inc_deq(struct xhci_hcd *xhci, struct xhci_ring *ring)
 		ring->dequeue = ring->deq_seg->trbs;
 		next = ring->dequeue;
 	}
-	addr = (unsigned long long) xhci_trb_virt_to_dma(ring->deq_seg, ring->dequeue);
 }
 
 /*
@@ -193,7 +191,6 @@ static void inc_enq(struct xhci_hcd *xhci, struct xhci_ring *ring,
 {
 	u32 chain;
 	union xhci_trb *next;
-	unsigned long long addr;
 
 	chain = le32_to_cpu(ring->enqueue->generic.field[3]) & TRB_CHAIN;
 	/* If this is not event ring, there is one less usable TRB */
@@ -245,7 +242,6 @@ static void inc_enq(struct xhci_hcd *xhci, struct xhci_ring *ring,
 		ring->enqueue = ring->enq_seg->trbs;
 		next = ring->enqueue;
 	}
-	addr = (unsigned long long) xhci_trb_virt_to_dma(ring->enq_seg, ring->enqueue);
 }
 
 /*
-- 


