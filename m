Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560Ab1KGOVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 09:21:47 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18013 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab1KGOUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 09:20:42 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 07 Nov 2011 06:20:24 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH v3 1/8] arm/tegra: initial device tree for tegra30
Date: Mon, 7 Nov 2011 16:20:08 +0200
Message-ID: <1320675617-20751-2-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1320675617-20751-1-git-send-email-pdeschrijver@nvidia.com>
References: <1320675617-20751-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the initial device tree for tegra30

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/boot/dts/tegra30.dtsi |  127 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 127 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/boot/dts/tegra30.dtsi

diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
new file mode 100644
index 0000000..fabe243
--- /dev/null
+++ b/arch/arm/boot/dts/tegra30.dtsi
@@ -0,0 +1,127 @@
+/include/ "skeleton.dtsi"
+
+/ {
+	compatible = "nvidia,tegra30";
+	interrupt-parent = <&intc>;
+
+	intc: interrupt-controller@50041000 {
+		compatible = "nvidia,tegra30-gic", "nvidia,tegra20-gic";
+		interrupt-controller;
+		#interrupt-cells = <1>;
+		reg = < 0x50041000 0x1000 >,
+		      < 0x50040100 0x0100 >;
+	};
+
+	i2c@7000c000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible =  "nvidia,tegra30-i2c", "nvidia,tegra20-i2c";
+		reg = <0x7000C000 0x100>;
+		interrupts = < 70 >;
+	};
+
+	i2c@7000c400 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "nvidia,tegra30-i2c", "nvidia,tegra20-i2c";
+		reg = <0x7000C400 0x100>;
+		interrupts = < 116 >;
+	};
+
+	i2c@7000c500 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "nvidia,tegra30-i2c", "nvidia,tegra20-i2c";
+		reg = <0x7000C500 0x100>;
+		interrupts = < 124 >;
+	};
+
+	i2c@7000c700 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "nvidia,tegra30-i2c", "nvidia,tegra20-i2c";
+		reg = <0x7000c700 0x100>;
+		interrupts = < 152 >;
+	};
+
+	i2c@7000d000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "nvidia,tegra30-i2c", "nvidia,tegra20-i2c";
+		reg = <0x7000D000 0x100>;
+		interrupts = < 85 >;
+	};
+
+	gpio: gpio@6000d000 {
+		compatible = "nvidia,tegra30-gpio", "nvidia,tegra20-gpio";
+		reg = < 0x6000d000 0x1000 >;
+		interrupts = < 64 65 66 67 87 119 121 >;
+		#gpio-cells = <2>;
+		gpio-controller;
+	};
+
+	serial@70006000 {
+		compatible = "nvidia,tegra30-uart", "nvidia,tegra20-uart";
+		reg = <0x70006000 0x40>;
+		reg-shift = <2>;
+		interrupts = < 68 >;
+	};
+
+	serial@70006040 {
+		compatible = "nvidia,tegra30-uart", "nvidia,tegra20-uart";
+		reg = <0x70006040 0x40>;
+		reg-shift = <2>;
+		interrupts = < 69 >;
+	};
+
+	serial@70006200 {
+		compatible = "nvidia,tegra30-uart", "nvidia,tegra20-uart";
+		reg = <0x70006200 0x100>;
+		reg-shift = <2>;
+		interrupts = < 78 >;
+	};
+
+	serial@70006300 {
+		compatible = "nvidia,tegra30-uart", "nvidia,tegra20-uart";
+		reg = <0x70006300 0x100>;
+		reg-shift = <2>;
+		interrupts = < 122 >;
+	};
+
+	serial@70006400 {
+		compatible = "nvidia,tegra30-uart", "nvidia,tegra20-uart";
+		reg = <0x70006400 0x100>;
+		reg-shift = <2>;
+		interrupts = < 123 >;
+	};
+
+	sdhci@78000000 {
+		compatible = "nvidia,tegra30-sdhci", "nvidia,tegra20-sdhci";
+		reg = <0x78000000 0x200>;
+		interrupts = < 46 >;
+	};
+
+	sdhci@78000200 {
+		compatible = "nvidia,tegra30-sdhci", "nvidia,tegra20-sdhci";
+		reg = <0x78000200 0x200>;
+		interrupts = < 47 >;
+	};
+
+	sdhci@78000400 {
+		compatible = "nvidia,tegra30-sdhci", "nvidia,tegra20-sdhci";
+		reg = <0x78000400 0x200>;
+		interrupts = < 51 >;
+	};
+
+	sdhci@78000600 {
+		compatible = "nvidia,tegra30-sdhci", "nvidia,tegra20-sdhci";
+		reg = <0x78000600 0x200>;
+		interrupts = < 63 >;
+	};
+
+	pinmux: pinmux@70000000 {
+		compatible = "nvidia,tegra30-pinmux";
+		reg = < 0x70000868 0xd0     /* Pad control registers */
+			0x70003000 0x3e0 >; /* Mux registers */
+	};
+};
-- 
1.7.7.rc0.72.g4b5ea.dirty

