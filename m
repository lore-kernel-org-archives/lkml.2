Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab1LINAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 08:00:47 -0500
Received: from mga03.intel.com ([143.182.124.21]:31189 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402Ab1LIM76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 07:59:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="83996293"
Message-Id: <20111209124555.686455496@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 09 Dec 2011 20:42:17 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Keith Packard <keithp@keithp.com>
cc: Takashi Iwai <tiwai@suse.de>, Wu Fengguang <fengguang.wu@intel.com>
Cc: Sander Jansen <s.jansen@gmail.com>,
        Christopher White <c.white@pulseforce.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "Pierre-louis Bossart " <pierre-louis.bossart@intel.com>,
        "Zhenyu Wang" <zhenyu.z.wang@intel.com>,
        Jeremy Bush <contractfrombelow@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] drm/i915: fix ELD writing for SandyBridge
References: <20111209124216.701131933@intel.com>
Content-Disposition: inline; filename=sandybridge-eld-fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SandyBridge should be using the same register addresses as IvyBridge.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/gpu/drm/i915/intel_display.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- linux.orig/drivers/gpu/drm/i915/intel_display.c	2011-11-28 15:33:04.000000000 +0800
+++ linux/drivers/gpu/drm/i915/intel_display.c	2011-11-29 19:51:28.000000000 +0800
@@ -5857,14 +5857,14 @@ static void ironlake_write_eld(struct dr
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


