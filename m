Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab0CSPVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 11:21:44 -0400
Received: from kroah.org ([198.145.64.141]:45923 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658Ab0CSPTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 11:19:05 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jani Nikula <ext-jani.1.nikula@nokia.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 11/12] driver-core: document ERR_PTR() return values
Date: Fri, 19 Mar 2010 08:18:54 -0700
Message-Id: <1269011935-8886-11-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <20100319151311.GA8541@kroah.com>
References: <20100319151311.GA8541@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jani Nikula <ext-jani.1.nikula@nokia.com>

A number of functions in the driver core return ERR_PTR() values on
error. Document this in the kernel-doc of the functions.

Signed-off-by: Jani Nikula <ext-jani.1.nikula@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/class.c    |    2 ++
 drivers/base/core.c     |    6 ++++++
 drivers/base/platform.c |    6 ++++++
 3 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index 0147f47..9c6a0d6 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -219,6 +219,8 @@ static void class_create_release(struct class *cls)
  * This is used to create a struct class pointer that can then be used
  * in calls to device_create().
  *
+ * Returns &struct class pointer on success, or ERR_PTR() on error.
+ *
  * Note, the pointer created here is to be destroyed when finished by
  * making a call to class_destroy().
  */
diff --git a/drivers/base/core.c b/drivers/base/core.c
index ef55df3..b56a0ba 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1345,6 +1345,8 @@ static void root_device_release(struct device *dev)
  * 'module' symlink which points to the @owner directory
  * in sysfs.
  *
+ * Returns &struct device pointer on success, or ERR_PTR() on error.
+ *
  * Note: You probably want to use root_device_register().
  */
 struct device *__root_device_register(const char *name, struct module *owner)
@@ -1432,6 +1434,8 @@ static void device_create_release(struct device *dev)
  * Any further sysfs files that might be required can be created using this
  * pointer.
  *
+ * Returns &struct device pointer on success, or ERR_PTR() on error.
+ *
  * Note: the struct class passed to this function must have previously
  * been created with a call to class_create().
  */
@@ -1492,6 +1496,8 @@ EXPORT_SYMBOL_GPL(device_create_vargs);
  * Any further sysfs files that might be required can be created using this
  * pointer.
  *
+ * Returns &struct device pointer on success, or ERR_PTR() on error.
+ *
  * Note: the struct class passed to this function must have previously
  * been created with a call to class_create().
  */
diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index f6bcf22..4b4b565 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -362,6 +362,8 @@ EXPORT_SYMBOL_GPL(platform_device_unregister);
  * enumeration tasks, they don't fully conform to the Linux driver model.
  * In particular, when such drivers are built as modules, they can't be
  * "hotplugged".
+ *
+ * Returns &struct platform_device pointer on success, or ERR_PTR() on error.
  */
 struct platform_device *platform_device_register_simple(const char *name,
 							int id,
@@ -408,6 +410,8 @@ EXPORT_SYMBOL_GPL(platform_device_register_simple);
  * allocated for the device allows drivers using such devices to be
  * unloaded without waiting for the last reference to the device to be
  * dropped.
+ *
+ * Returns &struct platform_device pointer on success, or ERR_PTR() on error.
  */
 struct platform_device *platform_device_register_data(
 		struct device *parent,
@@ -559,6 +563,8 @@ EXPORT_SYMBOL_GPL(platform_driver_probe);
  *
  * Use this in legacy-style modules that probe hardware directly and
  * register a single platform device and corresponding platform driver.
+ *
+ * Returns &struct platform_device pointer on success, or ERR_PTR() on error.
  */
 struct platform_device * __init_or_module platform_create_bundle(
 			struct platform_driver *driver,
-- 
1.7.0.2

