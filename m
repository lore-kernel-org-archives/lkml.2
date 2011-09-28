Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab1I1A7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 20:59:48 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10030 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab1I1A7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 20:59:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 27 Sep 2011 17:59:33 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH v3 1/3] arm/tegra: prepare Seaboard pinmux code for derived boards
Date: Wed, 28 Sep 2011 03:59:20 +0300
Message-ID: <1317171563-14559-2-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1317171563-14559-1-git-send-email-pdeschrijver@nvidia.com>
References: <1317171563-14559-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch splits out the common part of pinmux and GPIO initialization for
seaboard and derived boards. This code is based on work done by Jong Kim
<jongk@nvidia.com>.

Change-Id: I861db37c727a7118d38885c4bcb6f4acce3d4133
Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/board-seaboard-pinmux.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-tegra/board-seaboard-pinmux.c b/arch/arm/mach-tegra/board-seaboard-pinmux.c
index 74f78b7..b31c765 100644
--- a/arch/arm/mach-tegra/board-seaboard-pinmux.c
+++ b/arch/arm/mach-tegra/board-seaboard-pinmux.c
@@ -1,5 +1,6 @@
 /*
- * Copyright (C) 2010 NVIDIA Corporation
+ * Copyright (C) 2010,2011 NVIDIA Corporation
+ * Copyright (C) 2011 Google, Inc.
  *
  * This software is licensed under the terms of the GNU General Public
  * License version 2, as published by the Free Software Foundation, and
@@ -160,7 +161,7 @@ static __initdata struct tegra_pingroup_config seaboard_pinmux[] = {
 
 
 
-static struct tegra_gpio_table gpio_table[] = {
+static struct tegra_gpio_table common_gpio_table[] = {
 	{ .gpio = TEGRA_GPIO_SD2_CD,		.enable = true },
 	{ .gpio = TEGRA_GPIO_SD2_WP,		.enable = true },
 	{ .gpio = TEGRA_GPIO_SD2_POWER,		.enable = true },
@@ -171,12 +172,17 @@ static struct tegra_gpio_table gpio_table[] = {
 	{ .gpio = TEGRA_GPIO_USB1,		.enable = true },
 };
 
-void __init seaboard_pinmux_init(void)
+static void __init seaboard_common_pinmux_init(void)
 {
 	tegra_pinmux_config_table(seaboard_pinmux, ARRAY_SIZE(seaboard_pinmux));
 
 	tegra_drive_pinmux_config_table(seaboard_drive_pinmux,
 					ARRAY_SIZE(seaboard_drive_pinmux));
 
-	tegra_gpio_config(gpio_table, ARRAY_SIZE(gpio_table));
+	tegra_gpio_config(common_gpio_table, ARRAY_SIZE(common_gpio_table));
+}
+
+void __init seaboard_pinmux_init(void)
+{
+	seaboard_common_pinmux_init();
 }
-- 
1.7.0.4

