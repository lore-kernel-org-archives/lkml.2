Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab1BPWXl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:23:41 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54437 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857Ab1BPWXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 17:23:38 -0500
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: kernel@pengutronix.de, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH v2] Driver core: convert platform_{get,set}_drvdata to static inline functions
Date: Wed, 16 Feb 2011 23:23:27 +0100
Message-Id: <1297895007-2104-1-git-send-email-mkl@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the macros for platform_{get,set}_drvdata to
static inline functions to add typechecking.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
Changes since v1:
- remove ugly macro magic, use static inline functions instead

 include/linux/platform_device.h |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 2e700ec..d96db98 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -130,8 +130,15 @@ extern void platform_driver_unregister(struct platform_driver *);
 extern int platform_driver_probe(struct platform_driver *driver,
 		int (*probe)(struct platform_device *));
 
-#define platform_get_drvdata(_dev)	dev_get_drvdata(&(_dev)->dev)
-#define platform_set_drvdata(_dev,data)	dev_set_drvdata(&(_dev)->dev, (data))
+static inline void *platform_get_drvdata(const struct platform_device *pdev)
+{
+	return dev_get_drvdata(&pdev->dev);
+}
+
+static inline void platform_set_drvdata(struct platform_device *pdev, void *data)
+{
+	dev_set_drvdata(&pdev->dev, data);
+}
 
 extern struct platform_device *platform_create_bundle(struct platform_driver *driver,
 					int (*probe)(struct platform_device *),
-- 
1.7.2.3

