Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740Ab2HGDvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:51:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59718 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757338Ab2HGDia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:38:30 -0400
Message-Id: <20120807032805.109987404@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:28:57 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 62/70] drm/i915: prefer wide & slow to fast & narrow in DP configs
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit 2514bc510d0c3aadcc5204056bb440fa36845147 upstream.

High frequency link configurations have the potential to cause trouble
with long and/or cheap cables, so prefer slow and wide configurations
instead.  This patch has the potential to cause trouble for eDP
configurations that lie about available lanes, so if we run into that we
can make it conditional on eDP.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=45801
Tested-by: peter@colberg.org
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_dp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -708,8 +708,8 @@ intel_dp_mode_fixup(struct drm_encoder *
 
 	bpp = adjusted_mode->private_flags & INTEL_MODE_DP_FORCE_6BPC ? 18 : 24;
 
-	for (lane_count = 1; lane_count <= max_lane_count; lane_count <<= 1) {
-		for (clock = 0; clock <= max_clock; clock++) {
+	for (clock = 0; clock <= max_clock; clock++) {
+		for (lane_count = 1; lane_count <= max_lane_count; lane_count <<= 1) {
 			int link_avail = intel_dp_max_data_rate(intel_dp_link_clock(bws[clock]), lane_count);
 
 			if (intel_dp_link_required(mode->clock, bpp)



