Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908Ab0KSWBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:01:55 -0500
Received: from kroah.org ([198.145.64.141]:45305 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757634Ab0KSV7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:59:05 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:45 2010
Message-Id: <20101119215644.989162137@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:56:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Greear <greearb@candelatech.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [76/82] net/core: Allow tagged VLAN packets to flow through VETH devices.
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Ben Greear <greearb@candelatech.com>

[ Upstream commit d2ed817766987fd05e69b7da65d4861b38f1aa2a ]

When there are VLANs on a VETH device, the packets being transmitted
through the VETH device may be 4 bytes bigger than MTU.  A check
in dev_forward_skb did not take this into account and so dropped
these packets.

This patch is needed at least as far back as 2.6.34.7 and should
be considered for -stable.

Signed-off-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/core/dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1491,7 +1491,7 @@ int dev_forward_skb(struct net_device *d
 	nf_reset(skb);
 
 	if (!(dev->flags & IFF_UP) ||
-	    (skb->len > (dev->mtu + dev->hard_header_len))) {
+	    (skb->len > (dev->mtu + dev->hard_header_len + VLAN_HLEN))) {
 		kfree_skb(skb);
 		return NET_RX_DROP;
 	}


