Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab0ISMzJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 08:55:09 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44711 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408Ab0ISMzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 08:55:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=XUXokCCXeE8vBzCuN/RCKsYbvdcq3HMSMg7vUxE6H+F4IcQWnx3QBjJ6IPzugta0SG
         pVmHywbWjHjH3d4N6DumC5dJ+tIfxu/+j9R7HafhNPVqQX+Inf6i3on3JNH6Y5bxUOd0
         wUZY0eFQtFetW8b3oOBUGHAt6R1FKugJtSjm8=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jani Nikula <ext-jani.1.nikula@nokia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 08/14] regulator: fix device_register() error handling
Date: Sun, 19 Sep 2010 16:55:01 +0400
Message-Id: <1284900901-24537-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If device_register() fails then call put_device().
See comment to device_register.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 compile tested.

 drivers/regulator/core.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 422a709..a43eedb 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2302,8 +2302,10 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
 	dev_set_name(&rdev->dev, "regulator.%d",
 		     atomic_inc_return(&regulator_no) - 1);
 	ret = device_register(&rdev->dev);
-	if (ret != 0)
+	if (ret != 0) {
+		put_device(&rdev->dev);
 		goto clean;
+	}
 
 	dev_set_drvdata(&rdev->dev, rdev);
 
-- 
1.7.0.4

