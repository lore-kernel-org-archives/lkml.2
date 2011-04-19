Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab1DSU1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:27:10 -0400
Received: from kroah.org ([198.145.64.141]:47690 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754614Ab1DSURM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:12 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:46 2011
Message-Id: <20110419201046.138225658@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:08:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Patrick McHardy <kaber@trash.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [28/70] vlan: should take into account needed_headroom
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit d870bfb9d366c5d466c0f5419a4ec95a3f71ea8a ]

Commit c95b819ad7 (gre: Use needed_headroom)
made gre use needed_headroom instead of hard_header_len

This uncover a bug in vlan code.

We should make sure vlan devices take into account their
real_dev->needed_headroom or we risk a crash in ipgre_header(), because
we dont have enough room to push IP header in skb.

Reported-by: Diddi Oscarsson <diddi@diddi.se>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/8021q/vlan_dev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -707,6 +707,7 @@ static int vlan_dev_init(struct net_devi
 	dev->fcoe_ddp_xid = real_dev->fcoe_ddp_xid;
 #endif
 
+	dev->needed_headroom = real_dev->needed_headroom;
 	if (real_dev->features & NETIF_F_HW_VLAN_TX) {
 		dev->header_ops      = real_dev->header_ops;
 		dev->hard_header_len = real_dev->hard_header_len;


