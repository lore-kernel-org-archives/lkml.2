Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933647Ab2GFLYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:24:21 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:43947 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933021Ab2GFLYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:24:19 -0400
Message-ID: <1341573852.6611.3.camel@phoenix>
Subject: [PATCH 1/2] regulator: max8952: Remove wrong set_suspend_disable
 callback setting
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>, Liam Girdwood <lrg@ti.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 06 Jul 2012 19:24:12 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the same ops for both .disable and .set_suspend_disable callbacks is
actively broken. This patch removes .set_suspend_disable callback setting.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8952.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
index 910c9b2..ea58a44 100644
--- a/drivers/regulator/max8952.c
+++ b/drivers/regulator/max8952.c
@@ -151,7 +151,6 @@ static struct regulator_ops max8952_ops = {
 	.disable		= max8952_disable,
 	.get_voltage_sel	= max8952_get_voltage_sel,
 	.set_voltage_sel	= max8952_set_voltage_sel,
-	.set_suspend_disable	= max8952_disable,
 };
 
 static const struct regulator_desc regulator = {
-- 
1.7.9.5



