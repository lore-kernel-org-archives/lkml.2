Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059Ab2IYQOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:14:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60753 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758038Ab2IYQOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:14:08 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 44/57] power: ab8500: remove unecesary define flag
Date: Tue, 25 Sep 2012 10:12:41 -0600
Message-Id: <1348589574-25655-45-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcus Cooper <marcus.xm.cooper@stericsson.com>

Remove flag that serve no purpose from source code, Kconfig
and Makefile.

Signed-off-by: Marcus Cooper <marcus.xm.cooper@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Hakan BERG <hakan.berg@stericsson.com>
Reviewed-by: Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>
---
 drivers/power/Kconfig          |    7 -------
 drivers/power/ab8500_charger.c |    2 +-
 2 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index c1892f3..f7c13ae 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -303,13 +303,6 @@ config AB8500_BM
 	depends on AB8500_CORE && AB8500_GPADC
 	help
 	  Say Y to include support for AB8500 battery management.
-
-config AB8500_BATTERY_THERM_ON_BATCTRL
-	bool "Thermistor connected on BATCTRL ADC"
-	depends on AB8500_BM
-	help
-	  Say Y to enable battery temperature measurements using
-	  thermistor connected on BATCTRL ADC.
 endif # POWER_SUPPLY
 
 source "drivers/power/avs/Kconfig"
diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 9449a33..d90fe9f 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -3369,7 +3369,7 @@ static int __devexit ab8500_charger_remove(struct platform_device *pdev)
 	flush_scheduled_work();
 	if (di->usb_chg.enabled)
 		power_supply_unregister(&di->usb_chg.psy);
-	if (di->ac_chg.enabled)
+	if (di->ac_chg.enabled && !di->ac_chg.external)
 		power_supply_unregister(&di->ac_chg.psy);
 
 	platform_set_drvdata(pdev, NULL);
-- 
1.7.5.4

