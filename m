Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab2JNPQL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:16:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46074 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753841Ab2JNOli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:41:38 -0400
Message-Id: <20121014143534.214799251@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:35:36 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [ 003/147] drm/i915: prevent possible pin leak on error path
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eugeni Dodonov <eugeni.dodonov@intel.com>

commit ab3951eb74e7c33a2f5b7b64d72e82f1eea61571 upstream.

We should not hit this under any sane conditions, but still, this does not
looks right.

CC: Chris Wilson <chris@chris-wilson.co.uk>
CC: Daniel Vetter <daniel.vetter@ffwll.ch>
Reported-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Reviewed-by: Chris Wlison <chris@chris-wilson.co.uk>
Signed-off-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_display.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 17020cd..2e1f28f 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -6317,7 +6317,7 @@ static int intel_gen7_queue_flip(struct drm_device *dev,
 	default:
 		WARN_ONCE(1, "unknown plane in flip command\n");
 		ret = -ENODEV;
-		goto err;
+		goto err_unpin;
 	}
 
 	ret = intel_ring_begin(ring, 4);


