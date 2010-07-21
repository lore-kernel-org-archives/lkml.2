Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab0GUMgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 08:36:09 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:58263 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751368Ab0GUMgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 08:36:04 -0400
Date: Wed, 21 Jul 2010 14:36:02 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 3/3] sound/isa/gus: Remove dead CONFIG_SND_DEBUG_ROM
Message-ID: <d96aeb5b8db5602de499b783897b6e8c285ee59b.1279708102.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1279708102.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1279708102.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_SND_DEBUG_ROM doesn't exist in Kconfig, therefore it is never
defined and we can remove all references to it. If it should stay as a
debug flag, perhaps it shouldn't be named CONFIG_

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 sound/isa/gus/interwave.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/sound/isa/gus/interwave.c b/sound/isa/gus/interwave.c
index c7b80e4..ac60c7d 100644
--- a/sound/isa/gus/interwave.c
+++ b/sound/isa/gus/interwave.c
@@ -442,19 +442,11 @@ static void __devinit snd_interwave_detect_memory(struct snd_gus_card * gus)
 	for (bank_pos = 0; bank_pos < 16L * 1024L * 1024L; bank_pos += 4L * 1024L * 1024L) {
 		for (i = 0; i < 8; ++i)
 			iwave[i] = snd_gf1_peek(gus, bank_pos + i);
-#ifdef CONFIG_SND_DEBUG_ROM
-		printk(KERN_DEBUG "ROM at 0x%06x = %02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x\n", bank_pos,
-		       iwave[0], iwave[1], iwave[2], iwave[3],
-		       iwave[4], iwave[5], iwave[6], iwave[7]);
-#endif
 		if (strncmp(iwave, "INTRWAVE", 8))
 			continue;	/* first check */
 		csum = 0;
 		for (i = 0; i < sizeof(struct rom_hdr); i++)
 			csum += snd_gf1_peek(gus, bank_pos + i);
-#ifdef CONFIG_SND_DEBUG_ROM
-		printk(KERN_DEBUG "ROM checksum = 0x%x (computed)\n", csum);
-#endif
 		if (csum != 0)
 			continue;	/* not valid rom */
 		gus->gf1.rom_banks++;
-- 
1.7.0.4

