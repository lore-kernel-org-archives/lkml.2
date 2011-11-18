Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303Ab1KSAJF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 19:09:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38400 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758282Ab1KSAJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 19:09:03 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Nov 18 16:00:04 2011
Message-Id: <20111119000004.407781487@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Fri, 18 Nov 2011 15:58:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Anholt <eric@anholt.net>,
        Keith Packard <keithp@keithp.com>
Subject: [05/26] drm/i915: Fix object refcount leak on mmappable size limit error path.
In-Reply-To: <20111119000026.GA6679@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Anholt <eric@anholt.net>

commit 14660ccd599dc7bd6ecef17408bd76dc853f9b77 upstream.

I've been seeing memory leaks on my system in the form of large
(300-400MB) GEM objects created by now-dead processes laying around
clogging up memory.  I usually notice when it gets to about 1.2GB of
them.  Hopefully this clears up the issue, but I just found this bug
by inspection.

Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_gem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1475,7 +1475,7 @@ i915_gem_mmap_gtt(struct drm_file *file,
 
 	if (obj->base.size > dev_priv->mm.gtt_mappable_end) {
 		ret = -E2BIG;
-		goto unlock;
+		goto out;
 	}
 
 	if (obj->madv != I915_MADV_WILLNEED) {


