Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485Ab2HHKeN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 06:34:13 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:51775 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804Ab2HHKeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 06:34:12 -0400
X-Greylist: delayed 1238 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Aug 2012 06:34:11 EDT
From: Ilya Shchepetkov <shchepetkov@ispras.ru>
To: Chris Verges <chrisv@cyberswitching.com>
Cc: Ilya Shchepetkov <shchepetkov@ispras.ru>,
        Christian Pellegrin <chripell@fsfe.org>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH] rtc-pcf2123: Initialize dynamic sysfs attributes
Date: Wed,  8 Aug 2012 14:11:25 +0400
Message-Id: <1344420685-30727-1-git-send-email-shchepetkov@ispras.ru>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically allocated sysfs attributes must be initialized using
sysfs_attr_init(), otherwise lockdep complains:
BUG: key <address> not in .data!

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Ilya Shchepetkov <shchepetkov@ispras.ru>
---
 drivers/rtc/rtc-pcf2123.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/rtc-pcf2123.c b/drivers/rtc/rtc-pcf2123.c
index 8361187..13e4df6 100644
--- a/drivers/rtc/rtc-pcf2123.c
+++ b/drivers/rtc/rtc-pcf2123.c
@@ -43,6 +43,7 @@
 #include <linux/rtc.h>
 #include <linux/spi/spi.h>
 #include <linux/module.h>
+#include <linux/sysfs.h>
 
 #define DRV_VERSION "0.6"
 
@@ -292,6 +293,7 @@ static int __devinit pcf2123_probe(struct spi_device *spi)
 	pdata->rtc = rtc;
 
 	for (i = 0; i < 16; i++) {
+		sysfs_attr_init(&pdata->regs[i].attr.attr);
 		sprintf(pdata->regs[i].name, "%1x", i);
 		pdata->regs[i].attr.attr.mode = S_IRUGO | S_IWUSR;
 		pdata->regs[i].attr.attr.name = pdata->regs[i].name;
-- 
1.7.7

