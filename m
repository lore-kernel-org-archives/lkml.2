Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab0LVGYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 01:24:19 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:40604 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab0LVGYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 01:24:14 -0500
Date: Wed, 22 Dec 2010 15:23:09 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v2 4/6] MFD MAX8998/LP3974 Bufgix: accessing array out of bound.
In-reply-to: <20101221155004.GA21871@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>, myungjoo.ham@gmail.com
Message-id: <1292998991-26968-5-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.1
Content-transfer-encoding: 7BIT
References: <20101221155004.GA21871@opensource.wolfsonmicro.com>
X-OriginalArrivalTime: 22 Dec 2010 06:23:11.0811 (UTC)
 FILETIME=[B5433130:01CBA1A0]
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
index 7c1478b..d183756 100644
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

