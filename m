Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab1LCIUy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 03:20:54 -0500
Received: from www17.your-server.de ([213.133.104.17]:58082 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab1LCIUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 03:20:52 -0500
Subject: [PATCH] drm/i915: Use kcalloc instead of kzalloc to allocate array
From: Thomas Meyer <thomas@m3y3r.de>
To: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.297.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The advantage of kcalloc is, that will prevent integer overflows which could
result from the multiplication of number of elements and size and it is also
a bit nicer to read.

The semantic patch that makes this change is available
in https://lkml.org/lkml/2011/11/25/107

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel_bios.c
--- a/drivers/gpu/drm/i915/intel_bios.c 2011-11-13 11:07:23.820113543 +0100
+++ b/drivers/gpu/drm/i915/intel_bios.c 2011-11-28 19:49:51.443206904 +0100
@@ -572,7 +572,7 @@ parse_device_mapping(struct drm_i915_pri
 		DRM_DEBUG_KMS("no child dev is parsed from VBT\n");
 		return;
 	}
-	dev_priv->child_dev = kzalloc(sizeof(*p_child) * count, GFP_KERNEL);
+	dev_priv->child_dev = kcalloc(count, sizeof(*p_child), GFP_KERNEL);
 	if (!dev_priv->child_dev) {
 		DRM_DEBUG_KMS("No memory space for child device\n");
 		return;
