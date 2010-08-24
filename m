Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923Ab0HXW6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:58:51 -0400
Received: from kroah.org ([198.145.64.141]:40400 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932895Ab0HXW6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:58:45 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:42:15 2010
Message-Id: <20100824224215.076926353@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:41:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Eric Anholt <eric@anholt.net>
Subject: [35/91] drm/i915: fixup pageflip ringbuffer commands for i8xx
In-Reply-To: <20100824224617.GA5440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 69d0b96c095468526009cb3104eee561c9252a84 upstream.

Add a new path for 2nd gen chips that uses the commands for i81x
chips (where public docs do exist) augmented with the plane bits
from i915. It seems to work and doesn't result in a black screen
like before.

Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[anholt: resolved against conflict]
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_display.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -4311,11 +4311,17 @@ static int intel_crtc_page_flip(struct d
 		OUT_RING(offset | obj_priv->tiling_mode);
 		pipesrc = I915_READ(pipesrc_reg); 
 		OUT_RING(pipesrc & 0x0fff0fff);
-	} else {
+	} else if (IS_GEN3(dev)) {
 		OUT_RING(MI_DISPLAY_FLIP_I915 |
 			 MI_DISPLAY_FLIP_PLANE(intel_crtc->plane));
 		OUT_RING(fb->pitch);
 		OUT_RING(offset);
+		OUT_RING(MI_NOOP);
+	} else {
+		OUT_RING(MI_DISPLAY_FLIP |
+			 MI_DISPLAY_FLIP_PLANE(intel_crtc->plane));
+		OUT_RING(fb->pitch);
+		OUT_RING(offset);
 		OUT_RING(MI_NOOP);
 	}
 	ADVANCE_LP_RING();


