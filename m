Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933246Ab1C3VG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:06:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:21130 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933137Ab1C3VGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621236178"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: david.henningsson@canonical.com, tiwai@suse.de, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [45/275] ALSA: HDA: Fix dmesg output of HDMI supported bits
Message-Id: <20110330210441.143D13E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: David Henningsson <david.henningsson@canonical.com>

commit d757534ed15387202e322854cd72dc58bbb975de upstream.

This typo caused the dmesg output of the supported bits of HDMI
to be cut off early.

Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/pci/hda/hda_eld.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/sound/pci/hda/hda_eld.c
===================================================================
--- linux-2.6.35.y.orig/sound/pci/hda/hda_eld.c	2011-03-29 22:51:51.337409574 -0700
+++ linux-2.6.35.y/sound/pci/hda/hda_eld.c	2011-03-29 23:02:59.121322653 -0700
@@ -381,7 +381,7 @@
 	snd_print_pcm_rates(a->rates, buf, sizeof(buf));
 
 	if (a->format == AUDIO_CODING_TYPE_LPCM)
-		snd_print_pcm_bits(a->sample_bits, buf2 + 8, sizeof(buf2 - 8));
+		snd_print_pcm_bits(a->sample_bits, buf2 + 8, sizeof(buf2) - 8);
 	else if (a->max_bitrate)
 		snprintf(buf2, sizeof(buf2),
 				", max bitrate = %d", a->max_bitrate);
