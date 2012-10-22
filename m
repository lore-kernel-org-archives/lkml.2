Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab2JVNH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 09:07:29 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13614 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab2JVNH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 09:07:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 22 Oct 2012 05:55:29 -0700
From: Denis Kirjanov <kirjanov@gmail.com>
To: perex@perex.cz
CC: tiwai@suse.de, alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        kirjanov@gmail.com
Subject: [PATCH] check for the kzalloc return value
Date: Mon, 22 Oct 2012 17:05:53 +0400
Message-ID: <1350911153-23647-1-git-send-email-kirjanov@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Denis Kirjanov <kirjanov@gmail.com>
---
 sound/pci/als300.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/pci/als300.c b/sound/pci/als300.c
index 68c4469..e1f74d4 100644
--- a/sound/pci/als300.c
+++ b/sound/pci/als300.c
@@ -394,6 +394,8 @@ static int snd_als300_playback_open(struct snd_pcm_substream *substream)
 	struct snd_als300_substream_data *data = kzalloc(sizeof(*data),
 								GFP_KERNEL);
 
+	if (!data)
+		return -ENOMEM;
 	snd_als300_dbgcallenter();
 	chip->playback_substream = substream;
 	runtime->hw = snd_als300_playback_hw;
@@ -425,6 +427,8 @@ static int snd_als300_capture_open(struct snd_pcm_substream *substream)
 	struct snd_als300_substream_data *data = kzalloc(sizeof(*data),
 								GFP_KERNEL);
 
+	if (!data)
+		return -ENOMEM;
 	snd_als300_dbgcallenter();
 	chip->capture_substream = substream;
 	runtime->hw = snd_als300_capture_hw;
-- 
1.7.9.5

