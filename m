Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab1HRVvD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 17:51:03 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:53825 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754337Ab1HRVu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 17:50:57 -0400
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Sekhar Nori <nsekhar@ti.com>,
        davinci-linux-open-source@linux.davincidsp.com
Cc: James Nuss <jamesnuss@nanometrics.ca>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] ARM: davinci: da850, omapl138: share boot_params
Date: Thu, 18 Aug 2011 17:50:48 -0400
Message-Id: <4b305c5bad3d09ba46420ae9a440efb2c7fb88ba.1313702401.git.bengardiner@nanometrics.ca>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <cover.1313702401.git.bengardiner@nanometrics.ca>
References: <cover.1313702401.git.bengardiner@nanometrics.ca>
In-Reply-To: <cover.1313702401.git.bengardiner@nanometrics.ca>
References: <cover.1313702401.git.bengardiner@nanometrics.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extract the value of .boot_params used by the da850/omapl138 machines to
a common DA850_REFERENCE_BOOT_PARAMS defined in the da850-reference.h
header introduced in a previous commit.

Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
Reviewed-by: James Nuss <jamesnuss@nanometrics.ca>
---
 arch/arm/mach-davinci/board-da850-evm.c            |    2 +-
 arch/arm/mach-davinci/board-mityomapl138.c         |    2 +-
 arch/arm/mach-davinci/board-omapl138-hawk.c        |    2 +-
 .../mach-davinci/include/mach/da850-reference.h    |    4 ++++
 4 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index 3ee12f3..f707bb2 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -1259,7 +1259,7 @@ console_initcall(da850_evm_console_init);
 #endif
 
 MACHINE_START(DAVINCI_DA850_EVM, "DaVinci DA850/OMAP-L138/AM18x EVM")
-	.boot_params	= (DA8XX_DDR_BASE + 0x100),
+	.boot_params	= DA850_REFERENCE_BOOT_PARAMS,
 	.map_io		= da850_reference_map_io,
 	.init_irq	= cp_intc_init,
 	.timer		= &davinci_timer,
diff --git a/arch/arm/mach-davinci/board-mityomapl138.c b/arch/arm/mach-davinci/board-mityomapl138.c
index c256858..998cd2e 100644
--- a/arch/arm/mach-davinci/board-mityomapl138.c
+++ b/arch/arm/mach-davinci/board-mityomapl138.c
@@ -561,7 +561,7 @@ console_initcall(mityomapl138_console_init);
 #endif
 
 MACHINE_START(MITYOMAPL138, "MityDSP-L138/MityARM-1808")
-	.boot_params	= (DA8XX_DDR_BASE + 0x100),
+	.boot_params	= DA850_REFERENCE_BOOT_PARAMS,
 	.map_io		= da850_reference_map_io,
 	.init_irq	= cp_intc_init,
 	.timer		= &davinci_timer,
diff --git a/arch/arm/mach-davinci/board-omapl138-hawk.c b/arch/arm/mach-davinci/board-omapl138-hawk.c
index 5d556cf..cfad483 100644
--- a/arch/arm/mach-davinci/board-omapl138-hawk.c
+++ b/arch/arm/mach-davinci/board-omapl138-hawk.c
@@ -334,7 +334,7 @@ console_initcall(omapl138_hawk_console_init);
 #endif
 
 MACHINE_START(OMAPL138_HAWKBOARD, "AM18x/OMAP-L138 Hawkboard")
-	.boot_params	= (DA8XX_DDR_BASE + 0x100),
+	.boot_params	= DA850_REFERENCE_BOOT_PARAMS,
 	.map_io		= da850_reference_map_io,
 	.init_irq	= cp_intc_init,
 	.timer		= &davinci_timer,
diff --git a/arch/arm/mach-davinci/include/mach/da850-reference.h b/arch/arm/mach-davinci/include/mach/da850-reference.h
index d3beb13..6837a98 100644
--- a/arch/arm/mach-davinci/include/mach/da850-reference.h
+++ b/arch/arm/mach-davinci/include/mach/da850-reference.h
@@ -9,6 +9,10 @@
 #ifndef __ASM_ARCH_DAVINCI_DA850_REFERENCE_H
 #define __ASM_ARCH_DAVINCI_DA850_REFERENCE_H
 
+#include <mach/memory.h>
+
+#define DA850_REFERENCE_BOOT_PARAMS (DA8XX_DDR_BASE + 0x100)
+
 void __init da850_reference_map_io(void);
 
 #endif /* __ASM_ARCH_DAVINCI_DA850_REFERENCE_H */
-- 
1.7.4.1

