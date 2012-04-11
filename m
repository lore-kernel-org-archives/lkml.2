Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275Ab2DKMyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 08:54:09 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:54381 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab2DKMyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 08:54:08 -0400
Message-ID: <1334148838.8687.1.camel@phoenix>
Subject: [PATCH] regulator: Fix the logic to ensure new voltage setting in
 valid range
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@smasung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 11 Apr 2012 20:53:58 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think this is a typo.
To ensure new voltage setting won't greater than desc->max,
the equation should be desc->min + desc->step * new_val <= desc->max.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8997.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index db09244..77feeeb 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -682,7 +682,7 @@ static int max8997_set_voltage_buck(struct regulator_dev *rdev,
 		}
 
 		new_val++;
-	} while (desc->min + desc->step + new_val <= desc->max);
+	} while (desc->min + desc->step * new_val <= desc->max);
 
 	new_idx = tmp_idx;
 	new_val = tmp_val;
-- 
1.7.5.4



