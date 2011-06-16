Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390Ab1FPI7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 04:59:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23201 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757329Ab1FPI7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 04:59:06 -0400
X-AuditID: cbfee61b-b7c62ae0000056ed-75-4df9c5d8363a
Date: Thu, 16 Jun 2011 17:59:02 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH 1/2] ARM: Exynos4: Support ADC
To: linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>, dg77.kim@samsung.com,
        myungjoo.ham@gmail.com
Message-id: <1308214743-16295-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 16 Jun 2011 08:58:50.0798 (UTC)
 FILETIME=[9C6F84E0:01CC2C03]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos4/Kconfig             |    1 +
 arch/arm/mach-exynos4/cpu.c               |    4 ++++
 arch/arm/mach-exynos4/include/mach/irqs.h |    8 ++++++++
 arch/arm/mach-exynos4/include/mach/map.h  |    5 +++++
 4 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-exynos4/Kconfig b/arch/arm/mach-exynos4/Kconfig
index 1435fc3..61fdf68 100644
--- a/arch/arm/mach-exynos4/Kconfig
+++ b/arch/arm/mach-exynos4/Kconfig
@@ -183,6 +183,7 @@ config MACH_NURI
 	select EXYNOS4_SETUP_SDHCI
 	select EXYNOS4_SETUP_USB_PHY
 	select SAMSUNG_DEV_PWM
+	select SAMSUNG_DEV_ADC
 	help
 	  Machine support for Samsung Mobile NURI Board.
 
diff --git a/arch/arm/mach-exynos4/cpu.c b/arch/arm/mach-exynos4/cpu.c
index 9babe44..c9af2f9 100644
--- a/arch/arm/mach-exynos4/cpu.c
+++ b/arch/arm/mach-exynos4/cpu.c
@@ -19,7 +19,9 @@
 
 #include <plat/cpu.h>
 #include <plat/clock.h>
+#include <plat/devs.h>
 #include <plat/exynos4.h>
+#include <plat/adc-core.h>
 #include <plat/sdhci.h>
 #include <plat/devs.h>
 #include <plat/fimc-core.h>
@@ -128,6 +130,8 @@ void __init exynos4_map_io(void)
 	exynos4_default_sdhci2();
 	exynos4_default_sdhci3();
 
+	s3c_adc_setname("s5p-adc");
+
 	s3c_fimc_setname(0, "exynos4-fimc");
 	s3c_fimc_setname(1, "exynos4-fimc");
 	s3c_fimc_setname(2, "exynos4-fimc");
diff --git a/arch/arm/mach-exynos4/include/mach/irqs.h b/arch/arm/mach-exynos4/include/mach/irqs.h
index 5d03730..aa62d3f 100644
--- a/arch/arm/mach-exynos4/include/mach/irqs.h
+++ b/arch/arm/mach-exynos4/include/mach/irqs.h
@@ -73,6 +73,11 @@
 #define IRQ_SYSMMU_MFC_M1_0	COMBINER_IRQ(5, 6)
 #define IRQ_SYSMMU_PCIE_0	COMBINER_IRQ(5, 7)
 
+#define IRQ_ADC0                COMBINER_IRQ(19, 0)
+#define IRQ_PEN0                COMBINER_IRQ(19, 1)
+#define IRQ_ADC1                COMBINER_IRQ(19, 2)
+#define IRQ_PEN1                COMBINER_IRQ(19, 3)
+
 #define IRQ_PDMA0		COMBINER_IRQ(21, 0)
 #define IRQ_PDMA1		COMBINER_IRQ(21, 1)
 
@@ -143,6 +148,9 @@
 
 #define MAX_COMBINER_NR		54
 
+#define IRQ_ADC			IRQ_ADC0
+#define IRQ_TC			IRQ_PEN0
+
 #define S5P_IRQ_EINT_BASE	COMBINER_IRQ(MAX_COMBINER_NR, 0)
 
 #define S5P_EINT_BASE1		(S5P_IRQ_EINT_BASE + 0)
diff --git a/arch/arm/mach-exynos4/include/mach/map.h b/arch/arm/mach-exynos4/include/mach/map.h
index 0009e77..d5ba95b 100644
--- a/arch/arm/mach-exynos4/include/mach/map.h
+++ b/arch/arm/mach-exynos4/include/mach/map.h
@@ -108,6 +108,9 @@
 
 #define EXYNOS4_PA_IIC(x)		(0x13860000 + ((x) * 0x10000))
 
+#define EXYNOS4_PA_ADC			0x13910000
+#define EXYNOS4_PA_ADC1			0x13911000
+
 #define EXYNOS4_PA_AC97			0x139A0000
 
 #define EXYNOS4_PA_SPDIF		0x139B0000
@@ -130,6 +133,8 @@
 #define S3C_PA_IIC5			EXYNOS4_PA_IIC(5)
 #define S3C_PA_IIC6			EXYNOS4_PA_IIC(6)
 #define S3C_PA_IIC7			EXYNOS4_PA_IIC(7)
+#define SAMSUNG_PA_ADC			EXYNOS4_PA_ADC
+#define SAMSUNG_PA_ADC1			EXYNOS4_PA_ADC1
 #define S3C_PA_RTC			EXYNOS4_PA_RTC
 #define S3C_PA_WDT			EXYNOS4_PA_WATCHDOG
 
-- 
1.7.4.1

