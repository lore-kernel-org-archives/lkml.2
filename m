Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929Ab0H0IeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 04:34:15 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:47096 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab0H0IeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 04:34:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=VXvjijwiA+KdKPepZBW4lNN76wLQwsF+JIIMXmrDQsHmcLwlTN4p5JYa+IadrOod39
         pii997IR9t2xSo6Wuy4XgoVrpyPRtAnPqqZXgAjm17A+wAjLhk2Z2JoZlkpiUgifM36Y
         HemV+I1GUn7pfpjkNKypwhRpEHHGVn+vHPGYc=
Subject: [PATCH] regulator: set max8998->dev to &pdev->dev.
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain
Date: Fri, 27 Aug 2010 16:37:34 +0800
Message-Id: <1282898254.1971.4.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

max8998->dev is NULL in current implementation, set it to &pdev->dev.

regulator_register() still return success if max8998->dev is NULL,
but rdev->dev.parent will be set to NULL which is incorrect.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8998.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index 8b9bfdf..a1baf1f 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -557,6 +557,7 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 	}
 
 	rdev = max8998->rdev;
+	max8998->dev = &pdev->dev;
 	max8998->iodev = iodev;
 	max8998->num_regulators = pdata->num_regulators;
 	platform_set_drvdata(pdev, max8998);
-- 
1.7.2



