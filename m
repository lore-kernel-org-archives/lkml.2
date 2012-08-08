Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041Ab2HHMTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 08:19:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59460 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757968Ab2HHMTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 08:19:40 -0400
Message-ID: <1344428374.3199.3.camel@phoenix>
Subject: [PATCH 3/7] regulator: wm831x-isink: set_current_limit should
 select the maximum current in specific range
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Wed, 08 Aug 2012 20:19:34 +0800
In-Reply-To: <1344428238.3199.1.camel@phoenix>
References: <1344428238.3199.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm831x-isink.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/wm831x-isink.c b/drivers/regulator/wm831x-isink.c
index 0d207c2..5dba339 100644
--- a/drivers/regulator/wm831x-isink.c
+++ b/drivers/regulator/wm831x-isink.c
@@ -97,14 +97,13 @@ static int wm831x_isink_set_current(struct regulator_dev *rdev,
 {
 	struct wm831x_isink *isink = rdev_get_drvdata(rdev);
 	struct wm831x *wm831x = isink->wm831x;
-	int ret, i;
+	int i;
 
-	for (i = 0; i < ARRAY_SIZE(wm831x_isinkv_values); i++) {
+	for (i = ARRAY_SIZE(wm831x_isinkv_values) - 1; i >= 0; i--) {
 		int val = wm831x_isinkv_values[i];
 		if (min_uA <= val && val <= max_uA) {
-			ret = wm831x_set_bits(wm831x, isink->reg,
-					      WM831X_CS1_ISEL_MASK, i);
-			return ret;
+			return wm831x_set_bits(wm831x, isink->reg,
+					       WM831X_CS1_ISEL_MASK, i);
 		}
 	}
 
-- 
1.7.9.5



