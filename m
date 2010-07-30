Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab0G3TNH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 15:13:07 -0400
Received: from kroah.org ([198.145.64.141]:46354 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756911Ab0G3RSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:18:13 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:02 2010
Message-Id: <20100730171502.824940357@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:14:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Adam Jackson <ajax@redhat.com>, Eric Anholt <eric@anholt.net>
Subject: [035/165] drm/i915: Make G4X-style PLL search more permissive
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Adam Jackson <ajax@redhat.com>

commit 6ba770dc5c334aff1c055c8728d34656e0f091e2 upstream.

Fixes an Ironlake laptop with a 68.940MHz 1280x800 panel and 120MHz SSC
reference clock.

More generally, the 0.488% tolerance used before is just too tight to
reliably find a PLL setting.  I extracted the search algorithm and
modified it to find the dot clocks with maximum error over the valid
range for the given output type:

http://people.freedesktop.org/~ajax/intel_g4x_find_best_pll.c

This gave:

Worst dotclock for Ironlake DAC refclk is 350000kHz (error 0.00571)
Worst dotclock for Ironlake SL-LVDS refclk is 102321kHz (error 0.00524)
Worst dotclock for Ironlake DL-LVDS refclk is 219642kHz (error 0.00488)
Worst dotclock for Ironlake SL-LVDS SSC refclk is 84374kHz (error 0.00529)
Worst dotclock for Ironlake DL-LVDS SSC refclk is 183035kHz (error 0.00488)
Worst dotclock for G4X SDVO refclk is 267600kHz (error 0.00448)
Worst dotclock for G4X HDMI refclk is 334400kHz (error 0.00478)
Worst dotclock for G4X SL-LVDS refclk is 95571kHz (error 0.00449)
Worst dotclock for G4X DL-LVDS refclk is 224000kHz (error 0.00510)

Signed-off-by: Adam Jackson <ajax@redhat.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_display.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -785,8 +785,8 @@ intel_g4x_find_best_PLL(const intel_limi
 	intel_clock_t clock;
 	int max_n;
 	bool found;
-	/* approximately equals target * 0.00488 */
-	int err_most = (target >> 8) + (target >> 10);
+	/* approximately equals target * 0.00585 */
+	int err_most = (target >> 8) + (target >> 9);
 	found = false;
 
 	if (intel_pipe_has_type(crtc, INTEL_OUTPUT_LVDS)) {


