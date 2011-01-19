Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab1ASU0E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 15:26:04 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5080 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab1ASUZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 15:25:58 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6231"; a="70910651"
From: David Brown <davidb@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 03/11] msm: Generalize QGIC registers
Date: Wed, 19 Jan 2011 12:25:39 -0800
Message-Id: <1295468747-22796-4-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1295468747-22796-1-git-send-email-davidb@codeaurora.org>
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
 <1295468747-22796-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The QGIC registers are mapped to the same virtual addresses across
targets, only the physical address changes.  Move the BASE address out
of target-specific files, and add a SOC name to the base addresses.

Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h |   10 ++++------
 arch/arm/mach-msm/include/mach/msm_iomap.h      |    2 ++
 arch/arm/mach-msm/io.c                          |    4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
index d5482d6..5bd18db 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
@@ -35,13 +35,11 @@
  *
  */
 
-#define MSM_QGIC_DIST_BASE	IOMEM(0xF0000000)
-#define MSM_QGIC_DIST_PHYS	0x02080000
-#define MSM_QGIC_DIST_SIZE	SZ_4K
+#define MSM8X60_QGIC_DIST_PHYS	0x02080000
+#define MSM8X60_QGIC_DIST_SIZE	SZ_4K
 
-#define MSM_QGIC_CPU_BASE	IOMEM(0xF0001000)
-#define MSM_QGIC_CPU_PHYS	0x02081000
-#define MSM_QGIC_CPU_SIZE	SZ_4K
+#define MSM8X60_QGIC_CPU_PHYS	0x02081000
+#define MSM8X60_QGIC_CPU_SIZE	SZ_4K
 
 #define MSM_ACC_BASE		IOMEM(0xF0002000)
 #define MSM_ACC_PHYS		0x02001000
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap.h b/arch/arm/mach-msm/include/mach/msm_iomap.h
index 0243bd0..bb42de3 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap.h
@@ -55,6 +55,8 @@
 
 /* Virtual addressses shared across all MSM targets. */
 #define MSM_CSR_BASE		IOMEM(0xE0001000)
+#define MSM_QGIC_DIST_BASE	IOMEM(0xF0000000)
+#define MSM_QGIC_CPU_BASE	IOMEM(0xF0001000)
 #define MSM_TMR_BASE		IOMEM(0xF0200000)
 #define MSM_TMR0_BASE		IOMEM(0xF0201000)
 
diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
index 47d699f..5dd0d1b9 100644
--- a/arch/arm/mach-msm/io.c
+++ b/arch/arm/mach-msm/io.c
@@ -103,8 +103,8 @@ void __init msm_map_qsd8x50_io(void)
 
 #ifdef CONFIG_ARCH_MSM8X60
 static struct map_desc msm8x60_io_desc[] __initdata = {
-	MSM_DEVICE(QGIC_DIST),
-	MSM_DEVICE(QGIC_CPU),
+	MSM_CHIP_DEVICE(QGIC_DIST, MSM8X60),
+	MSM_CHIP_DEVICE(QGIC_CPU, MSM8X60),
 	MSM_CHIP_DEVICE(TMR, MSM8X60),
 	MSM_CHIP_DEVICE(TMR0, MSM8X60),
 	MSM_DEVICE(ACC),
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

