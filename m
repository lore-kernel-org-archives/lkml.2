Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759442Ab0G3SDX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:03:23 -0400
Received: from kroah.org ([198.145.64.141]:59338 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932865Ab0G3R6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:58:07 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:52 2010
Message-Id: <20100730175152.521106357@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:53:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [205/205] drm/i915: make sure we shut off the panel in eDP configs
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit 5620ae29f1eabe655f44335231b580a78c8364ea upstream.

Fix error from the last pull request.  Making sure we shut the panel off
is more correct and saves power.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_dp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -758,7 +758,7 @@ intel_dp_dpms(struct drm_encoder *encode
 			intel_dp_link_down(intel_encoder, dp_priv->DP);
 			if (IS_eDP(intel_encoder)) {
 				ironlake_edp_backlight_off(dev);
-				ironlake_edp_backlight_off(dev);
+				ironlake_edp_panel_off(dev);
 			}
 		}
 	} else {


