Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914Ab2IYQNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:13:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60753 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757879Ab2IYQNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:13:50 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 31/57] power: ab8500_fg: fix to use correct battery charge full design
Date: Tue, 25 Sep 2012 10:12:28 -0600
Message-Id: <1348589574-25655-32-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rajkumar Kasirajan <rajkumar.kasirajan@stericsson.com>

If battery is not identified while fg probe, mah_max_design gets
initialized with unknown battery's charge full design. Reinitialize
mah_max_design if battery is identified after fg probe.

Signed-off-by: Rajkumar Kasirajan <rajkumar.kasirajan@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
Reviewed-by: Vijaya Kumar K-1 <vijay.kilari@stericsson.com>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Olivier CLERGEAUD <olivier.clergeaud@stericsson.com>
Reviewed-by: Arun MURTHY <arun.murthy@stericsson.com>
Reviewed-by: Rupesh KUMAR <rupesh.kumar@stericsson.com>
Reviewed-by: Rabin VINCENT <rabin.vincent@stericsson.com>
---
 drivers/power/ab8500_fg.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 0e71e7e..5e4a46b 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -2258,9 +2258,9 @@ static int ab8500_fg_get_ext_psy_data(struct device *dev, void *data)
 		case POWER_SUPPLY_PROP_TECHNOLOGY:
 			switch (ext->type) {
 			case POWER_SUPPLY_TYPE_BATTERY:
-				if (!di->flags.batt_id_received) {
+				if (!di->flags.batt_id_received &&
+					di->bat->batt_id != BATTERY_UNKNOWN) {
 					const struct abx500_battery_type *b;
-
 					b = &(di->bat->bat_type[di->bat->batt_id]);
 
 					di->flags.batt_id_received = true;
-- 
1.7.5.4

