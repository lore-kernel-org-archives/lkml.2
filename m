Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab2GTTWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 15:22:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573Ab2GTTWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 15:22:39 -0400
Date: Fri, 20 Jul 2012 22:23:14 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, davem@davemloft.net
Subject: [PATCHv3 4/6] tun: orphan frags on xmit
Message-ID: <0dfc0ecf9db41f42d7662210a10f3f674116f3ed.1342812067.git.mst@redhat.com>
References: <cover.1342812067.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1342812067.git.mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tun xmit is actually receive of the internal tun
socket. Orphan the frags same as we do for normal rx path.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/tun.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index f3a454c..b95a7f4 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -416,6 +416,8 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	/* Orphan the skb - required as we might hang on to it
 	 * for indefinite time. */
+	if (unlikely(skb_orphan_frags(skb, GFP_ATOMIC)))
+		goto drop;
 	skb_orphan(skb);
 
 	/* Enqueue packet */
-- 
MST

