Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab1GYPYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 11:24:53 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:60942 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab1GYPYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 11:24:45 -0400
X-Spam-Flag: NO
X-Spam-Score: -21.869
Message-ID: <4E2D8A11.4020809@tremplin-utc.net>
Date: Mon, 25 Jul 2011 17:21:53 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Mandriva/3.1.11-1 (2011.0) Thunderbird/3.1.11
MIME-Version: 1.0
CC: Ilkka Koskinen <ilkka.koskinen@nokia.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 07/10] lis3: Free regulators if probe() fails.
References: <4E2D8858.8000900@tremplin-utc.net>
In-Reply-To: <4E2D8858.8000900@tremplin-utc.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
Signed-off-by: Éric Piel <eric.piel@tremplin-utc.net>
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
1.7.6

