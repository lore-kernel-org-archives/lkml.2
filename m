Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab2K3Foz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 00:44:55 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14403 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab2K3Fox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 00:44:53 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 29 Nov 2012 21:44:18 -0800
From: Mark Zhang <markz@nvidia.com>
To: <thierry.reding@avionic-design.de>, <swarren@wwwdotorg.org>,
        <linux@arm.linux.org.uk>
CC: <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Mark Zhang <markz@nvidia.com>
Subject: [PATCH] ARM: dt: tegra: cardhu: Add drm components
Date: Fri, 30 Nov 2012 13:44:16 +0800
Message-ID: <1354254256-10212-1-git-send-email-markz@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the RGB & HDMI nodes in Tegra 30 cardhu's dts.
This makes the LVDS & HDMI working.

Signed-off-by: Mark Zhang <markz@nvidia.com>
---
Changes:
- This patch depcrates the patch:
  "[PATCH V2] ARM: dt: tegra: cardhu: Add drm components"
  Because the issue that LCD and HDMI can't work at the same time
  has been fixed by Thierry's patch:
  "drm: tegra: Use framebuffer pitch as line stride"

 arch/arm/boot/dts/tegra30-cardhu.dtsi |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi b/arch/arm/boot/dts/tegra30-cardhu.dtsi
index bdb2a66..9b33bfb 100644
--- a/arch/arm/boot/dts/tegra30-cardhu.dtsi
+++ b/arch/arm/boot/dts/tegra30-cardhu.dtsi
@@ -27,6 +27,25 @@
 	model = "NVIDIA Tegra30 Cardhu evaluation board";
 	compatible = "nvidia,cardhu", "nvidia,tegra30";
 
+	host1x {
+		dc@54200000 {
+			rgb {
+				status = "okay";
+				nvidia,ddc-i2c-bus = <&rgb_ddc>;
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
+			nvidia,ddc-i2c-bus = <&hdmi_ddc>;
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
+	rgb_ddc: i2c@7000c000 {
 		status = "okay";
 		clock-frequency = <100000>;
 	};
@@ -137,7 +156,7 @@
 		};
 	};
 
-	i2c@7000c700 {
+	hdmi_ddc: i2c@7000c700 {
 		status = "okay";
 		clock-frequency = <100000>;
 	};
-- 
1.7.9.5

