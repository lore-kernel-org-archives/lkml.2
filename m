Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab0FBEq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 00:46:27 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:59055 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab0FBEq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 00:46:26 -0400
X-Greylist: delayed 860 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jun 2010 00:46:26 EDT
Date: Tue, 1 Jun 2010 23:31:31 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Cc: Kailang Yang <kailang@realtek.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH] regression 2.6.35-rc1+ hda realtek missing beep 10ec0883
Message-ID: <20100602043129.GE22327@spacedout.fries.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Tue, 01 Jun 2010 23:31:46 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Fries <david@fries.net>

The PC-Spekaer Beep control worked in 2.6.34, but not 2.6.35-rc1, this
is the patch that modified that behavior.
"ALSA: hda - Add parse customize define function for Realtek codecs"
regression in commit da00c24493bf6ae3772dfe7343dca033ebc75955.

Debug output (after this patch),
HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
SKU: Nid=0x0 sku_cfg=0x0000140d
SKU: port_connectivity=0x0
SKU: enable_pcbeep=0x0
SKU: check_sum=0x00000000
SKU: customization=0x00000000
SKU: external_amp=0x1
SKU: platform_type=0x1
SKU: swap=0x0
SKU: override=0x1
hda_codec: ALC883: BIOS auto-probing.
autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0)
   speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
   hp_outs=0 (0x0/0x0/0x0/0x0/0x0)
   mono: mono_out=0x0
   dig-out=0x1e/0x0
   inputs: mic=0x18, fmic=0x0, line=0x1a, fline=0x0, cd=0x1c, aux=0x0
realtek: Enabling init ASM_ID=0x140d CODEC_ID=10ec0883
input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:14.2/input/input16

Signed-off-by: David Fries <david@fries.net>
Cc: Kailang Yang <kailang@realtek.com>
Cc: Takashi Iwai <tiwai@suse.de>
---
My patch restores both the Beep volume and mute.  I'll let someone
else determine if this is the correct solution or not.

 sound/pci/hda/patch_realtek.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 17d4548..c31c8b9 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10611,7 +10611,7 @@ static int patch_alc882(struct hda_codec *codec)
 
 	set_capture_mixer(codec);
 
-	if (spec->cdefine.enable_pcbeep)
+	if (spec->cdefine.enable_pcbeep || codec->vendor_id == 0x10ec0883)
 		set_beep_amp(spec, 0x0b, 0x05, HDA_INPUT);
 
 	if (board_config == ALC882_AUTO)
-- 
1.7.1
