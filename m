Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab2HTEAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:00:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38485 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab2HTEAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 00:00:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kris Karas <bugs-a12@moonlit-rail.com>, Hunt Xu <mhuntxu@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 15/46] drm/i915: make rc6 in sysfs functions conditional
Date: Sun, 19 Aug 2012 20:58:51 -0700
Message-Id: <20120820035834.393396419@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035832.274275502@linuxfoundation.org>
References: <20120820035832.274275502@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hunt Xu <mhuntxu@gmail.com>

commit 5ab3633d6907018b0b830a720e877c3884d679c3 upstream.

Commit 0136db586c028f71e7cc21cc183064ff0d5919c8 merges rc6 information
into the power group. However, when compiled with CONFIG_PM not set,
modprobing i915 would taint since power_group_name is defined as NULL.

This patch makes these rc6 in sysfs functions conditional upon the
definition of the CONFIG_PM macro to avoid the above-mentioned problem.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=45181
Tested-by: Kris Karas <bugs-a12@moonlit-rail.com>
Signed-off-by: Hunt Xu <mhuntxu@gmail.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_sysfs.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/gpu/drm/i915/i915_sysfs.c
+++ b/drivers/gpu/drm/i915/i915_sysfs.c
@@ -31,6 +31,7 @@
 #include <linux/sysfs.h>
 #include "i915_drv.h"
 
+#ifdef CONFIG_PM
 static u32 calc_residency(struct drm_device *dev, const u32 reg)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
@@ -109,3 +110,14 @@ void i915_teardown_sysfs(struct drm_devi
 {
 	sysfs_unmerge_group(&dev->primary->kdev.kobj, &rc6_attr_group);
 }
+#else
+void i915_setup_sysfs(struct drm_device *dev)
+{
+	return;
+}
+
+void i915_teardown_sysfs(struct drm_device *dev)
+{
+	return;
+}
+#endif /* CONFIG_PM */


