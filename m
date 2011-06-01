Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162775Ab1FAIX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:23:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44181 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162713Ab1FAIXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:23:52 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:49 2011
Message-Id: <20110601081149.260524103@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:11:09 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [099/165] ASoC: Add some missing volume update bit sets for wm_hubs
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
 devices
Content-Length: 1499
Lines: 39

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit fb5af53d421d80725172427e9076f6e889603df6 upstream.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm_hubs.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/wm_hubs.c
+++ b/sound/soc/codecs/wm_hubs.c
@@ -836,17 +836,21 @@ int wm_hubs_add_analogue_controls(struct
 	snd_soc_update_bits(codec, WM8993_RIGHT_LINE_INPUT_3_4_VOLUME,
 			    WM8993_IN2_VU, WM8993_IN2_VU);
 
+	snd_soc_update_bits(codec, WM8993_SPEAKER_VOLUME_LEFT,
+			    WM8993_SPKOUT_VU, WM8993_SPKOUT_VU);
 	snd_soc_update_bits(codec, WM8993_SPEAKER_VOLUME_RIGHT,
 			    WM8993_SPKOUT_VU, WM8993_SPKOUT_VU);
 
 	snd_soc_update_bits(codec, WM8993_LEFT_OUTPUT_VOLUME,
-			    WM8993_HPOUT1L_ZC, WM8993_HPOUT1L_ZC);
+			    WM8993_HPOUT1_VU | WM8993_HPOUT1L_ZC,
+			    WM8993_HPOUT1_VU | WM8993_HPOUT1L_ZC);
 	snd_soc_update_bits(codec, WM8993_RIGHT_OUTPUT_VOLUME,
 			    WM8993_HPOUT1_VU | WM8993_HPOUT1R_ZC,
 			    WM8993_HPOUT1_VU | WM8993_HPOUT1R_ZC);
 
 	snd_soc_update_bits(codec, WM8993_LEFT_OPGA_VOLUME,
-			    WM8993_MIXOUTL_ZC, WM8993_MIXOUTL_ZC);
+			    WM8993_MIXOUTL_ZC | WM8993_MIXOUT_VU,
+			    WM8993_MIXOUTL_ZC | WM8993_MIXOUT_VU);
 	snd_soc_update_bits(codec, WM8993_RIGHT_OPGA_VOLUME,
 			    WM8993_MIXOUTR_ZC | WM8993_MIXOUT_VU,
 			    WM8993_MIXOUTR_ZC | WM8993_MIXOUT_VU);


