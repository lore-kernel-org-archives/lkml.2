Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057Ab0LHBA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:00:27 -0500
Received: from kroah.org ([198.145.64.141]:48763 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757016Ab0LHBAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:00:20 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:30 2010
Message-Id: <20101208005730.050774757@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Keith Packard <keithp@keithp.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [087/289] drm/i915: Free hardware status page on unload when physically mapped
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Keith Packard <keithp@keithp.com>

commit c2873e9633fe908dccd36dbb1d370e9c59a1ca62 upstream.

A physically mapped hardware status page is allocated at driver load
time but was never freed. Call the existing code to free this page at
driver unload time on hardware which uses this kind.

Signed-off-by: Keith Packard <keithp@keithp.com>
[ickle: call before tearing down registers on KMS-only path, as pointed
out by Dave Airlie]
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_dma.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -2306,6 +2306,9 @@ int i915_driver_unload(struct drm_device
 		i915_gem_lastclose(dev);
 
 		intel_cleanup_overlay(dev);
+
+		if (!I915_NEED_GFX_HWS(dev))
+			i915_free_hws(dev);
 	}
 
 	intel_teardown_mchbar(dev);


