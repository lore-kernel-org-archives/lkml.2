Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697Ab2BJMFS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 07:05:18 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54596 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab2BJMFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 07:05:16 -0500
Message-ID: <1328875492.2695.1.camel@phoenix>
Subject: [PATCH] drm: Fix kcalloc parameters swapped
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Keith Packard <keithp@keithp.com>, Chris Wilson <chris@chris-wilson.co.uk>,
        Dave Airlie <airlied@redhat.com>,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        dri-devel@lists.freedesktop.org
Date: Fri, 10 Feb 2012 20:04:52 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first parameter should be "number of elements" and the second parameter
should be "element size".

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/gpu/drm/gma500/intel_gmbus.c |    2 +-
 drivers/gpu/drm/i915/intel_i2c.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/gma500/intel_gmbus.c b/drivers/gpu/drm/gma500/intel_gmbus.c
index 147584a..9db9052 100644
--- a/drivers/gpu/drm/gma500/intel_gmbus.c
+++ b/drivers/gpu/drm/gma500/intel_gmbus.c
@@ -395,7 +395,7 @@ int gma_intel_setup_gmbus(struct drm_device *dev)
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	int ret, i;
 
-	dev_priv->gmbus = kcalloc(sizeof(struct intel_gmbus), GMBUS_NUM_PORTS,
+	dev_priv->gmbus = kcalloc(GMBUS_NUM_PORTS, sizeof(struct intel_gmbus),
 				  GFP_KERNEL);
 	if (dev_priv->gmbus == NULL)
 		return -ENOMEM;
diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index 7fa4f64..03573e0 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -375,7 +375,7 @@ int intel_setup_gmbus(struct drm_device *dev)
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	int ret, i;
 
-	dev_priv->gmbus = kcalloc(sizeof(struct intel_gmbus), GMBUS_NUM_PORTS,
+	dev_priv->gmbus = kcalloc(GMBUS_NUM_PORTS, sizeof(struct intel_gmbus),
 				  GFP_KERNEL);
 	if (dev_priv->gmbus == NULL)
 		return -ENOMEM;
-- 
1.7.5.4



