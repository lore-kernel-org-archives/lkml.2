Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab0IRTTO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:19:14 -0400
Received: from kroah.org ([198.145.64.141]:43912 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757240Ab0IRTQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:16:26 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:07 2010
Message-Id: <20100918191307.161996238@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:13:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [115/129] drm/i915: Enable MI_FLUSH on Sandybridge
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhenyu Wang <zhenyuw@linux.intel.com>

commit a69ffdbfcba8eabf2ca9d384b578e6f28b339c61 upstream.

MI_FLUSH is being deprecated, but still available on Sandybridge.
Make sure it's enabled as userspace still uses MI_FLUSH.

Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_reg.h         |    1 +
 drivers/gpu/drm/i915/intel_ringbuffer.c |    8 ++++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -312,6 +312,7 @@
 
 #define MI_MODE		0x0209c
 # define VS_TIMER_DISPATCH				(1 << 6)
+# define MI_FLUSH_ENABLE				(1 << 11)
 
 #define SCPD0		0x0209c /* 915+ only */
 #define IER		0x020a0
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -203,9 +203,13 @@ static int init_render_ring(struct drm_d
 {
 	drm_i915_private_t *dev_priv = dev->dev_private;
 	int ret = init_ring_common(dev, ring);
+	int mode;
+
 	if (IS_I9XX(dev) && !IS_GEN3(dev)) {
-		I915_WRITE(MI_MODE,
-				(VS_TIMER_DISPATCH) << 16 | VS_TIMER_DISPATCH);
+		mode = VS_TIMER_DISPATCH << 16 | VS_TIMER_DISPATCH;
+		if (IS_GEN6(dev))
+			mode |= MI_FLUSH_ENABLE << 16 | MI_FLUSH_ENABLE;
+		I915_WRITE(MI_MODE, mode);
 	}
 	return ret;
 }


