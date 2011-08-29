Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab1H2RGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 13:06:36 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:59678 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754418Ab1H2RGf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 13:06:35 -0400
From: Philip Rakity <prakity@marvell.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "adharmap@codeaurora.org" <adharmap@codeaurora.org>,
        "cbou@mail.ru" <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 29 Aug 2011 10:03:58 -0700
Subject: [PATCH 1/3]  power: add two properties: charge_to_use and
  voltage_to_use
Thread-Topic: [PATCH 1/3]  power: add two properties: charge_to_use and
  voltage_to_use
Thread-Index: AcxmbaPPhFhQOYniTEKAkgQC8Haxng==
Message-ID: <B6E06046-954B-4598-93B8-4D4B8112AC8B@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add two new properties
a) POWER_SUPPLY_PROP_VOLTAGE_TO_USE
b) POWER_SUPPLY_PROP_CHARGE_TO_USE

These 2 properties can be returned by the battery to
tell the charger what voltage and charge to use.

Signed-off-by: Philip Rakity <prakity@marvell.com>
---
 drivers/power/power_supply_sysfs.c |    2 ++
 include/linux/power_supply.h       |    4 ++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index c9e9479..bffc67b 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -167,6 +167,8 @@ static struct device_attribute power_supply_attrs[] = {
 	POWER_SUPPLY_ATTR(time_to_full_now),
 	POWER_SUPPLY_ATTR(time_to_full_avg),
 	POWER_SUPPLY_ATTR(type),
+	POWER_SUPPLY_ATTR(charge_to_use),
+	POWER_SUPPLY_ATTR(voltage_to_use),
 	/* Properties of type `const char *' */
 	POWER_SUPPLY_ATTR(model_name),
 	POWER_SUPPLY_ATTR(manufacturer),
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 204c18d..a41b510 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -116,6 +116,8 @@ enum power_supply_property {
 	POWER_SUPPLY_PROP_TIME_TO_FULL_NOW,
 	POWER_SUPPLY_PROP_TIME_TO_FULL_AVG,
 	POWER_SUPPLY_PROP_TYPE, /* use power_supply.type instead */
+	POWER_SUPPLY_PROP_CHARGE_TO_USE,
+	POWER_SUPPLY_PROP_VOLTAGE_TO_USE,
 	/* Properties of type `const char *' */
 	POWER_SUPPLY_PROP_MODEL_NAME,
 	POWER_SUPPLY_PROP_MANUFACTURER,
@@ -228,6 +230,7 @@ static inline bool power_supply_is_amp_property(enum power_supply_property psp)
 	case POWER_SUPPLY_PROP_CURRENT_MAX:
 	case POWER_SUPPLY_PROP_CURRENT_NOW:
 	case POWER_SUPPLY_PROP_CURRENT_AVG:
+	case POWER_SUPPLY_PROP_CHARGE_TO_USE:
 		return 1;
 	default:
 		break;
@@ -252,6 +255,7 @@ static inline bool power_supply_is_watt_property(enum power_supply_property psp)
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
 	case POWER_SUPPLY_PROP_VOLTAGE_AVG:
 	case POWER_SUPPLY_PROP_POWER_NOW:
+	case POWER_SUPPLY_PROP_VOLTAGE_TO_USE:
 		return 1;
 	default:
 		break;
-- 
1.7.6


