Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab2FDLUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 07:20:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59796 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab2FDLUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 07:20:06 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, myungjoo.ham@samsung.com, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH 1/1] mfd: max8997: Add missing static storage class specifier
Date: Mon,  4 Jun 2012 16:39:07 +0530
Message-Id: <1338808147-1862-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following sparse warnings:
drivers/mfd/max8997.c:209:4: warning: symbol 'max8997_dumpaddr_pmic' was not declared. Should it be static?
drivers/mfd/max8997.c:334:4: warning: symbol 'max8997_dumpaddr_muic' was not declared. Should it be static?
drivers/mfd/max8997.c:344:4: warning: symbol 'max8997_dumpaddr_haptic' was not declared. Should it be static?
drivers/mfd/max8997.c:426:25: warning: symbol 'max8997_pm' was not declared. Should it be static?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/mfd/max8997.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
index cb83a7a..454f499 100644
--- a/drivers/mfd/max8997.c
+++ b/drivers/mfd/max8997.c
@@ -206,7 +206,7 @@ static const struct i2c_device_id max8997_i2c_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, max8998_i2c_id);
 
-u8 max8997_dumpaddr_pmic[] = {
+static u8 max8997_dumpaddr_pmic[] = {
 	MAX8997_REG_INT1MSK,
 	MAX8997_REG_INT2MSK,
 	MAX8997_REG_INT3MSK,
@@ -331,7 +331,7 @@ u8 max8997_dumpaddr_pmic[] = {
 	MAX8997_REG_DVSOKTIMER5,
 };
 
-u8 max8997_dumpaddr_muic[] = {
+static u8 max8997_dumpaddr_muic[] = {
 	MAX8997_MUIC_REG_INTMASK1,
 	MAX8997_MUIC_REG_INTMASK2,
 	MAX8997_MUIC_REG_INTMASK3,
@@ -341,7 +341,7 @@ u8 max8997_dumpaddr_muic[] = {
 	MAX8997_MUIC_REG_CONTROL3,
 };
 
-u8 max8997_dumpaddr_haptic[] = {
+static u8 max8997_dumpaddr_haptic[] = {
 	MAX8997_HAPTIC_REG_CONF1,
 	MAX8997_HAPTIC_REG_CONF2,
 	MAX8997_HAPTIC_REG_DRVCONF,
@@ -423,7 +423,7 @@ static int max8997_resume(struct device *dev)
 	return max8997_irq_resume(max8997);
 }
 
-const struct dev_pm_ops max8997_pm = {
+static const struct dev_pm_ops max8997_pm = {
 	.suspend = max8997_suspend,
 	.resume = max8997_resume,
 	.freeze = max8997_freeze,
-- 
1.7.4.1

