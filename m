Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933101Ab1BPAtb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:49:31 -0500
Received: from kroah.org ([198.145.64.141]:45676 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933086Ab1BPAtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:49:23 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:07 2011
Message-Id: <20110216002107.012384481@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:20:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [patch 079/176] ALSA: HDA: Fix dmesg output of HDMI supported bits
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit d757534ed15387202e322854cd72dc58bbb975de upstream.

This typo caused the dmesg output of the supported bits of HDMI
to be cut off early.

Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_eld.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/hda_eld.c
+++ b/sound/pci/hda/hda_eld.c
@@ -381,7 +381,7 @@ static void hdmi_show_short_audio_desc(s
 	snd_print_pcm_rates(a->rates, buf, sizeof(buf));
 
 	if (a->format == AUDIO_CODING_TYPE_LPCM)
-		snd_print_pcm_bits(a->sample_bits, buf2 + 8, sizeof(buf2 - 8));
+		snd_print_pcm_bits(a->sample_bits, buf2 + 8, sizeof(buf2) - 8);
 	else if (a->max_bitrate)
 		snprintf(buf2, sizeof(buf2),
 				", max bitrate = %d", a->max_bitrate);


