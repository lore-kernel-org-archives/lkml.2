Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288Ab0HTHbw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 03:31:52 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:65406 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab0HTHbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 03:31:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wJfFfvJE32IaHC/NIO3EsBlZzQdvbzEvB8DeS0mKJFjQ4kdKCDbeZ1fDk8orXBZ8Fh
         tNRsbpijtoVVINvSfH4Qjursz78B3cQRqHIPQZuZJMM+JVEl7LbKEcSu0dwIbw7wAqpC
         kmUPpzuZ7ltiMsdDn8jfUSpG80ZriUfnDX+a4=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: [PATCH] mmc: rename dev_to_mmc_card to mmc_dev_to_card
Date: Fri, 20 Aug 2010 10:32:31 +0300
Message-Id: <1282289551-12865-1-git-send-email-ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20100820002332.93b0c44d.akpm@linux-foundation.org>
References: <20100820002332.93b0c44d.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
---
 drivers/mmc/card/mmc_test.c |    2 +-
 drivers/mmc/core/bus.c      |   14 +++++++-------
 drivers/mmc/core/bus.h      |    2 +-
 include/linux/mmc/card.h    |    2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/card/mmc_test.c b/drivers/mmc/card/mmc_test.c
index 82d39bd..61253ee 100644
--- a/drivers/mmc/card/mmc_test.c
+++ b/drivers/mmc/card/mmc_test.c
@@ -1935,7 +1935,7 @@ static ssize_t mmc_test_show(struct device *dev,
 static ssize_t mmc_test_store(struct device *dev,
 	struct device_attribute *attr, const char *buf, size_t count)
 {
-	struct mmc_card *card = dev_to_mmc_card(dev);
+	struct mmc_card *card = mmc_to_dev_card(dev);
 	struct mmc_test_card *test;
 	int testcase;
 
diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
index 27326c4..1752097 100644
--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -27,7 +27,7 @@
 static ssize_t mmc_type_show(struct device *dev,
 	struct device_attribute *attr, char *buf)
 {
-	struct mmc_card *card = dev_to_mmc_card(dev);
+	struct mmc_card *card = mmc_to_dev_card(dev);
 
 	switch (card->type) {
 	case MMC_TYPE_MMC:
@@ -61,7 +61,7 @@ static int mmc_bus_match(struct device *dev, struct device_driver *drv)
 static int
 mmc_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
-	struct mmc_card *card = dev_to_mmc_card(dev);
+	struct mmc_card *card = mmc_to_dev_card(dev);
 	const char *type;
 	int retval = 0;
 
@@ -104,7 +104,7 @@ mmc_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
 static int mmc_bus_probe(struct device *dev)
 {
 	struct mmc_driver *drv = to_mmc_driver(dev->driver);
-	struct mmc_card *card = dev_to_mmc_card(dev);
+	struct mmc_card *card = mmc_to_dev_card(dev);
 
 	return drv->probe(card);
 }
@@ -112,7 +112,7 @@ static int mmc_bus_probe(struct device *dev)
 static int mmc_bus_remove(struct device *dev)
 {
 	struct mmc_driver *drv = to_mmc_driver(dev->driver);
-	struct mmc_card *card = dev_to_mmc_card(dev);
+	struct mmc_card *card = mmc_to_dev_card(dev);
 
 	drv->remove(card);
 
@@ -122,7 +122,7 @@ static int mmc_bus_remove(struct device *dev)
 static int mmc_bus_suspend(struct device *dev, pm_message_t state)
 {
 	struct mmc_driver *drv = to_mmc_driver(dev->driver);
-	struct mmc_card *card = dev_to_mmc_card(dev);
+	struct mmc_card *card = mmc_to_dev_card(dev);
 	int ret = 0;
 
 	if (dev->driver && drv->suspend)
@@ -133,7 +133,7 @@ static int mmc_bus_suspend(struct device *dev, pm_message_t state)
 static int mmc_bus_resume(struct device *dev)
 {
 	struct mmc_driver *drv = to_mmc_driver(dev->driver);
-	struct mmc_card *card = dev_to_mmc_card(dev);
+	struct mmc_card *card = mmc_to_dev_card(dev);
 	int ret = 0;
 
 	if (dev->driver && drv->resume)
@@ -188,7 +188,7 @@ EXPORT_SYMBOL(mmc_unregister_driver);
 
 static void mmc_release_card(struct device *dev)
 {
-	struct mmc_card *card = dev_to_mmc_card(dev);
+	struct mmc_card *card = mmc_to_dev_card(dev);
 
 	sdio_free_common_cis(card);
 
diff --git a/drivers/mmc/core/bus.h b/drivers/mmc/core/bus.h
index 7813954..74584af 100644
--- a/drivers/mmc/core/bus.h
+++ b/drivers/mmc/core/bus.h
@@ -14,7 +14,7 @@
 #define MMC_DEV_ATTR(name, fmt, args...)					\
 static ssize_t mmc_##name##_show (struct device *dev, struct device_attribute *attr, char *buf)	\
 {										\
-	struct mmc_card *card = dev_to_mmc_card(dev);				\
+	struct mmc_card *card = mmc_to_dev_card(dev);				\
 	return sprintf(buf, fmt, args);						\
 }										\
 static DEVICE_ATTR(name, S_IRUGO, mmc_##name##_show, NULL)
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 71acf19..e18bad4 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -173,7 +173,7 @@ static inline int mmc_blksz_for_byte_mode(const struct mmc_card *c)
 #define mmc_card_name(c)	((c)->cid.prod_name)
 #define mmc_card_id(c)		(dev_name(&(c)->dev))
 
-#define dev_to_mmc_card(d)	container_of(d, struct mmc_card, dev)
+#define mmc_to_dev_card(d)	container_of(d, struct mmc_card, dev)
 
 #define mmc_list_to_card(l)	container_of(l, struct mmc_card, node)
 #define mmc_get_drvdata(c)	dev_get_drvdata(&(c)->dev)
-- 
1.6.3.3

