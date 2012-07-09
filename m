Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab2GIGHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 02:07:34 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11323 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab2GIGHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 02:07:30 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 08 Jul 2012 23:07:24 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [RFC][PATCH V2 3/3] tegra: add pwm backlight device tree nodes
Date: Mon, 9 Jul 2012 15:08:25 +0900
Message-ID: <1341814105-20690-4-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.7.11.1
In-Reply-To: <1341814105-20690-1-git-send-email-acourbot@nvidia.com>
References: <1341814105-20690-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 arch/arm/boot/dts/tegra20-ventana.dts | 31 +++++++++++++++++++++++++++++++
 arch/arm/boot/dts/tegra20.dtsi        |  2 +-
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra20-ventana.dts b/arch/arm/boot/dts/tegra20-ventana.dts
index be90544..c67d9e1 100644
--- a/arch/arm/boot/dts/tegra20-ventana.dts
+++ b/arch/arm/boot/dts/tegra20-ventana.dts
@@ -317,6 +317,37 @@
 		bus-width = <8>;
 	};
 
+	backlight {
+		compatible = "pwm-backlight";
+		brightness-levels = <0 16 32 48 64 80 96 112 128 144 160 176 192 208 224 240 255>;
+		default-brightness-level = <12>;
+
+		pwms = <&pwm 2 5000000>;
+		pwm-names = "backlight";
+		power-supply = <&backlight_reg>;
+		enable-gpios = <&gpio 28 0>;
+
+		power-on-sequence = "REGULATOR", "power", <1>,
+				    "DELAY", <10>,
+				    "PWM", "backlight", <1>,
+				    "GPIO", "enable", <1>;
+		power-off-sequence = "GPIO", "enable", <0>,
+				     "PWM", "backlight", <0>,
+				     "DELAY", <10>,
+				     "REGULATOR", "power", <0>;
+	};
+
+	backlight_reg: fixedregulator@176 {
+		compatible = "regulator-fixed";
+		regulator-name = "backlight_regulator";
+		regulator-min-microvolt = <1800000>;
+		regulator-max-microvolt = <1800000>;
+		gpio = <&gpio 176 0>;
+		startup-delay-us = <0>;
+		enable-active-high;
+		regulator-boot-off;
+	};
+
 	sound {
 		compatible = "nvidia,tegra-audio-wm8903-ventana",
 			     "nvidia,tegra-audio-wm8903";
diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index 405d167..67a6cd9 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -123,7 +123,7 @@
 		status = "disabled";
 	};
 
-	pwm {
+	pwm: pwm {
 		compatible = "nvidia,tegra20-pwm";
 		reg = <0x7000a000 0x100>;
 		#pwm-cells = <2>;
-- 
1.7.11.1

