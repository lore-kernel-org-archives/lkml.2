Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab1HIShh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 14:37:37 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:47481 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751239Ab1HIShg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 14:37:36 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] mfd/tc3589x: add missing #ifdef around PM block
Date: Tue, 9 Aug 2011 20:37:17 +0200
Message-ID: <1312915037-9716-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The CONFIG_PM code was unconditionally compiled in despite
the dev_pm_ops only being included into the driver struct
if used. Fix this by adding the missing #ifdef.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/tc3589x.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/tc3589x.c b/drivers/mfd/tc3589x.c
index c27e515..de97974 100644
--- a/drivers/mfd/tc3589x.c
+++ b/drivers/mfd/tc3589x.c
@@ -357,6 +357,7 @@ static int __devexit tc3589x_remove(struct i2c_client *client)
 	return 0;
 }
 
+#ifdef CONFIG_PM
 static int tc3589x_suspend(struct device *dev)
 {
 	struct tc3589x *tc3589x = dev_get_drvdata(dev);
@@ -387,6 +388,7 @@ static int tc3589x_resume(struct device *dev)
 
 static const SIMPLE_DEV_PM_OPS(tc3589x_dev_pm_ops, tc3589x_suspend,
 						tc3589x_resume);
+#endif
 
 static const struct i2c_device_id tc3589x_id[] = {
 	{ "tc3589x", 24 },
-- 
1.7.3.2

