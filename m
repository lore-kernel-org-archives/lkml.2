Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab1BJGoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 01:44:10 -0500
Received: from smtp-out.google.com ([74.125.121.67]:20105 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab1BJGoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 01:44:07 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, olof@lixom.net, konkers@android.com,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 03/15] ARM: tegra: irqs: Update irq list
Date: Wed,  9 Feb 2011 22:43:12 -0800
Message-Id: <1297320204-31882-4-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1297320204-31882-1-git-send-email-ccross@android.com>
References: <1297320204-31882-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes typo in INT_CPU1_PMU_INTR (original fix from Will Deacon)
Adds board irqs

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/include/mach/irqs.h |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-tegra/include/mach/irqs.h b/arch/arm/mach-tegra/include/mach/irqs.h
index 71bbf34..73265af 100644
--- a/arch/arm/mach-tegra/include/mach/irqs.h
+++ b/arch/arm/mach-tegra/include/mach/irqs.h
@@ -88,7 +88,7 @@
 #define INT_SYS_STATS_MON		(INT_SEC_BASE + 22)
 #define INT_GPIO5			(INT_SEC_BASE + 23)
 #define INT_CPU0_PMU_INTR		(INT_SEC_BASE + 24)
-#define INT_CPU2_PMU_INTR		(INT_SEC_BASE + 25)
+#define INT_CPU1_PMU_INTR		(INT_SEC_BASE + 25)
 #define INT_SEC_RES_26			(INT_SEC_BASE + 26)
 #define INT_S_LINK1			(INT_SEC_BASE + 27)
 #define INT_APB_DMA_COP			(INT_SEC_BASE + 28)
@@ -166,10 +166,18 @@
 #define INT_QUAD_RES_30			(INT_QUAD_BASE + 30)
 #define INT_QUAD_RES_31			(INT_QUAD_BASE + 31)
 
-#define INT_GPIO_BASE			(INT_QUAD_BASE + 32)
+#define INT_MAIN_NR			(INT_QUAD_BASE + 32 - INT_PRI_BASE)
+
+#define INT_GPIO_BASE			(INT_PRI_BASE + INT_MAIN_NR)
+
 #define INT_GPIO_NR			(28 * 8)
 
-#define NR_IRQS				(INT_GPIO_BASE + INT_GPIO_NR)
+#define TEGRA_NR_IRQS			(INT_GPIO_BASE + INT_GPIO_NR)
+
+#define INT_BOARD_BASE			TEGRA_NR_IRQS
+#define NR_BOARD_IRQS			32
+
+#define NR_IRQS				(INT_BOARD_BASE + NR_BOARD_IRQS)
 #endif
 
 #endif
-- 
1.7.3.1

