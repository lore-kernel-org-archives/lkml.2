Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab0LMAT6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:19:58 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44926 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278Ab0LLXqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:01 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: richard@laptop.org, dsd@laptop.org, cbouatmailru@gmail.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [62/223] olpc_battery: Fix endian neutral breakage for s16 values
Message-Id: <20101212234600.42BE4B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:00 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Richard A. Smith <richard@laptop.org>

commit 7cfbb29466633e6ecdc14f76a693c8478c2b22af upstream.

When the driver was updated to be endian neutral (8e9c7716c)
the signed part of the s16 values was lost.  This is because be16_to_cpu()
returns an unsigned value.  This patch casts the values back to a s16
number prior to the the implicit cast up to an int.

Signed-off-by: Richard A. Smith <richard@laptop.org>
Signed-off-by: Daniel Drake <dsd@laptop.org>
Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/power/olpc_battery.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux/drivers/power/olpc_battery.c
===================================================================
--- linux.orig/drivers/power/olpc_battery.c
+++ linux/drivers/power/olpc_battery.c
@@ -271,14 +271,14 @@ static int olpc_bat_get_property(struct
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
@@ -299,7 +299,7 @@ static int olpc_bat_get_property(struct
 		if (ret)
 			return ret;
 
-		val->intval = (int)be16_to_cpu(ec_word) * 100 / 256;
+		val->intval = (s16)be16_to_cpu(ec_word) * 100 / 256;
 		break;
 	case POWER_SUPPLY_PROP_TEMP_AMBIENT:
 		ret = olpc_ec_cmd(EC_AMB_TEMP, NULL, 0, (void *)&ec_word, 2);
@@ -313,7 +313,7 @@ static int olpc_bat_get_property(struct
 		if (ret)
 			return ret;
 
-		val->intval = (int)be16_to_cpu(ec_word) * 6250 / 15;
+		val->intval = (s16)be16_to_cpu(ec_word) * 6250 / 15;
 		break;
 	case POWER_SUPPLY_PROP_SERIAL_NUMBER:
 		ret = olpc_ec_cmd(EC_BAT_SERIAL, NULL, 0, (void *)&ser_buf, 8);
