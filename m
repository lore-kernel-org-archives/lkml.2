Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751098Ab2LUGwc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 01:52:32 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12192 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab2LUGw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 01:52:29 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 20 Dec 2012 22:50:46 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <swarren@wwwdotorg.org>, <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <sshtylyov@mvista.com>
CC: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH v3] usb: phy: use kzalloc to allocate struct tegra_usb_phy
Date: Fri, 21 Dec 2012 12:04:16 +0530
Message-ID: <1356071656-10052-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kzalloc instead of kmalloc to allocate struct tegra_usb_phy.
This ensures that all function pointers in member u_phy are
initialized to NULL.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
This patch is v3 patch for the patch discussed at
http://marc.info/?l=linux-kernel&m=135599303216132&w=2

 drivers/usb/phy/tegra_usb_phy.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/phy/tegra_usb_phy.c b/drivers/usb/phy/tegra_usb_phy.c
index 04bf5d2..dedead5 100644
--- a/drivers/usb/phy/tegra_usb_phy.c
+++ b/drivers/usb/phy/tegra_usb_phy.c
@@ -736,7 +736,7 @@ struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev,
 	int err;
 	u8 index = is_legacy_mode ? 0 : 2;
 
-	phy = kmalloc(sizeof(struct tegra_usb_phy), GFP_KERNEL);
+	phy = kzalloc(sizeof(struct tegra_usb_phy), GFP_KERNEL);
 	if (!phy)
 		return ERR_PTR(-ENOMEM);
 
-- 
1.7.0.4

