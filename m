Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933931Ab2DLAAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 20:00:48 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:40940 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933897Ab2DKXQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:16:33 -0400
Message-Id: <20120411231024.235038330@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:10:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 35/78] drm/i915: treat src w & h as fixed point in sprite handling code
In-Reply-To: <20120411231102.GA6404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit b4db1e35ac59c144965f517bc575a0d75b60b03f upstream.

This was missed when we converted the source values to 16.16 fixed point.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Tested-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_sprite.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/intel_sprite.c
+++ b/drivers/gpu/drm/i915/intel_sprite.c
@@ -411,6 +411,9 @@ intel_update_plane(struct drm_plane *pla
 
 	old_obj = intel_plane->obj;
 
+	src_w = src_w >> 16;
+	src_h = src_h >> 16;
+
 	/* Pipe must be running... */
 	if (!(I915_READ(PIPECONF(pipe)) & PIPECONF_ENABLE))
 		return -EINVAL;


