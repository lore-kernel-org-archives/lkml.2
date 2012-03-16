Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946225Ab2CPXvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:51:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45118 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965525Ab2CPXjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:39:40 -0400
Message-Id: <20120316233810.781249292@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:38:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 02/41] ALSA: hda/realtek - Apply the coef-setup only to ALC269VB
In-Reply-To: <20120316233829.GA14022@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

commit 526af6eb4dc71302f59806e2ccac7793963a7fe0 upstream.

The coef setup in alc269_fill_coef() was designed only for ALC269VB
model, and this has some bad effects for other ALC269 variants, such
as turning off the external mic input.  Apply it only to ALC269VB.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2063,12 +2063,16 @@ static int alc_build_controls(struct hda
  */
 
 static void alc_init_special_input_src(struct hda_codec *codec);
+static int alc269_fill_coef(struct hda_codec *codec);
 
 static int alc_init(struct hda_codec *codec)
 {
 	struct alc_spec *spec = codec->spec;
 	unsigned int i;
 
+	if (codec->vendor_id == 0x10ec0269)
+		alc269_fill_coef(codec);
+
 	alc_fix_pll(codec);
 	alc_auto_init_amp(codec, spec->init_amp);
 
@@ -5110,8 +5114,12 @@ static const struct alc_model_fixup alc2
 
 static int alc269_fill_coef(struct hda_codec *codec)
 {
+	struct alc_spec *spec = codec->spec;
 	int val;
 
+	if (spec->codec_variant != ALC269_TYPE_ALC269VB)
+		return 0;
+
 	if ((alc_get_coef0(codec) & 0x00ff) < 0x015) {
 		alc_write_coef_idx(codec, 0xf, 0x960b);
 		alc_write_coef_idx(codec, 0xe, 0x8817);


