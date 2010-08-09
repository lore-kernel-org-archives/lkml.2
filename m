Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639Ab0HIH4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 03:56:21 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50315 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab0HIH4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 03:56:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=MiUelcaRed0pnJcfpAjahRJr28H/U1F0zYoNxMjl1tZEbk27Nlq9WROSf0erTvFrrI
         y0nVu9GHCgmry85ARBdZrBDDvrqFjdEFjP+IVrqmO1BRPNnQwTsZcOsBGakpoVmv5l/w
         kpU6vQI8LFbTJC43c5nV5Lb5dF7oVEx72sPcA=
Subject: [PATCH] regulator: tps6586x - add regulator_unregister() in
	tps6586x_regulator_remove()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Mike Rapoport <mike@compulab.co.il>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Content-Type: text/plain
Date: Mon, 09 Aug 2010 15:58:06 +0800
Message-Id: <1281340686.20518.4.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps6586x-regulator.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index 3c2eee8..122193b 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -357,13 +357,16 @@ static int __devinit tps6586x_regulator_probe(struct platform_device *pdev)
 		return PTR_ERR(rdev);
 	}
 
-	platform_set_drvdata(pdev, ri);
+	platform_set_drvdata(pdev, rdev);
 
 	return 0;
 }
 
 static int __devexit tps6586x_regulator_remove(struct platform_device *pdev)
 {
+	struct regulator_dev *rdev = platform_get_drvdata(pdev);
+
+	regulator_unregister(rdev);
 	return 0;
 }
 
-- 
1.5.4.3



