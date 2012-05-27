Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab2E0BLg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:11:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54259 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933719Ab2E0BL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:11:28 -0400
Message-Id: <20120527010433.487440775@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 10:05:32 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Wilson <chris@chris-wilson.co.uk>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 69/94] drm/i915: dont clobber the pipe param in sanitize_modesetting
In-Reply-To: <20120527010332.GA11170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_display.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7496,10 +7496,11 @@ static void intel_sanitize_modesetting(s
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
 


