Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab2EVIwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 04:52:21 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7873 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab2EVIwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 04:52:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 22 May 2012 01:52:16 -0700
From: Pritesh Raithatha <praithatha@nvidia.com>
To: <cbouatmailru@gmail.com>, <axel.lin@gmail.com>, <lars@metafoo.de>,
        <cabarnes@indesign-llc.com>
CC: <linux-kernel@vger.kernel.org>, <praithatha@nvidia.com>
Subject: [PATCH] gpio-charger: use cansleep version of gpio_set_value
Date: Tue, 22 May 2012 14:20:04 +0530
Message-ID: <1337676604-22836-1-git-send-email-praithatha@nvidia.com>
X-Mailer: git-send-email 1.7.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Context of gpio_charger_get_property is sleepable so we should
use gpio_set_value_cansleep instead of gpio_set_value.

It will remove WARN_ON incase of using gpio from i2c-to-gpio
expander like pca953x.

Signed-off-by: Pritesh Raithatha <praithatha@nvidia.com>
---
 drivers/power/gpio-charger.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/power/gpio-charger.c b/drivers/power/gpio-charger.c
index 8672c91..cb2aa31 100644
--- a/drivers/power/gpio-charger.c
+++ b/drivers/power/gpio-charger.c
@@ -54,7 +54,7 @@ static int gpio_charger_get_property(struct power_supply *psy,
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_ONLINE:
-		val->intval = gpio_get_value(pdata->gpio);
+		val->intval = gpio_get_value_cansleep(pdata->gpio);
 		val->intval ^= pdata->gpio_active_low;
 		break;
 	default:
-- 
1.7.1

