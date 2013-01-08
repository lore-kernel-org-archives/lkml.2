Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab3AHDjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 22:39:41 -0500
Received: from amsterdam.lcs.mit.edu ([18.26.4.9]:52611 "EHLO
	amsterdam.lcs.mit.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab3AHDjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 22:39:39 -0500
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Nickolai Zeldovich <nickolai@csail.mit.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: xhci: fix incorrect bit test
Date: Mon,  7 Jan 2013 22:39:31 -0500
Message-Id: <1357616371-20689-1-git-send-email-nickolai@csail.mit.edu>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix incorrect bit test that originally showed up in
4ee823b83bc9851743fab756c76b27d6a1e2472b: use '&' instead of '&&'.

Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
---
 drivers/usb/host/xhci-ring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index cbb44b7..06921b6 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1698,7 +1698,7 @@ static void handle_port_status(struct xhci_hcd *xhci,
 				faked_port_index + 1);
 		if (slot_id && xhci->devs[slot_id])
 			xhci_ring_device(xhci, slot_id);
-		if (bus_state->port_remote_wakeup && (1 << faked_port_index)) {
+		if (bus_state->port_remote_wakeup & (1 << faked_port_index)) {
 			bus_state->port_remote_wakeup &=
 				~(1 << faked_port_index);
 			xhci_test_and_clear_bit(xhci, port_array,
-- 
1.7.10.4

