Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab2LCOpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:45:22 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43864 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755404Ab2LCOgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:49 -0500
Message-Id: <20121203143153.689468310@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:30 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 44/89] xhci: Remove scary warnings about transfer issues.
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 2a9227a5eeaeb3f91e3a72ceea4fa59016ca5d20 upstream.

Getting a short packet or a babble error is usually a recoverable error,
so stop scaring users with warnings in dmesg when xHCI debugging is turned
off.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci-ring.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index d030f0b..560b7d7 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1643,7 +1643,6 @@ static int process_ctrl_td(struct xhci_hcd *xhci, struct xhci_td *td,
 		}
 		break;
 	case COMP_SHORT_TX:
-		xhci_warn(xhci, "WARN: short transfer on control ep\n");
 		if (td->urb->transfer_flags & URB_SHORT_NOT_OK)
 			*status = -EREMOTEIO;
 		else
@@ -1985,7 +1984,7 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 		xhci_dbg(xhci, "Stopped on No-op or Link TRB\n");
 		break;
 	case COMP_STALL:
-		xhci_warn(xhci, "WARN: Stalled endpoint\n");
+		xhci_dbg(xhci, "Stalled endpoint\n");
 		ep->ep_state |= EP_HALTED;
 		status = -EPIPE;
 		break;
@@ -1995,11 +1994,11 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 		break;
 	case COMP_SPLIT_ERR:
 	case COMP_TX_ERR:
-		xhci_warn(xhci, "WARN: transfer error on endpoint\n");
+		xhci_dbg(xhci, "Transfer error on endpoint\n");
 		status = -EPROTO;
 		break;
 	case COMP_BABBLE:
-		xhci_warn(xhci, "WARN: babble error on endpoint\n");
+		xhci_dbg(xhci, "Babble error on endpoint\n");
 		status = -EOVERFLOW;
 		break;
 	case COMP_DB_ERR:


