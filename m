Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373Ab1FPI7K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 04:59:10 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:14885 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab1FPI7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 04:59:06 -0400
X-AuditID: cbfee61b-b7c62ae0000056ed-79-4df9c5d8d54e
Date: Thu, 16 Jun 2011 17:59:03 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH 2/2] ARM: Exynos4: ADC Support for NURI Board
In-reply-to: <1308214743-16295-1-git-send-email-myungjoo.ham@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>, dg77.kim@samsung.com,
        myungjoo.ham@gmail.com
Message-id: <1308214743-16295-2-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
References: <1308214743-16295-1-git-send-email-myungjoo.ham@samsung.com>
X-OriginalArrivalTime: 16 Jun 2011 08:58:51.0002 (UTC)
 FILETIME=[9C8EA5A0:01CC2C03]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos4/mach-nuri.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-exynos4/mach-nuri.c b/arch/arm/mach-exynos4/mach-nuri.c
index 5ca6bdd..0604f5d 100644
--- a/arch/arm/mach-exynos4/mach-nuri.c
+++ b/arch/arm/mach-exynos4/mach-nuri.c
@@ -29,6 +29,7 @@
 #include <asm/mach/arch.h>
 #include <asm/mach-types.h>
 
+#include <plat/adc.h>
 #include <plat/regs-serial.h>
 #include <plat/exynos4.h>
 #include <plat/cpu.h>
@@ -350,7 +351,7 @@ static void __init nuri_tsp_init(void)
 }
 
 static struct regulator_consumer_supply nuri_max8997_ldo1_consumer[] = {
-	REGULATOR_SUPPLY("vadc", NULL), /* Used by CPU's ADC drv */
+	REGULATOR_SUPPLY("vdd", "s5p-adc"), /* Used by CPU's ADC drv */
 };
 static struct regulator_consumer_supply nuri_max8997_ldo3_consumer[] = {
 	REGULATOR_SUPPLY("vdd11", "s5p-mipi-csis.0"), /* MIPI */
@@ -1057,6 +1058,7 @@ static struct platform_device *nuri_devices[] __initdata = {
 	&s3c_device_i2c3,
 	&s3c_device_i2c5,
 	&i2c9_gpio,
+	&s3c_device_adc,
 
 	/* NURI Devices */
 	&nuri_gpio_keys,
-- 
1.7.4.1

