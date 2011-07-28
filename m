Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab1G1Xqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:46:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:24978 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932231Ab1G1Xow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="35732487"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: broonie@opensource.wolfsonmicro.com, lrg@ti.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [47/50] ASoC: Ensure we delay long enough for WM8994 FLL to lock
Message-Id: <20110728234452.254642403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

[ upstream commit 8e9ddf811ba021506d2316fcfe619faa0ab3f567 ]
 when starting

This delay is very conservative.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@ti.com>
Cc: stable@kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/sound/soc/codecs/wm8994.c
===================================================================
--- linux-2.6.35.y.orig/sound/soc/codecs/wm8994.c
+++ linux-2.6.35.y/sound/soc/codecs/wm8994.c
@@ -2929,6 +2929,8 @@ static int wm8994_set_fll(struct snd_soc
 		snd_soc_update_bits(codec, WM8994_FLL1_CONTROL_1 + reg_offset,
 				    WM8994_FLL1_ENA | WM8994_FLL1_FRAC,
 				    reg);
+
+		msleep(5);
 	}
 
 	wm8994->fll[id].in = freq_in;
