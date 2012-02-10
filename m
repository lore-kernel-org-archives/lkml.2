Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760977Ab2BJXPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:15:48 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45193 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760631Ab2BJWmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:42:06 -0500
MIME-Version: 1.0
Message-Id: <20120210222949.006885301@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:30:04 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Keith Packard <keithp@keithp.com>
Subject: [patch 45/86] drm/i915: convert force_wake_get to func pointer in the gpu reset code
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel@ffwll.ch>

commit 8109021313c7a3d8947677391ce6ab9cd0bb1d28 upstream.

This was forgotten in the original multi-threaded forcewake
conversion:

commit 8d715f0024f64ad1b1be85d8c081cf577944c847
Author: Keith Packard <keithp at keithp.com>
Date:   Fri Nov 18 20:39:01 2011 -0800

    drm/i915: add multi-threaded forcewake support

Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -645,7 +645,7 @@ int i915_reset(struct drm_device *dev, u
 		ret = gen6_do_reset(dev, flags);
 		/* If reset with a user forcewake, try to restore */
 		if (atomic_read(&dev_priv->forcewake_count))
-			__gen6_gt_force_wake_get(dev_priv);
+			dev_priv->display.force_wake_get(dev_priv);
 		break;
 	case 5:
 		ret = ironlake_do_reset(dev, flags);


