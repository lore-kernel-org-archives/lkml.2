Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080Ab1I3BMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 21:12:45 -0400
Received: from home.keithp.com ([63.227.221.253]:49867 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756332Ab1I3BKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 21:10:24 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 08/21] drm/i915: Turn force VDD back off when panel running in intel_dp_dpms
Date: Thu, 29 Sep 2011 18:09:40 -0700
Message-Id: <1317344993-24945-9-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1317344993-24945-1-git-send-email-keithp@keithp.com>
References: <20110923085243.6e4b7b4c@jbarnes-x220>
 <1317344993-24945-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The VDD force bit is turned on before touching the panel, but if it
was enabled, there was no call to turn it back off. Add a call.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_dp.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index da725d8..b915fc3 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1080,7 +1080,8 @@ intel_dp_dpms(struct drm_encoder *encoder, int mode)
 				ironlake_edp_panel_on(intel_dp);
 			ironlake_edp_panel_vdd_off(intel_dp);
 			intel_dp_complete_link_train(intel_dp);
-		}
+		} else
+			ironlake_edp_panel_vdd_off(intel_dp);
 		if (is_edp(intel_dp))
 			ironlake_edp_backlight_on(dev);
 	}
-- 
1.7.6.3

