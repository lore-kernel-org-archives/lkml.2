Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab3AJKaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 05:30:13 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:33203 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab3AJKaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 05:30:10 -0500
From: "Kumar, Anil" <anilkumar.v@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
CC: <linux@arm.linux.org.uk>, <nsekhar@ti.com>, <khilman@ti.com>, <hs@denx.de>
Subject: [PATCH V3 3/3] ARM: davinci: da850: add NAND driver DT entries
Date: Thu, 10 Jan 2013 16:00:38 +0530
Message-ID: <1357813838-26511-4-git-send-email-anilkumar.v@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357813838-26511-1-git-send-email-anilkumar.v@ti.com>
References: <1357813838-26511-1-git-send-email-anilkumar.v@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add NAND driver DT node and related pinctrl DT data to export NAND
functionality on da850 evm.

Signed-off-by: Kumar, Anil <anilkumar.v@ti.com>
---
:100644 100644 c7609d0... 32ccecf... M	arch/arm/boot/dts/da850-evm.dts
:100644 100644 e9c6e82... 16e2ac2... M	arch/arm/boot/dts/da850.dtsi
 arch/arm/boot/dts/da850-evm.dts |   16 ++++++++++++++++
 arch/arm/boot/dts/da850.dtsi    |   13 +++++++++++++
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
index c7609d0..32ccecf 100644
--- a/arch/arm/boot/dts/da850-evm.dts
+++ b/arch/arm/boot/dts/da850-evm.dts
@@ -28,4 +28,20 @@
 			status = "okay";
 		};
 	};
+	nand_cs3@62000000 {
+		status = "okay";
+		pinctrl-names = "default";
+		pinctrl-0 = <&nand_cs3_pins>;
+	};
+};
+&pmx_core{
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

