Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab2BAV1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:27:44 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:58370 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757480Ab2BAVTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:19:25 -0500
X-Sasl-enc: gz/nuWUrbOqvJRzyR++37565xSBG90/EfW1JXQ/u64ul 1328131164
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:46 2012
Message-Id: <20120201210046.751517104@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:59:56 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Anholt <eric@anholt.net>,
        Keith Packard <keithp@keithp.com>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Kenneth Graunke <kenneth@whitecape.org>
Subject: [32/89] drm/i915: Re-enable gen7 RC6 and GPU turbo after resume.
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Anholt <eric@anholt.net>

commit 04115a9dee110b52a8eaa556c574022fa3bf4704 upstream.

Signed-off-by: Eric Anholt <eric@anholt.net>
Reviewed-by: Keith Packard <keithp@keithp.com>
Reviewed-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
Reviewed-by: Kenneth Graunke <kenneth@whitecape.org>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_suspend.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/i915_suspend.c
+++ b/drivers/gpu/drm/i915/i915_suspend.c
@@ -822,7 +822,7 @@ int i915_save_state(struct drm_device *d
 
 	if (IS_IRONLAKE_M(dev))
 		ironlake_disable_drps(dev);
-	if (IS_GEN6(dev))
+	if (INTEL_INFO(dev)->gen >= 6)
 		gen6_disable_rps(dev);
 
 	/* Cache mode state */
@@ -881,7 +881,7 @@ int i915_restore_state(struct drm_device
 		intel_init_emon(dev);
 	}
 
-	if (IS_GEN6(dev)) {
+	if (INTEL_INFO(dev)->gen >= 6) {
 		gen6_enable_rps(dev_priv);
 		gen6_update_ring_freq(dev_priv);
 	}


