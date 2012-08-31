Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab2HaDZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 23:25:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55810 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab2HaDZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 23:25:33 -0400
From: Prasad Joshi <prasadjoshi.linux@gmail.com>
To: prasadjoshi.linux@gmail.com
Cc: lrg@ti.com, broonie@opensource.wolfsonmicro.com, perex@perex.cz,
        tiwai@suse.de, rajeev-dlh.kumar@st.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ASoC: correct the check for NULL dma_buffer pointer
Date: Fri, 31 Aug 2012 08:55:21 +0530
Message-Id: <1346383521-2990-1-git-send-email-prasadjoshi.linux@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The if condition
	if (!buf && !buf->area)

checks if the buf pointer is NULL and then dereferences it again to
check if the buffer area is NULL, resulting in possible NULL
dereference.

Signed-off-by: Prasad Joshi <prasadjoshi.linux@gmail.com>
---
 sound/soc/spear/spear_pcm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/spear/spear_pcm.c b/sound/soc/spear/spear_pcm.c
index 97c2cac..8c7f237 100644
--- a/sound/soc/spear/spear_pcm.c
+++ b/sound/soc/spear/spear_pcm.c
@@ -138,7 +138,7 @@ static void spear_pcm_free(struct snd_pcm *pcm)
 			continue;
 
 		buf = &substream->dma_buffer;
-		if (!buf && !buf->area)
+		if (!buf || !buf->area)
 			continue;
 
 		dma_free_writecombine(pcm->card->dev, buf->bytes,
-- 
1.7.5.4

