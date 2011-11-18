Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117Ab1KRPrn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 10:47:43 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:59478 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758105Ab1KRPri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 10:47:38 -0500
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-i2c@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH v2] I2C: Make i2cdev_notifier_call static
Date: Fri, 18 Nov 2011 21:17:31 +0530
Message-ID: <1321631251-4438-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function i2cdev_notifier_call is used only in i2c-dev file
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

