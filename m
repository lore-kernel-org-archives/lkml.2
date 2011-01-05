Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301Ab1AEFWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 00:22:23 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63535 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab1AEFWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 00:22:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=qBWNpJO+ZFnQdAgZRN0rDU2eG1obrAgMO70DdROapDb5oDz1KYwdXhNG4o6y9vP8F+
         uEqFoWEMc3oRq86y5wvBoGsriQYhJgI9nKXfxmhdzHLf9++xc8PTUyXETpt6jERV7WmP
         RyaXTkAjYMFuk/mgCSSJ1GyXU0e0KnQbE+xOo=
Subject: [PATCH] net: ixp4xx_eth: Return proper error for eth_init_one
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Krzysztof Halasa <khc@pm.waw.pl>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
Content-Type: text/plain
Date: Wed, 05 Jan 2011 13:24:06 +0800
Message-Id: <1294205046.8294.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return PTR_ERR(port->phydev) instead of 1 if phy_connect failed.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/net/arm/ixp4xx_eth.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/arm/ixp4xx_eth.c b/drivers/net/arm/ixp4xx_eth.c
index 6028226..9eb9b98 100644
--- a/drivers/net/arm/ixp4xx_eth.c
+++ b/drivers/net/arm/ixp4xx_eth.c
@@ -1229,8 +1229,10 @@ static int __devinit eth_init_one(struct platform_device *pdev)
 	snprintf(phy_id, MII_BUS_ID_SIZE + 3, PHY_ID_FMT, "0", plat->phy);
 	port->phydev = phy_connect(dev, phy_id, &ixp4xx_adjust_link, 0,
 				   PHY_INTERFACE_MODE_MII);
-	if ((err = IS_ERR(port->phydev)))
+	if (IS_ERR(port->phydev)) {
+		err = PTR_ERR(port->phydev);
 		goto err_free_mem;
+	}
 
 	port->phydev->irq = PHY_POLL;
 
-- 
1.7.2



