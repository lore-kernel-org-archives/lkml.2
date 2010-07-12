Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab0GLUw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 16:52:27 -0400
Received: from mail.perches.com ([173.55.12.10]:1800 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755170Ab0GLUvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 16:51:10 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
Subject: [PATCH 36/36] sound/core: Remove unnecessary casts of private_data
Date: Mon, 12 Jul 2010 13:50:28 -0700
Message-Id: <2411ee190e0bcb4ba81d1f2e1b5db2e2a53fa1ca.1278967121.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.337.g6068.dirty
In-Reply-To: <cover.1278967120.git.joe@perches.com>
References: <cover.1278967120.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 sound/core/oss/mixer_oss.c |   22 +++++++++++-----------
 sound/core/pcm.c           |    3 +--
 sound/core/timer.c         |    4 ++--
 3 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/sound/core/oss/mixer_oss.c b/sound/core/oss/mixer_oss.c
index f50ebf2..86afb13 100644
--- a/sound/core/oss/mixer_oss.c
+++ b/sound/core/oss/mixer_oss.c
@@ -77,7 +77,7 @@ static int snd_mixer_oss_release(struct inode *inode, struct file *file)
 	struct snd_mixer_oss_file *fmixer;
 
 	if (file->private_data) {
-		fmixer = (struct snd_mixer_oss_file *) file->private_data;
+		fmixer = file->private_data;
 		module_put(fmixer->card->module);
 		snd_card_file_remove(fmixer->card, file);
 		kfree(fmixer);
@@ -368,7 +368,7 @@ static int snd_mixer_oss_ioctl1(struct snd_mixer_oss_file *fmixer, unsigned int
 
 static long snd_mixer_oss_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	return snd_mixer_oss_ioctl1((struct snd_mixer_oss_file *) file->private_data, cmd, arg);
+	return snd_mixer_oss_ioctl1(file->private_data, cmd, arg);
 }
 
 int snd_mixer_oss_ioctl_card(struct snd_card *card, unsigned int cmd, unsigned long arg)
@@ -582,7 +582,7 @@ static int snd_mixer_oss_get_volume1(struct snd_mixer_oss_file *fmixer,
 				     struct snd_mixer_oss_slot *pslot,
 				     int *left, int *right)
 {
-	struct slot *slot = (struct slot *)pslot->private_data;
+	struct slot *slot = pslot->private_data;
 	
 	*left = *right = 100;
 	if (slot->present & SNDRV_MIXER_OSS_PRESENT_PVOLUME) {
@@ -691,7 +691,7 @@ static int snd_mixer_oss_put_volume1(struct snd_mixer_oss_file *fmixer,
 				     struct snd_mixer_oss_slot *pslot,
 				     int left, int right)
 {
-	struct slot *slot = (struct slot *)pslot->private_data;
+	struct slot *slot = pslot->private_data;
 	
 	if (slot->present & SNDRV_MIXER_OSS_PRESENT_PVOLUME) {
 		snd_mixer_oss_put_volume1_vol(fmixer, pslot, slot->numid[SNDRV_MIXER_OSS_ITEM_PVOLUME], left, right);
@@ -740,7 +740,7 @@ static int snd_mixer_oss_get_recsrc1_sw(struct snd_mixer_oss_file *fmixer,
 					struct snd_mixer_oss_slot *pslot,
 					int *active)
 {
-	struct slot *slot = (struct slot *)pslot->private_data;
+	struct slot *slot = pslot->private_data;
 	int left, right;
 	
 	left = right = 1;
@@ -753,7 +753,7 @@ static int snd_mixer_oss_get_recsrc1_route(struct snd_mixer_oss_file *fmixer,
 					   struct snd_mixer_oss_slot *pslot,
 					   int *active)
 {
-	struct slot *slot = (struct slot *)pslot->private_data;
+	struct slot *slot = pslot->private_data;
 	int left, right;
 	
 	left = right = 1;
@@ -766,7 +766,7 @@ static int snd_mixer_oss_put_recsrc1_sw(struct snd_mixer_oss_file *fmixer,
 					struct snd_mixer_oss_slot *pslot,
 					int active)
 {
-	struct slot *slot = (struct slot *)pslot->private_data;
+	struct slot *slot = pslot->private_data;
 	
 	snd_mixer_oss_put_volume1_sw(fmixer, pslot, slot->numid[SNDRV_MIXER_OSS_ITEM_CSWITCH], active, active, 0);
 	return 0;
@@ -776,7 +776,7 @@ static int snd_mixer_oss_put_recsrc1_route(struct snd_mixer_oss_file *fmixer,
 					   struct snd_mixer_oss_slot *pslot,
 					   int active)
 {
-	struct slot *slot = (struct slot *)pslot->private_data;
+	struct slot *slot = pslot->private_data;
 	
 	snd_mixer_oss_put_volume1_sw(fmixer, pslot, slot->numid[SNDRV_MIXER_OSS_ITEM_CROUTE], active, active, 1);
 	return 0;
@@ -813,7 +813,7 @@ static int snd_mixer_oss_get_recsrc2(struct snd_mixer_oss_file *fmixer, unsigned
 		if (!(mixer->mask_recsrc & (1 << idx)))
 			continue;
 		pslot = &mixer->slots[idx];
-		slot = (struct slot *)pslot->private_data;
+		slot = pslot->private_data;
 		if (slot->signature != SNDRV_MIXER_OSS_SIGNATURE)
 			continue;
 		if (!(slot->present & SNDRV_MIXER_OSS_PRESENT_CAPTURE))
@@ -861,7 +861,7 @@ static int snd_mixer_oss_put_recsrc2(struct snd_mixer_oss_file *fmixer, unsigned
 		if (!(mixer->mask_recsrc & (1 << idx)))
 			continue;
 		pslot = &mixer->slots[idx];
-		slot = (struct slot *)pslot->private_data;
+		slot = pslot->private_data;
 		if (slot->signature != SNDRV_MIXER_OSS_SIGNATURE)
 			continue;
 		if (!(slot->present & SNDRV_MIXER_OSS_PRESENT_CAPTURE))
@@ -925,7 +925,7 @@ static int snd_mixer_oss_build_test(struct snd_mixer_oss *mixer, struct slot *sl
 
 static void snd_mixer_oss_slot_free(struct snd_mixer_oss_slot *chn)
 {
-	struct slot *p = (struct slot *)chn->private_data;
+	struct slot *p = chn->private_data;
 	if (p) {
 		if (p->allocated && p->assigned) {
 			kfree(p->assigned->name);
diff --git a/sound/core/pcm.c b/sound/core/pcm.c
index cbe815d..de5a0eb 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -358,8 +358,7 @@ static void snd_pcm_stream_proc_info_read(struct snd_info_entry *entry,
 static void snd_pcm_substream_proc_info_read(struct snd_info_entry *entry,
 					     struct snd_info_buffer *buffer)
 {
-	snd_pcm_proc_info_read((struct snd_pcm_substream *)entry->private_data,
-			       buffer);
+	snd_pcm_proc_info_read(entry->private_data, buffer);
 }
 
 static void snd_pcm_substream_proc_hw_params_read(struct snd_info_entry *entry,
diff --git a/sound/core/timer.c b/sound/core/timer.c
index 13afb60..5ab1014 100644
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -962,7 +962,7 @@ static int snd_timer_s_start(struct snd_timer * timer)
 	struct snd_timer_system_private *priv;
 	unsigned long njiff;
 
-	priv = (struct snd_timer_system_private *) timer->private_data;
+	priv = timer->private_data;
 	njiff = (priv->last_jiffies = jiffies);
 	if (priv->correction > timer->sticks - 1) {
 		priv->correction -= timer->sticks - 1;
@@ -981,7 +981,7 @@ static int snd_timer_s_stop(struct snd_timer * timer)
 	struct snd_timer_system_private *priv;
 	unsigned long jiff;
 
-	priv = (struct snd_timer_system_private *) timer->private_data;
+	priv = timer->private_data;
 	del_timer(&priv->tlist);
 	jiff = jiffies;
 	if (time_before(jiff, priv->last_expires))
-- 
1.7.1.337.g6068.dirty

