Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933185Ab2FGEWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:22:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63657 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933094Ab2FGEWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:22:05 -0400
Message-Id: <20120607040348.373565277@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:57 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Wilson <chris@chris-wilson.co.uk>,
        Keith Packard <keithp@keithp.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 81/82] drm/i915/dp: Flush any outstanding work to turn the VDD off
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 17038de5f16569a25343cf68668f3b657eafb00e upstream.

As we may kick off a delayed workqueue task to switch of the VDD lines, we
need to complete that task prior to turning off the panel (which itself
depends upon VDD being off).

v2: Don't cancel the outstanding work as this may trigger a deadlock

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Keith Packard <keithp@keithp.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_dp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1149,6 +1149,7 @@ static void ironlake_edp_panel_off(struc
 	DRM_DEBUG_KMS("Turn eDP power off\n");
 
 	WARN(intel_dp->want_panel_vdd, "Cannot turn power off while VDD is on\n");
+	ironlake_panel_vdd_off_sync(intel_dp); /* finish any pending work */
 
 	pp = ironlake_get_pp_control(dev_priv);
 	pp &= ~(POWER_TARGET_ON | EDP_FORCE_VDD | PANEL_POWER_RESET | EDP_BLC_ENABLE);


