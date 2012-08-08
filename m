Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab2HHFqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 01:46:54 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64327 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab2HHFqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 01:46:53 -0400
From: tobetter@gmail.com
Cc: Dongjin Kim <dongjin.kim@agreeyamobility.net>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] arm/dts: exynos4: Add DTS file for ODROID-X
Date: Wed,  8 Aug 2012 14:46:38 +0900
Message-Id: <1344404802-9442-1-git-send-email-dongjin.kim@agreeyamobility.net>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <[PATCH v2] arm/dts: exynos4: Add DTS file for ODROID-X>
References: <[PATCH v2] arm/dts: exynos4: Add DTS file for ODROID-X>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongjin Kim <dongjin.kim@agreeyamobility.net>

This patch create a DTS file for ODROID-X, it desribes PMIC max77686 and LED
gpios base.

Changes in V2 & V3:
    -. Banner changed

Signed-off-by: Dongjin Kim <dongjin.kim@agreeyamobility.net>
---
 arch/arm/boot/dts/exynos4412-odroidx.dts |  148 ++++++++++++++++++++++++++++++
 1 file changed, 148 insertions(+)
 create mode 100644 arch/arm/boot/dts/exynos4412-odroidx.dts

diff --git a/arch/arm/boot/dts/exynos4412-odroidx.dts b/arch/arm/boot/dts/exynos4412-odroidx.dts
new file mode 100644
index 0000000..7f63eaf
--- /dev/null
+++ b/arch/arm/boot/dts/exynos4412-odroidx.dts
@@ -0,0 +1,148 @@
+/*
+ * Samsung's Exynos4412 based ODROID-X board device tree source
+ *
+ * Copyright (c) 2012 AgreeYa Mobility Co., Ltd.
+ *		http://www.agreeyamobility.net
+ * Copyright (c) 2012 Hardkernel Co., Ltd.
+ *		http://www.hardkernel.com
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
+/include/ "max77686.dtsi"
+
+/ {
+	model = "Hardkernel ODROID-X evaluation board based on Exynos4412";
+	compatible = "hardkernel,odroidx", "samsung,exynos4412";
+
+	memory {
+		reg = <0x40000000 0x40000000>;
+	};
+
+	chosen {
+		bootargs = "root=/dev/mmcblk0p1 init=/sbin/init console=ttySAC1,115200 console=tty1 rootdalay=2";
+	};
+
+	/* sdhci0 */
+	sdhci@12510000 {
+		status = "disabled";
+	};
+
+	/* sdhci1 */
+	sdhci@12520000 {
+		status = "disabled";
+	};
+
+	/* sdhci2 */
+	sdhci@12530000 {
+		samsung,sdhci-bus-width = <4>;
+		linux,mmc_cap_4_bit_data;
+		samsung,sdhci-cd-internal;
+		gpio-cd = <&gpk2 2 2 3 3>;
+		gpios = <&gpk2 0 2 0 3>,
+			<&gpk2 1 2 0 3>,
+			<&gpk2 3 2 3 3>,
+			<&gpk2 4 2 3 3>,
+			<&gpk2 5 2 3 3>,
+			<&gpk2 6 2 3 3>;
+	};
+
+	/* sdhci3 */
+	sdhci@12540000 {
+		samsung,sdhci-bus-width = <4>;
+		linux,mmc_cap_4_bit_data;
+		samsung,sdhci-cd-internal;
+		gpio-cd	= <&gpk3 2 2 3 3>;
+		gpios = <&gpk3 0 2 0 3>,
+			<&gpk3 1 2 0 3>,
+			<&gpk3 3 2 3 3>,
+			<&gpk3 4 2 3 3>,
+			<&gpk3 5 2 3 3>,
+			<&gpk3 6 2 3 3>;
+	};
+
+	leds {
+		compatible = "gpio-leds";
+
+		led1 {
+			label	= "led1";
+			gpios	= <&gpc1 0 1 0x10000 0>;
+			linux,default-trigger	= "oneshot";
+			default-state	= "off";
+		};
+
+		led2 {
+			label	= "led2";
+			gpios	= <&gpc1 2 1 0x10000 0>;
+			linux,default-trigger	= "heartbeat";
+		};
+	};
+
+	i2c@13860000 {	/* i2c0 */
+		#address-cells = <1>;
+		#size-cells = <0>;
+		gpios = <&gpd1 0 2 0 0>,
+			<&gpd1 1 2 0 0>;
+		pmic@9 {
+			compatible = "maxim,max77686";
+			reg = <9>;
+		};
+	};
+
+	i2c@13870000 {	/* i2c1 */
+		status = "disabled";
+		gpios = <&gpd1 2 2 0 0>,
+			<&gpd1 3 2 0 0>;
+	};
+
+	i2c@13880000 {	/* i2c2 */
+		status = "disabled";
+		gpios = <&gpa0 6 2 0 0>,
+			<&gpa0 7 2 0 0>;
+	};
+
+	i2c@13890000 {	/* i2c3 */
+		status = "disabled";
+		gpios = <&gpa1 2 2 0 0>,
+			<&gpa1 3 2 0 0>;
+	};
+
+	i2c@138A0000 {	/* i2c4 */
+		status = "disabled";
+	};
+
+	i2c@138B0000 {	/* i2c5 */
+		status = "disabled";
+	};
+
+	i2c@138C0000 {	/* i2c6 */
+		status = "disabled";
+	};
+
+	i2c@138D0000 {	/* i2c7 */
+		status = "disabled";
+	};
+
+	keypad@100A0000 {
+		status = "disabled";
+	};
+
+	spi_0: spi@13920000 {
+		status = "disabled";
+	};
+
+	spi_1: spi@13930000 {
+		status = "disabled";
+	};
+
+	spi_2: spi@13940000 {
+		status = "disabled";
+	};
+};
-- 
1.7.9.5

