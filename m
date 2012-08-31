Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab2HaLdX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 07:33:23 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8827 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab2HaLdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 07:33:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 31 Aug 2012 04:32:52 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
CC: Leela Krishna Amudala <leelakrishna.a@gmail.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-pm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v5 4/4] tegra: ventana: add pwm backlight DT nodes
Date: Fri, 31 Aug 2012 20:34:06 +0900
Message-ID: <1346412846-17102-5-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346412846-17102-1-git-send-email-acourbot@nvidia.com>
References: <1346412846-17102-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 arch/arm/boot/dts/tegra20-ventana.dts | 59 ++++++++++++++++++++++++++++++++++-
 1 file changed, 58 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra20-ventana.dts b/arch/arm/boot/dts/tegra20-ventana.dts
index 4ec6b4c..025928d 100644
--- a/arch/arm/boot/dts/tegra20-ventana.dts
+++ b/arch/arm/boot/dts/tegra20-ventana.dts
@@ -467,6 +467,63 @@
 		bus-width = <8>;
 	};
 
+	backlight {
+		compatible = "pwm-backlight";
+		brightness-levels = <0 16 32 48 64 80 96 112 128 144 160 176 192 208 224 240 255>;
+		default-brightness-level = <12>;
+
+		/* resources used by the power sequences */
+		pwms = <&pwm 2 5000000>;
+		pwm-names = "backlight";
+		power-supply = <&vdd_bl_reg>;
+
+		power-sequences {
+			power-on {
+				step0 {
+					type = "regulator";
+					id = "power";
+					enable;
+				};
+				step1 {
+					type = "delay";
+					delay_us = <10000>;
+				};
+				step2 {
+					type = "pwm";
+					id = "backlight";
+					enable;
+				};
+				step3 {
+					type = "gpio";
+					number = <&gpio 28 0>;
+					enable;
+				};
+			};
+
+			power-off {
+				step0 {
+					type = "gpio";
+					number = <&gpio 28 0>;
+					disable;
+				};
+				step1 {
+					type = "pwm";
+					id = "backlight";
+					disable;
+				};
+				step2 {
+					type = "delay";
+					delay_us = <10000>;
+				};
+				step3 {
+					type = "regulator";
+					id = "power";
+					disable;
+				};
+			};
+		};
+	};
+
 	regulators {
 		compatible = "simple-bus";
 		#address-cells = <1>;
@@ -510,7 +567,7 @@
 			enable-active-high;
 		};
 
-		regulator@4 {
+		vdd_bl_reg: regulator@4 {
 			compatible = "regulator-fixed";
 			reg = <4>;
 			regulator-name = "vdd_bl";
-- 
1.7.12

