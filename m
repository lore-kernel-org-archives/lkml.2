Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab0CaAKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:10:46 -0400
Received: from kroah.org ([198.145.64.141]:51983 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932197Ab0C3XSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:18:00 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:56:27 2010
Message-Id: <20100330225626.992901645@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:55:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Takashi Iwai <tiwai@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [045/116] ALSA: hda - Fix secondary ADC of ALC260 basic model
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 9c4cc0bdede1c39bde60a0d5d9251aac71fbe719 upstream.

Fix adc_nids[] for ALC260 basic model to match with num_adc_nids.
Otherwise you get an invalid NID in the secondary "Input Source" mixer
element.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6281,7 +6281,7 @@ static struct alc_config_preset alc260_p
 		.num_dacs = ARRAY_SIZE(alc260_dac_nids),
 		.dac_nids = alc260_dac_nids,
 		.num_adc_nids = ARRAY_SIZE(alc260_dual_adc_nids),
-		.adc_nids = alc260_adc_nids,
+		.adc_nids = alc260_dual_adc_nids,
 		.num_channel_mode = ARRAY_SIZE(alc260_modes),
 		.channel_mode = alc260_modes,
 		.input_mux = &alc260_capture_source,


