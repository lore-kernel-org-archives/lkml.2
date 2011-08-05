Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab1HEQZd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 12:25:33 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:14233 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546Ab1HEQZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 12:25:25 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [RFC PATCH 1/2] AT91: dt: at91sam9g45 family and board device tree files
Date: Fri,  5 Aug 2011 17:24:52 +0100
Message-Id: <56092075210001f40db485e0b126fe7c0c7b75ac.1312560476.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1312561493-7849-1-git-send-email-nicolas.ferre@atmel.com>
References: <1312561493-7849-1-git-send-email-nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a new device tree source file for Atmel at91sam9g45 SoC family.
The Evaluation Kit at91sam9m10g45ek includes it.
This first basic support will be populated as drivers and boards will be
converted to device tree.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/at91sam9g45.dtsi     |   27 +++++++++++++++++++++++++++
 arch/arm/boot/dts/at91sam9m10g45ek.dts |   15 +++++++++++++++
 2 files changed, 42 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/boot/dts/at91sam9g45.dtsi
 create mode 100644 arch/arm/boot/dts/at91sam9m10g45ek.dts

diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
new file mode 100644
index 0000000..3d85f96
--- /dev/null
+++ b/arch/arm/boot/dts/at91sam9g45.dtsi
@@ -0,0 +1,27 @@
+/include/ "skeleton.dtsi"
+
+/ {
+	model = "Atmel AT91SAM9G45 family SoC";
+	compatible = "atmel,at91sam9g45", "atmel,at91sam9m10", "atmel,at91sam9g46", "atmel,at91sam9m11";
+	interrupt-parent = <&aic>;
+
+	memory {
+		reg = <0x70000000 0x10000000>;
+	};
+
+	aic: interrupt-controller@fffff000 {
+		#interrupt-cells = <1>;
+		compatible = "atmel,aic";
+		interrupt-controller;
+		reg = <0xfffff000 0x200>;
+	};
+
+	dma@ffffec00 {
+		compatible = "atmel,at91sam9g45-hdmac";
+		reg = <0xffffec00 0x200>;
+		interrupts = <21>;
+		atmel,hdmac-nr-channels = <8>;
+		atmel,hdmac-cap-memcpy;
+		atmel,hdmac-cap-slave;
+	};
+};
diff --git a/arch/arm/boot/dts/at91sam9m10g45ek.dts b/arch/arm/boot/dts/at91sam9m10g45ek.dts
new file mode 100644
index 0000000..48252c9
--- /dev/null
+++ b/arch/arm/boot/dts/at91sam9m10g45ek.dts
@@ -0,0 +1,15 @@
+/dts-v1/;
+/include/ "at91sam9g45.dtsi"
+
+/ {
+	model = "Atmel AT91SAM9M10G45-EK";
+	compatible = "atmel,at91sam9m10g45ek", "atmel,at91sam9g45ekes", "atmel,at91sam9m10ekes", "atmel,at91sam9g45", "atmel,at91sam9m10", "atmel,at91sam9g46", "atmel,at91sam9m11", "atmel,at91";
+
+	chosen {
+		bootargs = "mem=64M console=ttyS0,115200 mtdparts=atmel_nand:4M(bootstrap/uboot/kernel)ro,60M(rootfs),-(data) root=/dev/mtdblock1 rw rootfstype=jffs2";
+	};
+
+	memory {
+		reg = <0x70000000 0x4000000>;
+	};
+};
-- 
1.7.4.1

