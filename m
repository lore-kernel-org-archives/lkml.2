Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440Ab0JVS4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:56:47 -0400
Received: from kroah.org ([198.145.64.141]:34240 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759303Ab0JVS4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:41 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:32 2010
Message-Id: <20101022185232.849541551@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [061/103] drm/i915: Prevent module unload to avoid random memory corruption
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 6939a5aca7cfada279a24c307e772f33104fca20 upstream.

The i915 driver has quite a few module unload bugs, the known ones at
least have fixes that are targeting 2.6.37. However, in order to
maintain a stable kernel, we should prevent this known random memory
corruption following driver unload. This should have very low impact on
normal users who are unlikely to need to unload the i915 driver.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_dma.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -2222,6 +2222,9 @@ int i915_driver_load(struct drm_device *
 	dev_priv->mchdev_lock = &mchdev_lock;
 	spin_unlock(&mchdev_lock);
 
+	/* XXX Prevent module unload due to memory corruption bugs. */
+	__module_get(THIS_MODULE);
+
 	return 0;
 
 out_workqueue_free:


