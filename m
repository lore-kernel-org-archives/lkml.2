Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab2DQKHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 06:07:01 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63448 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab2DQKHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 06:07:00 -0400
Message-ID: <1334657210.7265.1.camel@phoenix>
Subject: [PATCH] regulator: max8660: Fix a memory leak due to missing
 devm_kzalloc conversion
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 17 Apr 2012 18:06:50 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 4d26f7 "regulator: max8660: Use devm_kzalloc()" missed to
replace kzalloc by devm_kzalloc. Fix it.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8660.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/max8660.c b/drivers/regulator/max8660.c
index 9997cfb..5d56817 100644
--- a/drivers/regulator/max8660.c
+++ b/drivers/regulator/max8660.c
@@ -370,7 +370,7 @@ static int __devinit max8660_probe(struct i2c_client *client,
 		return -EINVAL;
 	}
 
-	max8660 = kzalloc(sizeof(struct max8660) +
+	max8660 = devm_kzalloc(&client->dev, sizeof(struct max8660) +
 			sizeof(struct regulator_dev *) * MAX8660_V_END,
 			GFP_KERNEL);
 	if (!max8660)
-- 
1.7.5.4



