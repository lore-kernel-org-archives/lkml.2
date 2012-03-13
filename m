Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336Ab2CMIpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 04:45:31 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:2234
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756113Ab2CMIpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 04:45:14 -0400
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzz8275dhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng <b29396@freescale.com>
To: <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: <s.hauer@pengutronix.de>, <shawn.guo@freescale.com>,
        <kernel@pengutronix.de>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <cjb@laptop.org>, <rdunlap@xenotime.net>,
        <vinod.koul@linux.intel.com>
Subject: [PATCH v1 1/5] ARM: imx28: add basic dt support
Date: Tue, 13 Mar 2012 16:47:04 +0800
Message-ID: <1331628428-24017-2-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1331628428-24017-1-git-send-email-b29396@freescale.com>
References: <1331628428-24017-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

This patch includes basic dt support which can boot via nfs rootfs.

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
 Documentation/devicetree/bindings/arm/fsl.txt |    4 +
 arch/arm/boot/dts/imx28-evk.dts               |   31 +++++++++
 arch/arm/boot/dts/imx28.dtsi                  |   88 +++++++++++++++++++++++++
 arch/arm/mach-mxs/Kconfig                     |    9 +++
 arch/arm/mach-mxs/Makefile                    |    1 +
 arch/arm/mach-mxs/imx28-dt.c                  |   67 +++++++++++++++++++
 6 files changed, 200 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/fsl.txt b/Documentation/devicetree/bindings/arm/fsl.txt
index 54bddda..9f21faf 100644
--- a/Documentation/devicetree/bindings/arm/fsl.txt
+++ b/Documentation/devicetree/bindings/arm/fsl.txt
@@ -1,6 +1,10 @@
 Freescale i.MX Platforms Device Tree Bindings
 -----------------------------------------------
 
+i.MX28 Evaluation Kit
+Required root node properties:
+    - compatible = "fsl,imx28-evk", "fsl,imx28";
+
 i.MX51 Babbage Board
 Required root node properties:
     - compatible = "fsl,imx51-babbage", "fsl,imx51";
diff --git a/arch/arm/boot/dts/imx28-evk.dts b/arch/arm/boot/dts/imx28-evk.dts
new file mode 100644
index 0000000..9758dc4
--- /dev/null
+++ b/arch/arm/boot/dts/imx28-evk.dts
@@ -0,0 +1,31 @@
+/*
+ * Copyright 2012 Freescale Semiconductor, Inc.
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+/dts-v1/;
+/include/ "imx28.dtsi"
+
+/ {
+	model = "Freescale i.MX28 Evaluation Kit";
+	compatible = "fsl,imx28-evk", "fsl,imx28";
+
+	memory {
+		device_type = "memory";
+		reg = <0x40000000 0x08000000>;
+	};
+
+	ahb@80080000 {
+		fec@800f0000 {
+			phy-mode = "rmii";
+			local-mac-address = [00 04 9F 01 7D 5B];
+			status = "okay";
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/imx28.dtsi b/arch/arm/boot/dts/imx28.dtsi
new file mode 100644
index 0000000..acf0dab
--- /dev/null
+++ b/arch/arm/boot/dts/imx28.dtsi
@@ -0,0 +1,88 @@
+/*
+ * Copyright 2012 Freescale Semiconductor, Inc.
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+/include/ "skeleton.dtsi"
+
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	interrupt-parent = <&icoll>;
+
+	aliases {
+		serial0 = &uart1;
+	};
+
+	cpus {
+		cpu@0 {
+			compatible = "arm,arm926ejs";
+		};
+	};
+
+	apb@80000000 {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		reg = <0x80000000 0x80000>;
+		ranges;
+
+		apbh@80000000 {
+			compatible = "simple-bus";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			reg = <0x80000000 0x3c900>;
+			ranges;
+
+			icoll: interrupt-controller@80000000 {
+				compatible = "fsl,imx28-icoll";
+				interrupt-controller;
+				#interrupt-cells = <1>;
+				reg = <0x80000000 0x2000>;
+			};
+		};
+
+		apbx@80040000 {
+			compatible = "simple-bus";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			reg = <0x80040000 0x40000>;
+			ranges;
+
+			uart1: uart@80074000 {
+				compatible = "arm,pl011", "arm,primecell";
+				reg = <0x80074000 0x2000>;
+				interrupts = <47>;
+			};
+		};
+	};
+
+	ahb@80080000 {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		reg = <0x80080000 0x80000>;
+		ranges;
+
+		fec@800f0000 {
+			compatible = "fsl,imx28-fec";
+			reg = <0x800f0000 0x4000>;
+			interrupts = <101>;
+			status = "disabled";
+		};
+
+		fec@800f4000 {
+			compatible = "fsl,imx28-fec";
+			reg = <0x800f4000 0x4000>;
+			interrupts = <102>;
+			status = "disabled";
+		};
+
+	};
+};
diff --git a/arch/arm/mach-mxs/Kconfig b/arch/arm/mach-mxs/Kconfig
index c57f996..6ab66af 100644
--- a/arch/arm/mach-mxs/Kconfig
+++ b/arch/arm/mach-mxs/Kconfig
@@ -17,6 +17,15 @@ config SOC_IMX28
 
 comment "MXS platforms:"
 
+config MACH_IMX28_DT
+	bool "Support i.MX28 platforms from device tree"
+	select SOC_IMX28
+	select USE_OF
+	select MACH_MX28EVK
+	help
+	  Include support for Freescale i.MX28 based platforms
+	  using the device tree for discovery
+
 config MACH_STMP378X_DEVB
 	bool "Support STMP378x_devb Platform"
 	select SOC_IMX23
diff --git a/arch/arm/mach-mxs/Makefile b/arch/arm/mach-mxs/Makefile
index 908bf9a..25a4122 100644
--- a/arch/arm/mach-mxs/Makefile
+++ b/arch/arm/mach-mxs/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_PM) += pm.o
 obj-$(CONFIG_SOC_IMX23) += clock-mx23.o
 obj-$(CONFIG_SOC_IMX28) += clock-mx28.o
 
+obj-$(CONFIG_MACH_IMX28_DT) += imx28-dt.o
 obj-$(CONFIG_MACH_STMP378X_DEVB) += mach-stmp378x_devb.o
 obj-$(CONFIG_MACH_MX23EVK) += mach-mx23evk.o
 obj-$(CONFIG_MACH_MX28EVK) += mach-mx28evk.o
diff --git a/arch/arm/mach-mxs/imx28-dt.c b/arch/arm/mach-mxs/imx28-dt.c
new file mode 100644
index 0000000..78d1129
--- /dev/null
+++ b/arch/arm/mach-mxs/imx28-dt.c
@@ -0,0 +1,67 @@
+/*
+ * Copyright 2011 Freescale Semiconductor, Inc.
+ * Copyright 2011 Linaro Ltd.
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+#include <linux/init.h>
+#include <linux/irqdomain.h>
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/time.h>
+#include <mach/common.h>
+#include <mach/mx28.h>
+
+static const struct of_dev_auxdata imx28_auxdata_lookup[] __initconst = {
+	OF_DEV_AUXDATA("arm,pl011", MX28_DUART_BASE_ADDR, "duart", NULL),
+	OF_DEV_AUXDATA("fsl,imx28-fec", MX28_ENET_MAC0_BASE_ADDR, "imx28-fec.0", NULL),
+	OF_DEV_AUXDATA("fsl,imx28-fec", MX28_ENET_MAC1_BASE_ADDR, "imx28-fec.1", NULL),
+	{ /* sentinel */ }
+};
+
+static void __init imx28_init(void)
+{
+	of_platform_populate(NULL, of_default_bus_match_table,
+			     imx28_auxdata_lookup, NULL);
+}
+
+static const struct of_device_id icoll_of_match[] __initconst = {
+	{ .compatible = "fsl,imx28-icoll", },
+	{},
+};
+
+static void __init imx28_dt_init_irq(void)
+{
+	irq_domain_generate_simple(icoll_of_match, MX28_ICOLL_BASE_ADDR, 0);
+	mx28_init_irq();
+}
+
+static void __init imx28_timer_init(void)
+{
+	mx28_clocks_init();
+}
+
+static struct sys_timer imx28_timer = {
+	.init = imx28_timer_init,
+};
+
+static const char *imx28_dt_compat[] __initdata = {
+	"fsl,imx28-evk",
+	NULL,
+};
+
+DT_MACHINE_START(IMX28, "Freescale i.MX28 (Device Tree)")
+	.map_io		= mx28_map_io,
+	.init_irq	= imx28_dt_init_irq,
+	.timer		= &imx28_timer,
+	.init_machine	= imx28_init,
+	.dt_compat	= imx28_dt_compat,
+	.restart	= mxs_restart,
+MACHINE_END
-- 
1.7.0.4


