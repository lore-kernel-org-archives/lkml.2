Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab1EFAYN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:24:13 -0400
Received: from kroah.org ([198.145.64.141]:36536 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724Ab1EFAYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:24:11 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:06 2011
Message-Id: <20110506002205.948062679@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:19:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [009/143] ASoC: Fix output PGA enabling in wm_hubs CODECs
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 39cca168bdfaef9d0c496ec27f292445d6184946 upstream.

The output PGA was not being powered up in headphone and speaker paths,
removing the ability to offer volume control and mute with the output
PGA.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm_hubs.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/sound/soc/codecs/wm_hubs.c
+++ b/sound/soc/codecs/wm_hubs.c
@@ -593,12 +593,12 @@ static const struct snd_soc_dapm_route a
 
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
@@ -620,8 +620,8 @@ static const struct snd_soc_dapm_route a
 	{ "SPKOUTRP", NULL, "SPKR Driver" },
 	{ "SPKOUTRN", NULL, "SPKR Driver" },
 
-	{ "Left Headphone Mux", "Mixer", "Left Output Mixer" },
-	{ "Right Headphone Mux", "Mixer", "Right Output Mixer" },
+	{ "Left Headphone Mux", "Mixer", "Left Output PGA" },
+	{ "Right Headphone Mux", "Mixer", "Right Output PGA" },
 
 	{ "Headphone PGA", NULL, "Left Headphone Mux" },
 	{ "Headphone PGA", NULL, "Right Headphone Mux" },


