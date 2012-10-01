Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965273Ab2JAXhz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:37:55 -0400
Received: from 1wt.eu ([62.212.114.60]:35065 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932576Ab2JAW77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 18:59:59 -0400
Message-Id: <20121001225202.911322630@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:02 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 125/180] xhci: Increase reset timeout for Renesas 720201 host.
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 22ceac191211cf6688b1bf6ecd93c8b6bf80ed9b upstream.

The NEC/Renesas 720201 xHCI host controller does not complete its reset
within 250 milliseconds.  In fact, it takes about 9 seconds to reset the
host controller, and 1 second for the host to be ready for doorbell
rings.  Extend the reset and CNR polling timeout to 10 seconds each.

This patch should be backported to kernels as old as 2.6.31, that
contain the commit 66d4eadd8d067269ea8fead1a50fe87c2979a80d "USB: xhci:
BIOS handoff and HW initialization."

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Reported-by: Edwin Klein Mentink <e.kleinmentink@zonnet.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/usb/host/xhci-hcd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/xhci-hcd.c b/drivers/usb/host/xhci-hcd.c
index 56661a2..0641633 100644
--- a/drivers/usb/host/xhci-hcd.c
+++ b/drivers/usb/host/xhci-hcd.c
@@ -150,7 +150,7 @@ int xhci_reset(struct xhci_hcd *xhci)
 	xhci_to_hcd(xhci)->state = HC_STATE_HALT;
 
 	ret = handshake(xhci, &xhci->op_regs->command,
-			CMD_RESET, 0, 250 * 1000);
+			CMD_RESET, 0, 10 * 1000 * 1000);
 	if (ret)
 		return ret;
 
-- 
1.7.2.1.45.g54fbc



