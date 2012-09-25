Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321Ab2IYQTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:19:36 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:48198 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757919Ab2IYQN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:13:56 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 35/57] power: ab8500_fg: Report unscaled capacity
Date: Tue, 25 Sep 2012 10:12:32 -0600
Message-Id: <1348589574-25655-36-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Bergstrom <martin.bergstrom@stericsson.com>

Unscaled capacity should be reported for POWER_SUPPLY_PROP_CAPACITY.

Signed-off-by: Martin Bergstrom <martin.bergstrom@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/power/ab8500_fg.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index fde189a..c5732e7 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -2159,9 +2159,7 @@ static int ab8500_fg_get_property(struct power_supply *psy,
 			val->intval = di->bat_cap.prev_mah;
 		break;
 	case POWER_SUPPLY_PROP_CAPACITY:
-		if (di->bat->capacity_scaling)
-			val->intval = di->bat_cap.cap_scale.scaled_cap;
-		else if (di->flags.batt_unknown && !di->bat->chg_unknown_bat &&
+		if (di->flags.batt_unknown && !di->bat->chg_unknown_bat &&
 				di->flags.batt_id_received)
 			val->intval = 100;
 		else
@@ -2625,7 +2623,7 @@ static ssize_t ab8500_show_capacity(struct device *dev,
 	if (di->bat->capacity_scaling)
 		capacity = di->bat_cap.cap_scale.scaled_cap;
 	else
-		capacity = DIV_ROUND_CLOSEST(di->bat_cap.permille, 10);
+		capacity = di->bat_cap.prev_percent;
 
 	return scnprintf(buf, PAGE_SIZE, "%d\n", capacity);
 }
-- 
1.7.5.4

