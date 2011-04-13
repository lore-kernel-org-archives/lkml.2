Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270Ab1DMO4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 10:56:18 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:41583 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757149Ab1DMO4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 10:56:14 -0400
X-ASG-Debug-ID: 1302706573-082c4b8f0001-xx1T2L
X-Barracuda-Envelope-From: haojian.zhuang@marvell.com
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: sameo@linux.intel.com, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
X-ASG-Orig-Subj: [PATCH 13/13] regulator: max8925: enable i2c sequence for control
Subject: [PATCH 13/13] regulator: max8925: enable i2c sequence for control
Date: Wed, 13 Apr 2011 22:51:04 +0800
X-ASG-Orig-Subj: [PATCH 13/13] regulator: max8925: enable i2c sequence for control
Message-Id: <1302706264-25815-14-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1302706264-25815-13-git-send-email-haojian.zhuang@marvell.com>
References: <2011041301>
 <1302706264-25815-1-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-2-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-3-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-4-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-5-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-6-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-7-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-8-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-9-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-10-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-11-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-12-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-13-git-send-email-haojian.zhuang@marvell.com>
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1302706573
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Force to enable i2c as power up/down sequence. Otherwise, SD/LDO can't
be enabled or disabled via accessing i2c bus.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/max8925-regulator.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/max8925-regulator.c b/drivers/regulator/max8925-regulator.c
index ce821e4..2dd2fd9 100644
--- a/drivers/regulator/max8925-regulator.c
+++ b/drivers/regulator/max8925-regulator.c
@@ -23,6 +23,10 @@
 #define SD1_DVM_SHIFT		5		/* SDCTL1 bit5 */
 #define SD1_DVM_EN		6		/* SDV1 bit 6 */
 
+/* bit definitions in SD & LDO control registers */
+#define OUT_ENABLE   		0x1f		/* Power U/D sequence as I2C */
+#define OUT_DISABLE		0x1e		/* Power U/D sequence as I2C */
+
 struct max8925_regulator_info {
 	struct regulator_desc	desc;
 	struct regulator_dev	*regulator;
@@ -93,8 +97,8 @@ static int max8925_enable(struct regulator_dev *rdev)
 	struct max8925_regulator_info *info = rdev_get_drvdata(rdev);
 
 	return max8925_set_bits(info->i2c, info->enable_reg,
-				1 << info->enable_bit,
-				1 << info->enable_bit);
+				OUT_ENABLE << info->enable_bit,
+				OUT_ENABLE << info->enable_bit);
 }
 
 static int max8925_disable(struct regulator_dev *rdev)
@@ -102,7 +106,8 @@ static int max8925_disable(struct regulator_dev *rdev)
 	struct max8925_regulator_info *info = rdev_get_drvdata(rdev);
 
 	return max8925_set_bits(info->i2c, info->enable_reg,
-				1 << info->enable_bit, 0);
+				OUT_ENABLE << info->enable_bit,
+				OUT_DISABLE << info->enable_bit);
 }
 
 static int max8925_is_enabled(struct regulator_dev *rdev)
-- 
1.5.6.5

