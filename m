Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294Ab2KVSh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:37:26 -0500
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:53549 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753755Ab2KVShX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:37:23 -0500
From: Qing Xu <qingx@marvell.com>
To: qingx@marvell.com, broonie@opensource.wolfsonmicro.com, lrg@ti.com,
        haojian.zhuang@gmail.com, cxie4@marvell.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] regulator: max8925: fix compiler warnings
Date: Thu, 22 Nov 2012 10:11:06 +0800
Message-Id: <1353550266-21330-1-git-send-email-qingx@marvell.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 22 Nov 2012 02:10:03.0327 (UTC) FILETIME=[7BCB34F0:01CDC856]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qing Xu <qingx@marvell.com>

Fixed following compiler warning:

- drivers/regulator/max8925-regulator.c:269:51: warning:
  'regulator_idx' may be used uninitialized in this function
  [-Wmaybe-uninitialized]

Signed-off-by: Qing Xu <qingx@marvell.com>
---
 drivers/regulator/max8925-regulator.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/max8925-regulator.c b/drivers/regulator/max8925-regulator.c
index 2b54979..187b29b 100644
--- a/drivers/regulator/max8925-regulator.c
+++ b/drivers/regulator/max8925-regulator.c
@@ -282,7 +282,8 @@ static int __devinit max8925_regulator_probe(struct platform_device *pdev)
 	struct max8925_regulator_info *ri;
 	struct resource *res;
 	struct regulator_dev *rdev;
-	int i, regulator_idx;
+	int i;
+	int regulator_idx = 0;
 
 	res = platform_get_resource(pdev, IORESOURCE_REG, 0);
 	if (!res) {
-- 
1.7.0.4

