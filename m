Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab1L0BIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 20:08:05 -0500
Received: from home.keithp.com ([63.227.221.253]:36369 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491Ab1L0BHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 20:07:33 -0500
From: Keith Packard <keithp@keithp.com>
To: intel-gfx@lists.freedesktop.org, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Keith Packard <keithp@keithp.com>, Daniel Vetter <daniel@ffwll.ch>,
        Eugeni Dodonov <eugeni@dodonov.net>
Subject: [PATCH 1/2] drm/i915: Disable semaphores by default on SNB
Date: Mon, 26 Dec 2011 17:02:10 -0800
Message-Id: <1324947731-22980-2-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1324947731-22980-1-git-send-email-keithp@keithp.com>
References: <1324947731-22980-1-git-send-email-keithp@keithp.com>
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
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
index c681dc1..b9da890 100644
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -756,9 +756,9 @@ intel_enable_semaphores(struct drm_device *dev)
 	if (i915_semaphores >= 0)
 		return i915_semaphores;
 
-	/* Enable semaphores on SNB when IO remapping is off */
+	/* Disable semaphores on SNB */
 	if (INTEL_INFO(dev)->gen == 6)
-		return !intel_iommu_enabled;
+		return 0;
 
 	return 1;
 }
-- 
1.7.7.3

