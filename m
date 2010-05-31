Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab0EaNIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 09:08:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50559 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754374Ab0EaNIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 09:08:16 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] input: Fix build of S3C touchscreen driver
Date: Mon, 31 May 2010 14:08:14 +0100
Message-Id: <1275311294-10760-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The name of the Kconfig symbol for the ADC has changed as a result of
application to more SoCs but the select statement has not been updated,
causing linker failures in 2.6.35-rc1 as the ADC core has not been
built.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/input/touchscreen/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 6703c6b..3b9d5e2 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -156,7 +156,7 @@ config TOUCHSCREEN_FUJITSU
 config TOUCHSCREEN_S3C2410
 	tristate "Samsung S3C2410/generic touchscreen input driver"
 	depends on ARCH_S3C2410 || SAMSUNG_DEV_TS
-	select S3C24XX_ADC
+	select S3C_ADC
 	help
 	  Say Y here if you have the s3c2410 touchscreen.
 
-- 
1.7.1

