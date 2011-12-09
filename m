Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab1LIJDr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 04:03:47 -0500
Received: from mga09.intel.com ([134.134.136.24]:65185 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196Ab1LIJDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 04:03:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="85327678"
Date: Fri, 9 Dec 2011 17:03:43 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Keith Packard <keithp@keithp.com>
Cc: Takashi Iwai <tiwai@suse.de>, "Wang, Zhenyu Z" <zhenyu.z.wang@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] drm/i915: DisplayPort hot remove notification to audio
 driver
Message-ID: <20111209090343.GA2320@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On DP monitor hot remove, clear DP_AUDIO_OUTPUT_ENABLE accordingly,
so that the audio driver will receive hot plug events and take action
to refresh its device state and ELD contents.

Note that the DP_AUDIO_OUTPUT_ENABLE bit may be enabled or disabled
only when the link training is complete and set to "Normal".

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/gpu/drm/i915/intel_dp.c |    1 +
 1 file changed, 1 insertion(+)

This works both on KMS console and gnome desktop.
Hot plug/unplug and DPMS on/off are all tested OK.

--- linux.orig/drivers/gpu/drm/i915/intel_dp.c	2011-12-09 16:51:21.000000000 +0800
+++ linux/drivers/gpu/drm/i915/intel_dp.c	2011-12-09 16:59:45.000000000 +0800
@@ -1771,6 +1771,7 @@ intel_dp_link_down(struct intel_dp *inte
 			intel_wait_for_vblank(dev, to_intel_crtc(crtc)->pipe);
 	}
 
+	DP &= ~DP_AUDIO_OUTPUT_ENABLE;
 	I915_WRITE(intel_dp->output_reg, DP & ~DP_PORT_EN);
 	POSTING_READ(intel_dp->output_reg);
 	msleep(intel_dp->panel_power_down_delay);
