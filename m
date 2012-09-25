Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233Ab2IYQQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:16:41 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57024 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758057Ab2IYQON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:14:13 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 48/57] power: ab8500 : quick re-attach for ext charger
Date: Tue, 25 Sep 2012 10:12:45 -0600
Message-Id: <1348589574-25655-49-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rupesh Kumar <rupesh.kumar@stericsson.com>

Quick re-attach charging behaviour is not required
for external ac charger. Internal AC/USB Charger removal
detection problem is due to a bug in AB8500 ASICs.

Signed-off-by: Rupesh Kumar <rupesh.kumar@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Hakan BERG <hakan.berg@stericsson.com>
Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
---
 drivers/power/abx500_chargalg.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index 180deab..ce58f20 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -330,12 +330,13 @@ static int abx500_chargalg_check_charger_enable(struct abx500_chargalg *di)
 		return di->usb_chg->ops.check_enable(di->usb_chg,
 			di->bat->bat_type[di->bat->batt_id].normal_vol_lvl,
 			di->bat->bat_type[di->bat->batt_id].normal_cur_lvl);
-	} else if (di->chg_info.charger_type & AC_CHG) {
+	} else if ((di->chg_info.charger_type & AC_CHG) &&
+					!(di->ac_chg->external)) {
 		return di->ac_chg->ops.check_enable(di->ac_chg,
 			di->bat->bat_type[di->bat->batt_id].normal_vol_lvl,
 			di->bat->bat_type[di->bat->batt_id].normal_cur_lvl);
 	}
-	return -ENXIO;
+	return 0;
 }
 
 /**
-- 
1.7.5.4

