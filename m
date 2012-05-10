Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760318Ab2EJRd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:33:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58653 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760265Ab2EJRdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:33:50 -0400
Message-Id: <20120510173133.584262248@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 10 May 2012 10:31:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dave Airlie <airlied@redhat.com>,
        Kenneth Graunke <kenneth@whitecape.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 07/52] drm/i915: Do no set Stencil Cache eviction LRA w/a on gen7+
In-Reply-To: <20120510173229.GA5678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 2e7a44814d802c8ba479164b8924070cd908d6b5 upstream.

I've flagged this while reviewing the first version and Ken Graunke
fixed it up in v2, but unfortunately Dave Airlie picked up the wrong
version.

Cc: Dave Airlie <airlied@redhat.com>
Cc: Kenneth Graunke <kenneth@whitecape.org>
Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_ringbuffer.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -414,10 +414,8 @@ static int init_render_ring(struct intel
 			return ret;
 	}
 
-	if (INTEL_INFO(dev)->gen >= 6) {
-		I915_WRITE(INSTPM,
-			   INSTPM_FORCE_ORDERING << 16 | INSTPM_FORCE_ORDERING);
 
+	if (IS_GEN6(dev)) {
 		/* From the Sandybridge PRM, volume 1 part 3, page 24:
 		 * "If this bit is set, STCunit will have LRA as replacement
 		 *  policy. [...] This bit must be reset.  LRA replacement
@@ -427,6 +425,11 @@ static int init_render_ring(struct intel
 			   CM0_STC_EVICT_DISABLE_LRA_SNB << CM0_MASK_SHIFT);
 	}
 
+	if (INTEL_INFO(dev)->gen >= 6) {
+		I915_WRITE(INSTPM,
+			   INSTPM_FORCE_ORDERING << 16 | INSTPM_FORCE_ORDERING);
+	}
+
 	return ret;
 }
 


