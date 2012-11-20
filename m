Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab2KTH2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 02:28:52 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7632 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab2KTH2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 02:28:51 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 19 Nov 2012 23:28:04 -0800
From: Mark Zhang <markz@nvidia.com>
To: <swarren@wwwdotorg.org>, <linux@arm.linux.org.uk>
CC: <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Mark Zhang <markz@nvidia.com>
Subject: [PATCH V2] ARM: dt: tegra: cardhu: Add drm components
Date: Tue, 20 Nov 2012 15:27:52 +0800
Message-ID: <1353396472-24167-1-git-send-email-markz@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the rgb node which is needed by
tegra drm driver.

Signed-off-by: Mark Zhang <markz@nvidia.com>
---
Changes in V2:
- Remove HDMI node in dts. Currently tegra drm driver doesn't 
  work while RGB and HDMI are enabled simultaneously

 arch/arm/boot/dts/tegra30-cardhu.dtsi |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi b/arch/arm/boot/dts/tegra30-cardhu.dtsi
index bdb2a66..20af79e 100644
--- a/arch/arm/boot/dts/tegra30-cardhu.dtsi
+++ b/arch/arm/boot/dts/tegra30-cardhu.dtsi
@@ -27,6 +27,15 @@
 	model = "NVIDIA Tegra30 Cardhu evaluation board";
 	compatible = "nvidia,cardhu", "nvidia,tegra30";
 
+	host1x {
+		dc@54200000 {
+			rgb {
+				status = "okay";
+				nvidia,ddc-i2c-bus = <&rgbddc>;
+			};
+		};
+	};
+
 	memory {
 		reg = <0x80000000 0x40000000>;
 	};
@@ -114,7 +123,7 @@
 		clock-frequency = <408000000>;
 	};
 
-	i2c@7000c000 {
+	rgbddc: i2c@7000c000 {
 		status = "okay";
 		clock-frequency = <100000>;
 	};
-- 
1.7.9.5

