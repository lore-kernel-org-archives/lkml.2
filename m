Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab1LCI27 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 03:28:59 -0500
Received: from www17.your-server.de ([213.133.104.17]:53273 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566Ab1LCI2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 03:28:55 -0500
Message-ID: <1322865343.1534.356.camel@localhost.localdomain>
Subject: [PATCH] ll_temac: Use kcalloc instead of kzalloc to allocate array
From: Thomas Meyer <thomas@m3y3r.de>
To: grant.likely@secretlab.ca, rob.herring@calxeda.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Dec 2011 23:35:43 +0100
Mime-Version: 1.0
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The advantage of kcalloc is, that will prevent integer overflows which could
result from the multiplication of number of elements and size and it is also
a bit nicer to read.

The semantic patch that makes this change is available
in https://lkml.org/lkml/2011/11/25/107

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c 2011-11-28 19:36:47.733440944 +0100
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c 2011-11-28 19:53:34.187365029 +0100
@@ -237,7 +237,7 @@ static int temac_dma_bd_init(struct net_
 	struct sk_buff *skb;
 	int i;
 
-	lp->rx_skb = kzalloc(sizeof(*lp->rx_skb) * RX_BD_NUM, GFP_KERNEL);
+	lp->rx_skb = kcalloc(RX_BD_NUM, sizeof(*lp->rx_skb), GFP_KERNEL);
 	if (!lp->rx_skb) {
 		dev_err(&ndev->dev,
 				"can't allocate memory for DMA RX buffer\n");


