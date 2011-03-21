Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab1CUX1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:27:32 -0400
Received: from kroah.org ([198.145.64.141]:52642 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932292Ab1CUXSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:18:02 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:03:25 2011
Message-Id: <20110321230325.619783997@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:01:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [38/78] ALSA: HDA: Enable surround and subwoofer on Lenovo Ideapad Y530
In-Reply-To: <20110321230346.GA14681@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 32eea3884debb65ec1da633bc5df5aee23879865 upstream.

The pin config values would change the association instead of the
sequence, this commit fixes that up.

Tested-by: Bartłomiej Żogała <nusch88@gmail.com>
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10748,6 +10748,7 @@ static struct alc_config_preset alc882_p
  */
 enum {
 	PINFIX_ABIT_AW9D_MAX,
+	PINFIX_LENOVO_Y530,
 	PINFIX_PB_M5210,
 	PINFIX_ACER_ASPIRE_7736,
 };
@@ -10762,6 +10763,14 @@ static const struct alc_fixup alc882_fix
 			{ }
 		}
 	},
+	[PINFIX_LENOVO_Y530] = {
+		.type = ALC_FIXUP_PINS,
+		.v.pins = (const struct alc_pincfg[]) {
+			{ 0x15, 0x99130112 }, /* rear int speakers */
+			{ 0x16, 0x99130111 }, /* subwoofer */
+			{ }
+		}
+	},
 	[PINFIX_PB_M5210] = {
 		.type = ALC_FIXUP_VERBS,
 		.v.verbs = (const struct hda_verb[]) {
@@ -10777,6 +10786,7 @@ static const struct alc_fixup alc882_fix
 
 static struct snd_pci_quirk alc882_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x0155, "Packard-Bell M5120", PINFIX_PB_M5210),
+	SND_PCI_QUIRK(0x17aa, 0x3a0d, "Lenovo Y530", PINFIX_LENOVO_Y530),
 	SND_PCI_QUIRK(0x147b, 0x107a, "Abit AW9D-MAX", PINFIX_ABIT_AW9D_MAX),
 	SND_PCI_QUIRK(0x1025, 0x0296, "Acer Aspire 7736z", PINFIX_ACER_ASPIRE_7736),
 	{}


