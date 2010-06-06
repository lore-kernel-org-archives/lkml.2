Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab0FFXJ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 19:09:59 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:47225 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab0FFXJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 19:09:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xfyoHZYzfAhV59mkhTn3xgNA7gCU+PMMLspTLs2rDJ4zZ2FYYTec8+vX6iXTbcR2Iy
         tS9T+2sqYys+0uCIC+9MZ6i9RWfGxHVa9MQYKdDtCkpCxO0x292zlqpzr1uMumBS9XGe
         4dg9Jowc8irV0i8k6iqPuVUm009fMXYtNfX+g=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: alsa-devel@alsa-project.org
Cc: tiwai@suse.de, linux-kernel@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 4/5]alsa:patch_realtek.c Add support for the iMac7,1
Date: Sun,  6 Jun 2010 16:09:52 -0700
Message-Id: <1275865793-7357-4-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
In-Reply-To: <1275865793-7357-3-git-send-email-justinmattock@gmail.com>
References: <1275865793-7357-1-git-send-email-justinmattock@gmail.com>
 <1275865793-7357-2-git-send-email-justinmattock@gmail.com>
 <1275865793-7357-3-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: The below patch does not work with patch 5/5
(Add-SSID-table-for-iMac7-1)
I'm giving the option of either adding/creating a whole
new section for the iMac7,1 and or just add
the SSID for the iMac7,1 using ALC882_ASUS_A7M
stated on bug entry:
https://bugs.launchpad.net/mactel-support/+bug/360866

Note:I do not have this machine on hand only
codec#0 file for the machine so please
test if you have the appropriate equipment.

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/sound/alsa/HD-Audio-Models.txt |    1 +
 sound/pci/hda/patch_realtek.c                |   62 ++++++++++++++++++++++++++
 2 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/Documentation/sound/alsa/HD-Audio-Models.txt b/Documentation/sound/alsa/HD-Audio-Models.txt
index 1d38b0d..a9aac53 100644
--- a/Documentation/sound/alsa/HD-Audio-Models.txt
+++ b/Documentation/sound/alsa/HD-Audio-Models.txt
@@ -127,6 +127,7 @@ ALC882/883/885/888/889
   macmini3	Macmini 3,1
   mba21		Macbook Air 2,1
   mbp3		Macbook Pro rev3
+  imac71	iMac 7,1
   imac24	iMac 24'' with jack detection
   imac91	iMac 9,1
   w2jc		ASUS W2JC
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 17d4548..5ef35b8 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -213,6 +213,7 @@ enum {
 	ALC885_MBP3,
 	ALC885_MB5,
 	ALC885_MACMINI3,
+	ALC885_IMAC71,
 	ALC885_IMAC24,
 	ALC885_IMAC91,
 	ALC883_3ST_2ch_DIG,
@@ -7493,6 +7494,21 @@ static struct snd_kcontrol_new alc885_macmini3_mixer[] = {
 	{ } /* end */
 };
 
+static struct snd_kcontrol_new alc882_imac71_mixer[] = {
+	HDA_CODEC_VOLUME("Front Playback Volume", 0x0c, 0x0, HDA_OUTPUT),
+	HDA_BIND_MUTE("Front Playback Switch", 0x0c, 2, HDA_INPUT),
+	HDA_CODEC_MUTE("Headphone Playback Switch", 0x15, 0x0, HDA_OUTPUT),
+	HDA_CODEC_VOLUME("CD Playback Volume", 0x0b, 0x04, HDA_INPUT),
+	HDA_CODEC_MUTE("CD Playback Switch", 0x0b, 0x04, HDA_INPUT),
+	HDA_CODEC_VOLUME("Line Playback Volume", 0x0b, 0x02, HDA_INPUT),
+	HDA_CODEC_MUTE("Line Playback Switch", 0x0b, 0x02, HDA_INPUT),
+	HDA_CODEC_VOLUME("Mic Playback Volume", 0x0b, 0x0, HDA_INPUT),
+	HDA_CODEC_VOLUME("Mic Boost", 0x18, 0, HDA_INPUT),
+	HDA_CODEC_MUTE("Mic Playback Switch", 0x0b, 0x0, HDA_INPUT),
+	{ } /* end */
+};
+
+
 static struct snd_kcontrol_new alc885_imac91_mixer[] = {
 	HDA_CODEC_VOLUME("Speaker Playback Volume", 0x0c, 0x00, HDA_OUTPUT),
 	HDA_BIND_MUTE("Speaker Playback Switch", 0x0c, 0x02, HDA_INPUT),
@@ -7994,6 +8010,25 @@ static struct hda_verb alc885_mbp3_init_verbs[] = {
 	{ }
 };
 
+/* iMac7,1 */
+static struct hda_verb alc882_imac71_init_verbs[] = {
+	{0x0c, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
+	{0x0c, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(1)},
+
+	{0x15, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_HP},
+	{0x14, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT},
+	{0x16, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT},
+
+	{0x14, AC_VERB_SET_CONNECT_SEL, 0x00}, /* Front */
+	{0x15, AC_VERB_SET_CONNECT_SEL, 0x00}, /* HP */
+	{0x16, AC_VERB_SET_CONNECT_SEL, 0x00}, /* Front */
+
+	{0x18, AC_VERB_SET_CONNECT_SEL, 0x02}, /* mic/clfe */
+	{0x1a, AC_VERB_SET_CONNECT_SEL, 0x01}, /* line/surround */
+	{0x1b, AC_VERB_SET_CONNECT_SEL, 0x00}, /* HP */
+	{ } /* end */
+};
+
 /* iMac 9,1 */
 static struct hda_verb alc885_imac91_init_verbs[] = {
 	/* Internal Speaker Pin (0x0c) */
@@ -8099,7 +8134,14 @@ static void alc885_mba21_setup(struct hda_codec *codec)
        spec->autocfg.speaker_pins[0] = 0x18;
 }
 
+static void alc885_imac71_setup(struct hda_codec *codec)
+{
+	struct alc_spec *spec = codec->spec;
 
+	spec->autocfg.hp_pins[0] = 0x15;
+	spec->autocfg.speaker_pins[0] = 0x14;
+	spec->autocfg.speaker_pins[1] = 0x16;
+}
 
 static void alc885_mbp3_setup(struct hda_codec *codec)
 {
@@ -9300,6 +9342,7 @@ static const char *alc882_models[ALC882_MODEL_LAST] = {
 	[ALC885_MACMINI3]	= "macmini3",
 	[ALC885_MBA21]		= "mba21",
 	[ALC885_MBP3]		= "mbp3",
+	[ALC882_IMAC71]		= "imac71",
 	[ALC885_IMAC24]		= "imac24",
 	[ALC885_IMAC91]		= "imac91",
 	[ALC883_3ST_2ch_DIG]	= "3stack-2ch-dig",
@@ -9478,6 +9521,7 @@ static struct snd_pci_quirk alc882_ssid_cfg_tbl[] = {
 	SND_PCI_QUIRK(0x106b, 0x2c00, "MacbookPro rev3", ALC885_MBP3),
 	SND_PCI_QUIRK(0x106b, 0x3600, "Macbook 3,1", ALC889A_MB31),
 	SND_PCI_QUIRK(0x106b, 0x3800, "MacbookPro 4,1", ALC885_MBP3),
+	SND_PCI_QUIRK(0x106b, 0x3200, "iMac 7,1 Aluminum", ALC882_IMAC71),
 	SND_PCI_QUIRK(0x106b, 0x3e00, "iMac 24 Aluminum", ALC885_IMAC24),
 	SND_PCI_QUIRK(0x106b, 0x4900, "iMac 9,1 Aluminum", ALC885_IMAC91),
 	SND_PCI_QUIRK(0x106b, 0x3f00, "Macbook 5,1", ALC885_MB5),
@@ -9608,6 +9652,24 @@ static struct alc_config_preset alc882_presets[] = {
 		.input_mux = &alc882_capture_source,
 		.init_hook = alc885_macpro_init_hook,
 	},
+	[ALC882_IMAC71] = {
+		.mixers = { alc882_imac71_mixer, alc882_chmode_mixer },
+		.init_verbs = { alc882_base_init_verbs, alc882_adc1_init_verbs,
+				alc882_imac71_init_verbs},
+		.num_dacs = ARRAY_SIZE(alc882_dac_nids),
+		.dac_nids = alc882_dac_nids,
+		.dig_out_nid = ALC882_DIGOUT_NID,
+		.num_adc_nids = ARRAY_SIZE(alc882_adc_nids),
+		.adc_nids = alc882_adc_nids,
+		.capsrc_nids = alc882_capsrc_nids,
+		.num_channel_mode = ARRAY_SIZE(alc882_3ST_6ch_modes),
+		.channel_mode = alc882_3ST_6ch_modes,
+		.need_dac_fix = 1,
+		.input_mux = &alc882_capture_source,
+		.unsol_event = alc_automute_amp_unsol_event,
+		.setup = alc885_imac71_setup,
+		.init_hook = alc_automute_amp,
+	}
 	[ALC885_IMAC24] = {
 		.mixers = { alc885_imac24_mixer },
 		.init_verbs = { alc885_imac24_init_verbs },
-- 
1.6.5.2.180.gc5b3e

