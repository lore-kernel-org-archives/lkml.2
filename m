Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab1A2Ai7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 19:38:59 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:26316 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706Ab1A2Ai6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 19:38:58 -0500
Date: Sat, 29 Jan 2011 01:40:04 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
        Jaroslav Kysela <perex@perex.cz>, Wu Fengguang <wfg@linux.intel.com>
Subject: [PATCH] sound, hda_eld: suspicious sizeof() in call to
 snd_print_pcm_bits()
Message-ID: <alpine.LNX.2.00.1101290132560.6465@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In hdmi_show_short_audio_desc() we call snd_print_pcm_bits() like this:
  snd_print_pcm_bits(a->sample_bits, buf2 + 8, sizeof(buf2 - 8));
that last argument is supposed to be the size of the buffer that 
snd_print_pcm_bits() writes to, so I believe it should be this:
  snd_print_pcm_bits(a->sample_bits, buf2 + 8, sizeof(buf2) - 8);

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 hda_eld.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

 Compile tested only. I don't have relevant hardware.

diff --git a/sound/pci/hda/hda_eld.c b/sound/pci/hda/hda_eld.c
index 4a66347..74b0560 100644
--- a/sound/pci/hda/hda_eld.c
+++ b/sound/pci/hda/hda_eld.c
@@ -381,7 +381,7 @@ static void hdmi_show_short_audio_desc(struct cea_sad *a)
 	snd_print_pcm_rates(a->rates, buf, sizeof(buf));
 
 	if (a->format == AUDIO_CODING_TYPE_LPCM)
-		snd_print_pcm_bits(a->sample_bits, buf2 + 8, sizeof(buf2 - 8));
+		snd_print_pcm_bits(a->sample_bits, buf2 + 8, sizeof(buf2) - 8);
 	else if (a->max_bitrate)
 		snprintf(buf2, sizeof(buf2),
 				", max bitrate = %d", a->max_bitrate);


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

