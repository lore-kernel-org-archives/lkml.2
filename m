Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab1ATVrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 16:47:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55300 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755137Ab1ATVrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 16:47:14 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kyungmin Park <kyungmin.park@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Staticise non-exported symbols in MAX8998 driver
Date: Thu, 20 Jan 2011 21:47:31 +0000
Message-Id: <1295560051-4054-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to have them in the global namespace and sparse complains.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/max8998.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
index bbfe867..c002142 100644
--- a/drivers/mfd/max8998.c
+++ b/drivers/mfd/max8998.c
@@ -233,7 +233,7 @@ struct max8998_reg_dump {
 	u8	val;
 };
 #define SAVE_ITEM(x)	{ .addr = (x), .val = 0x0, }
-struct max8998_reg_dump max8998_dump[] = {
+static struct max8998_reg_dump max8998_dump[] = {
 	SAVE_ITEM(MAX8998_REG_IRQM1),
 	SAVE_ITEM(MAX8998_REG_IRQM2),
 	SAVE_ITEM(MAX8998_REG_IRQM3),
@@ -298,7 +298,7 @@ static int max8998_restore(struct device *dev)
 	return 0;
 }
 
-const struct dev_pm_ops max8998_pm = {
+static const struct dev_pm_ops max8998_pm = {
 	.suspend = max8998_suspend,
 	.resume = max8998_resume,
 	.freeze = max8998_freeze,
-- 
1.7.2.3

