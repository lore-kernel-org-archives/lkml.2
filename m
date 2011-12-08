Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab1LHIBI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 03:01:08 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:64408 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab1LHH7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 02:59:39 -0500
From: =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: netdev@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>,
        =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH v3 2/8] net/fec: set con_id in clk_get() call to NULL
Date: Thu,  8 Dec 2011 08:59:26 +0100
Message-Id: <6c28f25c5c6d2f88d0985ce361c5e16f19db27d0.1323326019.git.LW@KARO-electronics.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <bd4415514fa0b40ece04d56b3ac4f549e79d87d7.1323326019.git.LW@KARO-electronics.de>
References: <cover.1323326019.git.LW@KARO-electronics.de>
 <bd4415514fa0b40ece04d56b3ac4f549e79d87d7.1323326019.git.LW@KARO-electronics.de>
In-Reply-To: <cover.1323326019.git.LW@KARO-electronics.de>
References: <cover.1323326019.git.LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The con_id is actually not needed for clk_get().

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/net/ethernet/freescale/fec.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.c b/drivers/net/ethernet/freescale/fec.c
index f224e58..65ee506 100644
--- a/drivers/net/ethernet/freescale/fec.c
+++ b/drivers/net/ethernet/freescale/fec.c
@@ -1585,7 +1585,7 @@ fec_probe(struct platform_device *pdev)
 		}
 	}
 
-	fep->clk = clk_get(&pdev->dev, "fec_clk");
+	fep->clk = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(fep->clk)) {
 		ret = PTR_ERR(fep->clk);
 		goto failed_clk;
-- 
1.5.6.5

