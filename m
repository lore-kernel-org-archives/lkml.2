Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257Ab2IEJBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 05:01:21 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:32759 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758238Ab2IEJBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:01:19 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <netdev@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <davem@davemloft.net>,
        <havard@skinnemoen.net>, <nicolas.ferre@atmel.com>,
        <plagnioj@jcrosoft.com>, <jamie@jamieiles.com>,
        <linux-kernel@vger.kernel.org>, <patrice.vilchez@atmel.com>
Subject: [PATCH 08/10] net/macb: macb_get_drvinfo: add GEM/MACB suffix to differentiate revision
Date: Wed, 5 Sep 2012 11:00:53 +0200
Message-ID: <fc701a2ed18198b7a671c55f1e65725f1709509c.1346775479.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1346775479.git.nicolas.ferre@atmel.com>
References: <cover.1346775479.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an indication about which revision of the hardware we are running in
info->driver string.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/net/ethernet/cadence/macb.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
index bd331fd..c7c39f1 100644
--- a/drivers/net/ethernet/cadence/macb.c
+++ b/drivers/net/ethernet/cadence/macb.c
@@ -1313,6 +1313,10 @@ static void macb_get_drvinfo(struct net_device *dev,
 	struct macb *bp = netdev_priv(dev);
 
 	strcpy(info->driver, bp->pdev->dev.driver->name);
+	if (macb_is_gem(bp))
+		strcat(info->driver, " GEM");
+	else
+		strcat(info->driver, " MACB");
 	strcpy(info->version, "$Revision: 1.14 $");
 	strcpy(info->bus_info, dev_name(&bp->pdev->dev));
 }
-- 
1.7.10

