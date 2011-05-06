Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757Ab1EFAtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:49:14 -0400
Received: from kroah.org ([198.145.64.141]:36989 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755928Ab1EFAZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:19 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:13 2011
Message-Id: <20110506002213.350659490@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vince Weaver <vweaver1@eecs.utk.edu>, Takashi Iwai <tiwai@suse.de>
Subject: [083/143] ALSA: hda - MacBookPro 5,3 line-in support
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Vince Weaver <vweaver1@eecs.utk.edu>

commit 4e7d7c6018567fa03f387d06602d4145c75ebbe0 upstream.

I've found the following patch is necessary to enable line-in on
my MacBookPro 5,3 machine.  With the patch applied I've successfully
recorded audio from the line-in jack.  This is based on the existing
5,5 support.

Signed-off-by: Vince Weaver <vweaver1@eecs.utk.edu>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 sound/pci/hda/patch_cirrus.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_cirrus.c
+++ b/sound/pci/hda/patch_cirrus.c
@@ -65,6 +65,7 @@ struct cs_spec {
 
 /* available models */
 enum {
+	CS420X_MBP53,
 	CS420X_MBP55,
 	CS420X_IMAC27,
 	CS420X_AUTO,
@@ -833,7 +834,8 @@ static void cs_automute(struct hda_codec
 				    AC_VERB_SET_PIN_WIDGET_CONTROL,
 				    hp_present ? 0 : PIN_OUT);
 	}
-	if (spec->board_config == CS420X_MBP55 ||
+	if (spec->board_config == CS420X_MBP53 ||
+	    spec->board_config == CS420X_MBP55 ||
 	    spec->board_config == CS420X_IMAC27) {
 		unsigned int gpio = hp_present ? 0x02 : 0x08;
 		snd_hda_codec_write(codec, 0x01, 0,
@@ -1079,6 +1081,7 @@ static int cs_parse_auto_config(struct h
 }
 
 static const char *cs420x_models[CS420X_MODELS] = {
+	[CS420X_MBP53] = "mbp53",
 	[CS420X_MBP55] = "mbp55",
 	[CS420X_IMAC27] = "imac27",
 	[CS420X_AUTO] = "auto",
@@ -1086,6 +1089,7 @@ static const char *cs420x_models[CS420X_
 
 
 static struct snd_pci_quirk cs420x_cfg_tbl[] = {
+	SND_PCI_QUIRK(0x10de, 0x0ac0, "MacBookPro 5,3", CS420X_MBP53),
 	SND_PCI_QUIRK(0x10de, 0xcb79, "MacBookPro 5,5", CS420X_MBP55),
 	SND_PCI_QUIRK(0x8086, 0x7270, "IMac 27 Inch", CS420X_IMAC27),
 	{} /* terminator */
@@ -1096,6 +1100,20 @@ struct cs_pincfg {
 	u32 val;
 };
 
+static struct cs_pincfg mbp53_pincfgs[] = {
+	{ 0x09, 0x012b4050 },
+	{ 0x0a, 0x90100141 },
+	{ 0x0b, 0x90100140 },
+	{ 0x0c, 0x018b3020 },
+	{ 0x0d, 0x90a00110 },
+	{ 0x0e, 0x400000f0 },
+	{ 0x0f, 0x01cbe030 },
+	{ 0x10, 0x014be060 },
+	{ 0x12, 0x400000f0 },
+	{ 0x15, 0x400000f0 },
+	{} /* terminator */
+};
+
 static struct cs_pincfg mbp55_pincfgs[] = {
 	{ 0x09, 0x012b4030 },
 	{ 0x0a, 0x90100121 },
@@ -1125,6 +1143,7 @@ static struct cs_pincfg imac27_pincfgs[]
 };
 
 static struct cs_pincfg *cs_pincfgs[CS420X_MODELS] = {
+	[CS420X_MBP53] = mbp53_pincfgs,
 	[CS420X_MBP55] = mbp55_pincfgs,
 	[CS420X_IMAC27] = imac27_pincfgs,
 };
@@ -1157,6 +1176,7 @@ static int patch_cs420x(struct hda_codec
 
 	switch (spec->board_config) {
 	case CS420X_IMAC27:
+	case CS420X_MBP53:
 	case CS420X_MBP55:
 		/* GPIO1 = headphones */
 		/* GPIO3 = speakers */


