Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556Ab1DZVUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:20:17 -0400
Received: from mga14.intel.com ([143.182.124.37]:1652 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932515Ab1DZVPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:15:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="425951523"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [91/106] ASoC: Fix output PGA enabling in wm_hubs CODECs
Message-Id: <20110426211413.7250C3E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:14:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 39cca168bdfaef9d0c496ec27f292445d6184946 upstream.

The output PGA was not being powered up in headphone and speaker paths,
removing the ability to offer volume control and mute with the output
PGA.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/soc/codecs/wm_hubs.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6.35.y/sound/soc/codecs/wm_hubs.c
===================================================================
--- linux-2.6.35.y.orig/sound/soc/codecs/wm_hubs.c
+++ linux-2.6.35.y/sound/soc/codecs/wm_hubs.c
@@ -705,12 +705,12 @@ static const struct snd_soc_dapm_route a
 
 	{ "SPKL", "Input Switch", "MIXINL" },
 	{ "SPKL", "IN1LP Switch", "IN1LP" },
-	{ "SPKL", "Output Switch", "Left Output Mixer" },
+	{ "SPKL", "Output Switch", "Left Output PGA" },
 	{ "SPKL", NULL, "TOCLK" },
 
 	{ "SPKR", "Input Switch", "MIXINR" },
 	{ "SPKR", "IN1RP Switch", "IN1RP" },
-	{ "SPKR", "Output Switch", "Right Output Mixer" },
+	{ "SPKR", "Output Switch", "Right Output PGA" },
 	{ "SPKR", NULL, "TOCLK" },
 
 	{ "SPKL Boost", "Direct Voice Switch", "Direct Voice" },
@@ -732,8 +732,8 @@ static const struct snd_soc_dapm_route a
 	{ "SPKOUTRP", NULL, "SPKR Driver" },
 	{ "SPKOUTRN", NULL, "SPKR Driver" },
 
-	{ "Left Headphone Mux", "Mixer", "Left Output Mixer" },
-	{ "Right Headphone Mux", "Mixer", "Right Output Mixer" },
+	{ "Left Headphone Mux", "Mixer", "Left Output PGA" },
+	{ "Right Headphone Mux", "Mixer", "Right Output PGA" },
 
 	{ "Headphone PGA", NULL, "Left Headphone Mux" },
 	{ "Headphone PGA", NULL, "Right Headphone Mux" },
