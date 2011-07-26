Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab1GZJBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 05:01:32 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:21160 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab1GZJB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 05:01:26 -0400
X-AuditID: cbfee61a-b7cf0ae000006bc6-d3-4e2e826560a3
Date: Tue, 26 Jul 2011 18:01:56 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH] ARM: EXYNOS4: Add support power-domain of EXYNOS4210 on NURI
 board
To: Kukjin Kim <kgene.kim@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <4E2E8284.9000500@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
X-OriginalArrivalTime: 26 Jul 2011 09:01:46.0342 (UTC)
 FILETIME=[A5976860:01CC4B72]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos4/Kconfig     |    1 +
 arch/arm/mach-exynos4/mach-nuri.c |    8 ++++++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-exynos4/Kconfig b/arch/arm/mach-exynos4/Kconfig
index ed97f05..c7d6f07 100644
--- a/arch/arm/mach-exynos4/Kconfig
+++ b/arch/arm/mach-exynos4/Kconfig
@@ -197,6 +197,7 @@ config MACH_NURI
 	select EXYNOS4_SETUP_I2C5
 	select EXYNOS4_SETUP_SDHCI
 	select EXYNOS4_SETUP_USB_PHY
+	select EXYNOS4_DEV_PD
 	select SAMSUNG_DEV_PWM
 	select SAMSUNG_DEV_ADC
 	help
diff --git a/arch/arm/mach-exynos4/mach-nuri.c b/arch/arm/mach-exynos4/mach-nuri.c
index 1cc4d0b..09770c0 100644
--- a/arch/arm/mach-exynos4/mach-nuri.c
+++ b/arch/arm/mach-exynos4/mach-nuri.c
@@ -41,6 +41,7 @@
 #include <plat/clock.h>
 #include <plat/gpio-cfg.h>
 #include <plat/iic.h>
+#include <plat/pd.h>
 
 #include <mach/map.h>
 
@@ -1103,6 +1104,13 @@ static struct platform_device *nuri_devices[] __initdata = {
 	&i2c9_gpio,
 	&s3c_device_adc,
 	&s3c_device_rtc,
+	&exynos4_device_pd[PD_MFC],
+	&exynos4_device_pd[PD_G3D],
+	&exynos4_device_pd[PD_LCD0],
+	&exynos4_device_pd[PD_LCD1],
+	&exynos4_device_pd[PD_CAM],
+	&exynos4_device_pd[PD_TV],
+	&exynos4_device_pd[PD_GPS],
 
 	/* NURI Devices */
 	&nuri_gpio_keys,
-- 
1.7.0.4

