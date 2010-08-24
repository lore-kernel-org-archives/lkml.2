Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933320Ab0HXXbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:31:50 -0400
Received: from kroah.org ([198.145.64.141]:40492 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932833Ab0HXW7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:59:13 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:42:16 2010
Message-Id: <20100824224216.875508796@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:42:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Greear <greearb@candelatech.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [56/91] net: dev_forward_skb should call nf_reset
In-Reply-To: <20100824224617.GA5440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Ben Greear <greearb@candelatech.com>

[ Upstream commit c736eefadb71a01a5e61e0de700f28f6952b4444 ]

With conn-track zones and probably with different network
namespaces, the netfilter logic needs to be re-calculated
on packet receive.  If the netfilter logic is not reset,
it will not be recalculated properly.  This patch adds
the nf_reset logic to dev_forward_skb.

Signed-off-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/core/dev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1464,6 +1464,7 @@ static inline void net_timestamp(struct
 int dev_forward_skb(struct net_device *dev, struct sk_buff *skb)
 {
 	skb_orphan(skb);
+	nf_reset(skb);
 
 	if (!(dev->flags & IFF_UP) ||
 	    (skb->len > (dev->mtu + dev->hard_header_len))) {


