Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934837Ab1KJD1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:27:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42393 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934796Ab1KJD10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:27:26 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:14 2011
Message-Id: <20111109212714.703010156@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:27:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Ward <david.ward@ll.mit.edu>,
        "David S. Miller" <davem@davemloft.net>
Subject: [140/262] macvlan/macvtap: Fix unicast between macvtap interfaces in bridge mode
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: David Ward <david.ward@ll.mit.edu>

[ Upstream commit cb2d0f3e968bff7c6d262aca3e3ab8d4184e69b2 ]

Packets should always be forwarded to the lowerdev using dev_forward_skb.
vlan->forward is for packets being forwarded directly to another macvlan/
macvtap device (used for multicast in bridge mode).

Reported-and-tested-by: Shlomo Pongratz <shlomop@mellanox.com>
Signed-off-by: David Ward <david.ward@ll.mit.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/macvlan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -239,7 +239,7 @@ static int macvlan_queue_xmit(struct sk_
 		dest = macvlan_hash_lookup(port, eth->h_dest);
 		if (dest && dest->mode == MACVLAN_MODE_BRIDGE) {
 			/* send to lowerdev first for its network taps */
-			vlan->forward(vlan->lowerdev, skb);
+			dev_forward_skb(vlan->lowerdev, skb);
 
 			return NET_XMIT_SUCCESS;
 		}


