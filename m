Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab1EJTOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 15:14:42 -0400
Received: from smtp-out.google.com ([216.239.44.51]:11692 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab1EJTOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 15:14:41 -0400
From: Taylor Hutt <thutt@chromium.org>
To: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org, Taylor Hutt <thutt@chromium.org>
Subject: [PATCH] CHROMIUM: ASoC: Remove 'const' modifiers which cause warnings during compilation.
Date: Tue, 10 May 2011 12:14:20 -0700
Message-Id: <1305054860-16054-1-git-send-email-thutt@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change removes a warning produced when 'const * const' values
are assigned to a 'const **'.

These code being modified originally came from these two commits:

    http://git.kernel.org/?p=linux/kernel/git/broonie/sound-2.6.git;a=commit;h=82a5a936f6dea13849d93a2899a9b7294a8db336
    http://git.kernel.org/?p=linux/kernel/git/broonie/sound-2.6.git;a=commit;h=dad31ec133adb20c8fd10bfd9379da3f08b8721e

Change-Id: I964ff6d24aafe78c2db7002abfd03b9069db9687
Signed-off-by: Taylor Hutt <thutt@chromium.org>
---
 sound/soc/codecs/max98095.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/sound/soc/codecs/max98095.c b/sound/soc/codecs/max98095.c
index a6cc94e..55f5d0f 100644
--- a/sound/soc/codecs/max98095.c
+++ b/sound/soc/codecs/max98095.c
@@ -678,7 +678,7 @@ static void m98095_biquad_band(struct snd_soc_codec *codec, unsigned int dai,
 	}
 }
 
-static const char * const max98095_fltr_mode[] = { "Voice", "Music" };
+static const char *max98095_fltr_mode[] = { "Voice", "Music" };
 static const struct soc_enum max98095_dai1_filter_mode_enum[] = {
 	SOC_ENUM_SINGLE(M98095_02E_DAI1_FILTERS, 7, 2, max98095_fltr_mode),
 };
@@ -686,7 +686,7 @@ static const struct soc_enum max98095_dai2_filter_mode_enum[] = {
 	SOC_ENUM_SINGLE(M98095_038_DAI2_FILTERS, 7, 2, max98095_fltr_mode),
 };
 
-static const char * const max98095_extmic_text[] = { "None", "MIC1", "MIC2" };
+static const char *max98095_extmic_text[] = { "None", "MIC1", "MIC2" };
 
 static const struct soc_enum max98095_extmic_enum =
 	SOC_ENUM_SINGLE(M98095_087_CFG_MIC, 0, 3, max98095_extmic_text);
@@ -694,24 +694,22 @@ static const struct soc_enum max98095_extmic_enum =
 static const struct snd_kcontrol_new max98095_extmic_mux =
 	SOC_DAPM_ENUM("External MIC Mux", max98095_extmic_enum);
 
-static const char * const max98095_linein_text[] = { "INA", "INB" };
-
+static const char *max98095_linein_text[] = { "INA", "INB" };
 static const struct soc_enum max98095_linein_enum =
 	SOC_ENUM_SINGLE(M98095_086_CFG_LINE, 6, 2, max98095_linein_text);
 
 static const struct snd_kcontrol_new max98095_linein_mux =
 	SOC_DAPM_ENUM("Linein Input Mux", max98095_linein_enum);
 
-static const char * const max98095_line_mode_text[] = {
+static const char *max98095_line_mode_text[] = {
 	"Stereo", "Differential"};
-
 static const struct soc_enum max98095_linein_mode_enum =
 	SOC_ENUM_SINGLE(M98095_086_CFG_LINE, 7, 2, max98095_line_mode_text);
 
 static const struct soc_enum max98095_lineout_mode_enum =
 	SOC_ENUM_SINGLE(M98095_086_CFG_LINE, 4, 2, max98095_line_mode_text);
 
-static const char * const max98095_dai_fltr[] = {
+static const char *max98095_dai_fltr[] = {
 	"Off", "Elliptical-HPF-16k", "Butterworth-HPF-16k",
 	"Elliptical-HPF-8k", "Butterworth-HPF-8k", "Butterworth-HPF-Fs/240"};
 static const struct soc_enum max98095_dai1_dac_filter_enum[] = {
-- 
1.7.3.1

