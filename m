Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab1G0VsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:48:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:32147 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755416Ab1G0VsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="32826252"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: broonie@opensource.wolfsonmicro.com, lrg@ti.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [8/99] ASoC: Ensure output PGA is enabled for line outputs in
Message-Id: <20110727214806.76E9A2403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit d0b48af6c2b887354d0893e598d92911ce52620e upstream.

Also fix a left/right typo while we're at it.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/soc/codecs/wm_hubs.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: linux-2.6.35.y/sound/soc/codecs/wm_hubs.c
===================================================================
--- linux-2.6.35.y.orig/sound/soc/codecs/wm_hubs.c
+++ linux-2.6.35.y/sound/soc/codecs/wm_hubs.c
@@ -752,17 +752,17 @@ static const struct snd_soc_dapm_route a
 static const struct snd_soc_dapm_route lineout1_diff_routes[] = {
 	{ "LINEOUT1 Mixer", "IN1L Switch", "IN1L PGA" },
 	{ "LINEOUT1 Mixer", "IN1R Switch", "IN1R PGA" },
-	{ "LINEOUT1 Mixer", "Output Switch", "Left Output Mixer" },
+	{ "LINEOUT1 Mixer", "Output Switch", "Left Output PGA" },
 
 	{ "LINEOUT1N Driver", NULL, "LINEOUT1 Mixer" },
 	{ "LINEOUT1P Driver", NULL, "LINEOUT1 Mixer" },
 };
 
 static const struct snd_soc_dapm_route lineout1_se_routes[] = {
-	{ "LINEOUT1N Mixer", "Left Output Switch", "Left Output Mixer" },
-	{ "LINEOUT1N Mixer", "Right Output Switch", "Left Output Mixer" },
+	{ "LINEOUT1N Mixer", "Left Output Switch", "Left Output PGA" },
+	{ "LINEOUT1N Mixer", "Right Output Switch", "Right Output PGA" },
 
-	{ "LINEOUT1P Mixer", "Left Output Switch", "Left Output Mixer" },
+	{ "LINEOUT1P Mixer", "Left Output Switch", "Left Output PGA" },
 
 	{ "LINEOUT1N Driver", NULL, "LINEOUT1N Mixer" },
 	{ "LINEOUT1P Driver", NULL, "LINEOUT1P Mixer" },
@@ -771,17 +771,17 @@ static const struct snd_soc_dapm_route l
 static const struct snd_soc_dapm_route lineout2_diff_routes[] = {
 	{ "LINEOUT2 Mixer", "IN2L Switch", "IN2L PGA" },
 	{ "LINEOUT2 Mixer", "IN2R Switch", "IN2R PGA" },
-	{ "LINEOUT2 Mixer", "Output Switch", "Right Output Mixer" },
+	{ "LINEOUT2 Mixer", "Output Switch", "Right Output PGA" },
 
 	{ "LINEOUT2N Driver", NULL, "LINEOUT2 Mixer" },
 	{ "LINEOUT2P Driver", NULL, "LINEOUT2 Mixer" },
 };
 
 static const struct snd_soc_dapm_route lineout2_se_routes[] = {
-	{ "LINEOUT2N Mixer", "Left Output Switch", "Left Output Mixer" },
-	{ "LINEOUT2N Mixer", "Right Output Switch", "Left Output Mixer" },
+	{ "LINEOUT2N Mixer", "Left Output Switch", "Left Output PGA" },
+	{ "LINEOUT2N Mixer", "Right Output Switch", "Right Output PGA" },
 
-	{ "LINEOUT2P Mixer", "Right Output Switch", "Right Output Mixer" },
+	{ "LINEOUT2P Mixer", "Right Output Switch", "Right Output PGA" },
 
 	{ "LINEOUT2N Driver", NULL, "LINEOUT2N Mixer" },
 	{ "LINEOUT2P Driver", NULL, "LINEOUT2P Mixer" },
