Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341Ab0IRTRE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:17:04 -0400
Received: from kroah.org ([198.145.64.141]:43994 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757306Ab0IRTQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:16:40 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:08 2010
Message-Id: <20100918191308.252021070@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:13:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Adam Jackson <ajax@redhat.com>
Subject: [128/129] Revert "drm/i915: Allow LVDS on pipe A on gen4+"
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 12e8ba25ef52f19e7a42e61aecb3c1fef83b2a82 upstream.

This reverts commit 0f3ee801b332d6ff22285386675fe5aaedf035c3.

Enabling LVDS on pipe A was causing excessive wakeups on otherwise idle
systems due to i915 interrupts. So restrict the LVDS to pipe B once more,
whilst the issue is properly diagnosed.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=16307
Reported-and-tested-by: Enrico Bandiello <enban@postal.uv.es>
Poked-by: Florian Mickler <florian@mickler.org>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Adam Jackson <ajax@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_lvds.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -988,8 +988,6 @@ void intel_lvds_init(struct drm_device *
 
 	intel_encoder->clone_mask = (1 << INTEL_LVDS_CLONE_BIT);
 	intel_encoder->crtc_mask = (1 << 1);
-	if (IS_I965G(dev))
-		intel_encoder->crtc_mask |= (1 << 0);
 	drm_encoder_helper_add(encoder, &intel_lvds_helper_funcs);
 	drm_connector_helper_add(connector, &intel_lvds_connector_helper_funcs);
 	connector->display_info.subpixel_order = SubPixelHorizontalRGB;


