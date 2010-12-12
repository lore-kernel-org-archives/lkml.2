Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab0LMAFt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:05:49 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36310 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418Ab0LLXrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:19 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: chris@chris-wilson.co.uk, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [136/223] drm/i915/sdvo: Always add a 30ms delay to make SDVO TV detection reliable
Message-Id: <20101212234718.888ADB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:18 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Chris Wilson <chris@chris-wilson.co.uk>

commit ba84cd1f2b5dd49bda9300c5a11373f7e14c3c66 upstream.

Commit d09c23de intended to add a 30ms delay to give the ADD time to
detect any TVs connected. However, it used the sdvo->is_tv flag to do so
which is dependent upon the previous detection result and not whether the
output supports TVs.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/gpu/drm/i915/intel_sdvo.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux/drivers/gpu/drm/i915/intel_sdvo.c
===================================================================
--- linux.orig/drivers/gpu/drm/i915/intel_sdvo.c
+++ linux/drivers/gpu/drm/i915/intel_sdvo.c
@@ -1580,10 +1580,10 @@ static enum drm_connector_status intel_s
 
 	intel_sdvo_write_cmd(intel_encoder,
 			     SDVO_CMD_GET_ATTACHED_DISPLAYS, NULL, 0);
-	if (sdvo_priv->is_tv) {
-		/* add 30ms delay when the output type is SDVO-TV */
-		mdelay(30);
-	}
+	/* add 30ms delay when the output type might be TV */
+	if (sdvo_priv->caps.output_flags &
+	    (SDVO_OUTPUT_SVID0 | SDVO_OUTPUT_CVBS0))
+ 		mdelay(30);
 	status = intel_sdvo_read_response(intel_encoder, &response, 2);
 
 	DRM_DEBUG_KMS("SDVO response %d %d\n", response & 0xff, response >> 8);
