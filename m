Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791Ab2DALea (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 07:34:30 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:52202 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751300Ab2DALe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 07:34:26 -0400
From: Roland Stigge <stigge@antcom.de>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        linux-arm-kernel@lists.infradead.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH RESEND] net: lpc_eth: Fix rename of dev_hw_addr_random
Date: Sun,  1 Apr 2012 13:33:52 +0200
Message-Id: <1333280032-22618-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In parallel to the integration of lpc_eth.c, dev_hw_addr_random() has been
renamed to eth_hw_addr_random(). This patch fixes the resulting current compile
error in the new driver lpc_eth.c.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---

 Applies to v3.4-rc1

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
