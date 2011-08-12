Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab1HLWzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 18:55:44 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51318 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab1HLWzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 18:55:16 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [RFC PATCH 05/12] arm/dt: Tegra: Add nvidia,gpios property to GPIO controller
Date: Fri, 12 Aug 2011 16:54:50 -0600
Message-Id: <1313189697-21287-6-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1313189697-21287-1-git-send-email-swarren@nvidia.com>
References: <1313189697-21287-1-git-send-email-swarren@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add board-specific gpio node for Harmony and Seaboard. This lists the
GPIOs used by the board. Note that not all GPIOs that exist on the board
are listed; only those used by devices currently supported by device
tree.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/boot/dts/tegra-harmony.dts  |   15 +++++++++++++++
 arch/arm/boot/dts/tegra-seaboard.dts |    8 ++++++++
 2 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra-harmony.dts b/arch/arm/boot/dts/tegra-harmony.dts
index 4c05334..c9bb847 100644
--- a/arch/arm/boot/dts/tegra-harmony.dts
+++ b/arch/arm/boot/dts/tegra-harmony.dts
@@ -15,6 +15,21 @@
 		reg = < 0x00000000 0x40000000 >;
 	};
 
+	gpio: gpio@6000d000 {
+		nvidia,gpios = <
+			69	// TEGRA_GPIO_PI5 SD2_CD
+			57	// TEGRA_GPIO_PH1 SD2_WP
+			155	// TEGRA_GPIO_PT3 SD2_POWER
+			58	// TEGRA_GPIO_PH2 SD4_CD
+			59	// TEGRA_GPIO_PH3 SD4_WP
+			70	// TEGRA_GPIO_PI6 SD4_POWER
+			187	// TEGRA_GPIO_PX3 CDC_IRQ
+			178	// TEGRA_GPIO_PW2 HP_DET
+			184	// TEGRA_GPIO_PX0 INT_MIC_EN
+			185	// TEGRA_GPIO_PX1 EXT_MIC_EN
+		>;
+	};
+
 	i2c@7000c000 {
 		clock-frequency = <400000>;
 
diff --git a/arch/arm/boot/dts/tegra-seaboard.dts b/arch/arm/boot/dts/tegra-seaboard.dts
index 1940cae..b0d44a5 100644
--- a/arch/arm/boot/dts/tegra-seaboard.dts
+++ b/arch/arm/boot/dts/tegra-seaboard.dts
@@ -16,6 +16,14 @@
 		reg = < 0x00000000 0x40000000 >;
 	};
 
+	gpio: gpio@6000d000 {
+		nvidia,gpios = <
+			69 // TEGRA_GPIO_PI5 SD2_CD
+			57 // TEGRA_GPIO_PH1 SD2_WP
+			70 // TEGRA_GPIO_PI6 SD2_POWER
+		>;
+	};
+
 	serial@70006300 {
 		clock-frequency = < 216000000 >;
 	};
-- 
1.7.0.4

