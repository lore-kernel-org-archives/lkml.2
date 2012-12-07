Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932677Ab2LGA2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 19:28:49 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:49615 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932657Ab2LGA2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 19:28:47 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 3/3] ARM: tegra: paz00: enable HDMI port
Date: Thu,  6 Dec 2012 17:28:37 -0700
Message-Id: <1354840117-31264-4-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354840117-31264-1-git-send-email-swarren@wwwdotorg.org>
References: <1354840117-31264-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/boot/dts/tegra20-paz00.dts |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20-paz00.dts b/arch/arm/boot/dts/tegra20-paz00.dts
index 6a93d14..1062798 100644
--- a/arch/arm/boot/dts/tegra20-paz00.dts
+++ b/arch/arm/boot/dts/tegra20-paz00.dts
@@ -10,6 +10,18 @@
 		reg = <0x00000000 0x20000000>;
 	};
 
+	host1x {
+		hdmi {
+			status = "okay";
+
+			vdd-supply = <&hdmi_vdd_reg>;
+			pll-supply = <&hdmi_pll_reg>;
+
+			nvidia,ddc-i2c-bus = <&hdmi_ddc>;
+			nvidia,hpd-gpio = <&gpio 111 0>; /* PN7 */
+		};
+	};
+
 	pinmux {
 		pinctrl-names = "default";
 		pinctrl-0 = <&state_default>;
@@ -252,7 +264,7 @@
 		};
 	};
 
-	i2c@7000c400 {
+	hdmi_ddc: i2c@7000c400 {
 		status = "okay";
 		clock-frequency = <400000>;
 	};
@@ -367,13 +379,13 @@
 					regulator-max-microvolt = <1800000>;
 				};
 
-				ldo7 {
+				hdmi_vdd_reg: ldo7 {
 					regulator-name = "+3.3vs_ldo7,avdd_hdmi";
 					regulator-min-microvolt = <3300000>;
 					regulator-max-microvolt = <3300000>;
 				};
 
-				ldo8 {
+				hdmi_pll_reg: ldo8 {
 					regulator-name = "+1.8vs_ldo8,avdd_hdmi_pll";
 					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <1800000>;
-- 
1.7.10.4

