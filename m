Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760067Ab2DKDHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 23:07:24 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36056 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760012Ab2DKDHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 23:07:23 -0400
Message-ID: <1334113637.7919.3.camel@phoenix>
Subject: [PATCH 2/2] regulator: twl-regulator: Use twlreg_grp helper function
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Tero Kristo <t-kristo@ti.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 11 Apr 2012 11:07:17 +0800
In-Reply-To: <1334113557.7919.2.camel@phoenix>
References: <1334113557.7919.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the twlreg_grp helper function is there, use it.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/twl-regulator.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index d9ba4c4..7385b27 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -175,15 +175,14 @@ static int twl6030reg_is_enabled(struct regulator_dev *rdev)
 	struct twlreg_info	*info = rdev_get_drvdata(rdev);
 	int			grp = 0, val;
 
-	if (!(twl_class_is_6030() && (info->features & TWL6025_SUBCLASS)))
-		grp = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_GRP);
-	if (grp < 0)
-		return grp;
-
-	if (!(twl_class_is_6030() && (info->features & TWL6025_SUBCLASS)))
+	if (!(twl_class_is_6030() && (info->features & TWL6025_SUBCLASS))) {
+		grp = twlreg_grp(rdev);
+		if (grp < 0)
+			return grp;
 		grp &= P1_GRP_6030;
-	else
+	} else {
 		grp = 1;
+	}
 
 	val = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_STATE);
 	val = TWL6030_CFG_STATE_APP(val);
@@ -197,7 +196,7 @@ static int twl4030reg_enable(struct regulator_dev *rdev)
 	int			grp;
 	int			ret;
 
-	grp = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_GRP);
+	grp = twlreg_grp(rdev);
 	if (grp < 0)
 		return grp;
 
@@ -215,7 +214,7 @@ static int twl6030reg_enable(struct regulator_dev *rdev)
 	int			ret;
 
 	if (!(twl_class_is_6030() && (info->features & TWL6025_SUBCLASS)))
-		grp = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_GRP);
+		grp = twlreg_grp(rdev);
 	if (grp < 0)
 		return grp;
 
@@ -245,7 +244,7 @@ static int twl4030reg_disable(struct regulator_dev *rdev)
 	int			grp;
 	int			ret;
 
-	grp = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_GRP);
+	grp = twlreg_grp(rdev);
 	if (grp < 0)
 		return grp;
 
@@ -357,7 +356,7 @@ static int twl6030reg_set_mode(struct regulator_dev *rdev, unsigned mode)
 	int val;
 
 	if (!(twl_class_is_6030() && (info->features & TWL6025_SUBCLASS)))
-		grp = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_GRP);
+		grp = twlreg_grp(rdev);
 
 	if (grp < 0)
 		return grp;
-- 
1.7.5.4



