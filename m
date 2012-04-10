Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab2DJGUJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 02:20:09 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48509 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab2DJGUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 02:20:08 -0400
Message-ID: <1334038803.15859.14.camel@phoenix>
Subject: [PATCH RESEND 1/3] regulator: max8997: Use simple equation to get
 selector
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@smasung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 10 Apr 2012 14:20:03 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's more efficient to get the best selector by simple equation.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8997.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index 6e7beee..de752da 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -416,7 +416,7 @@ static inline int max8997_get_voltage_proper_val(
 		const struct voltage_map_desc *desc,
 		int min_vol, int max_vol)
 {
-	int i = 0;
+	int i;
 
 	if (desc == NULL)
 		return -EINVAL;
@@ -424,9 +424,10 @@ static inline int max8997_get_voltage_proper_val(
 	if (max_vol < desc->min || min_vol > desc->max)
 		return -EINVAL;
 
-	while (desc->min + desc->step * i < min_vol &&
-			desc->min + desc->step * i < desc->max)
-		i++;
+	if (min_vol < desc->min)
+		min_vol = desc->min;
+
+	i = DIV_ROUND_UP(min_vol - desc->min, desc->step);
 
 	if (desc->min + desc->step * i > max_vol)
 		return -EINVAL;
-- 
1.7.5.4



