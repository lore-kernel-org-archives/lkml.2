Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846Ab1BPAZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:25:50 -0500
Received: from kroah.org ([198.145.64.141]:49916 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757824Ab1BPAZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:25:27 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:51 2011
Message-Id: <20110216001451.065852899@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:15:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [260/272] drm/i915/panel: The backlight is enabled if the current value is non-zero
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Indan Zupancic <indan@nul.nu>

commit c8303e7f3f3093c16ef0fa5f73280637c89d4368 upstream.

... and not if the maximum is non-zero. This fixes the typo introduced
in 47356eb6728501452 and preserves the backlight value from boot.

[ickle: My thanks also to Indan Zupancic for diagnosing the original
        regression and suggesting the appropriate fix.]
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_panel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -246,6 +246,6 @@ void intel_panel_setup_backlight(struct
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 
-	dev_priv->backlight_level = intel_panel_get_max_backlight(dev);
+	dev_priv->backlight_level = intel_panel_get_backlight(dev);
 	dev_priv->backlight_enabled = dev_priv->backlight_level != 0;
 }


