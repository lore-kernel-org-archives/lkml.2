Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757847Ab1KQQYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 11:24:11 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6441 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab1KQQYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 11:24:09 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 17 Nov 2011 08:23:48 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH 01/10] arm/tegra: initial device tree for tegra30
Date: Thu, 17 Nov 2011 18:19:15 +0200
Message-ID: <1321546766-26770-2-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1321546766-26770-1-git-send-email-pdeschrijver@nvidia.com>
References: <1321546766-26770-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the initial device tree for tegra30

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 Documentation/devicetree/bindings/arm/tegra.txt |   18 +++
 arch/arm/boot/dts/tegra30.dtsi                  |  128 +++++++++++++++++++++++
 2 files changed, 146 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/tegra.txt
 create mode 100644 arch/arm/boot/dts/tegra30.dtsi

diff --git a/Documentation/devicetree/bindings/arm/tegra.txt b/Documentation/devicetree/bindings/arm/tegra.txt
new file mode 100644
index 0000000..0e696d2
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/tegra.txt
@@ -0,0 +1,18 @@
+NVIDIA Tegra platforms device tree bindings
+-------------------------------------------
+
+* harmony: tegra20 based development board
+Required root node properties:
+ - compatible = "nvidia,harmony", "nvidia,tegra20";
+
+* seaboard: tegra20 based clamshell reference design
+Required root node properties:
+ - compatible = "nvidia,seaboard", "nvidia,tegra20";
+
+* ventana: tegra20 based tablet reference design
+Required root node properties:
+ - compatible = "nvidia,ventana", "nvidia,tegra20";
+
+* cardhu: tegra30 based tablet reference design
+Required root node properties:
+ - compatible = "nvidia,cardhu", "nvidia,tegra30";
diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
new file mode 100644
index 0000000..85efb0c
--- /dev/null
+++ b/arch/arm/boot/dts/tegra30.dtsi
@@ -0,0 +1,128 @@
+/include/ "skeleton.dtsi"
+
+/ {
+	compatible = "nvidia,tegra30";
+	interrupt-parent = <&intc>;
+
+	intc: interrupt-controller@50041000 {
+		compatible = "arm,cortex-a9-gic";
+		interrupt-controller;
+		interrupt-parent;
+		#interrupt-cells = <3>;
+		reg = < 0x50041000 0x1000 >,
+		      < 0x50040100 0x0100 >;
+	};
+
+	i2c@7000c000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible =  "nvidia,tegra30-i2c", "nvidia,tegra20-i2c";
+		reg = <0x7000C000 0x100>;
+		interrupts = < 0 38 0x04 >;
+	};
+
+	i2c@7000c400 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "nvidia,tegra30-i2c", "nvidia,tegra20-i2c";
+		reg = <0x7000C400 0x100>;
+		interrupts = < 0 84 0x04 >;
+	};
+
+	i2c@7000c500 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "nvidia,tegra30-i2c", "nvidia,tegra20-i2c";
+		reg = <0x7000C500 0x100>;
+		interrupts = < 0 92 0x04 >;
+	};
+
+	i2c@7000c700 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "nvidia,tegra30-i2c", "nvidia,tegra20-i2c";
+		reg = <0x7000c700 0x100>;
+		interrupts = < 0 120 0x04 >;
+	};
+
+	i2c@7000d000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "nvidia,tegra30-i2c", "nvidia,tegra20-i2c";
+		reg = <0x7000D000 0x100>;
+		interrupts = < 0 53 0x04 >;
+	};
+
+	gpio: gpio@6000d000 {
+		compatible = "nvidia,tegra30-gpio", "nvidia,tegra20-gpio";
+		reg = < 0x6000d000 0x1000 >;
+		interrupts = < 0 32 0x04 0 33 0x04 0 34 0x04 0 35 0x04 0 55 0x04 0 87 0x04 0 89 0x04 >;
+		#gpio-cells = <2>;
+		gpio-controller;
+	};
+
+	serial@70006000 {
+		compatible = "nvidia,tegra30-uart", "nvidia,tegra20-uart";
+		reg = <0x70006000 0x40>;
+		reg-shift = <2>;
+		interrupts = < 0 36 0x04 >;
+	};
+
+	serial@70006040 {
+		compatible = "nvidia,tegra30-uart", "nvidia,tegra20-uart";
+		reg = <0x70006040 0x40>;
+		reg-shift = <2>;
+		interrupts = < 0 37 0x04 >;
+	};
+
+	serial@70006200 {
+		compatible = "nvidia,tegra30-uart", "nvidia,tegra20-uart";
+		reg = <0x70006200 0x100>;
+		reg-shift = <2>;
+		interrupts = < 0 46 0x04 >;
+	};
+
+	serial@70006300 {
+		compatible = "nvidia,tegra30-uart", "nvidia,tegra20-uart";
+		reg = <0x70006300 0x100>;
+		reg-shift = <2>;
+		interrupts = < 0 90 0x04 >;
+	};
+
+	serial@70006400 {
+		compatible = "nvidia,tegra30-uart", "nvidia,tegra20-uart";
+		reg = <0x70006400 0x100>;
+		reg-shift = <2>;
+		interrupts = < 0 91 0x04 >;
+	};
+
+	sdhci@78000000 {
+		compatible = "nvidia,tegra30-sdhci", "nvidia,tegra20-sdhci";
+		reg = <0x78000000 0x200>;
+		interrupts = < 0 14 0x04 >;
+	};
+
+	sdhci@78000200 {
+		compatible = "nvidia,tegra30-sdhci", "nvidia,tegra20-sdhci";
+		reg = <0x78000200 0x200>;
+		interrupts = < 0 15 0x04 >;
+	};
+
+	sdhci@78000400 {
+		compatible = "nvidia,tegra30-sdhci", "nvidia,tegra20-sdhci";
+		reg = <0x78000400 0x200>;
+		interrupts = < 0 19 0x04 >;
+	};
+
+	sdhci@78000600 {
+		compatible = "nvidia,tegra30-sdhci", "nvidia,tegra20-sdhci";
+		reg = <0x78000600 0x200>;
+		interrupts = < 0 31 0x04 >;
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

