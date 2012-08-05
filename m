Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab2HEOqd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 10:46:33 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46126 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab2HEOqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 10:46:30 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ARM: kirkwood: DT descriptor for Seagate FreeAgent Dockstar
Date: Sun,  5 Aug 2012 16:46:13 +0200
Message-Id: <1344177973-6505-2-git-send-email-sebastian.hesselbarth@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344177973-6505-1-git-send-email-sebastian.hesselbarth@googlemail.com>
References: <1344177973-6505-1-git-send-email-sebastian.hesselbarth@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the corresponding device tree descriptor for the
Seagate FreeAgent Dockstar based on Kirkwood DT.

Please note that this patch requires the mach-kirkwood Makefile.boot typo
fix to fully apply.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/kirkwood-dockstar.dts |   57 +++++++++++++++++++++++++++++++
 arch/arm/mach-kirkwood/Makefile.boot    |    1 +
 2 files changed, 58 insertions(+)
 create mode 100644 arch/arm/boot/dts/kirkwood-dockstar.dts

diff --git a/arch/arm/boot/dts/kirkwood-dockstar.dts b/arch/arm/boot/dts/kirkwood-dockstar.dts
new file mode 100644
index 0000000..08a5824
--- /dev/null
+++ b/arch/arm/boot/dts/kirkwood-dockstar.dts
@@ -0,0 +1,57 @@
+/dts-v1/;
+
+/include/ "kirkwood.dtsi"
+
+/ {
+	model = "Seagate FreeAgent Dockstar";
+	compatible = "seagate,dockstar", "marvell,kirkwood-88f6281", "marvell,kirkwood";
+
+	memory {
+		device_type = "memory";
+		reg = <0x00000000 0x8000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttyS0,115200n8 earlyprintk root=/dev/sda1 rootdelay=10";
+	};
+
+	ocp@f1000000 {
+		serial@12000 {
+			clock-frequency = <200000000>;
+			status = "ok";
+		};
+
+		nand@3000000 {
+			status = "okay";
+
+			partition@0 {
+				label = "u-boot";
+				reg = <0x0000000 0x100000>;
+				read-only;
+			};
+
+			partition@100000 {
+				label = "uImage";
+				reg = <0x0100000 0x400000>;
+			};
+
+			partition@500000 {
+				label = "data";
+				reg = <0x0500000 0xfb00000>;
+			};
+		};
+	};
+	gpio-leds {
+		compatible = "gpio-leds";
+
+		health {
+			label = "status:green:health";
+			gpios = <&gpio1 14 1>;
+			linux,default-trigger = "default-on";
+		};
+		fault {
+			label = "status:orange:fault";
+			gpios = <&gpio1 15 1>;
+		};
+	};
+};
diff --git a/arch/arm/mach-kirkwood/Makefile.boot b/arch/arm/mach-kirkwood/Makefile.boot
index a571755..2c2edfb 100644
--- a/arch/arm/mach-kirkwood/Makefile.boot
+++ b/arch/arm/mach-kirkwood/Makefile.boot
@@ -11,3 +11,4 @@ dtb-$(CONFIG_MACH_TS219_DT)	+= kirkwood-qnap-ts219.dtb
 dtb-$(CONFIG_MACH_GOFLEXNET_DT) += kirkwood-goflexnet.dtb
 dtb-$(CONFIG_MACH_LSXL_DT) += kirkwood-lschlv2.dtb
 dtb-$(CONFIG_MACH_LSXL_DT) += kirkwood-lsxhl.dtb
+dtb-$(CONFIG_MACH_DOCKSTAR_DT) += kirkwood-dockstar.dtb
-- 
1.7.10.4

