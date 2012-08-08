Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078Ab2HHMYB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 08:24:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47659 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757931Ab2HHMX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 08:23:59 -0400
Message-ID: <1344428634.3199.8.camel@phoenix>
Subject: [PATCH 7/7] regulator: da9052: set_current_limit should select the
 maximum current in specific range
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Wed, 08 Aug 2012 20:23:54 +0800
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
 drivers/regulator/da9052-regulator.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/da9052-regulator.c b/drivers/regulator/da9052-regulator.c
index 903299c..27355b1 100644
--- a/drivers/regulator/da9052-regulator.c
+++ b/drivers/regulator/da9052-regulator.c
@@ -133,8 +133,8 @@ static int da9052_dcdc_set_current_limit(struct regulator_dev *rdev, int min_uA,
 	    max_uA < da9052_current_limits[row][DA9052_MIN_UA])
 		return -EINVAL;
 
-	for (i = 0; i < DA9052_CURRENT_RANGE; i++) {
-		if (min_uA <= da9052_current_limits[row][i]) {
+	for (i = DA9052_CURRENT_RANGE - 1; i >= 0; i--) {
+		if (da9052_current_limits[row][i] <= max_uA) {
 			reg_val = i;
 			break;
 		}
-- 
1.7.9.5



