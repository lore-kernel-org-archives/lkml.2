Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056Ab2HHMVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 08:21:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46021 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758008Ab2HHMVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 08:21:36 -0400
Message-ID: <1344428490.3199.5.camel@phoenix>
Subject: [PATCH 5/7] regulator: tps6524x: set_current_limit should select
 the maximum current in specific range
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Cyril Chemparathy <cyril@ti.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 08 Aug 2012 20:21:30 +0800
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
 drivers/regulator/tps6524x-regulator.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/tps6524x-regulator.c b/drivers/regulator/tps6524x-regulator.c
index 947ece9..058d2f2 100644
--- a/drivers/regulator/tps6524x-regulator.c
+++ b/drivers/regulator/tps6524x-regulator.c
@@ -502,15 +502,13 @@ static int set_current_limit(struct regulator_dev *rdev, int min_uA,
 	if (info->n_ilimsels == 1)
 		return -EINVAL;
 
-	for (i = 0; i < info->n_ilimsels; i++)
+	for (i = info->n_ilimsels - 1; i >= 0; i--) {
 		if (min_uA <= info->ilimsels[i] &&
 		    max_uA >= info->ilimsels[i])
-			break;
-
-	if (i >= info->n_ilimsels)
-		return -EINVAL;
+			return write_field(hw, &info->ilimsel, i);
+	}
 
-	return write_field(hw, &info->ilimsel, i);
+	return -EINVAL;
 }
 
 static int get_current_limit(struct regulator_dev *rdev)
-- 
1.7.9.5



