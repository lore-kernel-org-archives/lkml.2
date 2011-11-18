Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab1KRIm0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 03:42:26 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:41305 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641Ab1KRImY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 03:42:24 -0500
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-i2c@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH] I2C: Make i2cdev_detach_adapter static
Date: Fri, 18 Nov 2011 14:12:11 +0530
Message-ID: <1321605731-3098-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function i2cdev_detach_adapter is used only in i2c-dev file
making it static.
Also removes the following sparse warning

drivers/i2c/i2c-dev.c:582:5: warning: symbol 'i2cdev_notifier_call'
was not declared. Should it be static?

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/i2c/i2c-dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
index c90ce50..57a45ce 100644
--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -579,7 +579,7 @@ static int i2cdev_detach_adapter(struct device *dev, void *dummy)
 	return 0;
 }
 
-int i2cdev_notifier_call(struct notifier_block *nb, unsigned long action,
+static int i2cdev_notifier_call(struct notifier_block *nb, unsigned long action,
 			 void *data)
 {
 	struct device *dev = data;
-- 
1.7.1

