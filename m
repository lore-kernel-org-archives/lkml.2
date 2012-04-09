Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199Ab2DIOdB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 10:33:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44195 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755570Ab2DIOdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 10:33:00 -0400
Message-ID: <1333981969.9076.1.camel@phoenix>
Subject: [PATCH] regulator: twl-regulator: Simplify the code matching
 regulator id
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Tero Kristo <t-kristo@ti.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 09 Apr 2012 22:32:49 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the code easier to read.

Also add checking the case when no desc id is matched. This is required because
if no desc id is matched, the poiner info is pointed to twl_of_match[i].data
which may be not NULL. Checking info is NULL or not latter does not catch the
error.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/twl-regulator.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index 9cdfc38..964946f 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -1207,10 +1207,12 @@ static int __devinit twlreg_probe(struct platform_device *pdev)
 		initdata = pdev->dev.platform_data;
 		for (i = 0, info = NULL; i < ARRAY_SIZE(twl_of_match); i++) {
 			info = twl_of_match[i].data;
-			if (!info || info->desc.id != id)
-				continue;
-			break;
+			if (info && info->desc.id == id)
+				break;
 		}
+		if (i == ARRAY_SIZE(twl_of_match))
+			return -ENODEV;
+
 		drvdata = initdata->driver_data;
 		if (!drvdata)
 			return -EINVAL;
-- 
1.7.5.4



