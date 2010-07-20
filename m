Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761049Ab0GTADV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 20:03:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38437 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757430Ab0GTADS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 20:03:18 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Cc: Yulia Vilensky <vilensky@compulab.co.il>,
        Geert Stappers <stappers@stappers.nl>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 20 Jul 2010 01:02:55 +0100
Message-ID: <1279584175.4883.226.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH] ds2782_battery: Rename get_current and get_voltage
 operations
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 9b9ade6b612e562c4a5bd02ef38cc32e10f3f9ba "ds2782_battery: Add
support for ds2786 battery gas gauge" introduced an operation named
get_current.  Since get_current() is defined as a macro on some
architectures this driver no longer compiles on those architectures.

Rename get_current to get_current_now to avoid the macro.
Rename get_voltage to get_voltage_now for consistency.

Reported-by: Geert Stappers <stappers@stappers.nl>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/power/ds2782_battery.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
index d762a0c..8d0673f 100644
--- a/drivers/power/ds2782_battery.c
+++ b/drivers/power/ds2782_battery.c
@@ -43,8 +43,8 @@
 struct ds278x_info;
 
 struct ds278x_battery_ops {
-	int	(*get_current)(struct ds278x_info *info, int *current_uA);
-	int	(*get_voltage)(struct ds278x_info *info, int *voltage_uA);
+	int	(*get_current_now)(struct ds278x_info *info, int *current_uA);
+	int	(*get_voltage_now)(struct ds278x_info *info, int *voltage_uA);
 	int	(*get_capacity)(struct ds278x_info *info, int *capacity_uA);
 
 };
@@ -213,7 +213,7 @@ static int ds278x_get_status(struct ds278x_info *info, int *status)
 	int current_uA;
 	int capacity;
 
-	err = info->ops->get_current(info, &current_uA);
+	err = info->ops->get_current_now(info, &current_uA);
 	if (err)
 		return err;
 
@@ -250,11 +250,11 @@ static int ds278x_battery_get_property(struct power_supply *psy,
 		break;
 
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
-		ret = info->ops->get_voltage(info, &val->intval);
+		ret = info->ops->get_voltage_now(info, &val->intval);
 		break;
 
 	case POWER_SUPPLY_PROP_CURRENT_NOW:
-		ret = info->ops->get_current(info, &val->intval);
+		ret = info->ops->get_current_now(info, &val->intval);
 		break;
 
 	case POWER_SUPPLY_PROP_TEMP:
@@ -307,14 +307,14 @@ enum ds278x_num_id {
 
 static struct ds278x_battery_ops ds278x_ops[] = {
 	[DS2782] = {
-		.get_current  = ds2782_get_current,
-		.get_voltage  = ds2782_get_voltage,
-		.get_capacity = ds2782_get_capacity,
+		.get_current_now = ds2782_get_current,
+		.get_voltage_now = ds2782_get_voltage,
+		.get_capacity    = ds2782_get_capacity,
 	},
 	[DS2786] = {
-		.get_current  = ds2786_get_current,
-		.get_voltage  = ds2786_get_voltage,
-		.get_capacity = ds2786_get_capacity,
+		.get_current_now = ds2786_get_current,
+		.get_voltage_now = ds2786_get_voltage,
+		.get_capacity    = ds2786_get_capacity,
 	}
 };
 
-- 
1.7.1


