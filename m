Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756Ab2BAV2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:28:17 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:43271 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757478Ab2BAVTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:19:23 -0500
X-Sasl-enc: Jn3fFytRNgELwTHdlsEdPSkgRp/VdnTaNqQS4wfpYHk4 1328131162
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:46 2012
Message-Id: <20120201210046.659981201@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:59:55 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Anholt <eric@anholt.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Keith Packard <keithp@keithp.com>
Subject: [31/89] drm/i915/sdvo: always set positive sync polarity
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Zanoni <paulo.r.zanoni@intel.com>

commit ba68e086223a5f149f37bf8692c8cdbf1b0ba3ef upstream.

This is a revert of 81a14b46846fea0741902e8d8dfcc6c6c78154c8.

We already set the mode polarity using the SDVO commands with struct
intel_sdvo_dtd. We have at least 3 bugs that get fixed with this patch.
The documentation, despite not clear, can also be interpreted in a way
that suggests this patch is needed.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=15766
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=42174
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=43333
Reviewed-by: Eric Anholt <eric@anholt.net>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_sdvo.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -1066,15 +1066,13 @@ static void intel_sdvo_mode_set(struct d
 
 	/* Set the SDVO control regs. */
 	if (INTEL_INFO(dev)->gen >= 4) {
-		sdvox = 0;
+		/* The real mode polarity is set by the SDVO commands, using
+		 * struct intel_sdvo_dtd. */
+		sdvox = SDVO_VSYNC_ACTIVE_HIGH | SDVO_HSYNC_ACTIVE_HIGH;
 		if (intel_sdvo->is_hdmi)
 			sdvox |= intel_sdvo->color_range;
 		if (INTEL_INFO(dev)->gen < 5)
 			sdvox |= SDVO_BORDER_ENABLE;
-		if (adjusted_mode->flags & DRM_MODE_FLAG_PVSYNC)
-			sdvox |= SDVO_VSYNC_ACTIVE_HIGH;
-		if (adjusted_mode->flags & DRM_MODE_FLAG_PHSYNC)
-			sdvox |= SDVO_HSYNC_ACTIVE_HIGH;
 	} else {
 		sdvox = I915_READ(intel_sdvo->sdvo_reg);
 		switch (intel_sdvo->sdvo_reg) {


