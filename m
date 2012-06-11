Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751120Ab2FKIDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 04:03:53 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:59518 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750738Ab2FKIDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 04:03:50 -0400
From: Roland Stigge <stigge@antcom.de>
To: davem@davemloft.net, eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com,
        linux-arm-kernel@lists.infradead.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 3/3] net: lpc_eth: Driver cleanup
Date: Mon, 11 Jun 2012 10:03:13 +0200
Message-Id: <1339401793-12258-3-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339401793-12258-1-git-send-email-stigge@antcom.de>
References: <1339401793-12258-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes some nowadays superfluous definitions (one unused define and
an obsolete function forward declaration) and corrects a netdev_err() to
netdev_dbg().

Signed-off-by: Roland Stigge <stigge@antcom.de>
Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

---
 drivers/net/ethernet/nxp/lpc_eth.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- linux-2.6.orig/drivers/net/ethernet/nxp/lpc_eth.c
+++ linux-2.6/drivers/net/ethernet/nxp/lpc_eth.c
@@ -52,7 +52,6 @@
 
 #define MODNAME "lpc-eth"
 #define DRV_VERSION "1.00"
-#define PHYDEF_ADDR 0x00
 
 #define ENET_MAXF_SIZE 1536
 #define ENET_RX_DESC 48
@@ -416,9 +415,6 @@ static bool use_iram_for_net(struct devi
 #define TXDESC_CONTROL_LAST		(1 << 30)
 #define TXDESC_CONTROL_INT		(1 << 31)
 
-static int lpc_eth_hard_start_xmit(struct sk_buff *skb,
-				   struct net_device *ndev);
-
 /*
  * Structure of a TX/RX descriptors and RX status
  */
@@ -1441,7 +1437,7 @@ static int lpc_eth_drv_probe(struct plat
 			res->start);
 	netdev_dbg(ndev, "IO address size      :%d\n",
 			res->end - res->start + 1);
-	netdev_err(ndev, "IO address (mapped)  :0x%p\n",
+	netdev_dbg(ndev, "IO address (mapped)  :0x%p\n",
 			pldat->net_base);
 	netdev_dbg(ndev, "IRQ number           :%d\n", ndev->irq);
 	netdev_dbg(ndev, "DMA buffer size      :%d\n", pldat->dma_buff_size);
