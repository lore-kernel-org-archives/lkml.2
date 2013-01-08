Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab3AHIT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 03:19:59 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:60082 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754853Ab3AHIT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 03:19:56 -0500
From: "Kumar, Anil" <anilkumar.v@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
CC: <linux@arm.linux.org.uk>, <nsekhar@ti.com>, <khilman@ti.com>, <hs@denx.de>
Subject: [PATCH V2 3/3] ARM: davinci: da850: add NAND driver entries
Date: Tue, 8 Jan 2013 13:50:20 +0530
Message-ID: <1357633220-29827-4-git-send-email-anilkumar.v@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357633220-29827-1-git-send-email-anilkumar.v@ti.com>
References: <1357633220-29827-1-git-send-email-anilkumar.v@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add NAND driver entries to export NAND functionality on da850 EVM and
NAND pinctrl node to do pin mux according to pinctrl-single driver.

Signed-off-by: Kumar, Anil <anilkumar.v@ti.com>
---
:100644 100644 c7609d0... 382a7da... M	arch/arm/boot/dts/da850-evm.dts
:100644 100644 e9c6e82... 16e2ac2... M	arch/arm/boot/dts/da850.dtsi
 arch/arm/boot/dts/da850-evm.dts |   19 +++++++++++++++++++
 arch/arm/boot/dts/da850.dtsi    |   13 +++++++++++++
 2 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
index c7609d0..382a7da 100644
--- a/arch/arm/boot/dts/da850-evm.dts
+++ b/arch/arm/boot/dts/da850-evm.dts
@@ -28,4 +28,23 @@
 			status = "okay";
 		};
 	};
+	nand_cs3@62000000 {
+		status = "okay";
+	};
+};
+&pmx_core{
+	pinctrl-names = "default";
+	pinctrl-0 = <
+		&nand_cs3_pins
+	>;
+
+	nand_cs3_pins: pinmux_nand_pins {
+		pinctrl-single,bits = <
+			0x1c 0x00110000  0x00ff0000     /* EMA_OE, EMA_WE */
+			0x1c 0x00000110  0x00000ff0     /* EMA_CS[4],EMA_CS[3]*/
+			0x24 0x11111111  0xffffffff     /* EMA_D[0], EMA_D[1], EMA_D[2], EMA_D[3],
+							   EMA_D[4], EMA_D[5], EMA_D[6], EMA_D[7] */
+			0x30 0x01100000  0x0ff00000     /* EMA_A[1], EMA_A[2] */
+		>;
+	};
 };
diff --git a/arch/arm/boot/dts/da850.dtsi b/arch/arm/boot/dts/da850.dtsi
index e9c6e82..16e2ac2 100644
--- a/arch/arm/boot/dts/da850.dtsi
+++ b/arch/arm/boot/dts/da850.dtsi
@@ -67,4 +67,17 @@
 			status = "disabled";
 		};
 	};
+	nand_cs3@62000000 {
+		compatible = "ti,davinci-nand";
+		reg = <0x62000000 0x807ff
+			0x68000000 0x8000>;
+		ti,davinci-chipselect = <1>;
+		ti,davinci-mask-ale = <0>;
+		ti,davinci-mask-cle = <0>;
+		ti,davinci-mask-chipsel = <0>;
+		ti,davinci-ecc-mode = "hw";
+		ti,davinci-ecc-bits = <4>;
+		ti,davinci-nand-use-bbt;
+		status = "disabled";
+	};
 };
-- 
1.7.4.1

