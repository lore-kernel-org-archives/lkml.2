Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965007Ab2JaLGx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 07:06:53 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48999 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933580Ab2JaLGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 07:06:48 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <b-cousson@ti.com>, <tony@atomide.com>
CC: <anilkumar@ti.com>, <rob.herring@calxeda.com>, <hvaibhav@ti.com>,
        <afzal@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>,
        "Philip, Avinash" <avinashphilip@ti.com>
Subject: [PATCH v3] ARM: dts: AM33xx: Add SPI node
Date: Wed, 31 Oct 2012 16:21:09 +0530
Message-ID: <1351680669-20718-1-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add McSPI data node to AM33XX device tree file. The McSPI module (and so
as the driver) is reused from OMAP4.

Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
Tested-by: Matt Porter <mporter@ti.com>
---
Changes since v2:
        - Commit message corrected.
	- Rebase on top of for_3.8/dts

Changes since v1:
        - Corrected reg offset in reg DT entry.

:100644 100644 97a7bd3... 6e04789... M	arch/arm/boot/dts/am33xx.dtsi
 arch/arm/boot/dts/am33xx.dtsi |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 97a7bd3..6e04789 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -299,5 +299,29 @@
 				      76>;
 			ti,hwmods = "rtc";
 		};
+
+		spi0: spi@48030000 {
+			compatible = "ti,omap4-mcspi";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0x48030000 0x400>;
+			interrupt-parent = <&intc>;
+			interrupt = <65>;
+			ti,spi-num-cs = <2>;
+			ti,hwmods = "spi0";
+			status = "disabled";
+		};
+
+		spi1: spi@481a0000 {
+			compatible = "ti,omap4-mcspi";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0x481a0000 0x400>;
+			interrupt-parent = <&intc>;
+			interrupt = <125>;
+			ti,spi-num-cs = <2>;
+			ti,hwmods = "spi1";
+			status = "disabled";
+		};
 	};
 };
-- 
1.7.0.4

