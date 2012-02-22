Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138Ab2BVDnv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 22:43:51 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51524 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab2BVDnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 22:43:50 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of axel.lin@gmail.com designates 10.68.196.161 as permitted sender) smtp.mail=axel.lin@gmail.com; dkim=pass header.i=axel.lin@gmail.com
Message-ID: <1329882220.4193.0.camel@phoenix>
Subject: [PATCH] mfd: Remove unused io_lock mutex from da9052
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ashish Jangam <ashish.jangam@kpitcummins.com>,
        David Dajun Chen <dchen@diasemi.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 22 Feb 2012 11:43:40 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

da9052 has been converted to use regmap API, so we can remove the unused
io_lock mutex.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/da9052-core.c         |    3 ---
 include/linux/mfd/da9052/da9052.h |    2 --
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/da9052-core.c b/drivers/mfd/da9052-core.c
index 5ddde2a..7ff313f 100644
--- a/drivers/mfd/da9052-core.c
+++ b/drivers/mfd/da9052-core.c
@@ -16,7 +16,6 @@
 #include <linux/input.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
-#include <linux/mutex.h>
 #include <linux/mfd/core.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -647,8 +646,6 @@ int __devinit da9052_device_init(struct da9052 *da9052, u8 chip_id)
 	struct irq_desc *desc;
 	int ret;
 
-	mutex_init(&da9052->io_lock);
-
 	if (pdata && pdata->init != NULL)
 		pdata->init(da9052);
 
diff --git a/include/linux/mfd/da9052/da9052.h b/include/linux/mfd/da9052/da9052.h
index 5702d1b..7ffbd6e 100644
--- a/include/linux/mfd/da9052/da9052.h
+++ b/include/linux/mfd/da9052/da9052.h
@@ -76,8 +76,6 @@ enum da9052_chip_id {
 struct da9052_pdata;
 
 struct da9052 {
-	struct mutex io_lock;
-
 	struct device *dev;
 	struct regmap *regmap;
 
-- 
1.7.5.4



