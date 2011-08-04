Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab1HDIS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 04:18:26 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61364 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab1HDISV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 04:18:21 -0400
Subject: [PATCH] regulator: 88pm8607: Fix off-by-one value range checking
 in the case of no id is matched
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Aug 2011 16:18:11 +0800
Message-ID: <1312445891.5448.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of no id is matched, the variable i is equal to
ARRAY_SIZE(pm8607_regulator_info).

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
I think compare variable i with ARRAY_SIZE(pm8607_regulator_info) here is slightly
better in readability than compare with PM8607_ID_RG_MAX.
Axel

 drivers/regulator/88pm8607.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/88pm8607.c b/drivers/regulator/88pm8607.c
index 5dcdb0f..ca0d608 100644
--- a/drivers/regulator/88pm8607.c
+++ b/drivers/regulator/88pm8607.c
@@ -413,7 +413,7 @@ static int __devinit pm8607_regulator_probe(struct platform_device *pdev)
 		if (info->desc.id == res->start)
 			break;
 	}
-	if ((i < 0) || (i > PM8607_ID_RG_MAX)) {
+	if (i == ARRAY_SIZE(pm8607_regulator_info)) {
 		dev_err(&pdev->dev, "Failed to find regulator %llu\n",
 			(unsigned long long)res->start);
 		return -EINVAL;
-- 
1.7.4.1



