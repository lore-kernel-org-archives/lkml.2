Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab0INEZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 00:25:17 -0400
Received: from mail.perches.com ([173.55.12.10]:2019 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217Ab0INEYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 00:24:21 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
Subject: [PATCH next 16/16] sound: Use static const char * const where possible
Date: Mon, 13 Sep 2010 21:24:02 -0700
Message-Id: <8d1ddb8c4ad5c5454e647d753c072721ad1002f6.1284435710.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284435709.git.joe@perches.com>
References: <cover.1284435709.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 sound/core/misc.c       |    5 +----
 sound/core/pcm_native.c |    2 +-
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/sound/core/misc.c b/sound/core/misc.c
index 0e5e77f..2c41825 100644
--- a/sound/core/misc.c
+++ b/sound/core/misc.c
@@ -64,15 +64,12 @@ static int print_snd_pfx(unsigned int level, const char *path, int line,
 			 const char *format)
 {
 	const char *file = sanity_file_name(path);
-	char tmp[sizeof("<0>")];
+	char tmp[] = "<0>";
 	const char *pfx = level ? KERN_DEBUG : KERN_DEFAULT;
 	int ret = 0;
 
 	if (format[0] == '<' && format[2] == '>') {
-		tmp[0] = '<';
 		tmp[1] = format[1];
-		tmp[2] = '>';
-		tmp[3] = 0;
 		pfx = tmp;
 		ret = 1;
 	}
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index e2e7389..eb40942 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -142,7 +142,7 @@ int snd_pcm_info_user(struct snd_pcm_substream *substream,
 
 #ifdef RULES_DEBUG
 #define HW_PARAM(v) [SNDRV_PCM_HW_PARAM_##v] = #v
-char *snd_pcm_hw_param_names[] = {
+static const char * const snd_pcm_hw_param_names[] = {
 	HW_PARAM(ACCESS),
 	HW_PARAM(FORMAT),
 	HW_PARAM(SUBFORMAT),
-- 
1.7.3.rc1

