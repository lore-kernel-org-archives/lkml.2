Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab2K3FHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 00:07:34 -0500
Received: from mail-wg0-f74.google.com ([74.125.82.74]:54437 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab2K3FH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 00:07:27 -0500
From: Doug Anderson <dianders@chromium.org>
To: linux-mmc@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Will Newton <will.newton@imgtec.com>,
        Chris Ball <cjb@laptop.org>, Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>, linux-kernel@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>
Subject: [PATCH v3 3/4] mmc: dw_mmc: exynos: Remove code for wp-gpios
Date: Thu, 29 Nov 2012 21:04:16 -0800
Message-Id: <1354251857-21587-3-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1354251857-21587-1-git-send-email-dianders@chromium.org>
References: <1353624835-19137-1-git-send-email-dianders@chromium.org>
 <1354251857-21587-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The exynos code claimed the write protect with devm_gpio_request() but
never did anything with it.  That meant that anyone using a write
protect GPIO would effectively be write protected all the time.

The handling for wp-gpios belongs in the main dw_mmc driver and has
been moved there.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v3:
- Totally removed wp-gpios handling from exynos code.

Changes in v2: None

 drivers/mmc/host/dw_mmc-exynos.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc-exynos.c b/drivers/mmc/host/dw_mmc-exynos.c
index 4d50da6..72fd0f2 100644
--- a/drivers/mmc/host/dw_mmc-exynos.c
+++ b/drivers/mmc/host/dw_mmc-exynos.c
@@ -175,16 +175,6 @@ static int dw_mci_exynos_setup_bus(struct dw_mci *host,
 		}
 	}
 
-	gpio = of_get_named_gpio(slot_np, "wp-gpios", 0);
-	if (gpio_is_valid(gpio)) {
-		if (devm_gpio_request(host->dev, gpio, "dw-mci-wp"))
-			dev_info(host->dev, "gpio [%d] request failed\n",
-						gpio);
-	} else {
-		dev_info(host->dev, "wp gpio not available");
-		host->pdata->quirks |= DW_MCI_QUIRK_NO_WRITE_PROTECT;
-	}
-
 	if (host->pdata->quirks & DW_MCI_QUIRK_BROKEN_CARD_DETECTION)
 		return 0;
 
-- 
1.7.7.3

