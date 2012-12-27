Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab2L0OsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 09:48:22 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9132 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab2L0OsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 09:48:17 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 27 Dec 2012 06:48:13 -0800
From: Prashant Gaikwad <pgaikwad@nvidia.com>
To: <swarren@wwwdotorg.org>, <mturquette@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: [PATCH v2 04/11] ARM: Tegra: Define Tegra30 CAR binding
Date: Thu, 27 Dec 2012 20:17:17 +0530
Message-ID: <1356619644-18565-5-git-send-email-pgaikwad@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1356619644-18565-1-git-send-email-pgaikwad@nvidia.com>
References: <1356619644-18565-1-git-send-email-pgaikwad@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device tree binding models Tegra30 CAR (Clock And Reset)
as a single monolithic clock provider.

Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
---
 .../bindings/clock/nvidia,tegra30-car.txt          |  282 ++++++++++++++++++++
 arch/arm/boot/dts/tegra30.dtsi                     |    6 +
 2 files changed, 288 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/nvidia,tegra30-car.txt

diff --git a/Documentation/devicetree/bindings/clock/nvidia,tegra30-car.txt b/Documentation/devicetree/bindings/clock/nvidia,tegra30-car.txt
new file mode 100644
index 0000000..6740760
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/nvidia,tegra30-car.txt
@@ -0,0 +1,282 @@
+NVIDIA Tegra30 Clock And Reset Controller
+
+This binding uses the common clock binding:
+Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+The CAR (Clock And Reset) Controller on Tegra is the HW module responsible
+for muxing and gating Tegra's clocks, and setting their rates.
+
+Required properties :
+- compatible : Should be "nvidia,tegra30-car"
+- reg : Should contain CAR registers location and length
+- clocks : Should contain phandle and clock specifiers for two clocks:
+  the 32 KHz "32k_in", and the board-specific oscillator "osc".
+- #clock-cells : Should be 1.
+  In clock consumers, this cell represents the clock ID exposed by the CAR.
+
+  The first 130 clocks are numbered to match the bits in the CAR's CLK_OUT_ENB
+  registers. These IDs often match those in the CAR's RST_DEVICES registers,
+  but not in all cases. Some bits in CLK_OUT_ENB affect multiple clocks. In
+  this case, those clocks are assigned IDs above 160 in order to highlight
+  this issue. Implementations that interpret these clock IDs as bit values
+  within the CLK_OUT_ENB or RST_DEVICES registers should be careful to
+  explicitly handle these special cases.
+
+  The balance of the clocks controlled by the CAR are assigned IDs of 160 and
+  above.
+
+  0	cpu
+  1	unassigned
+  2	unassigned
+  3	unassigned
+  4	rtc
+  5	timer
+  6	uarta
+  7	unassigned	(register bit affects uartb and vfir)
+  8	gpio
+  9	sdmmc2
+  10	unassigned	(register bit affects spdif_in and spdif_out)
+  11	i2s1
+  12	i2c1
+  13	ndflash
+  14	sdmmc1
+  15	sdmmc4
+  16	unassigned
+  17	pwm
+  18	i2s2
+  19	epp
+  20	unassigned	(register bit affects vi and vi_sensor)
+  21	2d
+  22	usbd
+  23	isp
+  24	3d
+  25	unassigned
+  26	disp2
+  27	disp1
+  28	host1x
+  29	vcp
+  30	i2s0
+  31	cop_cache
+
+  32	mc
+  33	ahbdma
+  34	apbdma
+  35	unassigned
+  36	kbc
+  37	statmon
+  38	pmc
+  39	unassigned	(register bit affects fuse and fuse_burn)
+  40	kfuse
+  41	sbc1
+  42	nor
+  43	unassigned
+  44	sbc2
+  45	unassigned
+  46	sbc3
+  47	i2c5
+  48	dsia
+  49	unassigned	(register bit affects cve and tvo)
+  50	mipi
+  51	hdmi
+  52	csi
+  53	tvdac
+  54	i2c2
+  55	uartc
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
+  65	uartd
+  66	uarte
+  67	i2c3
+  68	sbc4
+  69	sdmmc3
+  70	pcie
+  71	owr
+  72	afi
+  73	csite
+  74	pciex
+  75	avpucq
+  76	la
+  77	unassigned
+  78	unassigned
+  79	dtv
+  80	ndspeed
+  81	i2cslow
+  82	dsib
+  83	unassigned
+  84	irama
+  85	iramb
+  86	iramc
+  87	iramd
+  88	cram2
+  89	unassigned
+  90	audio_2x	a/k/a audio_2x_sync_clk
+  91	unassigned
+  92	csus
+  93	cdev2
+  94	cdev1
+  95	unassigned
+
+  96	cpu_g
+  97	cpu_lp
+  98	3d2
+  99	mselect
+  100	tsensor
+  101	i2s3
+  102	i2s4
+  103	i2c4
+  104	sbc5
+  105	sbc6
+  106	d_audio
+  107	apbif
+  108	dam0
+  109	dam1
+  110	dam2
+  111	hda2codec_2x
+  112	atomics
+  113	audio0_2x
+  114	audio1_2x
+  115	audio2_2x
+  116	audio3_2x
+  117	audio4_2x
+  118	audio5_2x
+  119	actmon
+  120	extern1
+  121	extern2
+  122	extern3
+  123	sata_oob
+  124	sata
+  125	hda
+  127	se
+  128	hda2hdmi
+  129	sata_cold
+
+  160	uartb
+  161	vfir
+  162	spdif_in
+  163	spdif_out
+  164	vi
+  165	vi_sensor
+  166	fuse
+  167	fuse_burn
+  168	cve
+  169	tvo
+
+  170	clk_32k
+  171	clk_m
+  172	clk_m_div2
+  173	clk_m_div4
+  174	pll_ref
+  175	pll_c
+  176	pll_c_out1
+  177	pll_m
+  178	pll_m_out1
+  179	pll_p
+  180	pll_p_out1
+  181	pll_p_out2
+  182	pll_p_out3
+  183	pll_p_out4
+  184	pll_a
+  185	pll_a_out0
+  186	pll_d
+  187	pll_d_out0
+  188	pll_d2
+  189	pll_d2_out0
+  190	pll_u
+  191	pll_x
+  192	pll_x_out0
+  193	pll_e
+  194	spdif_in_sync
+  195	i2s0_sync
+  196	i2s1_sync
+  197	i2s2_sync
+  198	i2s3_sync
+  199	i2s4_sync
+  200	vimclk
+  201	audio0
+  202	audio1
+  203	audio2
+  204	audio3
+  205	audio4
+  206	audio5
+  207	clk_out_1 (extern1)
+  208	clk_out_2 (extern2)
+  209	clk_out_3 (extern3)
+  210	sclk
+  211	blink
+  212	cclk_g
+  213	cclk_lp
+  214	twd
+  215	cml0
+  216	cml1
+  217	i2cslow
+  218	i2c1_fast
+  219	i2c2_fast
+  220	i2c3_fast
+  221	i2c4_fast
+  222	i2c5_fast
+  223	dsi1_fast
+  224	dsi2_fast
+  225	hclk
+  226	pclk
+
+Mux clocks
+
+  300	audio0_mux
+  301	audio1_mux
+  302	audio2_mux
+  303	audio3_mux
+  304	audio4_mux
+  305	spdif_mux
+  306	clk_out_1_mux
+  307	clk_out_2_mux
+  308	clk_out_3_mux
+
+Example SoC include file:
+
+/ {
+	tegra_car: clock {
+		compatible = "nvidia,tegra30-car";
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
+		compatible = "simple-bug";
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
diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
index 529fdb8..6765646 100644
--- a/arch/arm/boot/dts/tegra30.dtsi
+++ b/arch/arm/boot/dts/tegra30.dtsi
@@ -125,6 +125,12 @@
 			      0 122 0x04>;
 	};
 
+	tegra_car: clock {
+		compatible = "nvidia,tegra30-car";
+		reg = <0x60006000 0x1000>;
+		#clock-cells = <1>;
+	};
+
 	apbdma: dma {
 		compatible = "nvidia,tegra30-apbdma", "nvidia,tegra20-apbdma";
 		reg = <0x6000a000 0x1400>;
-- 
1.7.4.1

