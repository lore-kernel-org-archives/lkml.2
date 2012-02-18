Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab2BRSxz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 13:53:55 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:52130 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab2BRSxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 13:53:53 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 18 Feb 2012 19:53:39 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] firewire: core: remove obsolete comment
Message-ID: <20120218195339.13d36f44@stein>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Target-like applications or peer-to-peer-like applications require the
global address handler registration which we have right now, or a per-
card registration.  And node lookup, while it would be nice to have,
would be impossible in the brief time between self-ID-complete event and
completion of firewire-core's topology scanning.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-transaction.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/drivers/firewire/core-transaction.c
+++ b/drivers/firewire/core-transaction.c
@@ -840,14 +840,6 @@ static void handle_exclusive_region_requ
 						   offset, request->length);
 	spin_unlock_irqrestore(&address_handler_lock, flags);
 
-	/*
-	 * FIXME: lookup the fw_node corresponding to the sender of
-	 * this request and pass that to the address handler instead
-	 * of the node ID.  We may also want to move the address
-	 * allocations to fw_node so we only do this callback if the
-	 * upper layers registered it for this node.
-	 */
-
 	if (handler == NULL)
 		fw_send_response(card, request, RCODE_ADDRESS_ERROR);
 	else


-- 
Stefan Richter
-=====-===-- --=- =--=-
http://arcgraph.de/sr/
