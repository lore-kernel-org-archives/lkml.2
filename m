Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143Ab2CMK4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 06:56:21 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:45816
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753150Ab2CMK4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 06:56:20 -0400
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzz8275dhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng <b29396@freescale.com>
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: <davem@davemloft.net>, <timur@freescale.com>, <rdunlap@xenotime.net>,
        <kernel@pengutronix.de>
Subject: [PATCH 1/1] net: phylib: add error checking if no phy found
Date: Tue, 13 Mar 2012 18:58:22 +0800
Message-ID: <1331636302-18256-1-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
 drivers/net/phy/mdio_bus.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 88cc5db..d8e044d 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -101,6 +101,7 @@ static struct class mdio_bus_class = {
 int mdiobus_register(struct mii_bus *bus)
 {
 	int i, err;
+	u32 phynum = 0;
 
 	if (NULL == bus || NULL == bus->name ||
 			NULL == bus->read ||
@@ -134,12 +135,20 @@ int mdiobus_register(struct mii_bus *bus)
 			if (IS_ERR(phydev)) {
 				err = PTR_ERR(phydev);
 				goto error;
+			} else if (phydev != NULL) {
+				phynum++;
 			}
 		}
 	}
 
+	if (!phynum) {
+		err = -ENODEV;
+		printk(KERN_ERR "%s: no phys found\n", bus->name);
+		goto error;
+	}
+
 	bus->state = MDIOBUS_REGISTERED;
-	pr_info("%s: probed\n", bus->name);
+	pr_info("%s: %d phys probed\n", bus->name, phynum);
 	return 0;
 
 error:
-- 
1.7.0.4


