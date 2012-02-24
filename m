Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab2BXByZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 20:54:25 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:54435 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752708Ab2BXByY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 20:54:24 -0500
From: Eugeni Dodonov <eugeni.dodonov@intel.com>
To: intel-gfx@lists.freedesktop.org
Cc: just.for.lkml@googlemail.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Dave Airlie <airlied@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 1/1] drm/i915: fix operator precedence when enabling RC6p
Date: Thu, 23 Feb 2012 23:57:06 -0200
Message-Id: <1330048626-16861-1-git-send-email-eugeni.dodonov@intel.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <CAPVoSvSvQv14dM6EWTi3YxUtxNWB8+kypDHSwkYTiWpBxL2eug@mail.gmail.com>
References: <CAPVoSvSvQv14dM6EWTi3YxUtxNWB8+kypDHSwkYTiWpBxL2eug@mail.gmail.com>
X-Identified-User: {669:box335.bluehost.com:dodonovn:dodonov.net} {sentby:smtp auth 187.23.86.115 authed with eugeni@dodonov.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As noticed by Torsten Kaiser, the operator precedence can play tricks with
us here.

CC: Dave Airlie <airlied@redhat.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
---
 drivers/gpu/drm/i915/intel_display.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index e654f32..4871ba0 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -8194,7 +8194,7 @@ void gen6_enable_rps(struct drm_i915_private *dev_priv)
 
 	if (intel_enable_rc6(dev_priv->dev))
 		rc6_mask = GEN6_RC_CTL_RC6_ENABLE |
-			(IS_GEN7(dev_priv->dev)) ? GEN6_RC_CTL_RC6p_ENABLE : 0;
+			((IS_GEN7(dev_priv->dev)) ? GEN6_RC_CTL_RC6p_ENABLE : 0);
 
 	I915_WRITE(GEN6_RC_CONTROL,
 		   rc6_mask |
-- 
1.7.8.4

