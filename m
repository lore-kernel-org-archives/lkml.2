Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab2FLBqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 21:46:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56031 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751687Ab2FLBqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 21:46:35 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] power_supply: pda_power: Complain if regulator operations fail
Date: Tue, 12 Jun 2012 09:46:26 +0800
Message-Id: <1339465586-10841-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than silently ignoring errors from the regulator enable and disable
add a WARN_ON() - it's probably pretty important if we're not getting
power, though it should be vanishingly unlikely in production.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/power/pda_power.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
index 214468f..ed54a35 100644
--- a/drivers/power/pda_power.c
+++ b/drivers/power/pda_power.c
@@ -134,13 +134,13 @@ static void update_charger(void)
 			regulator_set_current_limit(ac_draw, max_uA, max_uA);
 			if (!regulator_enabled) {
 				dev_dbg(dev, "charger on (AC)\n");
-				regulator_enable(ac_draw);
+				WARN_ON(regulator_enable(ac_draw));
 				regulator_enabled = 1;
 			}
 		} else {
 			if (regulator_enabled) {
 				dev_dbg(dev, "charger off\n");
-				regulator_disable(ac_draw);
+				WARN_ON(regulator_disable(ac_draw));
 				regulator_enabled = 0;
 			}
 		}
-- 
1.7.10

