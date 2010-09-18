Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336Ab0IRTRz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:17:55 -0400
Received: from kroah.org ([198.145.64.141]:43952 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757277Ab0IRTQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:16:34 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:07 2010
Message-Id: <20100918191307.743332084@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:13:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <error27@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [122/129] i915_gem: return -EFAULT if copy_to_user fails
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

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
@@ -3709,6 +3709,7 @@ i915_gem_do_execbuffer(struct drm_device
 		if (ret != 0) {
 			DRM_ERROR("copy %d cliprects failed: %d\n",
 				  args->num_cliprects, ret);
+			ret = -EFAULT;
 			goto pre_mutex_err;
 		}
 	}


