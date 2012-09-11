Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab2IKNBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 09:01:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58697 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab2IKNAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 09:00:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Samuel Ortiz <sameo@linux.intel.com>,
        Jochen Friedrich <jochen@scram.de>
Subject: [PATCH 08/16] ARM: sa1100: move platform_data definitions
Date: Tue, 11 Sep 2012 14:59:42 +0200
Message-Id: <1347368390-31252-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347368390-31252-1-git-send-email-arnd@arndb.de>
References: <1347368350-31212-1-git-send-email-arnd@arndb.de>
 <1347368390-31252-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:aFlRbDTadonri+rLe55y+tYT5mNdf/w+K4PIY4yJgPN
 iC1ByEJ+m9I6ryl2C1+YBsCUDGCfIvsWh9LrSHGrGvyBf+L9t6
 Nme0ROoAjKkR2D0CRAVRxRIcV7NnsX3Dqbqk5v5Px3RZbx3s9b
 IT2zobk7tcNZbc8eG+3llm+Cj/cgVLxnWFIkl2K2wZzm0/Z0Mi
 qSXP/eXHjHv0uOzNhxNunY5FPiZF/feP9gXeMM7yBwEQ4oYZWA
 wmECAyMCcZvxVJCMfCazi4QrN54zdYlCyriN95cZ6e8T+9jbzI
 7FWilQXlboep0yKKbwVIRemhXAUnXTmvmOKs/R4xrgEZnRmWGn
 XjkjVmxaw81Zw/wgoM8qs/gyEGC62usUrMFqqRFfJH9v30hGDm
 6aY8F8dzjyvB6rjub9B/PZtsT7bdo70HXo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platform data for device drivers should be defined in
include/linux/platform_data/*.h, not in the architecture
and platform specific directories.

This moves such data out of the sa1100 include directories

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Jochen Friedrich <jochen@scram.de>
---
 arch/arm/mach-sa1100/assabet.c                                       |    2 +-
 arch/arm/mach-sa1100/cerf.c                                          |    2 +-
 arch/arm/mach-sa1100/collie.c                                        |    2 +-
 arch/arm/mach-sa1100/lart.c                                          |    2 +-
 arch/arm/mach-sa1100/shannon.c                                       |    2 +-
 arch/arm/mach-sa1100/simpad.c                                        |    2 +-
 drivers/mfd/mcp-sa11x0.c                                             |    2 +-
 .../mach/mcp.h => include/linux/platform_data/mfd-mcp-sa11x0.h       |    0
 8 files changed, 7 insertions(+), 7 deletions(-)
 rename arch/arm/mach-sa1100/include/mach/mcp.h => include/linux/platform_data/mfd-mcp-sa11x0.h (100%)

diff --git a/arch/arm/mach-sa1100/assabet.c b/arch/arm/mach-sa1100/assabet.c
index d673211..ba49241 100644
--- a/arch/arm/mach-sa1100/assabet.c
+++ b/arch/arm/mach-sa1100/assabet.c
@@ -37,7 +37,7 @@
 #include <asm/mach/map.h>
 #include <asm/mach/serial_sa1100.h>
 #include <mach/assabet.h>
-#include <mach/mcp.h>
+#include <linux/platform_data/mfd-mcp-sa11x0.h>
 #include <mach/irqs.h>
 
 #include "generic.h"
diff --git a/arch/arm/mach-sa1100/cerf.c b/arch/arm/mach-sa1100/cerf.c
index 09d7f4b..985d0b5 100644
--- a/arch/arm/mach-sa1100/cerf.c
+++ b/arch/arm/mach-sa1100/cerf.c
@@ -28,7 +28,7 @@
 #include <asm/mach/serial_sa1100.h>
 
 #include <mach/cerf.h>
-#include <mach/mcp.h>
+#include <linux/platform_data/mfd-mcp-sa11x0.h>
 #include <mach/irqs.h>
 #include "generic.h"
 
diff --git a/arch/arm/mach-sa1100/collie.c b/arch/arm/mach-sa1100/collie.c
index ea5cff3..170cb61 100644
--- a/arch/arm/mach-sa1100/collie.c
+++ b/arch/arm/mach-sa1100/collie.c
@@ -45,7 +45,7 @@
 #include <asm/hardware/scoop.h>
 #include <asm/mach/sharpsl_param.h>
 #include <asm/hardware/locomo.h>
-#include <mach/mcp.h>
+#include <linux/platform_data/mfd-mcp-sa11x0.h>
 #include <mach/irqs.h>
 
 #include "generic.h"
diff --git a/arch/arm/mach-sa1100/lart.c b/arch/arm/mach-sa1100/lart.c
index b775a0a..7dc1a89 100644
--- a/arch/arm/mach-sa1100/lart.c
+++ b/arch/arm/mach-sa1100/lart.c
@@ -16,7 +16,7 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <asm/mach/serial_sa1100.h>
-#include <mach/mcp.h>
+#include <linux/platform_data/mfd-mcp-sa11x0.h>
 #include <mach/irqs.h>
 
 #include "generic.h"
diff --git a/arch/arm/mach-sa1100/shannon.c b/arch/arm/mach-sa1100/shannon.c
index 5d33fc3..ff6b7b3 100644
--- a/arch/arm/mach-sa1100/shannon.c
+++ b/arch/arm/mach-sa1100/shannon.c
@@ -19,7 +19,7 @@
 #include <asm/mach/flash.h>
 #include <asm/mach/map.h>
 #include <asm/mach/serial_sa1100.h>
-#include <mach/mcp.h>
+#include <linux/platform_data/mfd-mcp-sa11x0.h>
 #include <mach/shannon.h>
 #include <mach/irqs.h>
 
diff --git a/arch/arm/mach-sa1100/simpad.c b/arch/arm/mach-sa1100/simpad.c
index fbd5359..c73e1a3 100644
--- a/arch/arm/mach-sa1100/simpad.c
+++ b/arch/arm/mach-sa1100/simpad.c
@@ -24,7 +24,7 @@
 #include <asm/mach/flash.h>
 #include <asm/mach/map.h>
 #include <asm/mach/serial_sa1100.h>
-#include <mach/mcp.h>
+#include <linux/platform_data/mfd-mcp-sa11x0.h>
 #include <mach/simpad.h>
 #include <mach/irqs.h>
 
diff --git a/drivers/mfd/mcp-sa11x0.c b/drivers/mfd/mcp-sa11x0.c
index c54e244..f99d629 100644
--- a/drivers/mfd/mcp-sa11x0.c
+++ b/drivers/mfd/mcp-sa11x0.c
@@ -24,7 +24,7 @@
 
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
-#include <mach/mcp.h>
+#include <linux/platform_data/mfd-mcp-sa11x0.h>
 
 #define DRIVER_NAME "sa11x0-mcp"
 
diff --git a/arch/arm/mach-sa1100/include/mach/mcp.h b/include/linux/platform_data/mfd-mcp-sa11x0.h
similarity index 100%
rename from arch/arm/mach-sa1100/include/mach/mcp.h
rename to include/linux/platform_data/mfd-mcp-sa11x0.h
-- 
1.7.10

