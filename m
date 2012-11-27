Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092Ab2K0GtG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 01:49:06 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19620 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756732Ab2K0GtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 01:49:03 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 26 Nov 2012 22:49:02 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <gregkh@linuxfoundation.org>
CC: <swarren@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Hiroshi Doyu <hdoyu@nvidia.com>
Subject: [PATCH 1/1] memory: tegra30: Fix warning w/o PM_SLEEP
Date: Tue, 27 Nov 2012 08:48:35 +0200
Message-ID: <1353998915-13263-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20121126234729.GA19416@kroah.com>
References: <20121126234729.GA19416@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix build warning w/o PM_SLEEP.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
Reviewed-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/memory/tegra30-mc.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/memory/tegra30-mc.c b/drivers/memory/tegra30-mc.c
index 802b9ea..cf10b77 100644
--- a/drivers/memory/tegra30-mc.c
+++ b/drivers/memory/tegra30-mc.c
@@ -267,6 +267,7 @@ static const u32 tegra30_mc_ctx[] = {
 	MC_INTMASK,
 };
 
+#ifdef CONFIG_PM_SLEEP
 static int tegra30_mc_suspend(struct device *dev)
 {
 	int i;
@@ -290,6 +291,7 @@ static int tegra30_mc_resume(struct device *dev)
 	mc_readl(mc, MC_TIMING_CONTROL);
 	return 0;
 }
+#endif
 
 static UNIVERSAL_DEV_PM_OPS(tegra30_mc_pm,
 			    tegra30_mc_suspend,
-- 
1.7.9.5

