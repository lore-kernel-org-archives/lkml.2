Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab0G3Sbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:31:55 -0400
Received: from kroah.org ([198.145.64.141]:58134 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759429Ab0G3RzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:55:03 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:38 2010
Message-Id: <20100730175138.672205842@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:51:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel J Blueman <daniel.blueman@gmail.com>,
        Eric Anholt <eric@anholt.net>
Subject: [056/205] i915: fix lock imbalance on error path...
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel J Blueman <daniel.blueman@gmail.com>

commit f953c9353f5fe6e98fa7f32f51060a74d845b5f8 upstream.

While investigating Intel i5 Arrandale GPU lockups with -rc4, I
noticed a lock imbalance.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_drv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -341,6 +341,7 @@ int i965_reset(struct drm_device *dev, u
 		}
 	} else {
 		DRM_ERROR("Error occurred. Don't know how to reset this chip.\n");
+		mutex_unlock(&dev->struct_mutex);
 		return -ENODEV;
 	}
 


