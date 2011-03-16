Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab1CPVZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:25:11 -0400
Received: from kroah.org ([198.145.64.141]:42698 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754374Ab1CPVME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:12:04 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Marc Kleine-Budde <mkl@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 32/50] Driver core: convert platform_{get,set}_drvdata to static inline functions
Date: Wed, 16 Mar 2011 14:11:10 -0700
Message-Id: <1300309888-5028-32-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300309888-5028-1-git-send-email-gregkh@suse.de>
References: <20110316205204.GA2686@kroah.com>
 <1300309888-5028-1-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

This patch converts the macros for platform_{get,set}_drvdata to
static inline functions to add typechecking.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
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
1.7.4.1

