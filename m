Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934834Ab2JXNu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 09:50:28 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:49035 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756366Ab2JXNu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 09:50:26 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Ben Dooks <ben-linux@fluff.org>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] arm: mvebu: adding SATA support: dt binding and config update
Date: Wed, 24 Oct 2012 15:49:21 +0200
Message-Id: <1351086561-13569-3-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351086561-13569-1-git-send-email-gregory.clement@free-electrons.com>
References: <1351086561-13569-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lior Amsalem <alior@marvell.com>

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Signed-off-by: Lior Amsalem <alior@marvell.com>
---
 arch/arm/boot/dts/armada-370-db.dts  |    3 +++
 arch/arm/boot/dts/armada-370-xp.dtsi |   10 ++++++++++
 arch/arm/boot/dts/armada-xp-db.dts   |    3 +++
 arch/arm/configs/mvebu_defconfig     |    7 +++++++
 4 files changed, 23 insertions(+)

diff --git a/arch/arm/boot/dts/armada-370-db.dts b/arch/arm/boot/dts/armada-370-db.dts
index 4a31b03..2a2aa75 100644
--- a/arch/arm/boot/dts/armada-370-db.dts
+++ b/arch/arm/boot/dts/armada-370-db.dts
@@ -34,5 +34,8 @@
 			clock-frequency = <200000000>;
 			status = "okay";
 		};
+		sata@d00a0000 {
+			status = "okay";
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/armada-370-xp.dtsi b/arch/arm/boot/dts/armada-370-xp.dtsi
index 94b4b9e..3f08233 100644
--- a/arch/arm/boot/dts/armada-370-xp.dtsi
+++ b/arch/arm/boot/dts/armada-370-xp.dtsi
@@ -69,6 +69,16 @@
 			compatible = "marvell,armada-addr-decoding-controller";
 			reg = <0xd0020000 0x258>;
 		};
+
+		sata@d00a0000 {
+                        compatible = "marvell,orion-sata";
+                        reg = <0xd00a0000 0x2400>;
+                        interrupts = <55>;
+                        nr-ports = <2>;
+			clocks = <&coreclk 0>;//,  <&coreclk 0>;
+                        status = "disabled";
+		};
+
 	};
 };
 
diff --git a/arch/arm/boot/dts/armada-xp-db.dts b/arch/arm/boot/dts/armada-xp-db.dts
index b1fc728..b0db9a3 100644
--- a/arch/arm/boot/dts/armada-xp-db.dts
+++ b/arch/arm/boot/dts/armada-xp-db.dts
@@ -46,5 +46,8 @@
 			clock-frequency = <250000000>;
 			status = "okay";
 		};
+		sata@d00a0000 {
+			status = "okay";
+		};
 	};
 };
diff --git a/arch/arm/configs/mvebu_defconfig b/arch/arm/configs/mvebu_defconfig
index 7bcf850..8ac5f3c 100644
--- a/arch/arm/configs/mvebu_defconfig
+++ b/arch/arm/configs/mvebu_defconfig
@@ -18,6 +18,13 @@ CONFIG_ZBOOT_ROM_BSS=0x0
 CONFIG_ARM_APPENDED_DTB=y
 CONFIG_VFP=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
+CONFIG_BLK_DEV_SD=y
+CONFIG_ATA=y
+CONFIG_SATA_MV=y
+CONFIG_MD=y
+CONFIG_BLK_DEV_MD=y
+# CONFIG_MD_AUTODETECT is not set
+CONFIG_MD_RAID456=y
 CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
 CONFIG_SERIAL_OF_PLATFORM=y
-- 
1.7.9.5

