Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750995Ab2KPFB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 00:01:27 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16485 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab2KPFBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 00:01:25 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 15 Nov 2012 21:01:23 -0800
From: Mark Zhang <markz@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux-tegra@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Mark Zhang <markz@nvidia.com>
Subject: [PATCH] ARM: dt: tegra: cardhu: Add drm components
Date: Fri, 16 Nov 2012 13:00:45 +0800
Message-ID: <1353042045-3182-1-git-send-email-markz@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the rgb and hdmi nodes which are necessary for
tegra drm driver.

Signed-off-by: Mark Zhang <markz@nvidia.com>
---
 arch/arm/boot/dts/tegra30-cardhu.dtsi |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi b/arch/arm/boot/dts/tegra30-cardhu.dtsi
index bdb2a66..9af6987 100644
--- a/arch/arm/boot/dts/tegra30-cardhu.dtsi
+++ b/arch/arm/boot/dts/tegra30-cardhu.dtsi
@@ -27,6 +27,25 @@
 	model = "NVIDIA Tegra30 Cardhu evaluation board";
 	compatible = "nvidia,cardhu", "nvidia,tegra30";
 
+	host1x {
+		dc@54200000 {
+			rgb {
+				status = "okay";
+				nvidia,ddc-i2c-bus = <&rgbddc>;
+			};
+		};
+
+		hdmi {
+			status = "okay";
+
+			vdd-supply = <&sys_3v3_reg>;
+			pll-supply = <&vio_reg>;
+
+			nvidia,hpd-gpio = <&gpio 111 0>; /* PN7 */
+			nvidia,ddc-i2c-bus = <&hdmiddc>;
+		};
+	};
+
 	memory {
 		reg = <0x80000000 0x40000000>;
 	};
@@ -114,7 +133,7 @@
 		clock-frequency = <408000000>;
 	};
 
-	i2c@7000c000 {
+	rgbddc: i2c@7000c000 {
 		status = "okay";
 		clock-frequency = <100000>;
 	};
@@ -137,7 +156,7 @@
 		};
 	};
 
-	i2c@7000c700 {
+	hdmiddc: i2c@7000c700 {
 		status = "okay";
 		clock-frequency = <100000>;
 	};
-- 
1.7.9.5

