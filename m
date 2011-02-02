Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab1BBAn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:43:29 -0500
Received: from mga09.intel.com ([134.134.136.24]:41311 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391Ab1BBAnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="598622294"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: w0806.kim@samsung.com, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [20/139] ASoC: Fix swap of left and right channels for WM8993/4 speaker boost gain
Message-Id: <20110202004334.BDA9C3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:43:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Uk Kim <w0806.kim@samsung.com>

commit ed8cc471d75365f8590c76f580def899d58028c0 upstream.

SPKOUTL_BOOST start from third bit, SPKOUTLR_BOOST start from 0 bit.

Signed-off-by: Uk Kim <w0806.kim@samsung.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/soc/codecs/wm_hubs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/sound/soc/codecs/wm_hubs.c
===================================================================
--- linux-2.6.35.y.orig/sound/soc/codecs/wm_hubs.c
+++ linux-2.6.35.y/sound/soc/codecs/wm_hubs.c
@@ -293,7 +293,7 @@ SOC_DOUBLE_R("Speaker Switch",
 SOC_DOUBLE_R("Speaker ZC Switch",
 	     WM8993_SPEAKER_VOLUME_LEFT, WM8993_SPEAKER_VOLUME_RIGHT,
 	     7, 1, 0),
-SOC_DOUBLE_TLV("Speaker Boost Volume", WM8993_SPKOUT_BOOST, 0, 3, 7, 0,
+SOC_DOUBLE_TLV("Speaker Boost Volume", WM8993_SPKOUT_BOOST, 3, 0, 7, 0,
 	       spkboost_tlv),
 SOC_ENUM("Speaker Reference", speaker_ref),
 SOC_ENUM("Speaker Mode", speaker_mode),
