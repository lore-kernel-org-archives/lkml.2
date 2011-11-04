Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932879Ab1KDRQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 13:16:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42106 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755915Ab1KDRQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 13:16:28 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Cox <alan@linux.intel.com>, Kukjin Kim <kgene.kim@samsung.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] serial: samsung: Fix build for non-Exynos4210 devices
Date: Fri,  4 Nov 2011 17:16:24 +0000
Message-Id: <1320426984-17525-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

exynos4120_serial_drv_data is only defined when building with support
for Exynos4210 so use the already provided define to ensure that we
don't reference it when building for other SoCs.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/tty/serial/samsung.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index efe3756..7272eee 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -1649,7 +1649,7 @@ MODULE_DEVICE_TABLE(platform, s3c24xx_serial_driver_ids);
 #ifdef CONFIG_OF
 static const struct of_device_id s3c24xx_uart_dt_match[] = {
 	{ .compatible = "samsung,exynos4210-uart",
-		.data = &exynos4210_serial_drv_data },
+		.data = EXYNOS4210_SERIAL_DRV_DATA },
 	{},
 };
 MODULE_DEVICE_TABLE(of, s3c24xx_uart_dt_match);
-- 
1.7.7.1

