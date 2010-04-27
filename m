Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab0D0Cva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 22:51:30 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56383 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023Ab0D0Cv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 22:51:28 -0400
Date: Tue, 27 Apr 2010 12:51:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20100427125126.4ed062dc.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/i915/i915_drv.h between commit
20bf377e679208ba9ae0edcb8c70a8f6d33d17f9 ("drm/i915: cleanup FBC buffers
at unload time") from Linus' tree and commit
8be48d924c307e72e3797ab5bde81b07a1ccc52d ("drm/kms/fb: move to using fb
helper crtc grouping instead of core crtc list") from the drm tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/i915_drv.h
index 6e47900,242993b..0000000
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@@ -635,8 -641,8 +645,11 @@@ typedef struct drm_i915_private 
  
  	enum no_fbc_reason no_fbc_reason;
  
 +	struct drm_mm_node *compressed_fb;
 +	struct drm_mm_node *compressed_llb;
++
+ 	/* list of fbdev register on this device */
+ 	struct intel_fbdev *fbdev;
  } drm_i915_private_t;
  
  /** driver private structure attached to each drm_gem_object */
@@@ -1142,8 -1154,10 +1161,11 @@@ extern int i915_wait_ring(struct drm_de
  
  #define HAS_PCH_SPLIT(dev) (IS_IRONLAKE(dev) ||	\
  			    IS_GEN6(dev))
 +#define HAS_PIPE_CONTROL(dev) (IS_IRONLAKE(dev) || IS_GEN6(dev))
  
+ #define INTEL_PCH_TYPE(dev) (((struct drm_i915_private *)(dev)->dev_private)->pch_type)
+ #define HAS_PCH_CPT(dev) (INTEL_PCH_TYPE(dev) == PCH_CPT)
+ 
  #define PRIMARY_RINGBUFFER_SIZE         (128*1024)
  
  #endif
