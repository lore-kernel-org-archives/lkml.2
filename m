Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759316Ab2INJUw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 05:20:52 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44404 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758328Ab2INJUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 05:20:51 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 1/1] drivers: bus: Move the OMAP interconnect driver to drivers/bus/
Date: Fri, 14 Sep 2012 14:50:34 +0530
Message-ID: <1347614434-15938-1-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP interconnect drivers are used for the interconnect error handling.
Since they are bus driver, lets move it to newly created drivers/bus.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Lindgren <tony@atomide.com>
Tested-by: Lokesh Vutla <lokeshvutla@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
Patch just moves OMAP interconnect drivers as is to the newly created
driver/bus/* directory. Patch is generated against "arm-soc/drivers/ocp2scp"
tree and test on all OMAP boards.

 arch/arm/mach-omap2/Kconfig                        |    2 ++
 arch/arm/mach-omap2/Makefile                       |    5 -----
 drivers/bus/Kconfig                                |    6 ++++++
 drivers/bus/Makefile                               |    3 +++
 {arch/arm/mach-omap2 => drivers/bus}/omap_l3_noc.c |    0
 {arch/arm/mach-omap2 => drivers/bus}/omap_l3_noc.h |    0
 {arch/arm/mach-omap2 => drivers/bus}/omap_l3_smx.c |    0
 {arch/arm/mach-omap2 => drivers/bus}/omap_l3_smx.h |    0
 8 files changed, 11 insertions(+), 5 deletions(-)
 rename {arch/arm/mach-omap2 => drivers/bus}/omap_l3_noc.c (100%)
 rename {arch/arm/mach-omap2 => drivers/bus}/omap_l3_noc.h (100%)
 rename {arch/arm/mach-omap2 => drivers/bus}/omap_l3_smx.c (100%)
 rename {arch/arm/mach-omap2 => drivers/bus}/omap_l3_smx.h (100%)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index dd2db02..7d3c8ab 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -44,6 +44,7 @@ config ARCH_OMAP3
 	select ARM_CPU_SUSPEND if PM
 	select MULTI_IRQ_HANDLER
 	select SOC_HAS_OMAP2_SDRC
+	select OMAP_INTERCONNECT
 
 config ARCH_OMAP4
 	bool "TI OMAP4"
@@ -63,6 +64,7 @@ config ARCH_OMAP4
 	select USB_ARCH_HAS_EHCI if USB_SUPPORT
 	select ARM_CPU_SUSPEND if PM
 	select ARCH_NEEDS_CPU_IDLE_COUPLED
+	select OMAP_INTERCONNECT
 
 config SOC_OMAP5
 	bool "TI OMAP5"
diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index f6a24b3..7fed980 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -199,11 +199,6 @@ obj-$(CONFIG_ARCH_OMAP4)		+= omap_hwmod_44xx_data.o
 # EMU peripherals
 obj-$(CONFIG_OMAP3_EMU)			+= emu.o
 
-# L3 interconnect
-obj-$(CONFIG_ARCH_OMAP3)		+= omap_l3_smx.o
-obj-$(CONFIG_ARCH_OMAP4)		+= omap_l3_noc.o
-obj-$(CONFIG_SOC_OMAP5)			+= omap_l3_noc.o
-
 obj-$(CONFIG_OMAP_MBOX_FWK)		+= mailbox_mach.o
 mailbox_mach-objs			:= mailbox.o
 
diff --git a/drivers/bus/Kconfig b/drivers/bus/Kconfig
index 6270415..bbec35d 100644
--- a/drivers/bus/Kconfig
+++ b/drivers/bus/Kconfig
@@ -12,4 +12,10 @@ config OMAP_OCP2SCP
 	  OCP2SCP and in OMAP5, both USB PHY and SATA PHY is connected via
 	  OCP2SCP.
 
+config OMAP_INTERCONNECT
+	tristate "OMAP INTERCONNECT DRIVER"
+	depends on ARCH_OMAP2PLUS
+
+	help
+	  Driver to enable OMAP interconnect error handling driver.
 endmenu
diff --git a/drivers/bus/Makefile b/drivers/bus/Makefile
index 0ec50bc..45d997c 100644
--- a/drivers/bus/Makefile
+++ b/drivers/bus/Makefile
@@ -3,3 +3,6 @@
 #
 
 obj-$(CONFIG_OMAP_OCP2SCP)	+= omap-ocp2scp.o
+
+# Interconnect bus driver for OMAP SoCs.
+obj-$(CONFIG_OMAP_INTERCONNECT)	+= omap_l3_smx.o omap_l3_noc.o
diff --git a/arch/arm/mach-omap2/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
similarity index 100%
rename from arch/arm/mach-omap2/omap_l3_noc.c
rename to drivers/bus/omap_l3_noc.c
diff --git a/arch/arm/mach-omap2/omap_l3_noc.h b/drivers/bus/omap_l3_noc.h
similarity index 100%
rename from arch/arm/mach-omap2/omap_l3_noc.h
rename to drivers/bus/omap_l3_noc.h
diff --git a/arch/arm/mach-omap2/omap_l3_smx.c b/drivers/bus/omap_l3_smx.c
similarity index 100%
rename from arch/arm/mach-omap2/omap_l3_smx.c
rename to drivers/bus/omap_l3_smx.c
diff --git a/arch/arm/mach-omap2/omap_l3_smx.h b/drivers/bus/omap_l3_smx.h
similarity index 100%
rename from arch/arm/mach-omap2/omap_l3_smx.h
rename to drivers/bus/omap_l3_smx.h
-- 
1.7.9.5

