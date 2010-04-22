Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247Ab0DVTfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:35:07 -0400
Received: from kroah.org ([198.145.64.141]:41532 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756767Ab0DVT3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:51 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:23 2010
Message-Id: <20100422190923.248398208@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:10:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel T Chen <crimsun@ubuntu.com>, Takashi Iwai <tiwai@suse.de>
Subject: [177/197] ALSA: hda: Set Front Mic to input vref 50% for Lenovo 3000 Y410
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel T Chen <crimsun@ubuntu.com>

commit e2595322a3a353a59cecd7f57e7aa421ecb02d12 upstream.

BugLink: https://bugs.launchpad.net/bugs/479373

The OR has verified with hda-verb that the internal microphone needs
VREF50 set for audible capture.

Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10621,6 +10621,13 @@ static struct hda_verb alc262_lenovo_300
 	{}
 };
 
+static struct hda_verb alc262_lenovo_3000_init_verbs[] = {
+	/* Front Mic pin: input vref at 50% */
+	{0x19, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_VREF50},
+	{0x19, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE},
+	{}
+};
+
 static struct hda_input_mux alc262_fujitsu_capture_source = {
 	.num_items = 3,
 	.items = {
@@ -11688,7 +11695,8 @@ static struct alc_config_preset alc262_p
 	[ALC262_LENOVO_3000] = {
 		.mixers = { alc262_lenovo_3000_mixer },
 		.init_verbs = { alc262_init_verbs, alc262_EAPD_verbs,
-				alc262_lenovo_3000_unsol_verbs },
+				alc262_lenovo_3000_unsol_verbs,
+				alc262_lenovo_3000_init_verbs },
 		.num_dacs = ARRAY_SIZE(alc262_dac_nids),
 		.dac_nids = alc262_dac_nids,
 		.hp_nid = 0x03,


