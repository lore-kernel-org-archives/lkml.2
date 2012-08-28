Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352Ab2H1NKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 09:10:38 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46415 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab2H1NKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 09:10:36 -0400
MIME-Version: 1.0
Date: Tue, 28 Aug 2012 21:10:35 +0800
Message-ID: <CAPgLHd-YUs8OrMKfMn6g_i+MjYLewPo4xaByQA_1wwS-GekCbQ@mail.gmail.com>
Subject: [PATCH] staging: rtl8192e: remove pointless conditional before kfree_skb()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove pointless conditional before kfree_skb().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
index 4f602b2..7e260b9 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
@@ -734,8 +734,7 @@ static void rtl8192_prepare_beacon(struct r8192_priv *priv)
 
 	ring = &priv->tx_ring[BEACON_QUEUE];
 	pskb = __skb_dequeue(&ring->queue);
-	if (pskb)
-		kfree_skb(pskb);
+	kfree_skb(pskb);
 
 	pnewskb = rtllib_get_beacon(priv->rtllib);
 	if (!pnewskb)


