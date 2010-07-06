Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab0GFFMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 01:12:08 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:33374 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194Ab0GFFMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 01:12:03 -0400
Date: Tue, 6 Jul 2010 07:11:45 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drivers/net: correct valid flag
In-Reply-To: <20100705.180349.112607097.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.1007060711320.30668@ask.diku.dk>
References: <Pine.LNX.4.64.1007051706530.15185@ask.diku.dk>
 <20100705.180349.112607097.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Elsewhere in the "optimized" functions, the "2" constants are used.
NV_TX_VALID and NV_TX2_VALID have the same value.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
diff --git a/drivers/net/forcedeth.c b/drivers/net/forcedeth.c
index 268ea4d..9ef6a9d 100644
--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@ -2468,7 +2468,7 @@ static int nv_tx_done_optimized(struct net_device *dev, int limit)
 	struct ring_desc_ex* orig_get_tx = np->get_tx.ex;
 
 	while ((np->get_tx.ex != np->put_tx.ex) &&
-	       !((flags = le32_to_cpu(np->get_tx.ex->flaglen)) & NV_TX_VALID) &&
+	       !((flags = le32_to_cpu(np->get_tx.ex->flaglen)) & NV_TX2_VALID) &&
 	       (tx_work < limit)) {
 
 		dprintk(KERN_DEBUG "%s: nv_tx_done_optimized: flags 0x%x.\n",
