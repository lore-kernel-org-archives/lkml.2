Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab1I3BK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 21:10:27 -0400
Received: from home.keithp.com ([63.227.221.253]:49847 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756183Ab1I3BKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 21:10:20 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 21/21] drm/i915: No need to wait for eDP power off delay if panel is on
Date: Thu, 29 Sep 2011 18:09:53 -0700
Message-Id: <1317344993-24945-22-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1317344993-24945-1-git-send-email-keithp@keithp.com>
References: <20110923085243.6e4b7b4c@jbarnes-x220>
 <1317344993-24945-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the panel is powered up, there's no need to delay for the 'off'
interval when turning the panel on.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_dp.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index f223504..a01cc2a 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -856,7 +856,16 @@ static void ironlake_wait_panel_off(struct intel_dp *intel_dp)
 {
 	unsigned long	off_time;
 	unsigned long	delay;
+
 	DRM_DEBUG_KMS("Wait for panel power off time\n");
+
+	if (ironlake_edp_have_panel_power(intel_dp) ||
+	    ironlake_edp_have_panel_vdd(intel_dp))
+	{
+		DRM_DEBUG_KMS("Panel still on, no delay needed\n");
+		return;
+	}
+
 	off_time = intel_dp->panel_off_jiffies + msecs_to_jiffies(intel_dp->panel_power_down_delay);
 	if (time_after(jiffies, off_time)) {
 		DRM_DEBUG_KMS("Time already passed");
-- 
1.7.6.3

