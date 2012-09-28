Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030596Ab2I1TE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:04:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63006 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030578Ab2I1TEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:04:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 206/262] drm/i915: enable lvds pin pairs before dpll on gen2
Date: Fri, 28 Sep 2012 11:52:15 -0700
Message-Id: <20120928183022.447803441@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 5b5896e4e1f353ef3dbc4e4e9ee44d53ccf105d7 upstream.

Otherwise things migt not work too well.

Breakage introduced in

commit eb1cbe4848b01f9f073064377875bc7d71eb401b
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Wed Mar 28 23:12:16 2012 +0200

    drm/i915: split PLL update code out of i9xx_crtc_mode_set

Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_display.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -3926,12 +3926,6 @@ static void i8xx_update_pll(struct drm_c
 	POSTING_READ(DPLL(pipe));
 	udelay(150);
 
-	I915_WRITE(DPLL(pipe), dpll);
-
-	/* Wait for the clocks to stabilize. */
-	POSTING_READ(DPLL(pipe));
-	udelay(150);
-
 	/* The LVDS pin pair needs to be on before the DPLLs are enabled.
 	 * This is an exception to the general rule that mode_set doesn't turn
 	 * things on.
@@ -3939,6 +3933,12 @@ static void i8xx_update_pll(struct drm_c
 	if (intel_pipe_has_type(crtc, INTEL_OUTPUT_LVDS))
 		intel_update_lvds(crtc, clock, adjusted_mode);
 
+	I915_WRITE(DPLL(pipe), dpll);
+
+	/* Wait for the clocks to stabilize. */
+	POSTING_READ(DPLL(pipe));
+	udelay(150);
+
 	/* The pixel multiplier can only be updated once the
 	 * DPLL is enabled and the clocks are stable.
 	 *


