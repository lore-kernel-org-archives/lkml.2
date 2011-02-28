Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab1B1VwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 16:52:11 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:39577
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752494Ab1B1VwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 16:52:09 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh95h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
From: John Linn <john.linn@xilinx.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <catalin.marinas@arm.com>,
        <glikely@secretlab.ca>, <jamie@jamieiles.com>, <arnd@arndb.de>
CC: John Linn <john.linn@xilinx.com>
Subject: [PATCH V5 4/4] ARM: Xilinx: Adding Xilinx platform infrastructure support
Date: Mon, 28 Feb 2011 14:51:59 -0700
X-Mailer: git-send-email 1.5.6.6
In-Reply-To: <1298929919-510-4-git-send-email-john.linn@xilinx.com>
References: <1298929919-510-1-git-send-email-john.linn@xilinx.com>
 <1298929919-510-2-git-send-email-john.linn@xilinx.com>
 <1298929919-510-3-git-send-email-john.linn@xilinx.com>
 <1298929919-510-4-git-send-email-john.linn@xilinx.com>
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <18a47cd4-9482-4fb3-b759-5d9c06e867d0@VA3EHSMHS029.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minimum infrastructure to add the Xilinx machine and allow it to
be selected in the build.

Signed-off-by: John Linn <john.linn@xilinx.com>
---

No updates for V5

V4

Updated to apply against linux-next branch.

No updates for V3

V2 Changes

Updates based on Russell King's comments	
	Cleanup of the Kconfig
	Moved this patch to be last in the patch series

 arch/arm/Kconfig    |   13 +++++++++++++
 arch/arm/Makefile   |    1 +
 arch/arm/mm/Kconfig |    2 +-
 3 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 5e15e6b..3983afa 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -891,6 +891,17 @@ config PLAT_SPEAR
 	help
 	  Support for ST's SPEAr platform (SPEAr3xx, SPEAr6xx and SPEAr13xx).
 
+config ARCH_XILINX
+	bool "Xilinx ARM Cortex A9 Platform"
+	select CPU_V7
+	select GENERIC_TIME
+	select GENERIC_CLOCKEVENTS
+	select CLKDEV_LOOKUP
+	select ARM_GIC
+	select ARM_AMBA
+	help
+	  Support for Xilinx ARM Cortex A9 Platform
+
 endchoice
 
 #
@@ -1025,6 +1036,8 @@ source "arch/arm/mach-vexpress/Kconfig"
 
 source "arch/arm/mach-w90x900/Kconfig"
 
+source "arch/arm/mach-xilinx/Kconfig"
+
 # Definitions to make life easier
 config ARCH_ACORN
 	bool
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 6f7b292..a78ecf2 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -197,6 +197,7 @@ machine-$(CONFIG_MACH_SPEAR300)		:= spear3xx
 machine-$(CONFIG_MACH_SPEAR310)		:= spear3xx
 machine-$(CONFIG_MACH_SPEAR320)		:= spear3xx
 machine-$(CONFIG_MACH_SPEAR600)		:= spear6xx
+machine-$(CONFIG_ARCH_XILINX)		:= xilinx
 
 # Platform directory name.  This list is sorted alphanumerically
 # by CONFIG_* macro name.
diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index e4509ba..cb0c570 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -813,7 +813,7 @@ config CACHE_L2X0
 	depends on REALVIEW_EB_ARM11MP || MACH_REALVIEW_PB11MP || MACH_REALVIEW_PB1176 || \
 		   REALVIEW_EB_A9MP || ARCH_MX35 || ARCH_MX31 || MACH_REALVIEW_PBX || \
 		   ARCH_NOMADIK || ARCH_OMAP4 || ARCH_S5PV310 || ARCH_TEGRA || \
-		   ARCH_U8500 || ARCH_VEXPRESS_CA9X4 || ARCH_SHMOBILE
+		   ARCH_U8500 || ARCH_VEXPRESS_CA9X4 || ARCH_SHMOBILE || ARCH_XILINX
 	default y
 	select OUTER_CACHE
 	select OUTER_CACHE_SYNC
-- 
1.6.2.1



This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


