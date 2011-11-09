Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965657Ab1KJDpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:45:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44752 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965621Ab1KJDpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:45:14 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:58 2011
Message-Id: <20111109213158.509125145@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:33:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Vine <chris@cvine.freeserve.co.uk>,
        Takashi Iwai <tiwai@suse.de>
Subject: [162/264] ALSA: hda - Add missing static ADC tables for ALC269 quirks
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[There is no upstream commit for this patch since the corresponding
code was removed from 3.2 kernel.  This is a regression found only in
3.1 kernel, so please apply this only to 3.1.x series.]

Some ALC269 quirks define their own .cap_mixer field but without the
static adc_nids[].  This resulted in the mismatch of ADC because ALC269
may have the widget 0x07 for another audio-in, and the auto-parser picks
this up instead.

This patch fixes the problem by adding the static adc_nids[] and co
again to these entries.

Tested-by: Chris Vine <chris@cvine.freeserve.co.uk>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/alc269_quirks.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/sound/pci/hda/alc269_quirks.c
+++ b/sound/pci/hda/alc269_quirks.c
@@ -577,6 +577,9 @@ static const struct alc_config_preset al
 				alc269_laptop_amic_init_verbs },
 		.num_dacs = ARRAY_SIZE(alc269_dac_nids),
 		.dac_nids = alc269_dac_nids,
+		.adc_nids = alc269_adc_nids,
+		.capsrc_nids = alc269_capsrc_nids,
+		.num_adc_nids = ARRAY_SIZE(alc269_adc_nids),
 		.hp_nid = 0x03,
 		.num_channel_mode = ARRAY_SIZE(alc269_modes),
 		.channel_mode = alc269_modes,
@@ -591,6 +594,9 @@ static const struct alc_config_preset al
 				alc269_laptop_dmic_init_verbs },
 		.num_dacs = ARRAY_SIZE(alc269_dac_nids),
 		.dac_nids = alc269_dac_nids,
+		.adc_nids = alc269_adc_nids,
+		.capsrc_nids = alc269_capsrc_nids,
+		.num_adc_nids = ARRAY_SIZE(alc269_adc_nids),
 		.hp_nid = 0x03,
 		.num_channel_mode = ARRAY_SIZE(alc269_modes),
 		.channel_mode = alc269_modes,
@@ -605,6 +611,9 @@ static const struct alc_config_preset al
 				alc269vb_laptop_amic_init_verbs },
 		.num_dacs = ARRAY_SIZE(alc269_dac_nids),
 		.dac_nids = alc269_dac_nids,
+		.adc_nids = alc269vb_adc_nids,
+		.capsrc_nids = alc269vb_capsrc_nids,
+		.num_adc_nids = ARRAY_SIZE(alc269vb_adc_nids),
 		.hp_nid = 0x03,
 		.num_channel_mode = ARRAY_SIZE(alc269_modes),
 		.channel_mode = alc269_modes,
@@ -619,6 +628,9 @@ static const struct alc_config_preset al
 				alc269vb_laptop_dmic_init_verbs },
 		.num_dacs = ARRAY_SIZE(alc269_dac_nids),
 		.dac_nids = alc269_dac_nids,
+		.adc_nids = alc269vb_adc_nids,
+		.capsrc_nids = alc269vb_capsrc_nids,
+		.num_adc_nids = ARRAY_SIZE(alc269vb_adc_nids),
 		.hp_nid = 0x03,
 		.num_channel_mode = ARRAY_SIZE(alc269_modes),
 		.channel_mode = alc269_modes,
@@ -633,6 +645,8 @@ static const struct alc_config_preset al
 				alc269_laptop_dmic_init_verbs },
 		.num_dacs = ARRAY_SIZE(alc269_dac_nids),
 		.dac_nids = alc269_dac_nids,
+		.adc_nids = alc269_adc_nids,
+		.capsrc_nids = alc269_capsrc_nids,
 		.hp_nid = 0x03,
 		.num_channel_mode = ARRAY_SIZE(alc269_modes),
 		.channel_mode = alc269_modes,


