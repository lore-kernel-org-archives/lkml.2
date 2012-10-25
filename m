Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596Ab2JYGxO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 02:53:14 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18856 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab2JYGxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 02:53:13 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 24 Oct 2012 23:53:05 -0700
From: Mark Zhang <markz@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux@arm.linux.org.uk>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Mark Zhang <markz@nvidia.com>
Subject: [PATCH V2] ARM: dt: tegra: ventana: define pinmux for ddc
Date: Thu, 25 Oct 2012 14:52:30 +0800
Message-ID: <1351147951-19706-1-git-send-email-markz@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra 2's I2C2 controller can be routed to either the PTA
or DDC pin group on Ventana. So:
- Remove the HDMI function definition of pta pingroup
- Define child i2c adapters(ddc & pta) for I2C2 controller

Signed-off-by: Mark Zhang <markz@nvidia.com>
---
 arch/arm/boot/dts/tegra20-ventana.dts |   69 ++++++++++++++++++++++++++++++---
 1 file changed, 63 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20-ventana.dts b/arch/arm/boot/dts/tegra20-ventana.dts
index bec8bb2..1dde0d3 100644
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
@@ -98,7 +93,7 @@
 				nvidia,function = "pcie";
 			};
 			hdint {
-				nvidia,pins = "hdint", "pta";
+				nvidia,pins = "hdint";
 				nvidia,function = "hdmi";
 			};
 			i2cp {
@@ -129,6 +124,10 @@
 					"lspi", "lvp1", "lvs";
 				nvidia,function = "displaya";
 			};
+			owc {
+				nvidia,pins = "owc", "spdi", "spdo", "uac";
+				nvidia,function = "rsvd2";
+			};
 			pmc {
 				nvidia,pins = "pmc";
 				nvidia,function = "pwr_on";
@@ -248,6 +247,39 @@
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
@@ -291,6 +323,31 @@
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
+		};
+	};
+
 	i2c@7000c500 {
 		status = "okay";
 		clock-frequency = <400000>;
-- 
1.7.9.5

