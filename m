Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab2KTRXN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 12:23:13 -0500
Received: from mail-yh0-f74.google.com ([209.85.213.74]:40065 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab2KTRXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 12:23:10 -0500
From: Doug Anderson <dianders@chromium.org>
To: linux-samsung-soc@vger.kernel.org
Cc: Olof Johansson <olofj@chromium.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        Russell King <linux@arm.linux.org.uk>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Arun Kumar K <arun.kk@samsung.com>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ARM: dts: exynos: Move the dwmmc aliases from smdk5250 dts to exynos
Date: Tue, 20 Nov 2012 09:22:30 -0800
Message-Id: <1353432158-22999-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The aliases for dwmmc were placed in the SMDK5250 dts file but really
should be common for all exynos5250 boards.  Move it to the common CPU
file.

Signed-off-by: Doug Anderson <dianders@chromium.org>

---
 arch/arm/boot/dts/exynos5250-smdk5250.dts |   12 ++++--------
 arch/arm/boot/dts/exynos5250.dtsi         |   12 ++++++++----
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
index 405009c..541fe39 100644
--- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
+++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
@@ -17,10 +17,6 @@
 	compatible = "samsung,smdk5250", "samsung,exynos5250";
 
 	aliases {
-		mshc0 = &dwmmc_0;
-		mshc1 = &dwmmc_1;
-		mshc2 = &dwmmc_2;
-		mshc3 = &dwmmc_3;
 	};
 
 	memory {
@@ -97,7 +93,7 @@
 		};
 	};
 
-	dwmmc_0: dwmmc0@12200000 {
+	dwmmc0@12200000 {
 		num-slots = <1>;
 		supports-highspeed;
 		broken-cd;
@@ -118,11 +114,11 @@
 		};
 	};
 
-	dwmmc_1: dwmmc1@12210000 {
+	dwmmc1@12210000 {
 		status = "disabled";
 	};
 
-	dwmmc_2: dwmmc2@12220000 {
+	dwmmc2@12220000 {
 		num-slots = <1>;
 		supports-highspeed;
 		fifo-depth = <0x80>;
@@ -143,7 +139,7 @@
 		};
 	};
 
-	dwmmc_3: dwmmc3@12230000 {
+	dwmmc3@12230000 {
 		status = "disabled";
 	};
 
diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index cf6a02d..7c5664b 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -31,6 +31,10 @@
 		gsc1 = &gsc_1;
 		gsc2 = &gsc_2;
 		gsc3 = &gsc_3;
+		mshc0 = &dwmmc_0;
+		mshc1 = &dwmmc_1;
+		mshc2 = &dwmmc_2;
+		mshc3 = &dwmmc_3;
 	};
 
 	gic:interrupt-controller@10481000 {
@@ -206,7 +210,7 @@
 		#size-cells = <0>;
 	};
 
-	dwmmc0@12200000 {
+	dwmmc_0: dwmmc0@12200000 {
 		compatible = "samsung,exynos5250-dw-mshc";
 		reg = <0x12200000 0x1000>;
 		interrupts = <0 75 0>;
@@ -214,7 +218,7 @@
 		#size-cells = <0>;
 	};
 
-	dwmmc1@12210000 {
+	dwmmc_1: dwmmc1@12210000 {
 		compatible = "samsung,exynos5250-dw-mshc";
 		reg = <0x12210000 0x1000>;
 		interrupts = <0 76 0>;
@@ -222,7 +226,7 @@
 		#size-cells = <0>;
 	};
 
-	dwmmc2@12220000 {
+	dwmmc_2: dwmmc2@12220000 {
 		compatible = "samsung,exynos5250-dw-mshc";
 		reg = <0x12220000 0x1000>;
 		interrupts = <0 77 0>;
@@ -230,7 +234,7 @@
 		#size-cells = <0>;
 	};
 
-	dwmmc3@12230000 {
+	dwmmc_3: dwmmc3@12230000 {
 		compatible = "samsung,exynos5250-dw-mshc";
 		reg = <0x12230000 0x1000>;
 		interrupts = <0 78 0>;
-- 
1.7.7.3

