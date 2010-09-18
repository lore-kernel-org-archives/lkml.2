Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329Ab0IRTFo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:05:44 -0400
Received: from kroah.org ([198.145.64.141]:51934 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756231Ab0IRTCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:02:31 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:00:03 2010
Message-Id: <20100918190003.194341604@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:59:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <error27@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [121/123] i915_gem: return -EFAULT if copy_to_user fails
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=i915-return-efault-if-copy_to_user-fails-2.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

commit c877cdce93a44eea96f6cf7fc04be7d0372db2be upstream.

copy_to_user() returns the number of bytes remaining to be copied and
I'm pretty sure we want to return a negative error code here.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_gem.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -3667,6 +3667,7 @@ i915_gem_execbuffer(struct drm_device *d
 		if (ret != 0) {
 			DRM_ERROR("copy %d cliprects failed: %d\n",
 				  args->num_cliprects, ret);
+			ret = -EFAULT;
 			goto pre_mutex_err;
 		}
 	}


