Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206Ab2IYQQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:16:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41451 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758062Ab2IYQOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:14:15 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 50/57] power: ab8500-chargalg: update battery health on safety timer exp
Date: Tue, 25 Sep 2012 10:12:47 -0600
Message-Id: <1348589574-25655-51-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hakan Berg <hakan.berg@stericsson.com>

When the charging safety timer is elapsed the battery health is shown as "Good".
This is misleading and also hard to distingiush problems reported on "phone
discharges although charger is attached".

When safety timer elapses that is an indication of a fault in the battery of
some kind. Hence report as POWER_SUPPLY_HEALTH_UNSPEC_FAILURE.

Signed-off-by: Hakan Berg <hakan.berg@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Arun MURTHY <arun.murthy@stericsson.com>
Reviewed-by: Karl KOMIEROWSKI <karl.komierowski@stericsson.com>
---
 drivers/power/abx500_chargalg.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index 4db0ef0..1df238f 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -1711,6 +1711,10 @@ static int abx500_chargalg_get_property(struct power_supply *psy,
 				val->intval = POWER_SUPPLY_HEALTH_COLD;
 			else
 				val->intval = POWER_SUPPLY_HEALTH_OVERHEAT;
+		} else if (di->charge_state == STATE_SAFETY_TIMER_EXPIRED ||
+			di->charge_state ==
+			STATE_SAFETY_TIMER_EXPIRED_INIT) {
+			val->intval = POWER_SUPPLY_HEALTH_UNSPEC_FAILURE;
 		} else {
 			val->intval = POWER_SUPPLY_HEALTH_GOOD;
 		}
-- 
1.7.5.4

