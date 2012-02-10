Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760603Ab2BJWln (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:41:43 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35084 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760411Ab2BJWlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:41:36 -0500
MIME-Version: 1.0
Message-Id: <20120210222945.848673791@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:29:28 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [patch 09/86] ASoC: wm_hubs: Enable line out VMID buffer for single ended line outputs
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 77231abe55433aa17eca712718745275853fa66d upstream.

For optimal performance the single ended line outputs require that the
line output VMID buffer be enabled.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm_hubs.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/soc/codecs/wm_hubs.c
+++ b/sound/soc/codecs/wm_hubs.c
@@ -614,6 +614,8 @@ SND_SOC_DAPM_INPUT("IN2RP:VXRP"),
 SND_SOC_DAPM_MICBIAS("MICBIAS2", WM8993_POWER_MANAGEMENT_1, 5, 0),
 SND_SOC_DAPM_MICBIAS("MICBIAS1", WM8993_POWER_MANAGEMENT_1, 4, 0),
 
+SND_SOC_DAPM_SUPPLY("LINEOUT_VMID_BUF", WM8993_ANTIPOP1, 7, 0, NULL, 0),
+
 SND_SOC_DAPM_MIXER("IN1L PGA", WM8993_POWER_MANAGEMENT_2, 6, 0,
 		   in1l_pga, ARRAY_SIZE(in1l_pga)),
 SND_SOC_DAPM_MIXER("IN1R PGA", WM8993_POWER_MANAGEMENT_2, 4, 0,
@@ -832,9 +834,11 @@ static const struct snd_soc_dapm_route l
 };
 
 static const struct snd_soc_dapm_route lineout1_se_routes[] = {
+	{ "LINEOUT1N Mixer", NULL, "LINEOUT_VMID_BUF" },
 	{ "LINEOUT1N Mixer", "Left Output Switch", "Left Output PGA" },
 	{ "LINEOUT1N Mixer", "Right Output Switch", "Right Output PGA" },
 
+	{ "LINEOUT1P Mixer", NULL, "LINEOUT_VMID_BUF" },
 	{ "LINEOUT1P Mixer", "Left Output Switch", "Left Output PGA" },
 
 	{ "LINEOUT1N Driver", NULL, "LINEOUT1N Mixer" },
@@ -851,9 +855,11 @@ static const struct snd_soc_dapm_route l
 };
 
 static const struct snd_soc_dapm_route lineout2_se_routes[] = {
+	{ "LINEOUT2N Mixer", NULL, "LINEOUT_VMID_BUF" },
 	{ "LINEOUT2N Mixer", "Left Output Switch", "Left Output PGA" },
 	{ "LINEOUT2N Mixer", "Right Output Switch", "Right Output PGA" },
 
+	{ "LINEOUT2P Mixer", NULL, "LINEOUT_VMID_BUF" },
 	{ "LINEOUT2P Mixer", "Right Output Switch", "Right Output PGA" },
 
 	{ "LINEOUT2N Driver", NULL, "LINEOUT2N Mixer" },


