Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab1LHH7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 02:59:48 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:64400 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab1LHH7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 02:59:37 -0500
From: =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: netdev@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>,
        =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH v3 5/8] net/fec: don't munge MAC address from platform data
Date: Thu,  8 Dec 2011 08:59:29 +0100
Message-Id: <55b78c1766da5b0d0d679f5eae3fb9fc74a6ceef.1323326019.git.LW@KARO-electronics.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <6d1e5cdcbfc48df864ec9e0939645c0e95389d2a.1323326019.git.LW@KARO-electronics.de>
References: <cover.1323326019.git.LW@KARO-electronics.de>
 <bd4415514fa0b40ece04d56b3ac4f549e79d87d7.1323326019.git.LW@KARO-electronics.de>
 <6c28f25c5c6d2f88d0985ce361c5e16f19db27d0.1323326019.git.LW@KARO-electronics.de>
 <0b92136d69e509a6ce49b526e1834f0ec90b04a4.1323326019.git.LW@KARO-electronics.de>
 <6d1e5cdcbfc48df864ec9e0939645c0e95389d2a.1323326019.git.LW@KARO-electronics.de>
In-Reply-To: <cover.1323326019.git.LW@KARO-electronics.de>
References: <cover.1323326019.git.LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the MAC address is supplied via platform_data it should be OK as
it is and should not be modified in case of a dual FEC setup.
Also copying the MAC from platform_data to the single 'macaddr'
variable will overwrite the MAC for the first interface in case of a
dual FEC setup.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/net/ethernet/freescale/fec.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.c b/drivers/net/ethernet/freescale/fec.c
index e2b5ce6..11534b9 100644
--- a/drivers/net/ethernet/freescale/fec.c
+++ b/drivers/net/ethernet/freescale/fec.c
@@ -818,7 +818,7 @@ static void __inline__ fec_get_mac(struct net_device *ndev)
 			iap = (unsigned char *)FEC_FLASHMAC;
 #else
 		if (pdata)
-			memcpy(iap, pdata->mac, ETH_ALEN);
+			iap = (unsigned char *)&pdata->mac;
 #endif
 	}
 
-- 
1.5.6.5

