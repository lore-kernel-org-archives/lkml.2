Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762033Ab2FHJWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 05:22:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42353 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760567Ab2FHJWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 05:22:17 -0400
Message-ID: <1339147304.5216.1.camel@phoenix>
Subject: [PATCH RFT] regulator: max77686: Fix the delay time for
 set_voltage_time_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Chiwoong Byun <woong.byun@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Fri, 08 Jun 2012 17:21:44 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rdev->desc->uV_step * abs(new_selector - old_selector) returns uV.
The unit of ramp_rate is mV/us.
Thus 1000 should be multiplied.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max77686.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index b76a038..10bf65a 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -78,7 +78,7 @@ static int max77686_set_dvs_voltage_time_sel(struct regulator_dev *rdev,
 
 	return DIV_ROUND_UP(rdev->desc->uV_step *
 			    abs(new_selector - old_selector),
-			    ramp_rate[max77686->ramp_delay]);
+			    ramp_rate[max77686->ramp_delay] * 1000);
 }
 
 static int max77686_set_voltage_time_sel(struct regulator_dev *rdev,
@@ -86,7 +86,7 @@ static int max77686_set_voltage_time_sel(struct regulator_dev *rdev,
 {
 	/* Unconditionally 100 mV/us */
 	return DIV_ROUND_UP(rdev->desc->uV_step *
-			    abs(new_selector - old_selector), 100);
+			    abs(new_selector - old_selector), 100 * 1000);
 }
 
 static struct regulator_ops max77686_ops = {
-- 
1.7.9.5



