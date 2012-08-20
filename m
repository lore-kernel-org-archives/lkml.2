Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab2HTD57 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 23:57:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38485 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717Ab2HTD5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 23:57:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jonathan Nieder <jrnieder@gmail.com>
Subject: [ 06/32] drm/i915: prefer wide & slow to fast & narrow in DP configs
Date: Sun, 19 Aug 2012 20:57:02 -0700
Message-Id: <20120820035648.743958782@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035647.862247088@linuxfoundation.org>
References: <20120820035647.862247088@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_dp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -712,8 +712,8 @@ intel_dp_mode_fixup(struct drm_encoder *
 
 	bpp = adjusted_mode->private_flags & INTEL_MODE_DP_FORCE_6BPC ? 18 : 24;
 
-	for (lane_count = 1; lane_count <= max_lane_count; lane_count <<= 1) {
-		for (clock = 0; clock <= max_clock; clock++) {
+	for (clock = 0; clock <= max_clock; clock++) {
+		for (lane_count = 1; lane_count <= max_lane_count; lane_count <<= 1) {
 			int link_avail = intel_dp_max_data_rate(intel_dp_link_clock(bws[clock]), lane_count);
 
 			if (intel_dp_link_required(mode->clock, bpp)


