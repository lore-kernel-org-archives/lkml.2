Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760591Ab0G3TNo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 15:13:44 -0400
Received: from kroah.org ([198.145.64.141]:46335 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756801Ab0G3RSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:18:10 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:02 2010
Message-Id: <20100730171502.551939522@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:14:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel J Blueman <daniel.blueman@gmail.com>,
        Eric Anholt <eric@anholt.net>
Subject: [032/165] i915: fix lock imbalance on error path...
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

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
@@ -192,6 +192,7 @@ int i965_reset(struct drm_device *dev, u
 		}
 	} else {
 		DRM_ERROR("Error occurred. Don't know how to reset this chip.\n");
+		mutex_unlock(&dev->struct_mutex);
 		return -ENODEV;
 	}
 


