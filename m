Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab2AaKgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 05:36:41 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:55929 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab2AaKgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 05:36:39 -0500
Date: Tue, 31 Jan 2012 11:36:32 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH 1/2] ARM: Exynos4: Make exynos4-dt compile again
In-reply-to: <1328006193-13902-1-git-send-email-k.lewandowsk@samsung.com>
To: thomas.abraham@linaro.org
Cc: m.szyprowski@samsung.com, linux-samsung-soc@vger.kernel.org,
        marc.zyngier@arm.com, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, kyungmin.park@samsung.com,
        Karol Lewandowski <k.lewandowsk@samsung.com>
Message-id: <1328006193-13902-2-git-send-email-k.lewandowsk@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.8.3
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1328006193-13902-1-git-send-email-k.lewandowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit cc511b8d84d8 ("ARM: 7257/1: EXYNOS: introduce
arch/arm/mach-exynos/common.[ch]") replaced plat/exynos4.h with
common.h, requiring all boards to be adjusted appropriately.

This commit fixes exynos4-dt.c, missed out in original patch.

Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
---
 arch/arm/mach-exynos/mach-exynos4-dt.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-exynos/mach-exynos4-dt.c b/arch/arm/mach-exynos/mach-exynos4-dt.c
index 85fa027..98e79c9 100644
--- a/arch/arm/mach-exynos/mach-exynos4-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos4-dt.c
@@ -19,7 +19,8 @@
 
 #include <plat/cpu.h>
 #include <plat/regs-serial.h>
-#include <plat/exynos4.h>
+
+#include "common.h"
 
 /*
  * The following lookup table is used to override device names when devices
@@ -60,7 +61,7 @@ static const struct of_dev_auxdata exynos4210_auxdata_lookup[] __initconst = {
 
 static void __init exynos4210_dt_map_io(void)
 {
-	s5p_init_io(NULL, 0, S5P_VA_CHIPID);
+	exynos_init_io(NULL, 0);
 	s3c24xx_init_clocks(24000000);
 }
 
-- 
1.7.8.3

