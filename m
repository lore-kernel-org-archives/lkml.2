Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966088Ab0GPQQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 12:16:21 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35131 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966035Ab0GPQQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 12:16:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=WZdifhUekrV9wkNCWrZrU6MlzUu9i3pywd3GQEuNYQUZ6qy/+9Ycs1VHLUsiGMJlXL
         ExDij7xxxrFYfdOvVWpyz3HXXPZ18TTob/EO/sSQxgKaWxVC5Kpk01c5ojW8QV5e/lXj
         gim6DGHKAW7PsHNg1lGN17blySXqvvfyv4jZo=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Dan Carpenter <error27@gmail.com>,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        Roel Kluin <roel.kluin@gmail.com>, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: [PATCH 12/15] pci: riptide: check kzalloc() result
Date: Fri, 16 Jul 2010 20:15:59 +0400
Message-Id: <1279296959-25227-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kzalloc() fails exit with -ENOMEM.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 sound/pci/riptide/riptide.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/sound/pci/riptide/riptide.c b/sound/pci/riptide/riptide.c
index 59d7996..f64fb7d 100644
--- a/sound/pci/riptide/riptide.c
+++ b/sound/pci/riptide/riptide.c
@@ -1615,7 +1615,10 @@ static int snd_riptide_playback_open(struct snd_pcm_substream *substream)
 
 	chip->playback_substream[sub_num] = substream;
 	runtime->hw = snd_riptide_playback;
+
 	data = kzalloc(sizeof(struct pcmhw), GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
 	data->paths = lbus_play_paths[sub_num];
 	data->id = play_ids[sub_num];
 	data->source = play_sources[sub_num];
@@ -1635,7 +1638,10 @@ static int snd_riptide_capture_open(struct snd_pcm_substream *substream)
 
 	chip->capture_substream = substream;
 	runtime->hw = snd_riptide_capture;
+
 	data = kzalloc(sizeof(struct pcmhw), GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
 	data->paths = lbus_rec_path;
 	data->id = PADC;
 	data->source = ACLNK2PADC;
-- 
1.7.0.4

