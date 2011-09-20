Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab1ITLZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 07:25:46 -0400
Received: from mail-ew0-f52.google.com ([209.85.215.52]:47856 "EHLO
	mail-ew0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142Ab1ITLZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 07:25:33 -0400
From: Richard Cochran <richardcochran@gmail.com>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>
Subject: [PATCH 2/2] dp83640: reduce driver noise
Date: Tue, 20 Sep 2011 13:25:42 +0200
Message-Id: <a351dbdb9962c213d2e6300a44565c5a7b153551.1316516990.git.richard.cochran@omicron.at>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <cover.1316516989.git.richard.cochran@omicron.at>
References: <cover.1316516989.git.richard.cochran@omicron.at>
In-Reply-To: <cover.1316516989.git.richard.cochran@omicron.at>
References: <cover.1316516989.git.richard.cochran@omicron.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver has two warning messages that might be triggered
by normal use cases. When they appear, the messages give the
impression of a never ending series of errors.

This commit changes them to debug messages instead.

Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
---
 drivers/net/phy/dp83640.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index cb6e0b4..edd7304 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -589,7 +589,7 @@ static void decode_rxts(struct dp83640_private *dp83640,
 	prune_rx_ts(dp83640);
 
 	if (list_empty(&dp83640->rxpool)) {
-		pr_warning("dp83640: rx timestamp pool is empty\n");
+		pr_debug("dp83640: rx timestamp pool is empty\n");
 		goto out;
 	}
 	rxts = list_first_entry(&dp83640->rxpool, struct rxts, list);
@@ -612,7 +612,7 @@ static void decode_txts(struct dp83640_private *dp83640,
 	skb = skb_dequeue(&dp83640->tx_queue);
 
 	if (!skb) {
-		pr_warning("dp83640: have timestamp but tx_queue empty\n");
+		pr_debug("dp83640: have timestamp but tx_queue empty\n");
 		return;
 	}
 	ns = phy2txts(phy_txts);
-- 
1.7.2.5

