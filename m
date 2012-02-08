Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab2BHD6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 22:58:23 -0500
Received: from mga14.intel.com ([143.182.124.37]:30631 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575Ab2BHD6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 22:58:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="104353560"
Date: Wed, 8 Feb 2012 11:48:16 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "stable@kernel.org" <stable@kernel.org>
Cc: Keith Packard <keithp@keithp.com>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>,
        intel-gfx@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3.2-stable] drm/i915: fix ELD writing for SandyBridge
Message-ID: <20120208034816.GA23374@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit b3f33cbf7ace8fc149993ee35e0d0fd57f41d6d8 upstream.

SandyBridge should be using the same register addresses as IvyBridge.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_display.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index d809b03..8a61b81 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -5876,14 +5876,14 @@ static void ironlake_write_eld(struct drm_connector *connector,
 	int aud_cntl_st;
 	int aud_cntrl_st2;
 
-	if (IS_IVYBRIDGE(connector->dev)) {
-		hdmiw_hdmiedid = GEN7_HDMIW_HDMIEDID_A;
-		aud_cntl_st = GEN7_AUD_CNTRL_ST_A;
-		aud_cntrl_st2 = GEN7_AUD_CNTRL_ST2;
-	} else {
+	if (HAS_PCH_IBX(connector->dev)) {
 		hdmiw_hdmiedid = GEN5_HDMIW_HDMIEDID_A;
 		aud_cntl_st = GEN5_AUD_CNTL_ST_A;
 		aud_cntrl_st2 = GEN5_AUD_CNTL_ST2;
+	} else {
+		hdmiw_hdmiedid = GEN7_HDMIW_HDMIEDID_A;
+		aud_cntl_st = GEN7_AUD_CNTRL_ST_A;
+		aud_cntrl_st2 = GEN7_AUD_CNTRL_ST2;
 	}
 
 	i = to_intel_crtc(crtc)->pipe;
-- 
1.7.7.3

