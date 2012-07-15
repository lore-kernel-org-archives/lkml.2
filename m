Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab2GOWEw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 18:04:52 -0400
Received: from queueout04-winn.ispmail.ntl.com ([81.103.221.58]:21114 "EHLO
	queueout04-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751003Ab2GOWEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 18:04:50 -0400
From: Daniel Drake <dsd@laptop.org>
To: cbou@mail.ru, dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, pgf@laptop.org, richard@laptop.org
Subject: [PATCH 2/2] olpc-battery: update CHARGE_FULL_DESIGN property for BYD LiFe batteries
Message-Id: <20120715214352.27F8C9D401E@zog.reactivated.net>
Date: Sun, 15 Jul 2012 22:43:51 +0100 (BST)
X-Cloudmark-Analysis: v=1.1 cv=AUhbpHVS+xhHrj9wLCYAQoYnFLYUZdbP8UM0GmH2jwk= c=1 sm=0 a=ZnH0VqctNHUA:10 a=vJ1w_8FsMGIA:10 a=Op-mwl0xAAAA:8 a=i4SUSGMWO3v0mh3mqmkA:9 a=d4CUUju0HPYA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard A. Smith <richard@laptop.org>

Reduce the mAh value for the BYD LiFe battery from 3100mAh to 2800mAh
to better reflect the average usable capacity as measured by olpc-pwr-log.

Signed-off-by: Richard A. Smith <richard@laptop.org>
Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/power/olpc_battery.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
index b98f531..debf797 100644
--- a/drivers/power/olpc_battery.c
+++ b/drivers/power/olpc_battery.c
@@ -231,11 +231,9 @@ static int olpc_bat_get_charge_full_design(union power_supply_propval *val)
 
 	case POWER_SUPPLY_TECHNOLOGY_LiFe:
 		switch (mfr) {
-		case 1: /* Gold Peak */
-			val->intval = 2800000;
-			break;
+		case 1: /* Gold Peak, fall through */
 		case 2: /* BYD */
-			val->intval = 3100000;
+			val->intval = 2800000;
 			break;
 		default:
 			return -EIO;
-- 
1.7.10.4

