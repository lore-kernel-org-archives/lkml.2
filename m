Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab1K1Hlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 02:41:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:44890 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495Ab1K1HlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 02:41:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="80548648"
Message-Id: <20111128074029.504309527@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 28 Nov 2011 15:33:38 +0800
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
Subject: [PATCH 1/4] drm/i915: fix ELD writing for SandyBridge
References: <20111128073337.815008177@intel.com>
Content-Disposition: inline; filename=sandybridge-eld-fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SandyBridge should be using the same register addresses as IvyBridge.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/gpu/drm/i915/intel_display.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux.orig/drivers/gpu/drm/i915/intel_display.c	2011-11-24 08:09:41.000000000 +0800
+++ linux/drivers/gpu/drm/i915/intel_display.c	2011-11-24 08:10:32.000000000 +0800
@@ -5857,7 +5857,7 @@ static void ironlake_write_eld(struct dr
 	int aud_cntl_st;
 	int aud_cntrl_st2;
 
-	if (IS_IVYBRIDGE(connector->dev)) {
+	if (HAS_PCH_IBX(connector->dev)) {
 		hdmiw_hdmiedid = GEN7_HDMIW_HDMIEDID_A;
 		aud_cntl_st = GEN7_AUD_CNTRL_ST_A;
 		aud_cntrl_st2 = GEN7_AUD_CNTRL_ST2;


