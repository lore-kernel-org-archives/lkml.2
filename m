Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab3AFLQU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 06:16:20 -0500
Received: from [216.228.121.35] ([216.228.121.35]:17361 "EHLO
	hqemgate04.nvidia.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755234Ab3AFLQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 06:16:12 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sun, 06 Jan 2013 03:15:31 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <dmitry.torokhov@gmail.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <swarren@nvidia.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-input@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V4 1/4] input: keyboard: tegra: fix build warning
Date: Sun, 6 Jan 2013 16:44:57 +0530
Message-ID: <1357470900-12619-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1357470900-12619-1-git-send-email-ldewangan@nvidia.com>
References: <1357470900-12619-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following build warning when building driver with CONFIG_PM_SLEEP
not selected.

tegra-kbc.c:360:13: warning: 'tegra_kbc_set_keypress_interrupt' defined but not used [-Wunused-function]

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1, V2 and V3:
	None

 drivers/input/keyboard/tegra-kbc.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c
index c76f968..f1d3ba0 100644
--- a/drivers/input/keyboard/tegra-kbc.c
+++ b/drivers/input/keyboard/tegra-kbc.c
@@ -357,18 +357,6 @@ static void tegra_kbc_set_fifo_interrupt(struct tegra_kbc *kbc, bool enable)
 	writel(val, kbc->mmio + KBC_CONTROL_0);
 }
 
-static void tegra_kbc_set_keypress_interrupt(struct tegra_kbc *kbc, bool enable)
-{
-	u32 val;
-
-	val = readl(kbc->mmio + KBC_CONTROL_0);
-	if (enable)
-		val |= KBC_CONTROL_KEYPRESS_INT_EN;
-	else
-		val &= ~KBC_CONTROL_KEYPRESS_INT_EN;
-	writel(val, kbc->mmio + KBC_CONTROL_0);
-}
-
 static void tegra_kbc_keypress_timer(unsigned long data)
 {
 	struct tegra_kbc *kbc = (struct tegra_kbc *)data;
@@ -866,6 +854,18 @@ static int tegra_kbc_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM_SLEEP
+static void tegra_kbc_set_keypress_interrupt(struct tegra_kbc *kbc, bool enable)
+{
+	u32 val;
+
+	val = readl(kbc->mmio + KBC_CONTROL_0);
+	if (enable)
+		val |= KBC_CONTROL_KEYPRESS_INT_EN;
+	else
+		val &= ~KBC_CONTROL_KEYPRESS_INT_EN;
+	writel(val, kbc->mmio + KBC_CONTROL_0);
+}
+
 static int tegra_kbc_suspend(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
-- 
1.7.1.1

