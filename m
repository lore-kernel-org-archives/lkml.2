Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648Ab0GAUuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 16:50:11 -0400
Received: from kroah.org ([198.145.64.141]:47287 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932586Ab0GAUty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:49:54 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:30 2010
Message-Id: <20100701173430.227528641@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:33:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [patch 040/164] USB: xhci: Limit bus sg_tablesize to 62 TRBs.
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit bc88d2eba5e19d10dd546e428314909d889b3b6a upstream.

When a scatter-gather list is enqueued to the xHCI driver, it translates
each entry into a transfer request block (TRB).  Only 63 TRBs can be
used per ring segment, and there must be one additional TRB reserved to
make sure the hardware does not think the ring is empty (so the enqueue
pointer doesn't equal the dequeue pointer).  Limit the bus sg_tablesize
to 62 TRBs.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -54,7 +54,7 @@ static int xhci_pci_setup(struct usb_hcd
 	struct pci_dev		*pdev = to_pci_dev(hcd->self.controller);
 	int			retval;
 
-	hcd->self.sg_tablesize = TRBS_PER_SEGMENT - 1;
+	hcd->self.sg_tablesize = TRBS_PER_SEGMENT - 2;
 
 	xhci->cap_regs = hcd->regs;
 	xhci->op_regs = hcd->regs +


