Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab2DBBOi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 21:14:38 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:36211 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab2DBBOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 21:14:37 -0400
Message-ID: <1333329268.8048.1.camel@phoenix>
Subject: [PATCH 1/2] regulator: Set list_voltage callback for max8925
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 02 Apr 2012 09:14:28 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code implements max8925_list_voltage but does not set the list_voltage
callback function in max8925_regulator_[ldo|sdv]_ops. Fix it.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8925-regulator.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/max8925-regulator.c b/drivers/regulator/max8925-regulator.c
index 2f242f4..ad8b093 100644
--- a/drivers/regulator/max8925-regulator.c
+++ b/drivers/regulator/max8925-regulator.c
@@ -163,6 +163,7 @@ static int max8925_set_dvm_disable(struct regulator_dev *rdev)
 }
 
 static struct regulator_ops max8925_regulator_sdv_ops = {
+	.list_voltage		= max8925_list_voltage,
 	.set_voltage		= max8925_set_voltage,
 	.get_voltage		= max8925_get_voltage,
 	.enable			= max8925_enable,
@@ -174,6 +175,7 @@ static struct regulator_ops max8925_regulator_sdv_ops = {
 };
 
 static struct regulator_ops max8925_regulator_ldo_ops = {
+	.list_voltage		= max8925_list_voltage,
 	.set_voltage		= max8925_set_voltage,
 	.get_voltage		= max8925_get_voltage,
 	.enable			= max8925_enable,
-- 
1.7.5.4



