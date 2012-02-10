Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142Ab2BJWs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:48:29 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35084 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933121Ab2BJWpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:45:33 -0500
MIME-Version: 1.0
Message-Id: <20120210223442.647456350@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:33:31 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Wu Fengguang <fengguang.wu@intel.com>,
        Keith Packard <keithp@keithp.com>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>
Subject: [patch 27/55] drm/i915: DisplayPort hot remove notification to audio driver
In-Reply-To: <20120210223500.GA24178@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wu Fengguang <fengguang.wu@intel.com>

commit 832afda6a7d7235ef0e09f4ec46736861540da6d upstream.

On DP monitor hot remove, clear DP_AUDIO_OUTPUT_ENABLE accordingly,
so that the audio driver will receive hot plug events and take action
to refresh its device state and ELD contents.

Note that the DP_AUDIO_OUTPUT_ENABLE bit may be enabled or disabled
only when the link training is complete and set to "Normal".

Tested OK for both hot plug/remove and DPMS on/off.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_dp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1554,6 +1554,7 @@ intel_dp_link_down(struct intel_dp *inte
 			intel_wait_for_vblank(dev, to_intel_crtc(crtc)->pipe);
 	}
 
+	DP &= ~DP_AUDIO_OUTPUT_ENABLE;
 	I915_WRITE(intel_dp->output_reg, DP & ~DP_PORT_EN);
 	POSTING_READ(intel_dp->output_reg);
 }


