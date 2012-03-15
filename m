Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760799Ab2COIvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 04:51:13 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56251 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759172Ab2COIvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 04:51:10 -0400
From: Gerard Snitselaar <dev@snitselaar.org>
To: martyn.welch@ge.com, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: vme: fix section mismatches in linux-next 20120314
Date: Thu, 15 Mar 2012 01:50:39 -0700
Message-Id: <1331801439-30038-1-git-send-email-dev@snitselaar.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pio2_gpio_init() annotated with __init, but called by pio2_probe()
which is annotated __devinit. pio2_gpio_exit() is annotated __exit,
but is called by pio2_probe() and by pio2_remove() which is annotated
__devexit.

Signed-off-by: Gerard Snitselaar <dev@snitselaar.org>
---
 drivers/staging/vme/devices/vme_pio2.h      |    4 ++--
 drivers/staging/vme/devices/vme_pio2_gpio.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vme/devices/vme_pio2.h b/drivers/staging/vme/devices/vme_pio2.h
index 3c59313..72d9ce0 100644
--- a/drivers/staging/vme/devices/vme_pio2.h
+++ b/drivers/staging/vme/devices/vme_pio2.h
@@ -243,7 +243,7 @@ struct pio2_card {
 int pio2_cntr_reset(struct pio2_card *);
 
 int pio2_gpio_reset(struct pio2_card *);
-int __init pio2_gpio_init(struct pio2_card *);
-void __exit pio2_gpio_exit(struct pio2_card *);
+int __devinit pio2_gpio_init(struct pio2_card *);
+void pio2_gpio_exit(struct pio2_card *);
 
 #endif /* _VME_PIO2_H_ */
diff --git a/drivers/staging/vme/devices/vme_pio2_gpio.c b/drivers/staging/vme/devices/vme_pio2_gpio.c
index dc837de..8584849 100644
--- a/drivers/staging/vme/devices/vme_pio2_gpio.c
+++ b/drivers/staging/vme/devices/vme_pio2_gpio.c
@@ -187,7 +187,7 @@ int pio2_gpio_reset(struct pio2_card *card)
 	return 0;
 }
 
-int __init pio2_gpio_init(struct pio2_card *card)
+int __devinit pio2_gpio_init(struct pio2_card *card)
 {
 	int retval = 0;
 	char *label;
@@ -220,7 +220,7 @@ int __init pio2_gpio_init(struct pio2_card *card)
 	return retval;
 };
 
-void __exit pio2_gpio_exit(struct pio2_card *card)
+void pio2_gpio_exit(struct pio2_card *card)
 {
 	const char *label = card->gc.label;
 
-- 
1.7.7.6

