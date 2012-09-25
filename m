Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220Ab2IYQQj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:16:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60753 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758061Ab2IYQOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:14:14 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 49/57] power: Cancelling status charging notification.
Date: Tue, 25 Sep 2012 10:12:46 -0600
Message-Id: <1348589574-25655-50-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Mathieu J. Poirier" <mathieu.poirier@linaro.org>

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/power/abx500_chargalg.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index ce58f20..4db0ef0 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -641,10 +641,8 @@ static void abx500_chargalg_hold_charging(struct abx500_chargalg *di)
 	abx500_chargalg_usb_en(di, false, 0, 0);
 	abx500_chargalg_stop_safety_timer(di);
 	abx500_chargalg_stop_maintenance_timer(di);
-	di->charge_status = POWER_SUPPLY_STATUS_CHARGING;
 	di->maintenance_chg = false;
 	cancel_delayed_work(&di->chargalg_wd_work);
-	power_supply_changed(&di->chargalg_psy);
 }
 
 /**
-- 
1.7.5.4

