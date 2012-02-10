Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760955Ab2BJXNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:13:32 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42369 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932615Ab2BJWmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:42:32 -0500
MIME-Version: 1.0
Message-Id: <20120210222949.998748819@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:30:15 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [patch 56/86] ASoC: wm_hubs: Fix routing of input PGAs to line output
 mixer
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit ee76744c51ec342df9822b4a85dbbfc3887b6d60 upstream.

IN1L/R is routed to both line output mixers, we don't route IN1 to LINEOUT1
and IN2 to LINEOUT2.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm_hubs.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/sound/soc/codecs/wm_hubs.c
+++ b/sound/soc/codecs/wm_hubs.c
@@ -587,8 +587,8 @@ SOC_DAPM_SINGLE("Left Output Switch", WM
 };
 
 static const struct snd_kcontrol_new line2_mix[] = {
-SOC_DAPM_SINGLE("IN2R Switch", WM8993_LINE_MIXER2, 2, 1, 0),
-SOC_DAPM_SINGLE("IN2L Switch", WM8993_LINE_MIXER2, 1, 1, 0),
+SOC_DAPM_SINGLE("IN1R Switch", WM8993_LINE_MIXER2, 2, 1, 0),
+SOC_DAPM_SINGLE("IN1L Switch", WM8993_LINE_MIXER2, 1, 1, 0),
 SOC_DAPM_SINGLE("Output Switch", WM8993_LINE_MIXER2, 0, 1, 0),
 };
 
@@ -846,8 +846,8 @@ static const struct snd_soc_dapm_route l
 };
 
 static const struct snd_soc_dapm_route lineout2_diff_routes[] = {
-	{ "LINEOUT2 Mixer", "IN2L Switch", "IN2L PGA" },
-	{ "LINEOUT2 Mixer", "IN2R Switch", "IN2R PGA" },
+	{ "LINEOUT2 Mixer", "IN1L Switch", "IN1L PGA" },
+	{ "LINEOUT2 Mixer", "IN1R Switch", "IN1R PGA" },
 	{ "LINEOUT2 Mixer", "Output Switch", "Right Output PGA" },
 
 	{ "LINEOUT2N Driver", NULL, "LINEOUT2 Mixer" },


