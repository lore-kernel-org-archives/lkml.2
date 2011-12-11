Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab1LKSQc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 13:16:32 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:54460 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751986Ab1LKSQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 13:16:31 -0500
X-Authenticated: #41721828
X-Provags-ID: V01U2FsdGVkX1+9XZUVQBu99YJ9GcKw6nRIvLICTddvNNKzWbDBhd
	fiVKI3iQwVflJy
From: =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
Subject: [PATCH] ASoC: WM8958: correctly show firmware magic on mismatch
Date: Sun, 11 Dec 2011 19:15:49 +0100
Message-Id: <1323627349-2488-1-git-send-email-j.neuschaefer@gmx.net>
X-Mailer: git-send-email 1.7.7.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
---
This patch is untested.

 sound/soc/codecs/wm8958-dsp2.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/wm8958-dsp2.c b/sound/soc/codecs/wm8958-dsp2.c
index 0293763..5a14d5c 100644
--- a/sound/soc/codecs/wm8958-dsp2.c
+++ b/sound/soc/codecs/wm8958-dsp2.c
@@ -60,6 +60,8 @@ static int wm8958_dsp2_fw(struct snd_soc_codec *codec, const char *name,
 	}
 
 	if (memcmp(fw->data, "WMFW", 4) != 0) {
+		memcpy(&data32, fw->data, sizeof(data32));
+		data32 = be32_to_cpu(data32);
 		dev_err(codec->dev, "%s: firmware has bad file magic %08x\n",
 			name, data32);
 		goto err;
-- 
1.7.7.3

