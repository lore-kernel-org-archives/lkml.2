Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499Ab0DWIAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 04:00:48 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:38572 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756395Ab0DWIAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 04:00:40 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 01/14] platform: Make platform resource input parameters const
Date: Fri, 23 Apr 2010 10:00:22 +0200
Message-Id: <1272009635-6504-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1272009635-6504-1-git-send-email-geert@linux-m68k.org>
References: <1272009635-6504-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the platform resource input parameters of platform_device_add_resources()
and platform_device_register_simple() const, as the resources are copied and
never modified.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c         |    4 ++--
 include/linux/platform_device.h |    6 ++++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 4b4b565..c5fbe19 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -187,7 +187,7 @@ EXPORT_SYMBOL_GPL(platform_device_alloc);
  * released.
  */
 int platform_device_add_resources(struct platform_device *pdev,
-				  struct resource *res, unsigned int num)
+				  const struct resource *res, unsigned int num)
 {
 	struct resource *r;
 
@@ -367,7 +367,7 @@ EXPORT_SYMBOL_GPL(platform_device_unregister);
  */
 struct platform_device *platform_device_register_simple(const char *name,
 							int id,
-							struct resource *res,
+							const struct resource *res,
 							unsigned int num)
 {
 	struct platform_device *pdev;
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 212da17..5417944 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -44,12 +44,14 @@ extern int platform_get_irq_byname(struct platform_device *, const char *);
 extern int platform_add_devices(struct platform_device **, int);
 
 extern struct platform_device *platform_device_register_simple(const char *, int id,
-					struct resource *, unsigned int);
+					const struct resource *, unsigned int);
 extern struct platform_device *platform_device_register_data(struct device *,
 		const char *, int, const void *, size_t);
 
 extern struct platform_device *platform_device_alloc(const char *name, int id);
-extern int platform_device_add_resources(struct platform_device *pdev, struct resource *res, unsigned int num);
+extern int platform_device_add_resources(struct platform_device *pdev,
+					 const struct resource *res,
+					 unsigned int num);
 extern int platform_device_add_data(struct platform_device *pdev, const void *data, size_t size);
 extern int platform_device_add(struct platform_device *pdev);
 extern void platform_device_del(struct platform_device *pdev);
-- 
1.6.0.4

