Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab2KLU2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 15:28:53 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:42881 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217Ab2KLU2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 15:28:52 -0500
From: Philippe Reynes <tremyfr@yahoo.fr>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: s.hauer@pengutronix.de, julien.boibessot@armadeus.com,
        eric.jarrige@armadeus.org, Philippe Reynes <tremyfr@yahoo.fr>
Subject: [PATCH v4] Add device tree file for the armadeus apf27
Date: Mon, 12 Nov 2012 21:28:33 +0100
Message-Id: <1352752113-21978-1-git-send-email-tremyfr@yahoo.fr>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philippe Reynes <tremyfr@yahoo.fr>
Signed-off-by: Eric Jarrige <eric.jarrige@armadeus.org>
---

v4: update model to use the same format as apf28
    remove some empty line
v3: set 26M clock to 0 (not used)
v2: avoid enable again the watchdog

 arch/arm/boot/dts/imx27-apf27.dts |   89 +++++++++++++++++++++++++++++++++++++
 1 files changed, 89 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/boot/dts/imx27-apf27.dts

diff --git a/arch/arm/boot/dts/imx27-apf27.dts b/arch/arm/boot/dts/imx27-apf27.dts
new file mode 100644
index 0000000..c0327c0
--- /dev/null
+++ b/arch/arm/boot/dts/imx27-apf27.dts
@@ -0,0 +1,89 @@
+/*
+ * Copyright 2012 Philippe Reynes <tremyfr@yahoo.fr>
+ * Copyright 2012 Armadeus Systems <support@armadeus.com>
+ *
+ * Based on code which is: Copyright 2012 Sascha Hauer, Pengutronix
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
+/include/ "imx27.dtsi"
+
+/ {
+	model = "Armadeus Systems APF27 module";
+	compatible = "armadeus,imx27-apf27", "fsl,imx27";
+
+	memory {
+		reg = <0xa0000000 0x04000000>;
+	};
+
+	clocks {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		osc26m {
+			compatible = "fsl,imx-osc26m", "fixed-clock";
+			clock-frequency = <0>;
+		};
+	};
+
+	soc {
+		aipi@10000000 {
+			serial@1000a000 {
+				status = "okay";
+			};
+
+			ethernet@1002b000 {
+				status = "okay";
+			};
+		};
+
+		nand@d8000000 {
+			status = "okay";
+			nand-bus-width = <16>;
+			nand-ecc-mode = "hw";
+			nand-on-flash-bbt;
+
+			partition@0 {
+				label = "u-boot";
+				reg = <0x0 0x100000>;
+			};
+
+			partition@100000 {
+				label = "env";
+				reg = <0x100000 0x80000>;
+			};
+
+			partition@180000 {
+				label = "env2";
+				reg = <0x180000 0x80000>;
+			};
+
+			partition@200000 {
+				label = "firmware";
+				reg = <0x200000 0x80000>;
+			};
+
+			partition@280000 {
+				label = "dtb";
+				reg = <0x280000 0x80000>;
+			};
+
+			partition@300000 {
+				label = "kernel";
+				reg = <0x300000 0x500000>;
+			};
+
+			partition@800000 {
+				label = "rootfs";
+				reg = <0x800000 0xf800000>;
+			};
+		};
+	};
+};
-- 
1.7.4.4

