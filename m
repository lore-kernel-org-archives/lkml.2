Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab0JKJ1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 05:27:21 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:54184 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab0JKJ1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 05:27:07 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Subject: [PATCH 1/3] NET: pch, fix use after free
Date: Mon, 11 Oct 2010 11:26:56 +0200
Message-Id: <1286789218-13976-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found that pch_gbe_xmit_frame uses skb after it is freed. Fix
that.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
---
 drivers/net/pch_gbe/pch_gbe_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/pch_gbe/pch_gbe_main.c b/drivers/net/pch_gbe/pch_gbe_main.c
index 53c56cf..e44644f 100644
--- a/drivers/net/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/pch_gbe/pch_gbe_main.c
@@ -1847,9 +1847,9 @@ static int pch_gbe_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
 	unsigned long flags;
 
 	if (unlikely(skb->len > (adapter->hw.mac.max_frame_size - 4))) {
-		dev_kfree_skb_any(skb);
 		pr_err("Transfer length Error: skb len: %d > max: %d\n",
 		       skb->len, adapter->hw.mac.max_frame_size);
+		dev_kfree_skb_any(skb);
 		adapter->stats.tx_length_errors++;
 		return NETDEV_TX_OK;
 	}
-- 
1.7.3.1


