Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945Ab2JSF7C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 01:59:02 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12934 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab2JSF7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 01:59:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 18 Oct 2012 22:58:50 -0700
From: Mark Zhang <markz@nvidia.com>
To: <swarren@wwwdotorg.org>, <linux@arm.linux.org.uk>
CC: <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Mark Zhang <markz@nvidia.com>
Subject: [PATCH] ARM: dt: tegra: ventana: define pinmux for ddc
Date: Fri, 19 Oct 2012 13:58:31 +0800
Message-ID: <1350626311-18131-1-git-send-email-markz@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define pinmux for DDC. The DDC pinmux in Ventana is 2 pins in I2C2.

Signed-off-by: Mark Zhang <markz@nvidia.com>
---
 arch/arm/boot/dts/tegra20-ventana.dts |   70 ++++++++++++++++++++++++++++++---
 1 file changed, 65 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20-ventana.dts b/arch/arm/boot/dts/tegra20-ventana.dts
index bec8bb2..b6b3af4 100644
--- a/arch/arm/boot/dts/tegra20-ventana.dts
+++ b/arch/arm/boot/dts/tegra20-ventana.dts
@@ -64,11 +64,6 @@
 				nvidia,pins = "dap4";
 				nvidia,function = "dap4";
 			};
-			ddc {
-				nvidia,pins = "ddc", "owc", "spdi", "spdo",
-					"uac";
-				nvidia,function = "rsvd2";
-			};
 			dta {
 				nvidia,pins = "dta", "dtb", "dtc", "dtd", "dte";
 				nvidia,function = "vi";
@@ -248,6 +243,39 @@
 				nvidia,slew-rate-falling = <3>;
 			};
 		};
+
+		state_i2cmux_ddc: pinmux_i2cmux_ddc {
+			ddc {
+				nvidia,pins = "ddc";
+				nvidia,function = "i2c2";
+			};
+			pta {
+				nvidia,pins = "pta";
+				nvidia,function = "rsvd4";
+			};
+		};
+
+		state_i2cmux_pta: pinmux_i2cmux_pta {
+			ddc {
+				nvidia,pins = "ddc";
+				nvidia,function = "rsvd4";
+			};
+			pta {
+				nvidia,pins = "pta";
+				nvidia,function = "i2c2";
+			};
+		};
+
+		state_i2cmux_idle: pinmux_i2cmux_idle {
+			ddc {
+				nvidia,pins = "ddc";
+				nvidia,function = "rsvd4";
+			};
+			pta {
+				nvidia,pins = "pta";
+				nvidia,function = "rsvd4";
+			};
+		};
 	};
 
 	i2s@70002800 {
@@ -291,6 +319,38 @@
 		clock-frequency = <400000>;
 	};
 
+	i2cmux {
+		compatible = "i2c-mux-pinctrl";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		i2c-parent = <&{/i2c@7000c400}>;
+
+		pinctrl-names = "ddc", "pta", "idle";
+		pinctrl-0 = <&state_i2cmux_ddc>;
+		pinctrl-1 = <&state_i2cmux_pta>;
+		pinctrl-2 = <&state_i2cmux_idle>;
+
+		i2c@0 {
+			reg = <0>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		i2c@1 {
+			reg = <1>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			smart-battery@b {
+				compatible = "ti,bq24617", "smart-battery-1.1";
+				reg = <0xb>;
+				ti,i2c-retry-count = <2>;
+				ti,poll-retry-count = <10>;
+			};
+		};
+	};
+
 	i2c@7000c500 {
 		status = "okay";
 		clock-frequency = <400000>;
-- 
1.7.9.5

