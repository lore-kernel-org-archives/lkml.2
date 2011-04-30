Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab1D3WAU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 18:00:20 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56410 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab1D3WAR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 18:00:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type
         :content-transfer-encoding;
        b=ukmBzj0wUJKlbAGUhQYG5ky1PIMqKRpwCiRus9VbSDO6SpDxVf2FbMxOKUlwMuaGAq
         8hw7w5mOuzASAXALoEjrfFH7EtnLX/otYOpqdOwc4HawJ2DtbYiax6dydYV19zjMk+40
         QZn0EpwCyDTk4ScFp593ER7wGq5etuxc4tI3w=
MIME-Version: 1.0
From: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Date: Sat, 30 Apr 2011 23:59:35 +0200
Message-ID: <BANLkTik8RDOP3Z2eYqQknEZXBNeWtvFLhw@mail.gmail.com>
Subject: [PATCH] bq27x00_battery: Name of cycle count property
To: Anton Vorontsov <cbouatmailru@gmail.com>,
        Grazvydas Ignotas <notasas@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Rodolfo Giometti <giometti@linux.it>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix using correct property POWER_SUPPLY_PROP_CYCLE_COUNT
for cycle count instead POWER_SUPPLY_PROP_CHARGE_COUNTER

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Tested-by: Pali Rohár <pali.rohar@gmail.com>

--- a/drivers/power/bq27x00_battery.c	2011-02-27 12:14:56.000000000 +0100
+++ b/drivers/power/bq27x00_battery.c	2011-04-30 23:50:19.000000000 +0200
@@ -4,6 +4,7 @@
  * Copyright (C) 2008 Rodolfo Giometti <giometti@linux.it>
  * Copyright (C) 2008 Eurotech S.p.A. <info@eurotech.it>
  * Copyright (C) 2010-2011 Lars-Peter Clausen <lars@metafoo.de>
+ * Copyright (C) 2011 Pali Rohár <pali.rohar@gmail.com>
  *
  * Based on a previous work by Copyright (C) 2008 Texas Instruments, Inc.
  *
@@ -76,7 +77,7 @@ struct bq27x00_reg_cache {
 	int time_to_empty_avg;
 	int time_to_full;
 	int charge_full;
-	int charge_counter;
+	int cycle_count;
 	int capacity;
 	int flags;

@@ -115,7 +116,7 @@ static enum power_supply_property bq27x0
 	POWER_SUPPLY_PROP_CHARGE_FULL,
 	POWER_SUPPLY_PROP_CHARGE_NOW,
 	POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
-	POWER_SUPPLY_PROP_CHARGE_COUNTER,
+	POWER_SUPPLY_PROP_CYCLE_COUNT,
 	POWER_SUPPLY_PROP_ENERGY_NOW,
 };

@@ -267,7 +268,7 @@ static void bq27x00_update(struct bq27x0
 		cache.time_to_empty_avg = bq27x00_battery_read_time(di, BQ27x00_REG_TTECP);
 		cache.time_to_full = bq27x00_battery_read_time(di, BQ27x00_REG_TTF);
 		cache.charge_full = bq27x00_battery_read_lmd(di);
-		cache.charge_counter = bq27x00_battery_read_cyct(di);
+		cache.cycle_count = bq27x00_battery_read_cyct(di);

 		if (!is_bq27500)
 			cache.current_now = bq27x00_read(di, BQ27x00_REG_AI, false);
@@ -496,8 +497,8 @@ static int bq27x00_battery_get_property(
 	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
 		ret = bq27x00_simple_value(di->charge_design_full, val);
 		break;
-	case POWER_SUPPLY_PROP_CHARGE_COUNTER:
-		ret = bq27x00_simple_value(di->cache.charge_counter, val);
+	case POWER_SUPPLY_PROP_CYCLE_COUNT:
+		ret = bq27x00_simple_value(di->cache.cycle_count, val);
 		break;
 	case POWER_SUPPLY_PROP_ENERGY_NOW:
 		ret = bq27x00_battery_energy(di, val);


-- 
Pali Rohár
pali.rohar@gmail.com
