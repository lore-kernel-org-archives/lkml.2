Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab2IIXU1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:20:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51543 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756473Ab2IIXRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:17:19 -0400
Message-Id: <20120909224153.908023874@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:12 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Benoit Gschwind <gschwind@gnu-log.net>,
        Francois Rigaut <frigaut@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [ 22/95] drm/i915: ignore eDP bpc settings from vbt
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 4344b813f105a19f793f1fd93ad775b784648b95 upstream.

This has originally been introduced to not oversubscribe the dp links
in

commit 885a5fb5b120a5c7e0b3baad7b0feb5a89f76c18
Author: Zhenyu Wang <zhenyuw@linux.intel.com>
Date:   Tue Jan 12 05:38:31 2010 +0800

    drm/i915: fix pixel color depth setting on eDP

Since then we've fixed up the dp link bandwidth calculation code and
should now automatically fall back to 6bpc dithering. So this is
unnecessary.

Furthermore it seems to break the new MacbookPro with retina display,
hence let's just rip this out.

Reported-by: Benoit Gschwind <gschwind@gnu-log.net>
Cc: Benoit Gschwind <gschwind@gnu-log.net>
Cc: Francois Rigaut <frigaut@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Tested-by: Benoit Gschwind <gschwind@gnu-log.net>
Tested-by: Bernhard Froemel <froemel at vmars tuwien.ac.at>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>

--

Testing feedback highgly welcome, and thanks for Benoit for finding
out that the bpc computations are busted.
-Daniel
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_display.c |   11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 88913a4..a69a3d0 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -3754,17 +3754,6 @@ static bool intel_choose_pipe_bpp_dither(struct drm_crtc *crtc,
 			continue;
 		}
 
-		if (intel_encoder->type == INTEL_OUTPUT_EDP) {
-			/* Use VBT settings if we have an eDP panel */
-			unsigned int edp_bpc = dev_priv->edp.bpp / 3;
-
-			if (edp_bpc < display_bpc) {
-				DRM_DEBUG_KMS("clamping display bpc (was %d) to eDP (%d)\n", display_bpc, edp_bpc);
-				display_bpc = edp_bpc;
-			}
-			continue;
-		}
-
 		/* Not one of the known troublemakers, check the EDID */
 		list_for_each_entry(connector, &dev->mode_config.connector_list,
 				    head) {


