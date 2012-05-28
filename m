Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab2E1DkU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:40:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52220 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754080Ab2E1D3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:41 -0400
Message-Id: <20120528031215.966098941@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:37 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>
Subject: [ 095/117] drm/i915: dont clobber the pipe param in sanitize_modesetting
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit a9dcf84b14ef4e9a609910367576995e6f32f3dc upstream.

... we need it later on in the function to clean up pipe <-> plane
associations. This regression has been introduced in

commit f47166d2b0001fcb752b40c5a2d4db986dfbea68
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Thu Mar 22 15:00:50 2012 +0000

    drm/i915: Sanitize BIOS debugging bits from PIPECONF

Spotted by staring at debug output of an (as it turns out) totally
unrelated bug.

v2: I've totally failed to do the s/pipe/i/ correctly, spotted by
Chris Wilson.

Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_display.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 391439f..956b228 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -6253,10 +6253,11 @@ static void intel_sanitize_modesetting(struct drm_device *dev,
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	u32 reg, val;
+	int i;
 
 	/* Clear any frame start delays used for debugging left by the BIOS */
-	for_each_pipe(pipe) {
-		reg = PIPECONF(pipe);
+	for_each_pipe(i) {
+		reg = PIPECONF(i);
 		I915_WRITE(reg, I915_READ(reg) & ~PIPECONF_FRAME_START_DELAY_MASK);
 	}
 


