Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab2KINUW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 08:20:22 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:60061 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab2KINUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 08:20:10 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ARM: tegra: Add Tegra30 host1x support
Date: Fri,  9 Nov 2012 14:20:02 +0100
Message-Id: <1352467202-27903-3-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352467202-27903-1-git-send-email-thierry.reding@avionic-design.de>
References: <1352467202-27903-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:FaPSp7WUrUkR+VVCIQJ7zLR4LYuarDWjhOcY/XIYsEI
 bTrYID/QvXW7SSagzJB13kMkhLwArtPDVdJ4iYc3GFATZi26ZD
 2JEHX1lfgtZR4YhGAqayaR7LvD0CDA+KVrWNDlHAgVjlQotXIK
 9lqUyEwUlPLjBV/JTEjtvKToBu78G8g/C2OzAAjd2K6BvwU/T2
 QhHs3c2f+BvPzAEuHtkKsgc4jpI+PuZelqpuL1Dzpk8Z1k2085
 nnC9Hks8pD9zyFtoyhSl32TT4QtUSbSeWdqbJeUk7nV/rGBENG
 ChOz4H02w7b8IUPnvPEkZrbgIT1FQE15QZIrelsTcnPfVl06Pf
 N5T0ccC+xmulJqDM3IpQ7feTD6kLSgzJNHKNxU+eW9EnFkZ/D4
 mA4XYToUgoU36pS/6EdL7k8gxCR37oxKOu4tl5PbNS4MQZZXwF
 oH47A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds the host1x node along with its children to the Tegra30
DTSI. Furthermore the OF auxiliary data table is updated to have proper
names assigned to the platform devices instantiated from the device
tree. Moreover, the clocks required by host1x and the two display
controllers are setup and initialized.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 arch/arm/boot/dts/tegra30.dtsi            | 87 +++++++++++++++++++++++++++++++
 arch/arm/mach-tegra/board-dt-tegra30.c    | 10 ++++
 arch/arm/mach-tegra/tegra30_clocks_data.c | 11 ++--
 3 files changed, 104 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
index b8e33c3..529fdb8 100644
--- a/arch/arm/boot/dts/tegra30.dtsi
+++ b/arch/arm/boot/dts/tegra30.dtsi
@@ -4,6 +4,93 @@
 	compatible = "nvidia,tegra30";
 	interrupt-parent = <&intc>;
 
+	host1x {
+		compatible = "nvidia,tegra30-host1x", "simple-bus";
+		reg = <0x50000000 0x00024000>;
+		interrupts = <0 65 0x04   /* mpcore syncpt */
+			      0 67 0x04>; /* mpcore general */
+
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		ranges = <0x54000000 0x54000000 0x04000000>;
+
+		mpe {
+			compatible = "nvidia,tegra30-mpe";
+			reg = <0x54040000 0x00040000>;
+			interrupts = <0 68 0x04>;
+		};
+
+		vi {
+			compatible = "nvidia,tegra30-vi";
+			reg = <0x54080000 0x00040000>;
+			interrupts = <0 69 0x04>;
+		};
+
+		epp {
+			compatible = "nvidia,tegra30-epp";
+			reg = <0x540c0000 0x00040000>;
+			interrupts = <0 70 0x04>;
+		};
+
+		isp {
+			compatible = "nvidia,tegra30-isp";
+			reg = <0x54100000 0x00040000>;
+			interrupts = <0 71 0x04>;
+		};
+
+		gr2d {
+			compatible = "nvidia,tegra30-gr2d";
+			reg = <0x54140000 0x00040000>;
+			interrupts = <0 72 0x04>;
+		};
+
+		gr3d {
+			compatible = "nvidia,tegra30-gr3d";
+			reg = <0x54180000 0x00040000>;
+		};
+
+		dc@54200000 {
+			compatible = "nvidia,tegra30-dc";
+			reg = <0x54200000 0x00040000>;
+			interrupts = <0 73 0x04>;
+
+			rgb {
+				status = "disabled";
+			};
+		};
+
+		dc@54240000 {
+			compatible = "nvidia,tegra30-dc";
+			reg = <0x54240000 0x00040000>;
+			interrupts = <0 74 0x04>;
+
+			rgb {
+				status = "disabled";
+			};
+		};
+
+		hdmi {
+			compatible = "nvidia,tegra30-hdmi";
+			reg = <0x54280000 0x00040000>;
+			interrupts = <0 75 0x04>;
+			status = "disabled";
+		};
+
+		tvo {
+			compatible = "nvidia,tegra30-tvo";
+			reg = <0x542c0000 0x00040000>;
+			interrupts = <0 76 0x04>;
+			status = "disabled";
+		};
+
+		dsi {
+			compatible = "nvidia,tegra30-dsi";
+			reg = <0x54300000 0x00040000>;
+			status = "disabled";
+		};
+	};
+
 	timer@50004600 {
 		compatible = "arm,cortex-a9-twd-timer";
 		reg = <0x50040600 0x20>;
diff --git a/arch/arm/mach-tegra/board-dt-tegra30.c b/arch/arm/mach-tegra/board-dt-tegra30.c
index cd30338..ff21107 100644
--- a/arch/arm/mach-tegra/board-dt-tegra30.c
+++ b/arch/arm/mach-tegra/board-dt-tegra30.c
@@ -57,6 +57,12 @@ struct of_dev_auxdata tegra30_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("nvidia,tegra30-slink", 0x7000DA00, "spi_tegra.3", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra30-slink", 0x7000DC00, "spi_tegra.4", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra30-slink", 0x7000DE00, "spi_tegra.5", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra30-host1x", 0x50000000, "tegra-host1x", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra30-dc", 0x54200000, "tegra-dc.0", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra30-dc", 0x54240000, "tegra-dc.1", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra30-hdmi", 0x54280000, "tegra-hdmi", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra30-dsi", 0x54300000, "tegra-dsi", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra30-tvo", 0x542c0000, "tegra-tvo", NULL),
 	{}
 };
 
@@ -82,6 +88,10 @@ static __initdata struct tegra_clk_init_table tegra_dt_clk_init_table[] = {
 	{ "sbc4",	"pll_p",	100000000,	false},
 	{ "sbc5",	"pll_p",	100000000,	false},
 	{ "sbc6",	"pll_p",	100000000,	false},
+	{ "host1x",	"pll_c",	144000000,	false},
+	{ "disp1",	"pll_p",	74000000,	false},
+	{ "disp2",	"pll_d2_out0",	148500000,	false},
+	{ "hdmi",	"pll_d2_out0",	148500000,	false},
 	{ NULL,		NULL,		0,		0},
 };
 
diff --git a/arch/arm/mach-tegra/tegra30_clocks_data.c b/arch/arm/mach-tegra/tegra30_clocks_data.c
index 7bc8b1d..210b8a4 100644
--- a/arch/arm/mach-tegra/tegra30_clocks_data.c
+++ b/arch/arm/mach-tegra/tegra30_clocks_data.c
@@ -1132,14 +1132,14 @@ PERIPH_CLK(2d,		"2d",			NULL,	21,	0x15c,	520000000, mux_pllm_pllc_pllp_plla,	MUX
 PERIPH_CLK(vi_sensor,	"tegra_camera",		"vi_sensor",	20,	0x1a8,	150000000, mux_pllm_pllc_pllp_plla,	MUX | DIV_U71 | PERIPH_NO_RESET);
 PERIPH_CLK(epp,		"epp",			NULL,	19,	0x16c,	520000000, mux_pllm_pllc_pllp_plla,	MUX | DIV_U71 | DIV_U71_INT);
 PERIPH_CLK(mpe,		"mpe",			NULL,	60,	0x170,	520000000, mux_pllm_pllc_pllp_plla,	MUX | DIV_U71 | DIV_U71_INT);
-PERIPH_CLK(host1x,	"host1x",		NULL,	28,	0x180,	260000000, mux_pllm_pllc_pllp_plla,	MUX | DIV_U71 | DIV_U71_INT);
+PERIPH_CLK(host1x,	"tegra-host1x",		NULL,	28,	0x180,	260000000, mux_pllm_pllc_pllp_plla,	MUX | DIV_U71 | DIV_U71_INT);
 PERIPH_CLK(cve,		"cve",			NULL,	49,	0x140,	250000000, mux_pllp_plld_pllc_clkm,	MUX | DIV_U71); /* requires min voltage */
 PERIPH_CLK(tvo,		"tvo",			NULL,	49,	0x188,	250000000, mux_pllp_plld_pllc_clkm,	MUX | DIV_U71); /* requires min voltage */
 PERIPH_CLK(dtv,		"dtv",			NULL,	79,	0x1dc,	250000000, mux_clk_m,			0);
-PERIPH_CLK(hdmi,	"hdmi",			NULL,	51,	0x18c,	148500000, mux_pllp_pllm_plld_plla_pllc_plld2_clkm,	MUX | MUX8 | DIV_U71);
+PERIPH_CLK(hdmi,	"tegra-hdmi",			NULL,	51,	0x18c,	148500000, mux_pllp_pllm_plld_plla_pllc_plld2_clkm,	MUX | MUX8 | DIV_U71);
 PERIPH_CLK(tvdac,	"tvdac",		NULL,	53,	0x194,	220000000, mux_pllp_plld_pllc_clkm,	MUX | DIV_U71); /* requires min voltage */
-PERIPH_CLK(disp1,	"tegradc.0",		NULL,	27,	0x138,	600000000, mux_pllp_pllm_plld_plla_pllc_plld2_clkm,	MUX | MUX8);
-PERIPH_CLK(disp2,	"tegradc.1",		NULL,	26,	0x13c,	600000000, mux_pllp_pllm_plld_plla_pllc_plld2_clkm,	MUX | MUX8);
+PERIPH_CLK(disp1,	"tegra-dc.0",		NULL,	27,	0x138,	600000000, mux_pllp_pllm_plld_plla_pllc_plld2_clkm,	MUX | MUX8);
+PERIPH_CLK(disp2,	"tegra-dc.1",		NULL,	26,	0x13c,	600000000, mux_pllp_pllm_plld_plla_pllc_plld2_clkm,	MUX | MUX8);
 PERIPH_CLK(usbd,	"fsl-tegra-udc",	NULL,	22,	0,	480000000, mux_clk_m,			0); /* requires min voltage */
 PERIPH_CLK(usb2,	"tegra-ehci.1",		NULL,	58,	0,	480000000, mux_clk_m,			0); /* requires min voltage */
 PERIPH_CLK(usb3,	"tegra-ehci.2",		NULL,	59,	0,	480000000, mux_clk_m,			0); /* requires min voltage */
@@ -1337,6 +1337,9 @@ struct clk_duplicate tegra_clk_duplicates[] = {
 	CLK_DUPLICATE("pll_p_out3", "tegra-i2c.2", "fast-clk"),
 	CLK_DUPLICATE("pll_p_out3", "tegra-i2c.3", "fast-clk"),
 	CLK_DUPLICATE("pll_p_out3", "tegra-i2c.4", "fast-clk"),
+	CLK_DUPLICATE("pll_p", "tegra-dc.0", "parent"),
+	CLK_DUPLICATE("pll_p", "tegra-dc.1", "parent"),
+	CLK_DUPLICATE("pll_d2_out0", "tegra-hdmi", "parent"),
 };
 
 struct clk *tegra_ptr_clks[] = {
-- 
1.8.0

