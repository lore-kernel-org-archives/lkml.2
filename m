Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760602Ab1DPXqK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 19:46:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55936 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760507Ab1DPXpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 19:45:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 9/9] PM: Revert "driver core: platform_bus: allow runtime override of dev_pm_ops"
Date: Sun, 17 Apr 2011 01:44:14 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Kevin Hilman <khilman@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>,
        linux-sh@vger.kernel.org, lethal@linux-sh.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>
References: <201104130205.26988.rjw@sisk.pl> <201104170135.19388.rjw@sisk.pl>
In-Reply-To: <201104170135.19388.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104170144.15043.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Hilman <khilman@ti.com>

The platform_bus_set_pm_ops() operation is deprecated in favor of the
new device power domain infrastructre implemented in commit
7538e3db6e015e890825fbd9f8659952896ddd5b (PM: add support for device
power domains)

Signed-off-by: Kevin Hilman <khilman@ti.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/platform.c         |   35 -----------------------------------
 include/linux/platform_device.h |    3 ---
 2 files changed, 38 deletions(-)

Index: linux-2.6/drivers/base/platform.c
===================================================================
--- linux-2.6.orig/drivers/base/platform.c
+++ linux-2.6/drivers/base/platform.c
@@ -916,41 +916,6 @@ struct bus_type platform_bus_type = {
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
Index: linux-2.6/include/linux/platform_device.h
===================================================================
--- linux-2.6.orig/include/linux/platform_device.h
+++ linux-2.6/include/linux/platform_device.h
@@ -150,9 +150,6 @@ extern struct platform_device *platform_
 					struct resource *res, unsigned int n_res,
 					const void *data, size_t size);
 
-extern const struct dev_pm_ops * platform_bus_get_pm_ops(void);
-extern void platform_bus_set_pm_ops(const struct dev_pm_ops *pm);
-
 /* early platform driver interface */
 struct early_platform_driver {
 	const char *class_str;

