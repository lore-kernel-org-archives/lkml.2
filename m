Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965050Ab2CBIVG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 03:21:06 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50034 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617Ab2CBIVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 03:21:04 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of axel.lin@gmail.com designates 10.68.223.161 as permitted sender) smtp.mail=axel.lin@gmail.com; dkim=pass header.i=axel.lin@gmail.com
Message-ID: <1330676454.31023.0.camel@phoenix>
Subject: [PATCH 1/3] regulator: ad5398: Use DIV_ROUND_UP macro to calculate
 selector
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sonic Zhang <sonic.zhang@analog.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 02 Mar 2012 16:20:54 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/ad5398.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/ad5398.c b/drivers/regulator/ad5398.c
index 483c809..26d23ad 100644
--- a/drivers/regulator/ad5398.c
+++ b/drivers/regulator/ad5398.c
@@ -94,8 +94,8 @@ static int ad5398_set_current_limit(struct regulator_dev *rdev, int min_uA, int
 	if (max_uA > chip->max_uA || max_uA < chip->min_uA)
 		return -EINVAL;
 
-	selector = ((min_uA - chip->min_uA) * chip->current_level +
-			range_uA - 1) / range_uA;
+	selector = DIV_ROUND_UP((min_uA - chip->min_uA) * chip->current_level,
+				range_uA);
 	if (ad5398_calc_current(chip, selector) > max_uA)
 		return -EINVAL;
 
-- 
1.7.5.4



