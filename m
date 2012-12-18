Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab2LRGip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 01:38:45 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10605 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab2LRGio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 01:38:44 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 17 Dec 2012 22:38:42 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <swarren@wwwdotorg.org>,
        <linux-usb@vger.kernel.org>, Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH] usb: phy: tegra: Using devm API for memory allocation
Date: Tue, 18 Dec 2012 11:51:23 +0530
Message-ID: <1355811683-29981-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using devm_kzalloc for allocating memory needed for PHY
pointer and hence removing kfree calls to PHY pointer.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 drivers/usb/phy/tegra_usb_phy.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/phy/tegra_usb_phy.c b/drivers/usb/phy/tegra_usb_phy.c
index 9d13c81..0b99e1f 100644
--- a/drivers/usb/phy/tegra_usb_phy.c
+++ b/drivers/usb/phy/tegra_usb_phy.c
@@ -704,7 +704,6 @@ static void tegra_usb_phy_close(struct usb_phy *x)
 		utmip_pad_close(phy);
 	clk_disable_unprepare(phy->pll_u);
 	clk_put(phy->pll_u);
-	kfree(phy);
 }
 
 static int tegra_usb_phy_power_on(struct tegra_usb_phy *phy)
@@ -740,7 +739,7 @@ struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instance,
 	int i;
 	int err;
 
-	phy = kmalloc(sizeof(struct tegra_usb_phy), GFP_KERNEL);
+	phy = devm_kzalloc(dev, sizeof(struct tegra_usb_phy), GFP_KERNEL);
 	if (!phy)
 		return ERR_PTR(-ENOMEM);
 
@@ -791,7 +790,6 @@ err1:
 	clk_disable_unprepare(phy->pll_u);
 	clk_put(phy->pll_u);
 err0:
-	kfree(phy);
 	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(tegra_usb_phy_open);
-- 
1.7.0.4

