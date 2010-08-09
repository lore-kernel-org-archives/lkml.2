Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab0HIDZo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 23:25:44 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:65313 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab0HIDZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 23:25:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=p+tVsdPa4J6GJKxFYw3H7etDmcsl7TedpevaoraweatqrcLLCiBIOZBJYFDtGaK82g
         I2YPVh1maUpBC74kJUDGFdnaZGD38gLTXL4TQWgCc0vFy7aSNCnbl6IHTifxEj9z/kap
         iQmYme3WaBmAMSofWH4prrm+UgH5J+w/6+Rug=
Subject: [PATCH] regulator: tps6507x - add missing platform_set_drvdata in
	tps6507x_pmic_probe
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anuj Aggarwal <anuj.aggarwal@ti.com>
Content-Type: text/plain
Date: Mon, 09 Aug 2010 11:27:25 +0800
Message-Id: <1281324445.12901.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should call platform_set_drvdata() before calling platform_get_drvdata().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps6507x-regulator.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/tps6507x-regulator.c b/drivers/regulator/tps6507x-regulator.c
index 8152d65..fbe21f7 100644
--- a/drivers/regulator/tps6507x-regulator.c
+++ b/drivers/regulator/tps6507x-regulator.c
@@ -614,6 +614,7 @@ int tps6507x_pmic_probe(struct platform_device *pdev)
 	}
 
 	tps6507x_dev->pmic = tps;
+	platform_set_drvdata(pdev, tps6507x_dev);
 
 	return 0;
 
@@ -640,6 +641,7 @@ static int __devexit tps6507x_pmic_remove(struct platform_device *pdev)
 	for (i = 0; i < TPS6507X_NUM_REGULATOR; i++)
 		regulator_unregister(tps->rdev[i]);
 
+	platform_set_drvdata(pdev, NULL);
 	kfree(tps);
 
 	return 0;
-- 
1.5.4.3



