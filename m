Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab2LARMD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 12:12:03 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46625 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752675Ab2LARMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 12:12:00 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] mfd: wm5102: Add tuning for revision B
Date: Sun,  2 Dec 2012 02:11:52 +0900
Message-Id: <1354381913-26146-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354381913-26146-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1354381913-26146-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evaluation of revision B of WM5102 suggests updates to the register patch
for optimal performance, and make this the default behaviour for new
devices.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5102-tables.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
index 8bd0504..36708b0 100644
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@ -56,6 +56,18 @@ static const struct reg_default wm5102_reva_patch[] = {
 	{ 0x80, 0x0000 },
 };
 
+static const struct reg_default wm5102_revb_patch[] = {
+	{ 0x80, 0x0003 },
+	{ 0x081, 0xE022 },
+	{ 0x410, 0x6080 },
+	{ 0x418, 0x6080 },
+	{ 0x420, 0x6080 },
+	{ 0x428, 0xC000 },
+	{ 0x441, 0x8014 },
+	{ 0x458, 0x000b },
+	{ 0x80, 0x0000 },
+};
+
 /* We use a function so we can use ARRAY_SIZE() */
 int wm5102_patch(struct arizona *arizona)
 {
@@ -65,7 +77,9 @@ int wm5102_patch(struct arizona *arizona)
 					     wm5102_reva_patch,
 					     ARRAY_SIZE(wm5102_reva_patch));
 	default:
-		return 0;
+		return regmap_register_patch(arizona->regmap,
+					     wm5102_revb_patch,
+					     ARRAY_SIZE(wm5102_revb_patch));
 	}
 }
 
-- 
1.7.10.4

