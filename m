Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab2GJAQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 20:16:30 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64343 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151Ab2GJAQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 20:16:27 -0400
From: Rob Herring <robherring2@gmail.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 4/4] net: calxedaxgmac: enable rx cut-thru mode
Date: Mon,  9 Jul 2012 19:16:10 -0500
Message-Id: <1341879370-23385-5-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341879370-23385-1-git-send-email-robherring2@gmail.com>
References: <1341879370-23385-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Enabling RX cut-thru mode yields better performance as received frames
start getting written to memory before a whole frame is received.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 drivers/net/ethernet/calxeda/xgmac.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index abb8f40..2b4b4f5 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -264,7 +264,7 @@
 #define XGMAC_OMR_FEF		0x00000080	/* Forward Error Frames */
 #define XGMAC_OMR_DT		0x00000040	/* Drop TCP/IP csum Errors */
 #define XGMAC_OMR_RSF		0x00000020	/* RX FIFO Store and Forward */
-#define XGMAC_OMR_RTC		0x00000010	/* RX Threshhold Ctrl */
+#define XGMAC_OMR_RTC_256	0x00000018	/* RX Threshhold Ctrl */
 #define XGMAC_OMR_RTC_MASK	0x00000018	/* RX Threshhold Ctrl MASK */
 
 /* XGMAC HW Features Register */
@@ -982,7 +982,8 @@ static int xgmac_hw_init(struct net_device *dev)
 	writel(value, ioaddr + XGMAC_DMA_CONTROL);
 
 	/* Set the HW DMA mode and the COE */
-	writel(XGMAC_OMR_TSF | XGMAC_OMR_RSF | XGMAC_OMR_RFD | XGMAC_OMR_RFA,
+	writel(XGMAC_OMR_TSF | XGMAC_OMR_RFD | XGMAC_OMR_RFA |
+		XGMAC_OMR_RTC_256,
 		ioaddr + XGMAC_OMR);
 
 	/* Reset the MMC counters */
-- 
1.7.9.5

