Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935811Ab2JaQI0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 12:08:26 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:30674 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423176Ab2JaQFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 12:05:36 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <netdev@vger.kernel.org>, <davem@davemloft.net>, <havard@skinnemoen.net>
CC: <bhutchings@solarflare.com>, <linux-arm-kernel@lists.infradead.org>,
        <plagnioj@jcrosoft.com>, <patrice.vilchez@atmel.com>,
        <linux-kernel@vger.kernel.org>, <manabian@gmail.com>,
        <David.Laight@ACULAB.COM>, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v4 05/10] net/macb: tx status is more than 8 bits now
Date: Wed, 31 Oct 2012 17:04:54 +0100
Message-ID: <76a3a1fb6ad2fbf5e4d8d447afe7cd5c0eb24b8b.1351690694.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <cover.1351690694.git.nicolas.ferre@atmel.com>
References: <cover.1351690694.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some revision of GEM, TSR status register has more information.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Tested-by: Joachim Eastwood <manabian@gmail.com>
---
 drivers/net/ethernet/cadence/macb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
index 4db52f3..cd6d431 100644
--- a/drivers/net/ethernet/cadence/macb.c
+++ b/drivers/net/ethernet/cadence/macb.c
@@ -314,7 +314,7 @@ static void macb_tx(struct macb *bp)
 	status = macb_readl(bp, TSR);
 	macb_writel(bp, TSR, status);
 
-	netdev_vdbg(bp->dev, "macb_tx status = %02lx\n", (unsigned long)status);
+	netdev_vdbg(bp->dev, "macb_tx status = 0x%03lx\n", (unsigned long)status);
 
 	if (status & (MACB_BIT(UND) | MACB_BIT(TSR_RLE))) {
 		int i;
-- 
1.8.0

