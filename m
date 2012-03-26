Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950Ab2CZSPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 14:15:19 -0400
Received: from mga14.intel.com ([143.182.124.37]:12893 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932638Ab2CZSPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 14:15:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="123437493"
From: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Subject: [PATCH] max17042_battery: fix driver exit function
Date: Mon, 26 Mar 2012 15:38:26 +0530
Message-Id: <1332756506-6905-1-git-send-email-ramakrishna.pallala@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch frees the irq and sets the i2c client
data to NULL in driver remove function.

Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
---
 drivers/power/max17042_battery.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index abf3400..d4868c5 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -721,6 +721,10 @@ static int __devexit max17042_remove(struct i2c_client *client)
 	struct max17042_chip *chip = i2c_get_clientdata(client);
 
 	power_supply_unregister(&chip->battery);
+	if (client->irq)
+		free_irq(client->irq, chip);
+	i2c_set_clientdata(client, NULL);
+
 	return 0;
 }
 
-- 
1.7.0.4

