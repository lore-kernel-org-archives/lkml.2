Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464Ab2EMBGb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 21:06:31 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:49937 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907Ab2EMBGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 21:06:30 -0400
MIME-Version: 1.0
From: Girish Verma <girish@circuitsutra.com>
Date: Sun, 13 May 2012 06:36:08 +0530
Message-ID: <CAOf1Mzv=+zSVCDgPcHhVvN6YCbhM8R2w6DDL80EbYTuA0EGpCw@mail.gmail.com>
Subject: [PATCH] USB: XHCI: xhci-ring: Remove unused dma address calculation
 in inc_enq and inc_deq function
To: kernel-janitors@vger.kernel.org, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, sarah.a.sharp@linux.intel.com,
        gregkh@linuxfoundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

in xhci-ring.c, function inc_enq and inc_deq calculate the dma address
of trb but never used. This calculation may be used for debugging
purpose, in that case this code should be part of debug flag.

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

@@ -168,7 +167,6 @@ static void inc_deq(struct xhci_hcd *xhci, struct
xhci_ring *ring)
 		ring->dequeue = ring->deq_seg->trbs;
 		next = ring->dequeue;
 	}
-	addr = (unsigned long long) xhci_trb_virt_to_dma(ring->deq_seg,
ring->dequeue);
 }

 /*
@@ -193,7 +191,6 @@ static void inc_enq(struct xhci_hcd *xhci, struct
xhci_ring *ring,
 {
 	u32 chain;
 	union xhci_trb *next;
-	unsigned long long addr;

 	chain = le32_to_cpu(ring->enqueue->generic.field[3]) & TRB_CHAIN;
 	/* If this is not event ring, there is one less usable TRB */
@@ -245,7 +242,6 @@ static void inc_enq(struct xhci_hcd *xhci, struct
xhci_ring *ring,
 		ring->enqueue = ring->enq_seg->trbs;
 		next = ring->enqueue;
 	}
-	addr = (unsigned long long) xhci_trb_virt_to_dma(ring->enq_seg,
ring->enqueue);
 }

 /*
--
