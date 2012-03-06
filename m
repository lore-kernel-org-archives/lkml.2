Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226Ab2CFB4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 20:56:11 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:46373 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758110Ab2CFB4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 20:56:10 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of axel.lin@gmail.com designates 10.68.194.3 as permitted sender) smtp.mail=axel.lin@gmail.com; dkim=pass header.i=axel.lin@gmail.com
Message-ID: <1330998965.3708.3.camel@phoenix>
Subject: [PATCH 2/2] regulator: wm8400: Use DIV_ROUND_UP macro to calculate
 selector
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Tue, 06 Mar 2012 09:56:05 +0800
In-Reply-To: <1330998862.3708.1.camel@phoenix>
References: <1330998862.3708.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use DIV_ROUND_UP macro for better readability.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm8400-regulator.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/wm8400-regulator.c b/drivers/regulator/wm8400-regulator.c
index 706f395..8477153 100644
--- a/drivers/regulator/wm8400-regulator.c
+++ b/drivers/regulator/wm8400-regulator.c
@@ -78,14 +78,14 @@ static int wm8400_ldo_set_voltage(struct regulator_dev *dev,
 
 	if (min_uV < 1700000) {
 		/* Steps of 50mV from 900mV;  */
-		val = (min_uV - 850001) / 50000;
+		val = DIV_ROUND_UP(min_uV - 900000, 50000);
 
 		if ((val * 50000) + 900000 > max_uV)
 			return -EINVAL;
 		BUG_ON((val * 50000) + 900000 < min_uV);
 	} else {
 		/* Steps of 100mV from 1700mV */
-		val = ((min_uV - 1600001) / 100000);
+		val = DIV_ROUND_UP(min_uV - 1700000, 100000);
 
 		if ((val * 100000) + 1700000 > max_uV)
 			return -EINVAL;
@@ -168,7 +168,7 @@ static int wm8400_dcdc_set_voltage(struct regulator_dev *dev,
 	if (min_uV < 850000)
 		return -EINVAL;
 
-	val = (min_uV - 825001) / 25000;
+	val = DIV_ROUND_UP(min_uV - 850000, 25000);
 
 	if (850000 + (25000 * val) > max_uV)
 		return -EINVAL;
-- 
1.7.5.4



