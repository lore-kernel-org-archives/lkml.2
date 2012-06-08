Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933269Ab2FHFYj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:24:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43209 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761135Ab2FHFHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:18 -0400
Message-Id: <20120608041849.128330238@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:42 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Wilson <chris@chris-wilson.co.uk>,
        Keith Packard <keithp@keithp.com>
Subject: [ 62/82] drm/i915:: Disable FBC on SandyBridge
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit d56d8b28e9247e7e35e02fbb12b12239a2c33ad1 upstream.

Enabling FBC is causing the BLT ring to run between 10-100x slower than
normal and frequently lockup. The interim solution is disable FBC once
more until we know why.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_display.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index b3b51c4..19f35ec 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1872,7 +1872,7 @@ static void intel_update_fbc(struct drm_device *dev)
 	if (enable_fbc < 0) {
 		DRM_DEBUG_KMS("fbc set to per-chip default\n");
 		enable_fbc = 1;
-		if (INTEL_INFO(dev)->gen <= 5)
+		if (INTEL_INFO(dev)->gen <= 6)
 			enable_fbc = 0;
 	}
 	if (!enable_fbc) {


