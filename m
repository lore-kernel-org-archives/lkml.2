Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab1LHVxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 16:53:39 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60385 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036Ab1LHVxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 16:53:37 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: kernel@pengutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers_base: make argument to platform_device_register_full const
Date: Thu,  8 Dec 2011 22:53:29 +0100
Message-Id: <1323381209-20643-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.7.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

platform_device_register_full doesn't modify *pdevinfo so it can be
marked as const without further adaptions.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/base/platform.c         |    2 +-
 include/linux/platform_device.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 7a24895..a7c0637 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -383,7 +383,7 @@ EXPORT_SYMBOL_GPL(platform_device_unregister);
  * Returns &struct platform_device pointer on success, or ERR_PTR() on error.
  */
 struct platform_device *platform_device_register_full(
-		struct platform_device_info *pdevinfo)
+		const struct platform_device_info *pdevinfo)
 {
 	int ret = -ENOMEM;
 	struct platform_device *pdev;
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 2a23f7d..8007e33 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -63,7 +63,7 @@ struct platform_device_info {
 		u64 dma_mask;
 };
 extern struct platform_device *platform_device_register_full(
-		struct platform_device_info *pdevinfo);
+		const struct platform_device_info *pdevinfo);
 
 /**
  * platform_device_register_resndata - add a platform-level device with
-- 
1.7.7.3

