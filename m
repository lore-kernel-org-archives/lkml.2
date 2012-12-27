Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab2L0Ouu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 09:50:50 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9130 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab2L0OsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 09:48:15 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 27 Dec 2012 06:48:09 -0800
From: Prashant Gaikwad <pgaikwad@nvidia.com>
To: <swarren@wwwdotorg.org>, <mturquette@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, Stephen Warren <swarren@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: [PATCH v2 03/11] ARM: tegra: Define Tegra20 CAR binding
Date: Thu, 27 Dec 2012 20:17:16 +0530
Message-ID: <1356619644-18565-4-git-send-email-pgaikwad@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1356619644-18565-1-git-send-email-pgaikwad@nvidia.com>
References: <1356619644-18565-1-git-send-email-pgaikwad@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

The Tegra20 CAR (Clock And Reset) Controller controls most aspects of
most clocks within Tegra20. The device tree binding models this as a
single monolithic clock provider, which exports many clocks. This reduces
the number of nodes needed in device tree to represent these clocks.

This binding is only useful for Tegra20; the set of clocks that exists on
Tegra30 is sufficiently different to merit its own binding.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Simon Glass <sjg@chromium.org>
[pgaikwad: Added mux clk ids and sorted CAR node]
Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
---
 .../bindings/clock/nvidia,tegra20-car.txt          |  209 ++++++++++++++++++++
 arch/arm/boot/dts/tegra20.dtsi                     |    6 +
 2 files changed, 215 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/nvidia,tegra20-car.txt

diff --git a/Documentation/devicetree/bindings/clock/nvidia,tegra20-car.txt b/Documentation/devicetree/bindings/clock/nvidia,tegra20-car.txt
new file mode 100644
index 0000000..dc9f2bf
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/nvidia,tegra20-car.txt
@@ -0,0 +1,209 @@
+NVIDIA Tegra20 Clock And Reset Controller
+
+This binding uses the common clock binding:
+Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+The CAR (Clock And Reset) Controller on Tegra is the HW module responsible
+for muxing and gating Tegra's clocks, and setting their rates.
+
+Required properties :
+- compatible : Should be "nvidia,tegra20-car"
+- reg : Should contain CAR registers location and length
+- clocks : Should contain phandle and clock specifiers for two clocks:
+  the 32 KHz "32k_in", and the board-specific oscillator "osc".
+- #clock-cells : Should be 1.
+  In clock consumers, this cell represents the clock ID exposed by the CAR.
+
+  The first 96 clocks are numbered to match the bits in the CAR's CLK_OUT_ENB
+  registers. These IDs often match those in the CAR's RST_DEVICES registers,
+  but not in all cases. Some bits in CLK_OUT_ENB affect multiple clocks. In
+  this case, those clocks are assigned IDs above 95 in order to highlight
+  this issue. Implementations that interpret these clock IDs as bit values
+  within the CLK_OUT_ENB or RST_DEVICES registers should be careful to
+  explicitly handle these special cases.
+
+  The balance of the clocks controlled by the CAR are assigned IDs of 96 and
+  above.
+
+  0	cpu
+  1	unassigned
+  2	unassigned
+  3	ac97
+  4	rtc
+  5	tmr
+  6	uart1
+  7	unassigned	(register bit affects uart2 and vfir)
+  8	gpio
+  9	sdmmc2
+  10	unassigned	(register bit affects spdif_in and spdif_out)
+  11	i2s1
+  12	i2c1
+  13	ndflash
+  14	sdmmc1
+  15	sdmmc4
+  16	twc
+  17	pwm
+  18	i2s2
+  19	epp
+  20	unassigned	(register bit affects vi and vi_sensor)
+  21	2d
+  22	usbd
+  23	isp
+  24	3d
+  25	ide
+  26	disp2
+  27	disp1
+  28	host1x
+  29	vcp
+  30	unassigned
+  31	cache2
+
+  32	mem
+  33	ahbdma
+  34	apbdma
+  35	unassigned
+  36	kbc
+  37	stat_mon
+  38	pmc
+  39	fuse
+  40	kfuse
+  41	sbc1
+  42	snor
+  43	spi1
+  44	sbc2
+  45	xio
+  46	sbc3
+  47	dvc
+  48	dsi
+  49	unassigned	(register bit affects tvo and cve)
+  50	mipi
+  51	hdmi
+  52	csi
+  53	tvdac
+  54	i2c2
+  55	uart3
+  56	unassigned
+  57	emc
+  58	usb2
+  59	usb3
+  60	mpe
+  61	vde
+  62	bsea
+  63	bsev
+
+  64	speedo
+  65	uart4
+  66	uart5
+  67	i2c3
+  68	sbc4
+  69	sdmmc3
+  70	pcie
+  71	owr
+  72	afi
+  73	csite
+  74	unassigned
+  75	avpucq
+  76	la
+  77	unassigned
+  78	unassigned
+  79	unassigned
+  80	unassigned
+  81	unassigned
+  82	unassigned
+  83	unassigned
+  84	irama
+  85	iramb
+  86	iramc
+  87	iramd
+  88	cram2
+  89	audio_2x	a/k/a audio_2x_sync_clk
+  90	clk_d
+  91	unassigned
+  92	sus
+  93	cdev1
+  94	cdev2
+  95	unassigned
+
+  96	uart2
+  97	vfir
+  98	spdif_in
+  99	spdif_out
+  100	vi
+  101	vi_sensor
+  102	tvo
+  103	cve
+  104	osc
+  105	clk_32k		a/k/a clk_s
+  106	clk_m
+  107	sclk
+  108	cclk
+  109	hclk
+  110	pclk
+  111	blink
+  112	pll_a
+  113	pll_a_out0
+  114	pll_c
+  115	pll_c_out1
+  116	pll_d
+  117	pll_d_out0
+  118	pll_e
+  119	pll_m
+  120	pll_m_out1
+  121	pll_p
+  122	pll_p_out1
+  123	pll_p_out2
+  124	pll_p_out3
+  125	pll_p_out4
+  126	pll_s
+  127	pll_u
+  128	pll_x
+  129	cop		a/k/a avp
+  130	audio		a/k/a audio_sync_clk
+  131	pll_ref
+  132	twd
+
+Mux clocks
+
+  200	audio_mux
+
+Example SoC include file:
+
+/ {
+	tegra_car: clock {
+		compatible = "nvidia,tegra20-car";
+		reg = <0x60006000 0x1000>;
+		#clock-cells = <1>;
+	};
+
+	usb@c5004000 {
+		clocks = <&tegra_car 58>; /* usb2 */
+	};
+};
+
+Example board file:
+
+/ {
+	clocks {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		osc: clock@0 {
+			compatible = "fixed-clock";
+			reg = <0>;
+			#clock-cells = <0>;
+			clock-frequency = <12000000>;
+		};
+
+		clk_32k: clock@1 {
+			compatible = "fixed-clock";
+			reg = <1>;
+			#clock-cells = <0>;
+			clock-frequency = <32768>;
+		};
+	};
+
+	&tegra_car {
+		clocks = <&clk_32k> <&osc>;
+	};
+};
diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index b8effa1..5b104f1 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -123,6 +123,12 @@
 			      0 42 0x04>;
 	};
 
+	tegra_car: clock {
+		compatible = "nvidia,tegra20-car";
+		reg = <0x60006000 0x1000>;
+		#clock-cells = <1>;
+	};
+
 	apbdma: dma {
 		compatible = "nvidia,tegra20-apbdma";
 		reg = <0x6000a000 0x1200>;
-- 
1.7.4.1

