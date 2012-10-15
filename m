Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab2JOMSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 08:18:50 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:47694 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab2JOMSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 08:18:48 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Ben Dooks <ben-linux@fluff.org>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Li Li <li.li@canonical.com>,
        Ike Pan <ike.pan@canonical.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH V3 2/3] clk: armada-370-xp: add support for clock framework
Date: Mon, 15 Oct 2012 14:18:18 +0200
Message-Id: <1350303499-30868-3-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350303499-30868-1-git-send-email-gregory.clement@free-electrons.com>
References: <1350303499-30868-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 arch/arm/boot/dts/armada-370.dtsi   |   12 +++++++++
 arch/arm/boot/dts/armada-xp.dtsi    |   48 +++++++++++++++++++++++++++++++++++
 arch/arm/mach-mvebu/Kconfig         |    5 ++++
 arch/arm/mach-mvebu/armada-370-xp.c |    8 +++++-
 arch/arm/mach-mvebu/common.h        |    1 +
 5 files changed, 73 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/armada-370.dtsi b/arch/arm/boot/dts/armada-370.dtsi
index 2069151..ac495b4 100644
--- a/arch/arm/boot/dts/armada-370.dtsi
+++ b/arch/arm/boot/dts/armada-370.dtsi
@@ -75,5 +75,17 @@
 			#interrupts-cells = <2>;
 			interrupts = <91>;
 		};
+		coreclk: mvebu-sar@d0018230 {
+			#clock-cells = <1>;
+			reg = <0xd0018230 0x08>;
+			compatible = "marvell,armada-370-core-clockctrl";
+			clock-output-names =
+				"tclk",	    /* 0 */
+				"pclk",	    /* 1 */
+				"nbclk",    /* 2 */
+				"hclk",	    /* 3 */
+				"dramclk";  /* 4 */
+		};
+
 	};
 };
diff --git a/arch/arm/boot/dts/armada-xp.dtsi b/arch/arm/boot/dts/armada-xp.dtsi
index 71d6b5d..a564b52 100644
--- a/arch/arm/boot/dts/armada-xp.dtsi
+++ b/arch/arm/boot/dts/armada-xp.dtsi
@@ -27,6 +27,35 @@
 		    <0xd0021870 0x58>;
 	};
 
+	cpus {
+	    #address-cells = <1>;
+	    #size-cells = <0>;
+
+	    cpu@0 {
+	       	compatible = "marvell,sheeva-v7";
+		reg = <0>;
+		clocks = <&cpuclk 0>;
+	    };
+
+	    cpu@1 {
+		compatible = "marvell,sheeva-v7";
+		reg = <1>;
+		clocks = <&cpuclk 1>;
+	    };
+
+	    cpu@2 {
+		compatible = "marvell,sheeva-v7";
+		reg = <2>;
+		clocks = <&cpuclk 2>;
+	    };
+
+	    cpu@3 {
+		compatible = "marvell,sheeva-v7";
+		reg = <3>;
+		clocks = <&cpuclk 3>;
+	    };
+	};
+
 	soc {
 		serial@d0012200 {
 				compatible = "ns16550";
@@ -47,6 +76,25 @@
 				marvell,timer-25Mhz;
 		};
 
+		coreclk: mvebu-sar@d0018230 {
+			#clock-cells = <1>;
+			reg = <0xd0018230 0x08>;
+			compatible = "marvell,armada-xp-core-clockctrl";
+			clock-output-names =
+				"tclk",	    /* 0 */
+				"pclk",	    /* 1 */
+				"nbclk",    /* 2 */
+				"hclk",	    /* 3 */
+				"dramclk";  /* 4 */
+		};
+
+		cpuclk: clock-complex@d0018700 {
+			#clock-cells = <1>;
+			compatible = "marvell,armada-xp-cpu-clockctrl";
+			reg = <0xd0018700 0xA0>;
+			clocks = <&coreclk 1>;
+		};
+
 		system-controller@d0018200 {
 				compatible = "marvell,armada-370-xp-system-controller";
 				reg = <0xd0018200 0x500>;
diff --git a/arch/arm/mach-mvebu/Kconfig b/arch/arm/mach-mvebu/Kconfig
index 416d46e..17d246b 100644
--- a/arch/arm/mach-mvebu/Kconfig
+++ b/arch/arm/mach-mvebu/Kconfig
@@ -9,11 +9,16 @@ config ARCH_MVEBU
 	select PINCTRL
 	select PLAT_ORION
 	select SPARSE_IRQ
+	select CLKDEV_LOOKUP
+	select MVEBU_CLK_CPU
 
 if ARCH_MVEBU
 
 menu "Marvell SOC with device tree"
 
+config MVEBU_CLK_CPU
+	   bool
+
 config MACH_ARMADA_370_XP
 	bool
 	select ARMADA_370_XP_TIMER
diff --git a/arch/arm/mach-mvebu/armada-370-xp.c b/arch/arm/mach-mvebu/armada-370-xp.c
index 49d7915..2af6ce5 100644
--- a/arch/arm/mach-mvebu/armada-370-xp.c
+++ b/arch/arm/mach-mvebu/armada-370-xp.c
@@ -37,8 +37,14 @@ void __init armada_370_xp_map_io(void)
 	iotable_init(armada_370_xp_io_desc, ARRAY_SIZE(armada_370_xp_io_desc));
 }
 
+void __init armada_370_xp_timer_and_clk_init(void)
+{
+	mvebu_clocks_init();
+	armada_370_xp_timer_init();
+}
+
 struct sys_timer armada_370_xp_timer = {
-	.init		= armada_370_xp_timer_init,
+	.init		= armada_370_xp_timer_and_clk_init,
 };
 
 static void __init armada_370_xp_dt_init(void)
diff --git a/arch/arm/mach-mvebu/common.h b/arch/arm/mach-mvebu/common.h
index 02f89ea..281fab3 100644
--- a/arch/arm/mach-mvebu/common.h
+++ b/arch/arm/mach-mvebu/common.h
@@ -16,6 +16,7 @@
 #define __ARCH_MVEBU_COMMON_H
 
 void mvebu_restart(char mode, const char *cmd);
+void mvebu_clocks_init(void);
 
 void armada_370_xp_init_irq(void);
 void armada_370_xp_handle_irq(struct pt_regs *regs);
-- 
1.7.9.5

