Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab0G1NuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 09:50:15 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:52924 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab0G1NuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 09:50:12 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 28 Jul 2010 15:50:00 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: ohci: release channel in error path
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.bce374d4efc046af@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

firewire-ohci keeps book of which isochronous channels are occupied by
IR DMA contexts, so that there cannot be more than one context listening
to a certain channel.

If IR context creation failed due to an out-of-memory condition, this
bookkeeping leaked a channel.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/ohci.c |    1 +
 1 file changed, 1 insertion(+)

Index: b/drivers/firewire/ohci.c
===================================================================
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -2314,6 +2314,7 @@ static struct fw_iso_context *ohci_alloc
 	free_page((unsigned long)ctx->header);
  out:
 	spin_lock_irqsave(&ohci->lock, flags);
+	*channels |= 1ULL << channel;
 	*mask |= 1 << index;
 	spin_unlock_irqrestore(&ohci->lock, flags);
 

-- 
Stefan Richter
-=====-==-=- -=== ===--
http://arcgraph.de/sr/

