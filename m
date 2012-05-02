Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177Ab2EBFMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 01:12:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45424 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756312Ab2EBFMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 01:12:25 -0400
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-mmc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        cjb@laptop.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        patches@linaro.org
Subject: [PATCH 7/7] ARM: dts: Add nodes for dw_mmc controllers for Samsung Exynos5250 platforms
Date: Tue,  1 May 2012 22:07:46 -0700
Message-Id: <1335935266-25289-8-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335935266-25289-1-git-send-email-thomas.abraham@linaro.org>
References: <1335935266-25289-1-git-send-email-thomas.abraham@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device nodes for the four instances of dw_mmc controllers in Exynos5250
and enable instance 0 and 2 for the smdk5250 board.

Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
---
 arch/arm/boot/dts/exynos5250-smdk5250.dts |   50 ++++++++++++++++++++++++++++-
 arch/arm/boot/dts/exynos5250.dtsi         |   24 ++++++++++++++
 2 files changed, 73 insertions(+), 1 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
index dbc4bdb..ac9df2f 100644
--- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
+++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
@@ -86,4 +86,52 @@
 	i2c@12CD0000 {
 		status = "disabled";
 	};
+
+	dwmmc0@12200000 {
+		supports-highspeed;
+		card-detection-broken;
+		no-write-protect;
+		fifo-depth = <0x80>;
+		card-detect-delay = <200>;
+		samsung,dw-mshc-sdr-timing = <2 3 3>;
+		samsung,dw-mshc-ddr-timing = <1 2 3>;
+
+		slot0 {
+			bus-width = <8>;
+			cd-gpios = <&gpc0 2 2 3 3>;
+			gpios = <&gpc0 0 2 0 3>, <&gpc0 1 2 0 3>,
+				<&gpc1 0 2 3 3>, <&gpc1 1 2 3 3>,
+				<&gpc1 2 2 3 3>, <&gpc1 3 2 3 3>,
+				<&gpc0 3 2 3 3>, <&gpc0 4 2 3 3>,
+				<&gpc0 5 2 3 3>, <&gpc0 6 2 3 3>;
+		};
+	};
+
+	dwmmc1@12210000 {
+		status = "disabled";
+	};
+
+	dwmmc2@12220000 {
+		supports-highspeed;
+		card-detection-broken;
+		no-write-protect;
+		fifo-depth = <0x80>;
+		card-detect-delay = <200>;
+		samsung,dw-mshc-sdr-timing = <2 3 3>;
+		samsung,dw-mshc-ddr-timing = <1 2 3>;
+
+		slot0 {
+			bus-width = <4>;
+			cd-gpios = <&gpc3 2 2 3 3>;
+			gpios = <&gpc3 0 2 0 3>, <&gpc3 1 2 0 3>,
+				<&gpc3 3 2 3 3>, <&gpc3 4 2 3 3>,
+				<&gpc3 5 2 3 3>, <&gpc3 6 2 3 3>,
+				<&gpc4 3 3 3 3>, <&gpc4 3 3 3 3>,
+				<&gpc4 5 3 3 3>, <&gpc4 6 3 3 3>;
+		};
+	};
+
+	dwmmc3@12230000 {
+		status = "disabled";
+	};
 };
diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index af124917..345e0bb 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -169,6 +169,30 @@
 		interrupts = <0 63 0>;
 	};
 
+	dwmmc0@12200000 {
+		compatible = "synopsis,dw-mshc-exynos5250";
+		reg = <0x12200000 0x1000>;
+		interrupts = <0 75 0>;
+	};
+
+	dwmmc1@12210000 {
+		compatible = "synopsis,dw-mshc-exynos5250";
+		reg = <0x12210000 0x1000>;
+		interrupts = <0 76 0>;
+	};
+
+	dwmmc2@12220000 {
+		compatible = "synopsis,dw-mshc-exynos5250";
+		reg = <0x12220000 0x1000>;
+		interrupts = <0 77 0>;
+	};
+
+	dwmmc3@12230000 {
+		compatible = "synopsis,dw-mshc-exynos5250";
+		reg = <0x12230000 0x1000>;
+		interrupts = <0 78 0>;
+	};
+
 	amba {
 		#address-cells = <1>;
 		#size-cells = <1>;
-- 
1.7.5.4

