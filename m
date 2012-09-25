Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081Ab2IYQOv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:14:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41451 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758097Ab2IYQOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:14:24 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 57/57] power: ab8500_charger: Limit USB charger current
Date: Tue, 25 Sep 2012 10:12:54 -0600
Message-Id: <1348589574-25655-58-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Bergstrom <martin.bergstrom@stericsson.com>

The USB charger current is limited according to information comming
from the USB driver

Signed-off-by: Martin Bergstrom <martin.bergstrom@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/power/ab8500_charger.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index afb4fda..3c6f11c 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -1248,6 +1248,9 @@ static int ab8500_charger_set_vbus_in_curr(struct ab8500_charger *di,
 	if (di->max_usb_in_curr.set_max > 0)
 		min_value = min(di->max_usb_in_curr.set_max, min_value);
 
+	if (di->usb_state.usb_current >= 0)
+		min_value = min(di->usb_state.usb_current, min_value);
+
 	switch (min_value) {
 	case 100:
 		if (di->vbat < VBAT_TRESH_IP_CUR_RED)
@@ -3413,6 +3416,7 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 	di->usb_chg.wdt_refresh = CHG_WD_INTERVAL;
 	di->usb_chg.enabled = di->pdata->usb_enabled;
 	di->usb_chg.external = false;
+	di->usb_state.usb_current = -1;
 
 	/* Create a work queue for the charger */
 	di->charger_wq =
-- 
1.7.5.4

