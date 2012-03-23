Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292Ab2CWRPF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 13:15:05 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63762 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759197Ab2CWROM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 13:14:12 -0400
From: mathieu.poirier@linaro.org
To: tony@atomide.com
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: [PATCH 6/9] omap2: select twl4030 support on boards that need it
Date: Fri, 23 Mar 2012 11:13:53 -0600
Message-Id: <1332522836-29517-7-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1332522836-29517-1-git-send-email-mathieu.poirier@linaro.org>
References: <1332522836-29517-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

These three boards unconditionally use the twl4030 driver
from the board-zoom-display.c file. Make sure that the driver
is always there.
We also need to select the I2C core so we are able to build
that driver.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/Kconfig |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index e20c8ab..0279e9e 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -265,6 +265,9 @@ config MACH_OMAP_ZOOM2
 	select SERIAL_CORE_CONSOLE
 	select SERIAL_8250_CONSOLE
 	select REGULATOR_FIXED_VOLTAGE if REGULATOR
+	select TWL4030_CORE
+	select MFD_SUPPORT
+	select I2C
 
 config MACH_OMAP_ZOOM3
 	bool "OMAP3630 Zoom3 board"
@@ -275,6 +278,9 @@ config MACH_OMAP_ZOOM3
 	select SERIAL_CORE_CONSOLE
 	select SERIAL_8250_CONSOLE
 	select REGULATOR_FIXED_VOLTAGE if REGULATOR
+	select TWL4030_CORE
+	select MFD_SUPPORT
+	select I2C
 
 config MACH_CM_T35
 	bool "CompuLab CM-T35/CM-T3730 modules"
@@ -316,6 +322,9 @@ config MACH_OMAP_3630SDP
 	depends on ARCH_OMAP3
 	default y
 	select OMAP_PACKAGE_CBP
+	select TWL4030_CORE
+	select MFD_SUPPORT
+	select I2C
 
 config MACH_TI8168EVM
 	bool "TI8168 Evaluation Module"
-- 
1.7.5.4

