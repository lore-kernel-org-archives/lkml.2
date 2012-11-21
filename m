Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab2KUMmD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 07:42:03 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2801 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab2KUMmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 07:42:02 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 21 Nov 2012 04:42:01 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <linux-tegra@vger.kernel.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, Russell King <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] amba: tegra-ahb: Fix warning w/o PM_SLEEP
Date: Wed, 21 Nov 2012 14:41:37 +0200
Message-ID: <1353501697-25345-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix build warning w/o PM_SLEEP.

Change-Id: Id5b7d089de835025b5708fa345a75990fd976363

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 drivers/amba/tegra-ahb.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/amba/tegra-ahb.c b/drivers/amba/tegra-ahb.c
index bd5de08..0576a7d 100644
--- a/drivers/amba/tegra-ahb.c
+++ b/drivers/amba/tegra-ahb.c
@@ -157,6 +157,7 @@ int tegra_ahb_enable_smmu(struct device_node *dn)
 EXPORT_SYMBOL(tegra_ahb_enable_smmu);
 #endif
 
+#ifdef CONFIG_PM_SLEEP
 static int tegra_ahb_suspend(struct device *dev)
 {
 	int i;
@@ -176,6 +177,7 @@ static int tegra_ahb_resume(struct device *dev)
 		gizmo_writel(ahb, ahb->ctx[i], tegra_ahb_gizmo[i]);
 	return 0;
 }
+#endif
 
 static UNIVERSAL_DEV_PM_OPS(tegra_ahb_pm,
 			    tegra_ahb_suspend,
-- 
1.7.9.5

