Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935255Ab2JaJGM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 05:06:12 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6606 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161067Ab2JaJEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:04:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 31 Oct 2012 01:52:07 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>, <linux@arm.linux.org.uk>
CC: <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V4 3/4] ARM: tegra: dts: cardhu: enable SLINK4
Date: Wed, 31 Oct 2012 14:32:54 +0530
Message-ID: <1351674176-20603-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1351674176-20603-1-git-send-email-ldewangan@nvidia.com>
References: <1351674176-20603-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable SLINK4 and connected device in Tegra30 based
platform Cardhu.
Setting maximum spi frequency to 25MHz.

Spi serial flash is connected on CS1 of SLINK4 on
cardhu platform.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
- rename the max freq prop to spi-max-frequency

Changes from V2:
- make node name to spi@

Changes from V3:
- Add winbond spi flash as cs1 for slink4.
- Add winbond company name in vendor list.

 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 arch/arm/boot/dts/tegra30-cardhu.dtsi              |   10 ++++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 9de2b9f..ac2c2c4 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -51,4 +51,5 @@ ti	Texas Instruments
 via	VIA Technologies, Inc.
 wlf	Wolfson Microelectronics
 wm	Wondermedia Technologies, Inc.
+winbond Winbond Electronics corp.
 xlnx	Xilinx
diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi b/arch/arm/boot/dts/tegra30-cardhu.dtsi
index b245e6c..b4e0eda 100644
--- a/arch/arm/boot/dts/tegra30-cardhu.dtsi
+++ b/arch/arm/boot/dts/tegra30-cardhu.dtsi
@@ -275,6 +275,16 @@
 		};
 	};
 
+	spi@7000da00 {
+		status = "okay";
+		spi-max-frequency = <25000000>;
+		spi-flash@1 {
+			compatible = "winbond,w25q32";
+			spi-max-frequency = <20000000>;
+			reg = <1>;
+		};
+	};
+
 	ahub {
 		i2s@70080400 {
 			status = "okay";
-- 
1.7.1.1

