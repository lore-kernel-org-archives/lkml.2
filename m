Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab1BPV4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 16:56:21 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34032 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419Ab1BPV4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 16:56:02 -0500
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: kernel@pengutronix.de
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 2/2] Driver core: add typechecking to platform_{get,set}_drvdata
Date: Wed, 16 Feb 2011 22:55:51 +0100
Message-Id: <1297893351-2900-3-git-send-email-mkl@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297893351-2900-1-git-send-email-mkl@pengutronix.de>
References: <1297893351-2900-1-git-send-email-mkl@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the previously introduced BUILD_BUG_ON_NOT_SAME_TYPE to check if the
dev argument is a struct platform_device pointer.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 include/linux/platform_device.h |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 2e700ec..761a917 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -130,8 +130,14 @@ extern void platform_driver_unregister(struct platform_driver *);
 extern int platform_driver_probe(struct platform_driver *driver,
 		int (*probe)(struct platform_device *));
 
-#define platform_get_drvdata(_dev)	dev_get_drvdata(&(_dev)->dev)
-#define platform_set_drvdata(_dev,data)	dev_set_drvdata(&(_dev)->dev, (data))
+#define platform_get_drvdata(_dev)	({ \
+	BUILD_BUG_ON_NOT_SAME_TYPE((_dev), (struct platform_device *)NULL); \
+	dev_get_drvdata(&(_dev)->dev); \
+})
+#define platform_set_drvdata(_dev,data)	({ \
+	BUILD_BUG_ON_NOT_SAME_TYPE((_dev), (struct platform_device *)NULL); \
+	dev_set_drvdata(&(_dev)->dev, (data)); \
+})
 
 extern struct platform_device *platform_create_bundle(struct platform_driver *driver,
 					int (*probe)(struct platform_device *),
-- 
1.7.2.3

