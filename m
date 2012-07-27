Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab2G0MG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 08:06:27 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5726 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab2G0MGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 08:06:24 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 27 Jul 2012 05:06:20 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [RFC][PATCH v3 3/3] tegra: add pwm backlight device tree nodes
Date: Fri, 27 Jul 2012 21:05:50 +0900
Message-ID: <1343390750-3642-4-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1343390750-3642-1-git-send-email-acourbot@nvidia.com>
References: <1343390750-3642-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 arch/arm/boot/dts/tegra20-ventana.dts | 53 +++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/tegra20.dtsi        |  2 +-
 2 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra20-ventana.dts b/arch/arm/boot/dts/tegra20-ventana.dts
index be90544..6acdb6d 100644
--- a/arch/arm/boot/dts/tegra20-ventana.dts
+++ b/arch/arm/boot/dts/tegra20-ventana.dts
@@ -317,6 +317,59 @@
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
+		enable-gpio = <&gpio 28 0>;
+
+		power-on-sequence {
+			regulator@0 {
+				id = "power";
+				enable;
+				post-delay = <10>;
+			};
+			pwm@1 {
+				id = "backlight";
+				enable;
+			};
+			gpio@2 {
+				id = "enable-gpio";
+				enable;
+			};
+		};
+		power-off-sequence {
+			gpio@0 {
+				id = "enable-gpio";
+				disable;
+			};
+			pwm@1 {
+				id = "backlight";
+				disable;
+			};
+			regulator@2 {
+				id = "power";
+				disable;
+				pre-delay = <10>;
+			};
+		};
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
1.7.11.3

