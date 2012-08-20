Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab2HTEJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:09:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61536 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab2HTEAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 00:00:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Benoit Gschwind <gschwind@gnu-log.net>,
        Francois Rigaut <frigaut@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 11/46] drm/i915: ignore eDP bpc settings from vbt
Date: Sun, 19 Aug 2012 20:58:47 -0700
Message-Id: <20120820035833.847091443@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035832.274275502@linuxfoundation.org>
References: <20120820035832.274275502@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Tested-by: Benoit Gschwind <gschwind@gnu-log.net>
Tested-by: Bernhard Froemel <froemel at vmars tuwien.ac.at>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

--

Testing feedback highgly welcome, and thanks for Benoit for finding
out that the bpc computations are busted.
-Daniel

---
 drivers/gpu/drm/i915/intel_display.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -3581,17 +3581,6 @@ static bool intel_choose_pipe_bpp_dither
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


