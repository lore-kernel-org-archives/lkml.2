Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929Ab1DNRqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:46:00 -0400
Received: from mail.windriver.com ([147.11.1.11]:37678 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200Ab1DNRp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:45:58 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "Richard A. Smith" <richard@laptop.org>,
        Daniel Drake <dsd@laptop.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 031/209] olpc_battery: Fix endian neutral breakage for s16 values
Date: Thu, 14 Apr 2011 13:41:01 -0400
Message-Id: <1302803039-9400-32-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard A. Smith <richard@laptop.org>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 7cfbb29466633e6ecdc14f76a693c8478c2b22af upstream.

When the driver was updated to be endian neutral (8e9c7716c)
the signed part of the s16 values was lost.  This is because be16_to_cpu()
returns an unsigned value.  This patch casts the values back to a s16
number prior to the the implicit cast up to an int.

Signed-off-by: Richard A. Smith <richard@laptop.org>
Signed-off-by: Daniel Drake <dsd@laptop.org>
Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/power/olpc_battery.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
index 8fefe5a..4b38eaa 100644
--- a/drivers/power/olpc_battery.c
+++ b/drivers/power/olpc_battery.c
@@ -271,14 +271,14 @@ static int olpc_bat_get_property(struct power_supply *psy,
 		if (ret)
 			return ret;
 
-		val->intval = (int)be16_to_cpu(ec_word) * 9760L / 32;
+		val->intval = (s16)be16_to_cpu(ec_word) * 9760L / 32;
 		break;
 	case POWER_SUPPLY_PROP_CURRENT_AVG:
 		ret = olpc_ec_cmd(EC_BAT_CURRENT, NULL, 0, (void *)&ec_word, 2);
 		if (ret)
 			return ret;
 
-		val->intval = (int)be16_to_cpu(ec_word) * 15625L / 120;
+		val->intval = (s16)be16_to_cpu(ec_word) * 15625L / 120;
 		break;
 	case POWER_SUPPLY_PROP_CAPACITY:
 		ret = olpc_ec_cmd(EC_BAT_SOC, NULL, 0, &ec_byte, 1);
@@ -299,7 +299,7 @@ static int olpc_bat_get_property(struct power_supply *psy,
 		if (ret)
 			return ret;
 
-		val->intval = (int)be16_to_cpu(ec_word) * 100 / 256;
+		val->intval = (s16)be16_to_cpu(ec_word) * 100 / 256;
 		break;
 	case POWER_SUPPLY_PROP_TEMP_AMBIENT:
 		ret = olpc_ec_cmd(EC_AMB_TEMP, NULL, 0, (void *)&ec_word, 2);
@@ -313,7 +313,7 @@ static int olpc_bat_get_property(struct power_supply *psy,
 		if (ret)
 			return ret;
 
-		val->intval = (int)be16_to_cpu(ec_word) * 6250 / 15;
+		val->intval = (s16)be16_to_cpu(ec_word) * 6250 / 15;
 		break;
 	case POWER_SUPPLY_PROP_SERIAL_NUMBER:
 		ret = olpc_ec_cmd(EC_BAT_SERIAL, NULL, 0, (void *)&ser_buf, 8);
-- 
1.7.4.4

