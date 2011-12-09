Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab1LINAA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 08:00:00 -0500
Received: from mga03.intel.com ([143.182.124.21]:31189 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512Ab1LIM77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 07:59:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="83996298"
Message-Id: <20111209124556.231744875@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 09 Dec 2011 20:42:21 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Keith Packard <keithp@keithp.com>
cc: Takashi Iwai <tiwai@suse.de>, Wu Fengguang <fengguang.wu@intel.com>
Cc: Sander Jansen <s.jansen@gmail.com>,
        Christopher White <c.white@pulseforce.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "Pierre-louis Bossart " <pierre-louis.bossart@intel.com>,
        "Zhenyu Wang" <zhenyu.z.wang@intel.com>,
        Jeremy Bush <contractfrombelow@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] drm/i915: DisplayPort hot remove notification to audio driver
References: <20111209124216.701131933@intel.com>
Content-Disposition: inline; filename=dp-eld-hot-disable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On DP monitor hot remove, clear DP_AUDIO_OUTPUT_ENABLE accordingly,
so that the audio driver will receive hot plug events and take action
to refresh its device state and ELD contents.

Note that the DP_AUDIO_OUTPUT_ENABLE bit may be enabled or disabled
only when the link training is complete and set to "Normal".

Tested OK for both hot plug/remove and DPMS on/off.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/gpu/drm/i915/intel_dp.c |    1 +
 1 file changed, 1 insertion(+)

--- linux.orig/drivers/gpu/drm/i915/intel_dp.c	2011-12-09 16:51:21.000000000 +0800
+++ linux/drivers/gpu/drm/i915/intel_dp.c	2011-12-09 16:59:45.000000000 +0800
@@ -1771,6 +1771,7 @@ intel_dp_link_down(struct intel_dp *inte
 			intel_wait_for_vblank(dev, to_intel_crtc(crtc)->pipe);
 	}
 
+	DP &= ~DP_AUDIO_OUTPUT_ENABLE;
 	I915_WRITE(intel_dp->output_reg, DP & ~DP_PORT_EN);
 	POSTING_READ(intel_dp->output_reg);
 	msleep(intel_dp->panel_power_down_delay);


