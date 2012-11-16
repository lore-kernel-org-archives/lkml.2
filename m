Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347Ab2KPI7p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 03:59:45 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:54898 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab2KPI7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 03:59:44 -0500
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: benh@kernel.crashing.org, paulus@samba.org
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        michael.neuling@au1.ibm.com,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: [PATCH] powerpc, perf: Change PMU flag values representation from decimal to hex
Date: Fri, 16 Nov 2012 14:29:04 +0530
Message-Id: <1353056344-1392-1-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
x-cbid: 12111608-4790-0000-0000-00000597248D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/perf_event_server.h | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/include/asm/perf_event_server.h b/arch/powerpc/include/asm/perf_event_server.h
index 9710be3..e3f10bb 100644
--- a/arch/powerpc/include/asm/perf_event_server.h
+++ b/arch/powerpc/include/asm/perf_event_server.h
@@ -11,6 +11,7 @@
 
 #include <linux/types.h>
 #include <asm/hw_irq.h>
+#include <asm/asm-compat.h>
 
 #define MAX_HWEVENTS		8
 #define MAX_EVENT_ALTERNATIVES	8
@@ -45,11 +46,21 @@ struct power_pmu {
 /*
  * Values for power_pmu.flags
  */
-#define PPMU_LIMITED_PMC5_6	1	/* PMC5/6 have limited function */
-#define PPMU_ALT_SIPR		2	/* uses alternate posn for SIPR/HV */
-#define PPMU_NO_SIPR		4	/* no SIPR/HV in MMCRA at all */
-#define PPMU_NO_CONT_SAMPLING	8	/* no continuous sampling */
-#define PPMU_SIAR_VALID		16	/* Processor has SIAR Valid bit */
+
+#define PPMU_LIMITED_PMC5_6	\
+	LONG_ASM_CONST(0x0000000000000001) /* PMC5/6 have limited function */
+
+#define PPMU_ALT_SIPR		\
+	LONG_ASM_CONST(0x0000000000000002) /* uses alternate posn for SIPR/HV */
+
+#define PPMU_NO_SIPR		\
+	LONG_ASM_CONST(0x0000000000000004) /* no SIPR/HV in MMCRA at all */
+
+#define PPMU_NO_CONT_SAMPLING	\
+	LONG_ASM_CONST(0x0000000000000008) /* no continuous sampling */
+
+#define PPMU_SIAR_VALID		\
+	LONG_ASM_CONST(0x0000000000000010) /* Processor has SIAR Valid bit */
 
 /*
  * Values for flags to get_alternatives()
-- 
1.7.11.7

