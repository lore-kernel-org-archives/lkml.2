Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab0LWIob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 03:44:31 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:39339 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab0LWIoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 03:44:30 -0500
Date: Thu, 23 Dec 2010 17:44:28 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH] regulator MAX8998/LP3974 Bufgix: accessing array out of bound.
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com
Message-id: <1293093868-24037-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 23 Dec 2010 08:44:28.0242 (UTC)
 FILETIME=[9C05AB20:01CBA27D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous driver may access ldo_voltage_map[] out of its bound at
probe function at line 790 (drivers/regulator/max8998.c). This patch
allocates an entry for every regulator in order to avoid accessing
out-of-bounds.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/regulator/max8998.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index 6413e80..ed5253c 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -110,6 +110,11 @@ static const struct voltage_map_desc *ldo_voltage_map[] = {
 	&buck12_voltage_map_desc,	/* BUCK2 */
 	&buck3_voltage_map_desc,	/* BUCK3 */
 	&buck4_voltage_map_desc,	/* BUCK4 */
+	NULL,				/* EN32KHZ_AP */
+	NULL,				/* EN32KHZ_CP */
+	NULL,				/* ENVICHG */
+	NULL,				/* ESAFEOUT1 */
+	NULL,				/* ESAFEOUT2 */
 };
 
 static inline int max8998_get_ldo(struct regulator_dev *rdev)
-- 
1.7.1

