Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110Ab2AXR1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 12:27:44 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38650 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757087Ab2AXR1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 12:27:42 -0500
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org
Cc: cbouatmailru@gmail.com, dg77.kim@samsung.com, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com, Jason.Wortham@maxim-ic.com,
        bruce.e.robertson@intel.com, Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 5/5] max17042: Change capacity property to use reported SOC register
Date: Tue, 24 Jan 2012 09:26:08 -0800
Message-Id: <1327425968-21195-6-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1327425968-21195-1-git-send-email-dirk.brandewie@gmail.com>
References: <1327425968-21195-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

The SOC register (0dh) reports the state of charge before empty
compensation adjustments are applied.  The max value reported by this
register will decrease as the battery ages.

Use the RepSOC register (06h) to report the capacity of the
battery. RepSOC contains a filtered version of the battery capacity
after empty compensation adjustments have been applied.

Reported-by: Gary Keyes <gary.e.keyes@intel.com>

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 drivers/power/max17042_battery.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index 6e96b58..2194278 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -160,7 +160,7 @@ static int max17042_get_property(struct power_supply *psy,
 		break;
 	case POWER_SUPPLY_PROP_CAPACITY:
 		val->intval = max17042_read_reg(chip->client,
-				MAX17042_SOC) / 256;
+				MAX17042_RepSOC) / 256;
 		break;
 	case POWER_SUPPLY_PROP_CHARGE_FULL:
 		val->intval = max17042_read_reg(chip->client,
-- 
1.7.7.5

