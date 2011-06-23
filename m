Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933079Ab1FWS0B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:26:01 -0400
Received: from mail.windriver.com ([147.11.1.11]:63147 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932761Ab1FWRWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:22:31 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 040/247] ALSA: HDA: Fix dmesg output of HDMI supported bits
Date: Thu, 23 Jun 2011 13:18:03 -0400
Message-Id: <1308849690-14530-41-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Henningsson <david.henningsson@canonical.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d757534ed15387202e322854cd72dc58bbb975de upstream.

This typo caused the dmesg output of the supported bits of HDMI
to be cut off early.

Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/pci/hda/hda_eld.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/pci/hda/hda_eld.c b/sound/pci/hda/hda_eld.c
index d8da18a..f585200 100644
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
1.7.4.4

