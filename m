Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528Ab2C0HS7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 03:18:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63569 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651Ab2C0HS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 03:18:57 -0400
Message-ID: <1332832733.9942.3.camel@phoenix>
Subject: [PATCH 2/4] regulator: wm831x-isink: Fix the logic to choose best
 current limit setting
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 27 Mar 2012 15:18:53 +0800
In-Reply-To: <1332832646.9942.1.camel@phoenix>
References: <1332832646.9942.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code in wm831x_isink_set_current actually set the current limit setting
smaller than specified range.

Fix the logic in wm831x_isink_set_current to choose the smallest current limit
setting falls within the specified range.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm831x-isink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/wm831x-isink.c b/drivers/regulator/wm831x-isink.c
index 634aac3..b414e09 100644
--- a/drivers/regulator/wm831x-isink.c
+++ b/drivers/regulator/wm831x-isink.c
@@ -101,7 +101,7 @@ static int wm831x_isink_set_current(struct regulator_dev *rdev,
 
 	for (i = 0; i < ARRAY_SIZE(wm831x_isinkv_values); i++) {
 		int val = wm831x_isinkv_values[i];
-		if (min_uA >= val && val <= max_uA) {
+		if (min_uA <= val && val <= max_uA) {
 			ret = wm831x_set_bits(wm831x, isink->reg,
 					      WM831X_CS1_ISEL_MASK, i);
 			return ret;
-- 
1.7.5.4



