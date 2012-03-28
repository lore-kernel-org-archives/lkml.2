Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758928Ab2C1Wh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 18:37:58 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:36021 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758897Ab2C1Whk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 18:37:40 -0400
From: Roland Stigge <stigge@antcom.de>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        linux-arm-kernel@lists.infradead.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH] net: lpc_eth: Fix rename of dev_hw_addr_random
Date: Thu, 29 Mar 2012 00:36:26 +0200
Message-Id: <1332974186-12962-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In parallel to the integration of lpc_eth.c, dev_hw_addr_random() has been
renamed to eth_hw_addr_random(). This patch fixes it also in the new driver
lpc_eth.c.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
 drivers/net/ethernet/nxp/lpc_eth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/drivers/net/ethernet/nxp/lpc_eth.c
+++ linux-2.6/drivers/net/ethernet/nxp/lpc_eth.c
@@ -1441,7 +1441,7 @@ static int lpc_eth_drv_probe(struct plat
 	}
 #endif
 	if (!is_valid_ether_addr(ndev->dev_addr))
-		dev_hw_addr_random(ndev, ndev->dev_addr);
+		eth_hw_addr_random(ndev);
 
 	/* Reset the ethernet controller */
 	__lpc_eth_reset(pldat);
