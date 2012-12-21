Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609Ab2LURjD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 12:39:03 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:65109 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab2LURi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 12:38:57 -0500
X-Greylist: delayed 1610 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Dec 2012 12:38:57 EST
From: Dongjin Kim <tobetter@gmail.com>
Cc: Dongjin Kim <tobetter@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>, Jason Cooper <jason@lakedaemon.net>,
        Shawn Guo <shawn.guo@linaro.org>, Andrew Lunn <andrew@lunn.ch>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] ODROID-X: dts: Add board dts file for ODROID-X
Date: Sat, 22 Dec 2012 02:37:00 +0900
Message-Id: <1356111423-3454-2-git-send-email-tobetter@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1356111423-3454-1-git-send-email-tobetter@gmail.com>
References: <1356111423-3454-1-git-send-email-tobetter@gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add initial dtb file for Hardkernel's ODROID-X board based on EXYNOS4412 SoC.

Signed-off-by: Dongjin Kim <tobetter@gmail.com>
---
 arch/arm/boot/dts/Makefile               |    1 +
 arch/arm/boot/dts/exynos4412-odroidx.dts |   47 ++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)
 create mode 100644 arch/arm/boot/dts/exynos4412-odroidx.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index d077ef8..364d67b 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -44,6 +44,7 @@ dtb-$(CONFIG_ARCH_EXYNOS) += exynos4210-origen.dtb \
 	exynos4210-trats.dtb \
 	exynos5250-smdk5250.dtb \
 	exynos5440-ssdk5440.dtb \
+	exynos4412-odroidx.dtb \
 	exynos4412-smdk4412.dtb \
 	exynos5250-smdk5250.dtb \
 	exynos5250-snow.dtb
diff --git a/arch/arm/boot/dts/exynos4412-odroidx.dts b/arch/arm/boot/dts/exynos4412-odroidx.dts
new file mode 100644
index 0000000..323ed177
--- /dev/null
+++ b/arch/arm/boot/dts/exynos4412-odroidx.dts
@@ -0,0 +1,47 @@
+/*
+ * Hardkernel's Exynos4412 based ODROID-X board device tree source
+ *
+ * Copyright (c) 2012 Dongjin Kim <tobetter@gmail.com>
+ *
+ * Device tree source file for Hardkernel's ODROID-X board which is based on
+ * Samsung's Exynos4412 SoC.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+/dts-v1/;
+/include/ "exynos4412.dtsi"
+
+/ {
+	model = "Hardkernel ODROID-X board based on Exynos4412";
+	compatible = "hardkernel,exynos4412", "samsung,exynos4412";
+
+	memory {
+		reg = <0x40000000 0x40000000>;
+	};
+
+	serial@13800000 {
+		status = "okay";
+	};
+
+	serial@13810000 {
+		status = "okay";
+	};
+
+	serial@13820000 {
+		status = "okay";
+	};
+
+	serial@13830000 {
+		status = "okay";
+	};
+
+	sdhci@12530000 {
+		bus-width = <4>;
+		pinctrl-0 = <&sd2_clk &sd2_cmd &sd2_cd &sd2_bus4>;
+		pinctrl-names = "default";
+		status = "okay";
+	};
+};
-- 
1.7.9.5

