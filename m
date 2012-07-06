Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933656Ab2GFLZP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:25:15 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:47448 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932632Ab2GFLZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:25:13 -0400
Message-ID: <1341573907.6611.4.camel@phoenix>
Subject: [PATCH 2/2] regulator: max8998: Remove wrong
 set_suspend_[en|dis]able callback settings
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>, Liam Girdwood <lrg@ti.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 06 Jul 2012 19:25:07 +0800
In-Reply-To: <1341573852.6611.3.camel@phoenix>
References: <1341573852.6611.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the same ops for both [en|dis]able and set_suspend_[en|dis]able
callbacks is actively broken. This patch removes .set_suspend_disable and
.set_suspend_enable callback setting.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8998.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index a1fa266..5dfa920 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -460,8 +460,6 @@ static struct regulator_ops max8998_ldo_ops = {
 	.disable		= max8998_ldo_disable,
 	.get_voltage_sel	= max8998_get_voltage_sel,
 	.set_voltage_sel	= max8998_set_voltage_ldo_sel,
-	.set_suspend_enable	= max8998_ldo_enable,
-	.set_suspend_disable	= max8998_ldo_disable,
 };
 
 static struct regulator_ops max8998_buck_ops = {
@@ -473,16 +471,12 @@ static struct regulator_ops max8998_buck_ops = {
 	.get_voltage_sel	= max8998_get_voltage_sel,
 	.set_voltage_sel	= max8998_set_voltage_buck_sel,
 	.set_voltage_time_sel	= max8998_set_voltage_buck_time_sel,
-	.set_suspend_enable	= max8998_ldo_enable,
-	.set_suspend_disable	= max8998_ldo_disable,
 };
 
 static struct regulator_ops max8998_others_ops = {
 	.is_enabled		= max8998_ldo_is_enabled,
 	.enable			= max8998_ldo_enable,
 	.disable		= max8998_ldo_disable,
-	.set_suspend_enable	= max8998_ldo_enable,
-	.set_suspend_disable	= max8998_ldo_disable,
 };
 
 static struct regulator_desc regulators[] = {
-- 
1.7.9.5



