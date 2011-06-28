Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab1F1W6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:58:36 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38243 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab1F1W6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:58:14 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, nico@fluxnic.net,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 2/4] ARM: remove unnecessary mach/hardware.h includes
Date: Tue, 28 Jun 2011 17:57:37 -0500
Message-Id: <1309301859-17651-3-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309301859-17651-1-git-send-email-robherring2@gmail.com>
References: <1309301859-17651-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Remove some includes of mach/hardware.h which are not needed. hardware.h will
be removed completely for tegra and cns3xxx in follow on patch.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 arch/arm/kernel/ecard.c                   |    1 -
 arch/arm/lib/ecard.S                      |    1 -
 arch/arm/lib/io-readsw-armv3.S            |    1 -
 arch/arm/lib/io-writesw-armv3.S           |    1 -
 arch/arm/mach-cns3xxx/cns3420vb.c         |    1 -
 arch/arm/mach-tegra/include/mach/system.h |    1 -
 arch/arm/mach-tegra/io.c                  |    1 -
 arch/arm/mach-tegra/platsmp.c             |    1 -
 arch/arm/mm/proc-xsc3.S                   |    1 -
 9 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/arch/arm/kernel/ecard.c b/arch/arm/kernel/ecard.c
index d165001..04b06c1 100644
--- a/arch/arm/kernel/ecard.c
+++ b/arch/arm/kernel/ecard.c
@@ -46,7 +46,6 @@
 
 #include <asm/dma.h>
 #include <asm/ecard.h>
-#include <mach/hardware.h>
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
 #include <asm/mach/irq.h>
diff --git a/arch/arm/lib/ecard.S b/arch/arm/lib/ecard.S
index 8678eb2..e6057fa 100644
--- a/arch/arm/lib/ecard.S
+++ b/arch/arm/lib/ecard.S
@@ -12,7 +12,6 @@
  */
 #include <linux/linkage.h>
 #include <asm/assembler.h>
-#include <mach/hardware.h>
 
 #define CPSR2SPSR(rt) \
 		mrs	rt, cpsr; \
diff --git a/arch/arm/lib/io-readsw-armv3.S b/arch/arm/lib/io-readsw-armv3.S
index 9aaf7c7..88487c8 100644
--- a/arch/arm/lib/io-readsw-armv3.S
+++ b/arch/arm/lib/io-readsw-armv3.S
@@ -9,7 +9,6 @@
  */
 #include <linux/linkage.h>
 #include <asm/assembler.h>
-#include <mach/hardware.h>
 
 .Linsw_bad_alignment:
 		adr	r0, .Linsw_bad_align_msg
diff --git a/arch/arm/lib/io-writesw-armv3.S b/arch/arm/lib/io-writesw-armv3.S
index cd34503..49b8004 100644
--- a/arch/arm/lib/io-writesw-armv3.S
+++ b/arch/arm/lib/io-writesw-armv3.S
@@ -9,7 +9,6 @@
  */
 #include <linux/linkage.h>
 #include <asm/assembler.h>
-#include <mach/hardware.h>
 
 .Loutsw_bad_alignment:
 		adr	r0, .Loutsw_bad_align_msg
diff --git a/arch/arm/mach-cns3xxx/cns3420vb.c b/arch/arm/mach-cns3xxx/cns3420vb.c
index 08e5c87..85e6390 100644
--- a/arch/arm/mach-cns3xxx/cns3420vb.c
+++ b/arch/arm/mach-cns3xxx/cns3420vb.c
@@ -29,7 +29,6 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <asm/mach/time.h>
-#include <mach/hardware.h>
 #include <mach/cns3xxx.h>
 #include <mach/irqs.h>
 #include "core.h"
diff --git a/arch/arm/mach-tegra/include/mach/system.h b/arch/arm/mach-tegra/include/mach/system.h
index d0183d8..027c421 100644
--- a/arch/arm/mach-tegra/include/mach/system.h
+++ b/arch/arm/mach-tegra/include/mach/system.h
@@ -21,7 +21,6 @@
 #ifndef __MACH_TEGRA_SYSTEM_H
 #define __MACH_TEGRA_SYSTEM_H
 
-#include <mach/hardware.h>
 #include <mach/iomap.h>
 
 extern void (*arch_reset)(char mode, const char *cmd);
diff --git a/arch/arm/mach-tegra/io.c b/arch/arm/mach-tegra/io.c
index 31848a9..ea50fe2 100644
--- a/arch/arm/mach-tegra/io.c
+++ b/arch/arm/mach-tegra/io.c
@@ -24,7 +24,6 @@
 #include <linux/mm.h>
 #include <linux/io.h>
 
-#include <mach/hardware.h>
 #include <asm/page.h>
 #include <asm/mach/map.h>
 
diff --git a/arch/arm/mach-tegra/platsmp.c b/arch/arm/mach-tegra/platsmp.c
index b8ae3c9..deb3851 100644
--- a/arch/arm/mach-tegra/platsmp.c
+++ b/arch/arm/mach-tegra/platsmp.c
@@ -21,7 +21,6 @@
 
 #include <asm/cacheflush.h>
 #include <asm/hardware/gic.h>
-#include <mach/hardware.h>
 #include <asm/mach-types.h>
 #include <asm/smp_scu.h>
 
diff --git a/arch/arm/mm/proc-xsc3.S b/arch/arm/mm/proc-xsc3.S
index 5962136..9ab25b4 100644
--- a/arch/arm/mm/proc-xsc3.S
+++ b/arch/arm/mm/proc-xsc3.S
@@ -28,7 +28,6 @@
 #include <linux/init.h>
 #include <asm/assembler.h>
 #include <asm/hwcap.h>
-#include <mach/hardware.h>
 #include <asm/pgtable.h>
 #include <asm/pgtable-hwdef.h>
 #include <asm/page.h>
-- 
1.7.4.1

