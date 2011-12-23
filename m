Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142Ab1LWVcH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 16:32:07 -0500
Received: from home.keithp.com ([63.227.221.253]:32936 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757817Ab1LWVcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 16:32:03 -0500
From: Keith Packard <keithp@keithp.com>
To: intel-gfx@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Keith Packard <keithp@keithp.com>, Daniel Vetter <daniel@ffwll.ch>,
        Eugeni Dodonov <eugeni@dodonov.net>
Subject: [PATCH] drm/i915: Disable semaphores by default on SNB
Date: Fri, 23 Dec 2011 13:33:07 -0800
Message-Id: <1324675987-31033-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Semaphores still cause problems on some machines:

> From Udo Steinberg:
>
> With Linux-3.2-rc6 I'm frequently seeing GPU hangs when large amounts of
> text scroll in an xterm, such as when extracting a tar archive. Such as this
> one (note the timestamps):
>
>  I can reproduce it fairly easily with something
>  as simple as:
>
>	  while true; do dmesg; done

This patch turns them off on SNB while leaving them on for IVB.

Reported-by: Udo Steinberg <udo@hypervisor.org>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Eugeni Dodonov <eugeni@dodonov.net>
Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
index c681dc1..0d4d308 100644
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -758,7 +758,7 @@ intel_enable_semaphores(struct drm_device *dev)
 
 	/* Enable semaphores on SNB when IO remapping is off */
 	if (INTEL_INFO(dev)->gen == 6)
-		return !intel_iommu_enabled;
+		return 0;
 
 	return 1;
 }
-- 
1.7.7.3

