Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab2JRN12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 09:27:28 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:61187 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884Ab2JRN0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 09:26:09 -0400
From: Matt Porter <mporter@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>
Cc: Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <djbw@fb.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [RFC PATCH v3 13/16] ARM: dts: add AM33XX MMC support
Date: Thu, 18 Oct 2012 09:26:52 -0400
Message-Id: <1350566815-409-14-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350566815-409-1-git-send-email-mporter@ti.com>
References: <1350566815-409-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds AM33XX MMC support for am335x-bone and am335x-evm.

Signed-off-by: Matt Porter <mporter@ti.com>
---
 arch/arm/boot/dts/am335x-bone.dts |    6 ++++++
 arch/arm/boot/dts/am335x-evm.dts  |    6 ++++++
 arch/arm/boot/dts/am33xx.dtsi     |   27 +++++++++++++++++++++++++++
 3 files changed, 39 insertions(+)

diff --git a/arch/arm/boot/dts/am335x-bone.dts b/arch/arm/boot/dts/am335x-bone.dts
index c634f87..5510979 100644
--- a/arch/arm/boot/dts/am335x-bone.dts
+++ b/arch/arm/boot/dts/am335x-bone.dts
@@ -70,6 +70,8 @@
 		};
 
 		ldo3_reg: regulator@5 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <3300000>;
 			regulator-always-on;
 		};
 
@@ -78,3 +80,7 @@
 		};
 	};
 };
+
+&mmc1 {
+	vmmc-supply = <&ldo3_reg>;
+};
diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
index 185d632..d63fce8 100644
--- a/arch/arm/boot/dts/am335x-evm.dts
+++ b/arch/arm/boot/dts/am335x-evm.dts
@@ -114,7 +114,13 @@
 		};
 
 		vmmc_reg: regulator@12 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <3300000>;
 			regulator-always-on;
 		};
 	};
 };
+
+&mmc1 {
+	vmmc-supply = <&vmmc_reg>;
+};
diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index ab9c78f..26a6af7 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -234,6 +234,33 @@
 			status = "disabled";
 		};
 
+		mmc1: mmc@48060000 {
+			compatible = "ti,omap3-hsmmc";
+			ti,hwmods = "mmc1";
+			ti,dual-volt;
+			ti,needs-special-reset;
+			dmas = <&edma 24
+				&edma 25>;
+			dma-names = "tx", "rx";
+		};
+
+		mmc2: mmc@481d8000 {
+			compatible = "ti,omap3-hsmmc";
+			ti,hwmods = "mmc2";
+			ti,needs-special-reset;
+			dmas = <&edma 2
+				&edma 3>;
+			dma-names = "tx", "rx";
+			status = "disabled";
+		};
+
+		mmc3: mmc@47810000 {
+			compatible = "ti,omap3-hsmmc";
+			ti,hwmods = "mmc3";
+			ti,needs-special-reset;
+			status = "disabled";
+		};
+
 		wdt2: wdt@44e35000 {
 			compatible = "ti,omap3-wdt";
 			ti,hwmods = "wd_timer2";
-- 
1.7.9.5

