Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab3AEHq2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 02:46:28 -0500
Received: from [216.228.121.35] ([216.228.121.35]:15065 "EHLO
	hqemgate04.nvidia.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755054Ab3AEHqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 02:46:25 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 04 Jan 2013 23:41:34 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <dmitry.torokhov@gmail.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <swarren@nvidia.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-input@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH v2 1/4] input: keyboard: tegra: fix build warning
Date: Sat, 5 Jan 2013 13:15:07 +0530
Message-ID: <1357371910-3164-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1357371910-3164-1-git-send-email-ldewangan@nvidia.com>
References: <1357371910-3164-1-git-send-email-ldewangan@nvidia.com>
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
Changes form V1:
- none

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

