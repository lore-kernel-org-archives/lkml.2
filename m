Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab2HABPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 21:15:22 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:41012 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab2HABPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 21:15:21 -0400
Message-ID: <1343783711.8776.1.camel@phoenix>
Subject: [PATCH] regulator: wm8400: Simplify set REGULATOR_MODE_IDLE mode in
 wm8400_dcdc_set_mode
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Wed, 01 Aug 2012 09:15:11 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To set REGULATOR_MODE_IDLE mode, what we do is to clear DC1_ACTIVE and
DC1_SLEEP bits, this can be done in one wm8400_set_bits() call.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm8400-regulator.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/regulator/wm8400-regulator.c b/drivers/regulator/wm8400-regulator.c
index 9035dd0..27c746e 100644
--- a/drivers/regulator/wm8400-regulator.c
+++ b/drivers/regulator/wm8400-regulator.c
@@ -120,13 +120,8 @@ static int wm8400_dcdc_set_mode(struct regulator_dev *dev, unsigned int mode)
 
 	case REGULATOR_MODE_IDLE:
 		/* Datasheet: standby */
-		ret = wm8400_set_bits(wm8400, WM8400_DCDC1_CONTROL_1 + offset,
-				      WM8400_DC1_ACTIVE, 0);
-		if (ret != 0)
-			return ret;
 		return wm8400_set_bits(wm8400, WM8400_DCDC1_CONTROL_1 + offset,
-				       WM8400_DC1_SLEEP, 0);
-
+				       WM8400_DC1_ACTIVE | WM8400_DC1_SLEEP, 0);
 	default:
 		return -EINVAL;
 	}
-- 
1.7.9.5



