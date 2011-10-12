Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab1JLXjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 19:39:09 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45626 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab1JLXjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 19:39:07 -0400
Subject: [PATCH] ASoC: pxa: Remove redundant snd_soc_dapm_sync() calls from
 machine drivers
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Miao <eric.y.miao@gmail.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Oct 2011 07:38:56 +0800
Message-ID: <1318462736.17043.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core will sync DAPM as part of the card initialization, there is no
need for machine drivers to do so during their setup.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/pxa/poodle.c |    1 -
 sound/soc/pxa/spitz.c  |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/sound/soc/pxa/poodle.c b/sound/soc/pxa/poodle.c
index da3ae43..4c29bc1 100644
--- a/sound/soc/pxa/poodle.c
+++ b/sound/soc/pxa/poodle.c
@@ -265,7 +265,6 @@ static int poodle_wm8731_init(struct snd_soc_pcm_runtime *rtd)
 	/* Set up poodle specific audio path audio_map */
 	snd_soc_dapm_add_routes(dapm, audio_map, ARRAY_SIZE(audio_map));
 
-	snd_soc_dapm_sync(dapm);
 	return 0;
 }
 
diff --git a/sound/soc/pxa/spitz.c b/sound/soc/pxa/spitz.c
index ce920e3..c2d6ff9 100644
--- a/sound/soc/pxa/spitz.c
+++ b/sound/soc/pxa/spitz.c
@@ -301,7 +301,6 @@ static int spitz_wm8750_init(struct snd_soc_pcm_runtime *rtd)
 	/* Set up spitz specific audio paths */
 	snd_soc_dapm_add_routes(dapm, audio_map, ARRAY_SIZE(audio_map));
 
-	snd_soc_dapm_sync(dapm);
 	return 0;
 }
 
-- 
1.7.4.1



