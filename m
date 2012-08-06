Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab2HFMYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 08:24:17 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40028 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108Ab2HFMYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 08:24:13 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rabeeh Khoury <rabeeh@solid-run.com>,
        Ian Molton <ian.molton@codethink.co.uk>, Arnd Bergmann <arnd@arndb.de>,
        Maen Suleiman <maen@marvell.com>, Olof Johansson <olof@lixom.net>
Subject: [PATCH 6/6] ARM: dove: SolidRun CuBox DT
Date: Mon,  6 Aug 2012 14:23:34 +0200
Message-Id: <1344255815-4457-7-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344255815-4457-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1344255815-4457-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds basic support for the SolidRun CuBox to DT based
mach-dove. There are still some issues related to ongoing orion/mvebu
development, e.g. gpio-led will not work as there is no DT pinctrl
for dove yet and we don't have board specific setup code. Nevertheless,
the DT description is already introduced here.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: Rabeeh Khoury <rabeeh@solid-run.com>
Cc: Ian Molton <ian.molton@codethink.co.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Maen Suleiman <maen@marvell.com>
Cc: Olof Johansson <olof@lixom.net>
---
 arch/arm/boot/dts/dove-cubox.dts |   42 ++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-dove/Makefile.boot |    1 +
 2 files changed, 43 insertions(+)
 create mode 100644 arch/arm/boot/dts/dove-cubox.dts

diff --git a/arch/arm/boot/dts/dove-cubox.dts b/arch/arm/boot/dts/dove-cubox.dts
new file mode 100644
index 0000000..0adbd5a
--- /dev/null
+++ b/arch/arm/boot/dts/dove-cubox.dts
@@ -0,0 +1,42 @@
+/dts-v1/;
+
+/include/ "dove.dtsi"
+
+/ {
+	model = "SolidRun CuBox";
+	compatible = "solidrun,cubox", "marvell,dove";
+
+	memory {
+		device_type = "memory";
+		reg = <0x00000000 0x40000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttyS0,115200n8 earlyprintk";
+	};
+
+	leds {
+		compatible = "gpio-leds";
+		power {
+			label = "Power";
+			gpios = <&gpio0 18 1>;
+			linux,default-trigger = "default-on";
+		};
+	};
+};
+
+&uart0 { status = "okay"; };
+&sdio0 { status = "okay"; };
+&sata0 { status = "okay"; };
+&i2c0 { status = "okay"; };
+
+&spi0 {
+	status = "okay";
+
+	/* spi0.0: 4M Flash Winbond W25Q32BV */
+	spi-flash@0 {
+		compatible = "st,w25q32";
+		spi-max-frequency = <20000000>;
+		reg = <0>;
+	};
+};
diff --git a/arch/arm/mach-dove/Makefile.boot b/arch/arm/mach-dove/Makefile.boot
index 94ab6b3..cfac9c5 100644
--- a/arch/arm/mach-dove/Makefile.boot
+++ b/arch/arm/mach-dove/Makefile.boot
@@ -4,3 +4,4 @@ initrd_phys-y	:= 0x00800000
 
 dtb-$(CONFIG_MACH_DOVE_DT) += dove-dove-db.dtb
 dtb-$(CONFIG_MACH_DOVE_DT) += dove-cm-a510.dtb
+dtb-$(CONFIG_MACH_DOVE_DT) += dove-cubox.dtb
-- 
1.7.10.4

