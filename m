Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424051Ab2LGBsI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 20:48:08 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45490 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423243Ab2LGBsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 20:48:06 -0500
Message-ID: <1354844877.13831.1.camel@phoenix>
Subject: [PATCH] regulator: lp8788-ldo: Remove val array in
 lp8788_config_ldo_enable_mode
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "Milo(Woogyom) Kim" <milo.kim@ti.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 07 Dec 2012 09:47:57 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To clear the mask bit, setting data argument to be 0 with proper mask setting
for lp8788_update_bits. We don't need the var array here.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/lp8788-ldo.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/regulator/lp8788-ldo.c b/drivers/regulator/lp8788-ldo.c
index 9c1c253..3792741 100644
--- a/drivers/regulator/lp8788-ldo.c
+++ b/drivers/regulator/lp8788-ldo.c
@@ -662,14 +662,6 @@ static int lp8788_config_ldo_enable_mode(struct lp8788_ldo *ldo,
 		[EN_DLDO7]   = LP8788_EN_SEL_DLDO7_M,
 		[EN_DLDO911] = LP8788_EN_SEL_DLDO911_M,
 	};
-	u8 val[] = {
-		[EN_ALDO1]   = 0 << 5,
-		[EN_ALDO234] = 0 << 4,
-		[EN_ALDO5]   = 0 << 3,
-		[EN_ALDO7]   = 0 << 2,
-		[EN_DLDO7]   = 0 << 1,
-		[EN_DLDO911] = 0 << 0,
-	};
 
 	switch (id) {
 	case DLDO7:
@@ -708,8 +700,7 @@ static int lp8788_config_ldo_enable_mode(struct lp8788_ldo *ldo,
 	return ret;
 
 set_default_ldo_enable_mode:
-	return lp8788_update_bits(lp, LP8788_EN_SEL, en_mask[enable_id],
-				val[enable_id]);
+	return lp8788_update_bits(lp, LP8788_EN_SEL, en_mask[enable_id], 0);
 }
 
 static int lp8788_dldo_probe(struct platform_device *pdev)
-- 
1.7.9.5



