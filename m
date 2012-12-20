Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534Ab2LTInr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 03:43:47 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13028 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab2LTInl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 03:43:41 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 20 Dec 2012 00:41:11 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <swarren@wwwdotorg.org>, <balbi@ti.com>, <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH v2] usb: phy: using kzalloc instead of kmalloc
Date: Thu, 20 Dec 2012 13:55:51 +0530
Message-ID: <1355991951-3503-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Tegra PHY driver open is using kmalloc,
changing it to kzalloc.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
This patch is v2 patch for the patch discussed at
http://marc.info/?l=linux-usb&m=135593869431766&w=2

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

