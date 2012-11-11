Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab2KKM0a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 07:26:30 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60902 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab2KKMZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 07:25:08 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>, Daniel Mack <zonque@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 5/8] staging: line6: wrap lines to 80 chars in playback.c
Date: Sun, 11 Nov 2012 13:24:43 +0100
Message-Id: <1352636686-31170-6-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1352636686-31170-1-git-send-email-stefanha@gmail.com>
References: <1352636686-31170-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a few instances of 80+ character lines in playback.c.  Two
instances are just because of a useless comment "this is somewhat
paranoid", so drop the comment.  Other instances are straightforward
line wrapping.

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/playback.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/line6/playback.c b/drivers/staging/line6/playback.c
index a0ab9d0..4cf23af 100644
--- a/drivers/staging/line6/playback.c
+++ b/drivers/staging/line6/playback.c
@@ -185,7 +185,7 @@ static int submit_audio_out_urb(struct snd_line6_pcm *line6pcm)
 	if (urb_size == 0) {
 		/* can't determine URB size */
 		spin_unlock_irqrestore(&line6pcm->lock_audio_out, flags);
-		dev_err(line6pcm->line6->ifcdev, "driver bug: urb_size = 0\n");	/* this is somewhat paranoid */
+		dev_err(line6pcm->line6->ifcdev, "driver bug: urb_size = 0\n");
 		return -EINVAL;
 	}
 
@@ -218,7 +218,8 @@ static int submit_audio_out_urb(struct snd_line6_pcm *line6pcm)
 				       len * bytes_per_frame, runtime->dma_area,
 				       (urb_frames - len) * bytes_per_frame);
 			} else
-				dev_err(line6pcm->line6->ifcdev, "driver bug: len = %d\n", len);	/* this is somewhat paranoid */
+				dev_err(line6pcm->line6->ifcdev, "driver bug: len = %d\n",
+					len);
 		} else {
 			memcpy(urb_out->transfer_buffer,
 			       runtime->dma_area +
@@ -319,7 +320,8 @@ void line6_unlink_audio_out_urbs(struct snd_line6_pcm *line6pcm)
 }
 
 /*
-	Wait until unlinking of all currently active playback URBs has been finished.
+	Wait until unlinking of all currently active playback URBs has been
+	finished.
 */
 void line6_wait_clear_audio_out_urbs(struct snd_line6_pcm *line6pcm)
 {
@@ -413,7 +415,8 @@ static void audio_out_callback(struct urb *urb)
 	if (!shutdown) {
 		submit_audio_out_urb(line6pcm);
 
-		if (test_bit(LINE6_INDEX_PCM_ALSA_PLAYBACK_STREAM, &line6pcm->flags)) {
+		if (test_bit(LINE6_INDEX_PCM_ALSA_PLAYBACK_STREAM,
+			     &line6pcm->flags)) {
 			line6pcm->bytes_out += length;
 			if (line6pcm->bytes_out >= line6pcm->period_out) {
 				line6pcm->bytes_out %= line6pcm->period_out;
@@ -499,7 +502,8 @@ int snd_line6_playback_trigger(struct snd_line6_pcm *line6pcm, int cmd)
 #ifdef CONFIG_PM
 	case SNDRV_PCM_TRIGGER_RESUME:
 #endif
-		err = line6_pcm_acquire(line6pcm, LINE6_BIT_PCM_ALSA_PLAYBACK_STREAM);
+		err = line6_pcm_acquire(line6pcm,
+					LINE6_BIT_PCM_ALSA_PLAYBACK_STREAM);
 
 		if (err < 0)
 			return err;
@@ -510,7 +514,8 @@ int snd_line6_playback_trigger(struct snd_line6_pcm *line6pcm, int cmd)
 #ifdef CONFIG_PM
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 #endif
-		err = line6_pcm_release(line6pcm, LINE6_BIT_PCM_ALSA_PLAYBACK_STREAM);
+		err = line6_pcm_release(line6pcm,
+					LINE6_BIT_PCM_ALSA_PLAYBACK_STREAM);
 
 		if (err < 0)
 			return err;
-- 
1.7.12.1

