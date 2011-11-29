Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab1K2Lxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 06:53:52 -0500
Received: from mga03.intel.com ([143.182.124.21]:35502 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052Ab1K2Lxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 06:53:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,590,1315206000"; 
   d="scan'208";a="80170977"
Date: Tue, 29 Nov 2011 19:53:45 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Keith Packard <keithp@keithp.com>
Cc: Takashi Iwai <tiwai@suse.de>, Sander Jansen <s.jansen@gmail.com>,
        Christopher White <c.white@pulseforce.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "Bossart, Pierre-louis" <pierre-louis.bossart@intel.com>,
        "Wang, Zhenyu Z" <zhenyu.z.wang@intel.com>,
        Jeremy Bush <contractfrombelow@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4 v2] drm/i915: fix ELD writing for SandyBridge
Message-ID: <20111129115345.GB11973@localhost>
References: <20111128073337.815008177@intel.com>
 <20111128074029.504309527@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128074029.504309527@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SandyBridge should be using the same register addresses as IvyBridge.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/gpu/drm/i915/intel_display.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Sorry, this moves some necessary changes from patch 2/4 to here.

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
