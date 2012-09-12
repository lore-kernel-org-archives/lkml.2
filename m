Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab2ILXCP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:02:15 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12341 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab2ILXCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:02:11 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6833"; a="233698678"
From: David Brown <davidb@codeaurora.org>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: David Brown <davidb@codeaurora.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 2/2] ARM: msm: Move core.h contents into common.h
Date: Wed, 12 Sep 2012 16:01:40 -0700
Message-Id: <1347490900-8409-2-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347490900-8409-1-git-send-email-davidb@codeaurora.org>
References: <1347461906-13527-7-git-send-email-arnd@arndb.de>
 <1347490900-8409-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No real need to have a separate core.h from the common.h file.  Fold
these two prototypes into the common header file.

Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
This is Stephen Boyd's suggestion to not have a separate core.h.  It
is probably best to just fold this into the previous patch.

 arch/arm/mach-msm/board-dt-8660.c | 1 -
 arch/arm/mach-msm/board-dt-8960.c | 1 -
 arch/arm/mach-msm/common.h        | 2 ++
 arch/arm/mach-msm/core.h          | 2 --
 arch/arm/mach-msm/hotplug.c       | 2 +-
 arch/arm/mach-msm/platsmp.c       | 2 +-
 6 files changed, 4 insertions(+), 6 deletions(-)
 delete mode 100644 arch/arm/mach-msm/core.h

diff --git a/arch/arm/mach-msm/board-dt-8660.c b/arch/arm/mach-msm/board-dt-8660.c
index e5643f6..b5b4de2 100644
--- a/arch/arm/mach-msm/board-dt-8660.c
+++ b/arch/arm/mach-msm/board-dt-8660.c
@@ -20,7 +20,6 @@
 
 #include <mach/board.h>
 #include "common.h"
-#include "core.h"
 
 static const struct of_device_id msm_dt_gic_match[] __initconst = {
 	{ .compatible = "qcom,msm-8660-qgic", .data = gic_of_init },
diff --git a/arch/arm/mach-msm/board-dt-8960.c b/arch/arm/mach-msm/board-dt-8960.c
index 139d61b..4490edb 100644
--- a/arch/arm/mach-msm/board-dt-8960.c
+++ b/arch/arm/mach-msm/board-dt-8960.c
@@ -18,7 +18,6 @@
 #include <asm/mach/arch.h>
 
 #include "common.h"
-#include "core.h"
 
 static const struct of_device_id msm_dt_gic_match[] __initconst = {
 	{ .compatible = "qcom,msm-qgic2", .data = gic_of_init },
diff --git a/arch/arm/mach-msm/common.h b/arch/arm/mach-msm/common.h
index d68e5d7..633a7159 100644
--- a/arch/arm/mach-msm/common.h
+++ b/arch/arm/mach-msm/common.h
@@ -26,5 +26,7 @@ extern void msm_map_qsd8x50_io(void);
 extern void __iomem *__msm_ioremap_caller(unsigned long phys_addr, size_t size,
 					  unsigned int mtype, void *caller);
 
+extern struct smp_operations msm_smp_ops;
+extern void msm_cpu_die(unsigned int cpu);
 
 #endif
diff --git a/arch/arm/mach-msm/core.h b/arch/arm/mach-msm/core.h
deleted file mode 100644
index a9bab53..0000000
--- a/arch/arm/mach-msm/core.h
+++ /dev/null
@@ -1,2 +0,0 @@
-extern struct smp_operations msm_smp_ops;
-extern void msm_cpu_die(unsigned int cpu);
diff --git a/arch/arm/mach-msm/hotplug.c b/arch/arm/mach-msm/hotplug.c
index d0f79e8..3f87911 100644
--- a/arch/arm/mach-msm/hotplug.c
+++ b/arch/arm/mach-msm/hotplug.c
@@ -13,7 +13,7 @@
 #include <asm/cacheflush.h>
 #include <asm/smp_plat.h>
 
-#include "core.h"
+#include "common.h"
 
 extern volatile int pen_release;
 
diff --git a/arch/arm/mach-msm/platsmp.c b/arch/arm/mach-msm/platsmp.c
index 313bd7d..948f970 100644
--- a/arch/arm/mach-msm/platsmp.c
+++ b/arch/arm/mach-msm/platsmp.c
@@ -23,7 +23,7 @@
 #include <asm/smp_plat.h>
 
 #include "scm-boot.h"
-#include "core.h"
+#include "common.h"
 
 #define VDD_SC1_ARRAY_CLAMP_GFS_CTL 0x15A0
 #define SCSS_CPU1CORE_RESET 0xD80
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

