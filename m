Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab0FVLle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 07:41:34 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:35802 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab0FVLlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 07:41:32 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: isdn@linux-pingi.de
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Jiri Slaby <jslaby@suse.cz>, "David S. Miller" <davem@davemloft.net>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org
Subject: [PATCH] ISDN: hysdn, fix potential NULL dereference
Date: Tue, 22 Jun 2010 13:41:36 +0200
Message-Id: <1277206896-27197-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found that lp is dereferenced earlier than checked for being
NULL in hysdn_rx_netpkt. Move the initialization below the test.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Patrick McHardy <kaber@trash.net>
Cc: netdev@vger.kernel.org
---
 drivers/isdn/hysdn/hysdn_net.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/hysdn/hysdn_net.c b/drivers/isdn/hysdn/hysdn_net.c
index 72eb926..feec8d8 100644
--- a/drivers/isdn/hysdn/hysdn_net.c
+++ b/drivers/isdn/hysdn/hysdn_net.c
@@ -187,12 +187,13 @@ void
 hysdn_rx_netpkt(hysdn_card * card, unsigned char *buf, unsigned short len)
 {
 	struct net_local *lp = card->netif;
-	struct net_device *dev = lp->dev;
+	struct net_device *dev;
 	struct sk_buff *skb;
 
 	if (!lp)
 		return;		/* non existing device */
 
+	dev = lp->dev;
 	dev->stats.rx_bytes += len;
 
 	skb = dev_alloc_skb(len);
-- 
1.7.1


