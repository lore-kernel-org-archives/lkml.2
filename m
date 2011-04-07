Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220Ab1DGADB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 20:03:01 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:42527 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757140Ab1DGAC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 20:02:59 -0400
From: Kevin Hilman <khilman@ti.com>
To: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-sh@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        "Rafael J. Wysocki" <rjw@suse.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH/RFC 6/6] Revert "driver core: platform_bus: allow runtime override of dev_pm_ops"
Date: Wed,  6 Apr 2011 17:02:49 -0700
Message-Id: <1302134569-22825-7-git-send-email-khilman@ti.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1302134569-22825-1-git-send-email-khilman@ti.com>
References: <1302134569-22825-1-git-send-email-khilman@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit c64a0926710153b9d44c979d2942f4a8648fd74e.

The platform_bus_set_pm_ops() is deprecated in favor of the new device
power domain infrastructre implemented in commit
7538e3db6e015e890825fbd9f8659952896ddd5b (PM: add support for device
power domains)

Signed-off-by: Kevin Hilman <khilman@ti.com>
---
 drivers/base/platform.c         |   35 -----------------------------------
 include/linux/platform_device.h |    3 ---
 2 files changed, 0 insertions(+), 38 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index f051cff..46335ca 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -976,41 +976,6 @@ struct bus_type platform_bus_type = {
 };
 EXPORT_SYMBOL_GPL(platform_bus_type);
 
-/**
- * platform_bus_get_pm_ops() - return pointer to busses dev_pm_ops
- *
- * This function can be used by platform code to get the current
- * set of dev_pm_ops functions used by the platform_bus_type.
- */
-const struct dev_pm_ops * __init platform_bus_get_pm_ops(void)
-{
-	return platform_bus_type.pm;
-}
-
-/**
- * platform_bus_set_pm_ops() - update dev_pm_ops for the platform_bus_type
- *
- * @pm: pointer to new dev_pm_ops struct to be used for platform_bus_type
- *
- * Platform code can override the dev_pm_ops methods of
- * platform_bus_type by using this function.  It is expected that
- * platform code will first do a platform_bus_get_pm_ops(), then
- * kmemdup it, then customize selected methods and pass a pointer to
- * the new struct dev_pm_ops to this function.
- *
- * Since platform-specific code is customizing methods for *all*
- * devices (not just platform-specific devices) it is expected that
- * any custom overrides of these functions will keep existing behavior
- * and simply extend it.  For example, any customization of the
- * runtime PM methods should continue to call the pm_generic_*
- * functions as the default ones do in addition to the
- * platform-specific behavior.
- */
-void __init platform_bus_set_pm_ops(const struct dev_pm_ops *pm)
-{
-	platform_bus_type.pm = pm;
-}
-
 int __init platform_bus_init(void)
 {
 	int error;
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index d96db98..53745dc 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -145,9 +145,6 @@ extern struct platform_device *platform_create_bundle(struct platform_driver *dr
 					struct resource *res, unsigned int n_res,
 					const void *data, size_t size);
 
-extern const struct dev_pm_ops * platform_bus_get_pm_ops(void);
-extern void platform_bus_set_pm_ops(const struct dev_pm_ops *pm);
-
 /* early platform driver interface */
 struct early_platform_driver {
 	const char *class_str;
-- 
1.7.4

