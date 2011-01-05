Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656Ab1AEIiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 03:38:15 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:64588 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab1AEIiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 03:38:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=cHyH3CTEVwJulzzJpG3oEnuEwmL9M0kkC3Ough/w642uip4hBCgcY2HpBeub1cZqLl
         P6cqbFape0D7Gs6VlIcWjGj6FkPU8tESc6ApFB3PRHD8R2ThMQwZlcRB6DUvP48x53+1
         eDJxElHZLOQOIwfM7Prr9tYVD6I9meYa3myMc=
Subject: [PATCH] net: r6040: Return proper error for r6040_init_one
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Florian Fainelli <florian@openwrt.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Content-Type: text/plain
Date: Wed, 05 Jan 2011 16:40:04 +0800
Message-Id: <1294216804.19064.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return -ENOMEM instead of 0 for the case of mdiobus_alloc and kmalloc failure.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/net/r6040.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/r6040.c b/drivers/net/r6040.c
index 0b014c89..27e6f6d 100644
--- a/drivers/net/r6040.c
+++ b/drivers/net/r6040.c
@@ -1153,6 +1153,7 @@ static int __devinit r6040_init_one(struct pci_dev *pdev,
 	lp->mii_bus = mdiobus_alloc();
 	if (!lp->mii_bus) {
 		dev_err(&pdev->dev, "mdiobus_alloc() failed\n");
+		err = -ENOMEM;
 		goto err_out_unmap;
 	}
 
@@ -1165,6 +1166,7 @@ static int __devinit r6040_init_one(struct pci_dev *pdev,
 	lp->mii_bus->irq = kmalloc(sizeof(int)*PHY_MAX_ADDR, GFP_KERNEL);
 	if (!lp->mii_bus->irq) {
 		dev_err(&pdev->dev, "mii_bus irq allocation failed\n");
+		err = -ENOMEM;
 		goto err_out_mdio;
 	}
 
-- 
1.7.2



