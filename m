Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab1DEOrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 10:47:49 -0400
Received: from smtp.nokia.com ([147.243.128.26]:50647 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784Ab1DEOrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:47:46 -0400
From: Ilkka Koskinen <ilkka.koskinen@nokia.com>
To: eric.piel@tremplin-utc.net, mjg@redhat.com
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        samu.p.onkalo@nokia.com, ilkka.koskinen@nokia.com
Subject: [RFC PATCHv2 1/5] hwmon: lis3: Free regulators if probe() fails.
Date: Tue,  5 Apr 2011 17:45:10 +0300
Message-Id: <1302014714-7334-2-git-send-email-ilkka.koskinen@nokia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1302014714-7334-1-git-send-email-ilkka.koskinen@nokia.com>
References: <1302014714-7334-1-git-send-email-ilkka.koskinen@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
---
 drivers/misc/lis3lv02d/lis3lv02d_i2c.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/lis3lv02d/lis3lv02d_i2c.c b/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
index b20dfb4..ea9159c 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
@@ -161,8 +161,13 @@ static int __devinit lis3lv02d_i2c_probe(struct i2c_client *client,
 	if (lis3_dev.reg_ctrl)
 		lis3_reg_ctrl(&lis3_dev, LIS3_REG_OFF);
 
-	if (ret == 0)
-		return 0;
+	if (ret)
+		goto fail2;
+	return 0;
+
+fail2:
+	regulator_bulk_free(ARRAY_SIZE(lis3_dev.regulators),
+				lis3_dev.regulators);
 fail:
 	if (pdata && pdata->release_resources)
 		pdata->release_resources();
-- 
1.7.0.4

