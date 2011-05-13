Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932980Ab1EMALH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 20:11:07 -0400
Received: from home.keithp.com ([63.227.221.253]:39640 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932907Ab1EMALF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 20:11:05 -0400
From: Keith Packard <keithp@keithp.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        Keith Packard <keithp@keithp.com>
Subject: [PATCH 1/2] drm/i915: Select correct pipe during TV detect
Date: Thu, 12 May 2011 17:10:57 -0700
Message-Id: <1305245458-29826-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_tv.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_tv.c
index 6b22c1d..876064c 100644
--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -1236,6 +1236,8 @@ intel_tv_detect_type (struct intel_tv *intel_tv,
 		      struct drm_connector *connector)
 {
 	struct drm_encoder *encoder = &intel_tv->base.base;
+	struct drm_crtc *crtc = encoder->crtc;
+	struct intel_crtc *intel_crtc = to_intel_crtc(crtc);
 	struct drm_device *dev = encoder->dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	unsigned long irqflags;
@@ -1258,6 +1260,10 @@ intel_tv_detect_type (struct intel_tv *intel_tv,
 	/* Poll for TV detection */
 	tv_ctl &= ~(TV_ENC_ENABLE | TV_TEST_MODE_MASK);
 	tv_ctl |= TV_TEST_MODE_MONITOR_DETECT;
+	if (intel_crtc->pipe == 1)
+		tv_ctl |= TV_ENC_PIPEB_SELECT;
+	else
+		tv_ctl &= ~TV_ENC_PIPEB_SELECT;
 
 	tv_dac &= ~(TVDAC_SENSE_MASK | DAC_A_MASK | DAC_B_MASK | DAC_C_MASK);
 	tv_dac |= (TVDAC_STATE_CHG_EN |
-- 
1.7.5.1

