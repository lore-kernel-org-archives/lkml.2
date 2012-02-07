Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab2BGDNB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 22:13:01 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38773 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782Ab2BGDNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 22:13:00 -0500
Message-ID: <1328584375.5528.3.camel@phoenix>
Subject: [PATCH] regulator: Fix getting voltage in max8649_enable_time()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jonghwan Choi <jhbird.choi@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Tue, 07 Feb 2012 11:12:55 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code takes wrong parameter while calling max8649_list_voltage.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8649.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/max8649.c b/drivers/regulator/max8649.c
index 636dfd4..f724644 100644
--- a/drivers/regulator/max8649.c
+++ b/drivers/regulator/max8649.c
@@ -150,7 +150,7 @@ static int max8649_enable_time(struct regulator_dev *rdev)
 	if (ret != 0)
 		return ret;
 	val &= MAX8649_VOL_MASK;
-	voltage = max8649_list_voltage(rdev, (unsigned char)ret); /* uV */
+	voltage = max8649_list_voltage(rdev, (unsigned char)val); /* uV */
 
 	/* get rate */
 	ret = regmap_read(info->regmap, MAX8649_RAMP, &val);
-- 
1.7.5.4



