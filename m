Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab2EEHRa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 03:17:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:14651 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153Ab2EEHR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 03:17:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="140384324"
From: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Subject: [PATCH] max17042_battery: Handle irq request failure case
Date: Sat,  5 May 2012 04:43:10 +0530
Message-Id: <1336173190-30003-1-git-send-email-ramakrishna.pallala@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

suspend/resume functions take action based upon the fuel gauge
interrupt. If the rquest irq fails we should assign 0 to client->irq.

Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
---
 drivers/power/max17042_battery.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index 3c16724..db776a2 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -707,9 +707,11 @@ static int __devinit max17042_probe(struct i2c_client *client,
 			reg |= CONFIG_ALRT_BIT_ENBL;
 			max17042_write_reg(client, MAX17042_CONFIG, reg);
 			max17042_set_soc_threshold(chip, 1);
-		} else
+		} else {
+			client->irq = 0;
 			dev_err(&client->dev, "%s(): cannot get IRQ\n",
 				__func__);
+		}
 	}
 
 	reg = max17042_read_reg(chip->client, MAX17042_STATUS);
-- 
1.7.0.4

