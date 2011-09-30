Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427Ab1I3BM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 21:12:26 -0400
Received: from home.keithp.com ([63.227.221.253]:49873 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756444Ab1I3BKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 21:10:25 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 09/21] drm/i915: Delay DP i2c initialization until panel power timings are computed
Date: Thu, 29 Sep 2011 18:09:41 -0700
Message-Id: <1317344993-24945-10-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1317344993-24945-1-git-send-email-keithp@keithp.com>
References: <20110923085243.6e4b7b4c@jbarnes-x220>
 <1317344993-24945-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On eDP, DDC requires panel power, but turning that on uses the panel
power sequencing timing values fetch from the DPCD data.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_dp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index b915fc3..0b462f9 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -2069,8 +2069,6 @@ intel_dp_init(struct drm_device *dev, int output_reg)
 			break;
 	}
 
-	intel_dp_i2c_init(intel_dp, intel_connector, name);
-
 	/* Cache some DPCD data in the eDP case */
 	if (is_edp(intel_dp)) {
 		bool ret;
@@ -2102,6 +2100,8 @@ intel_dp_init(struct drm_device *dev, int output_reg)
 		}
 	}
 
+	intel_dp_i2c_init(intel_dp, intel_connector, name);
+
 	intel_encoder->hot_plug = intel_dp_hot_plug;
 
 	if (is_edp(intel_dp)) {
-- 
1.7.6.3

