Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab1IUTdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 15:33:49 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33605 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab1IUTdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 15:33:47 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@secretlab.ca>, Chris Ball <cjb@laptop.org>,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 1/3] arm/tegra: Move EN_VDD_1V05_GPIO to board-harmony.h
Date: Wed, 21 Sep 2011 13:33:38 -0600
Message-Id: <1316633620-13184-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This centralizes all GPIO naming in one header.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
This patch series relies on various previous changes to the Tegra GPIO
driver that were made in Russell's GPIO tree. I assume this series will
go in through that tree.

This first patch is cleanup which makes the second slightly cleaner (no
need to edit board-harmony-pcie.c in patch 2). Usually, it would go in
through the Tegra tree, but I think it makes sense to merge these 3
patches all together in one place.

 arch/arm/mach-tegra/board-harmony-pcie.c |   10 ++++------
 arch/arm/mach-tegra/board-harmony.h      |    1 +
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-tegra/board-harmony-pcie.c b/arch/arm/mach-tegra/board-harmony-pcie.c
index 9c27b95..6db7d69 100644
--- a/arch/arm/mach-tegra/board-harmony-pcie.c
+++ b/arch/arm/mach-tegra/board-harmony-pcie.c
@@ -24,12 +24,10 @@
 
 #include <mach/pinmux.h>
 #include "board.h"
+#include "board-harmony.h"
 
 #ifdef CONFIG_TEGRA_PCI
 
-/* GPIO 3 of the PMIC */
-#define EN_VDD_1V05_GPIO	(TEGRA_NR_GPIOS + 2)
-
 static int __init harmony_pcie_init(void)
 {
 	struct regulator *regulator = NULL;
@@ -38,11 +36,11 @@ static int __init harmony_pcie_init(void)
 	if (!machine_is_harmony())
 		return 0;
 
-	err = gpio_request(EN_VDD_1V05_GPIO, "EN_VDD_1V05");
+	err = gpio_request(TEGRA_GPIO_EN_VDD_1V05_GPIO, "EN_VDD_1V05");
 	if (err)
 		return err;
 
-	gpio_direction_output(EN_VDD_1V05_GPIO, 1);
+	gpio_direction_output(TEGRA_GPIO_EN_VDD_1V05_GPIO, 1);
 
 	regulator = regulator_get(NULL, "pex_clk");
 	if (IS_ERR_OR_NULL(regulator))
@@ -68,7 +66,7 @@ err_pcie:
 	regulator_disable(regulator);
 	regulator_put(regulator);
 err_reg:
-	gpio_free(EN_VDD_1V05_GPIO);
+	gpio_free(TEGRA_GPIO_EN_VDD_1V05_GPIO);
 
 	return err;
 }
diff --git a/arch/arm/mach-tegra/board-harmony.h b/arch/arm/mach-tegra/board-harmony.h
index d85142e..280d203 100644
--- a/arch/arm/mach-tegra/board-harmony.h
+++ b/arch/arm/mach-tegra/board-harmony.h
@@ -31,6 +31,7 @@
 #define TEGRA_GPIO_HP_DET		TEGRA_GPIO_PW2
 #define TEGRA_GPIO_INT_MIC_EN		TEGRA_GPIO_PX0
 #define TEGRA_GPIO_EXT_MIC_EN		TEGRA_GPIO_PX1
+#define TEGRA_GPIO_EN_VDD_1V05_GPIO	HARMONY_GPIO_TPS6586X(2)
 
 void harmony_pinmux_init(void);
 int harmony_regulator_init(void);
-- 
1.7.0.4

