Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab1HDIew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 04:34:52 -0400
Received: from customer-relay.songnetworks.se ([195.42.210.9]:42174 "EHLO
	customer-relay.songnetworks.se" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751216Ab1HDIen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 04:34:43 -0400
X-Greylist: delayed 1375 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Aug 2011 04:34:43 EDT
From: Tord Andersson <tord.andersson@endian.se>
To: nicolas.ferre@atmel.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tord Andersson <tord.andersson@endian.se>
Subject: [PATCH] macb: restore wrap bit when performing underrun cleanup
Date: Thu,  4 Aug 2011 10:11:47 +0200
Message-Id: <1312445507-31382-1-git-send-email-tord.andersson@endian.se>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When TX underrun occurs, a cleanup is performed that marks all buffers as used. As a side effect it also clears the wrap bit in the last buffer. This patch will restore the wrap bit.

Signed-off-by: Tord Andersson <tord.andersson@endian.se>
---
 drivers/net/macb.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/macb.c b/drivers/net/macb.c
index 0fcdc25..dc4e305 100644
--- a/drivers/net/macb.c
+++ b/drivers/net/macb.c
@@ -322,6 +322,9 @@ static void macb_tx(struct macb *bp)
 		for (i = 0; i < TX_RING_SIZE; i++)
 			bp->tx_ring[i].ctrl = MACB_BIT(TX_USED);
 
+		/* Add wrap bit */
+		bp->tx_ring[TX_RING_SIZE - 1].ctrl |= MACB_BIT(TX_WRAP);
+
 		/* free transmit buffer in upper layer*/
 		for (tail = bp->tx_tail; tail != head; tail = NEXT_TX(tail)) {
 			struct ring_info *rp = &bp->tx_skb[tail];
-- 
1.5.4.3

