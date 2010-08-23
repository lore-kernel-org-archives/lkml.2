Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab0HWKia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 06:38:30 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:35720 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725Ab0HWKi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 06:38:29 -0400
Date: Mon, 23 Aug 2010 13:38:27 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Chris Wilson <chris@chris-wilson.co.uk>, Eric Anholt <eric@anholt.net>,
        David Airlie <airlied@linux.ie>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH] fix i915 compile in 2.6.36-rc2
Message-ID: <alpine.SOC.1.00.1008231332460.14284@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6ef3d4278034982c13df87c4a51e0445f762d316 introduces seq_file 
usage in intel_overlay.c but does not include the header and now 
compilation fails on i386. Fix it by including the necessary header.

Signed-off-by: Meelis Roos <mroos@linux.ee>

diff --git a/drivers/gpu/drm/i915/intel_overlay.c b/drivers/gpu/drm/i915/intel_overlay.c
index 4f00390..7e4b378 100644
--- a/drivers/gpu/drm/i915/intel_overlay.c
+++ b/drivers/gpu/drm/i915/intel_overlay.c
@@ -25,6 +25,7 @@
  *
  * Derived from Xorg ddx, xf86-video-intel, src/i830_video.c
  */
+#include <linux/seq_file.h>
 #include "drmP.h"
 #include "drm.h"
 #include "i915_drm.h"

-- 
Meelis Roos (mroos@linux.ee)
