Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab0LXVFO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 16:05:14 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21444 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab0LXVFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 16:05:12 -0500
Date: Fri, 24 Dec 2010 21:55:21 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: James Courtier-Dutton <James@superbug.demon.co.uk>,
        alsa-devel@alsa-project.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Andy Owen <andy-alsa@ultra-premium.com>, Takashi Iwai <tiwai@suse.de>,
        Jaroslav Kysela <perex@perex.cz>, trivial@kernel.org
Subject: [PATCH][Trivial] sound, ca0106: Fix assignment to 'channel'.
Message-ID: <alpine.LNX.2.00.1012242152030.28973@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The assignment to the local variable 'channel' in 
snd_ca0106_pcm_pointer_capture() is a little crazy.
Order of assignment is undefined. This fixes it.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 ca0106_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
diff --git a/sound/pci/ca0106/ca0106_main.c b/sound/pci/ca0106/ca0106_main.c
index d2d12c0..01b4938 100644
--- a/sound/pci/ca0106/ca0106_main.c
+++ b/sound/pci/ca0106/ca0106_main.c
@@ -1082,7 +1082,7 @@ snd_ca0106_pcm_pointer_capture(struct snd_pcm_substream *substream)
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct snd_ca0106_pcm *epcm = runtime->private_data;
 	snd_pcm_uframes_t ptr, ptr1, ptr2 = 0;
-	int channel = channel=epcm->channel_id;
+	int channel = epcm->channel_id;
 
 	if (!epcm->running)
 		return 0;


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

