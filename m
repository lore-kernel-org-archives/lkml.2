Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264Ab2IFEjB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 00:39:01 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:58036 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab2IFEjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 00:39:00 -0400
MIME-Version: 1.0
Date: Thu, 6 Sep 2012 12:38:59 +0800
Message-ID: <CAPgLHd9d18FuOU12S_ZZibnKEP==XNtmev77_aF5j0JQB8ugVw@mail.gmail.com>
Subject: [PATCH] staging: wlags49_h2: use list_move instead of list_del/list_add
From: Wei Yongjun <weiyj.lk@gmail.com>
To: pe1dnn@amsat.org, gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using list_move() instead of list_del() + list_add().

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/wlags49_h2/wl_netdev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_netdev.c b/drivers/staging/wlags49_h2/wl_netdev.c
index 824b852..e401b49 100644
--- a/drivers/staging/wlags49_h2/wl_netdev.c
+++ b/drivers/staging/wlags49_h2/wl_netdev.c
@@ -836,8 +836,7 @@ int wl_tx( struct sk_buff *skb, struct net_device *dev, int port )
         txF->frame.port = port;
         /* Move the frame to the txQ */
         /* NOTE: Here's where we would do priority queueing */
-        list_del( &( txF->node ));
-        list_add( &( txF->node ), &( lp->txQ[0] ));
+        list_move(&(txF->node), &(lp->txQ[0]));
 
         lp->txQ_count++;
         if( lp->txQ_count >= DEFAULT_NUM_TX_FRAMES ) {

