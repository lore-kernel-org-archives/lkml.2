Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877Ab2EIGDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:03:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39158 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756897Ab2EIFxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:40 -0400
Message-Id: <20120509055051.248515698@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:53:06 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>,
        Kenneth Graunke <kenneth@whitecape.org>
Subject: [ 157/167] [PATCH] drm/i915: Do no set Stencil Cache eviction LRA w/a on gen7+
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 2e7a44814d802c8ba479164b8924070cd908d6b5 upstream.

I've flagged this while reviewing the first version and Ken Graunke
fixed it up in v2, but unfortunately Dave Airlie picked up the wrong
version.

Cc: Dave Airlie <airlied@redhat.com>
Cc: Kenneth Graunke <kenneth@whitecape.org>
Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_ringbuffer.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index 80fce51..62892a8 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -398,10 +398,8 @@ static int init_render_ring(struct intel_ring_buffer *ring)
 			return ret;
 	}
 
-	if (INTEL_INFO(dev)->gen >= 6) {
-		I915_WRITE(INSTPM,
-			   INSTPM_FORCE_ORDERING << 16 | INSTPM_FORCE_ORDERING);
 
+	if (IS_GEN6(dev)) {
 		/* From the Sandybridge PRM, volume 1 part 3, page 24:
 		 * "If this bit is set, STCunit will have LRA as replacement
 		 *  policy. [...] This bit must be reset.  LRA replacement
@@ -411,6 +409,11 @@ static int init_render_ring(struct intel_ring_buffer *ring)
 			   CM0_STC_EVICT_DISABLE_LRA_SNB << CM0_MASK_SHIFT);
 	}
 
+	if (INTEL_INFO(dev)->gen >= 6) {
+		I915_WRITE(INSTPM,
+			   INSTPM_FORCE_ORDERING << 16 | INSTPM_FORCE_ORDERING);
+	}
+
 	return ret;
 }
 
-- 
1.7.10



