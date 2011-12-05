Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797Ab1LEX63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 18:58:29 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16814 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932719Ab1LEX61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 18:58:27 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 05 Dec 2011 15:58:23 -0800
From: Rhyland Klein <rklein@nvidia.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 2/2] Added parameter for selection power supply name from pdata
Date: Mon,  5 Dec 2011 15:57:03 -0800
Message-Id: <1323129423-24705-2-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323129423-24705-1-git-send-email-rklein@nvidia.com>
References: <1323129423-24705-1-git-send-email-rklein@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change-Id: Ib0a41ff9ac8c1fc97aa7a87320f8d95be7988d71
Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 drivers/power/sbs-battery.c       |    2 +-
 include/linux/power/sbs-battery.h |    2 ++
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/power/sbs-battery.c b/drivers/power/sbs-battery.c
index 1e60a54..567b8c1 100644
--- a/drivers/power/sbs-battery.c
+++ b/drivers/power/sbs-battery.c
@@ -615,7 +615,7 @@ static int __devinit sbs_probe(struct i2c_client *client,
 	chip->client = client;
 	chip->enable_detection = false;
 	chip->gpio_detect = false;
-	chip->power_supply.name = "battery";
+	chip->power_supply.name = (pdata->power_supply_name ? : "battery");
 	chip->power_supply.type = POWER_SUPPLY_TYPE_BATTERY;
 	chip->power_supply.properties = sbs_properties;
 	chip->power_supply.num_properties = ARRAY_SIZE(sbs_properties);
diff --git a/include/linux/power/sbs-battery.h b/include/linux/power/sbs-battery.h
index 2b0a9d9..fa9bc89 100644
--- a/include/linux/power/sbs-battery.h
+++ b/include/linux/power/sbs-battery.h
@@ -31,12 +31,14 @@
  * @i2c_retry_count:		# of times to retry on i2c IO failure
  * @poll_retry_count:		# of times to retry looking for new status after
  *				external change notification
+ * @power_supply_name:		Optional name for power supply: default: battery
  */
 struct sbs_platform_data {
 	int battery_detect;
 	int battery_detect_present;
 	int i2c_retry_count;
 	int poll_retry_count;
+	const char *power_supply_name;
 };
 
 #endif
-- 
1.7.0.4

