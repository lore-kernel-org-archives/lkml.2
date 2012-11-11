Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab2KKMZF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 07:25:05 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60902 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab2KKMZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 07:25:01 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>, Daniel Mack <zonque@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 1/8] staging: line6: wrap >80 char lines in capture.c
Date: Sun, 11 Nov 2012 13:24:39 +0100
Message-Id: <1352636686-31170-2-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1352636686-31170-1-git-send-email-stefanha@gmail.com>
References: <1352636686-31170-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/capture.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/line6/capture.c b/drivers/staging/line6/capture.c
index c85c5b6..389c41f 100644
--- a/drivers/staging/line6/capture.c
+++ b/drivers/staging/line6/capture.c
@@ -256,8 +256,8 @@ static void audio_in_callback(struct urb *urb)
 #ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
 		if (!(line6pcm->flags & LINE6_BITS_PCM_IMPULSE))
 #endif
-			if (test_bit(LINE6_INDEX_PCM_ALSA_CAPTURE_STREAM, &line6pcm->flags)
-			    && (fsize > 0))
+			if (test_bit(LINE6_INDEX_PCM_ALSA_CAPTURE_STREAM,
+				     &line6pcm->flags) && (fsize > 0))
 				line6_capture_copy(line6pcm, fbuf, fsize);
 	}
 
@@ -274,7 +274,8 @@ static void audio_in_callback(struct urb *urb)
 #ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
 		if (!(line6pcm->flags & LINE6_BITS_PCM_IMPULSE))
 #endif
-			if (test_bit(LINE6_INDEX_PCM_ALSA_CAPTURE_STREAM, &line6pcm->flags))
+			if (test_bit(LINE6_INDEX_PCM_ALSA_CAPTURE_STREAM,
+				     &line6pcm->flags))
 				line6_capture_check_period(line6pcm, length);
 	}
 }
@@ -356,7 +357,8 @@ int snd_line6_capture_trigger(struct snd_line6_pcm *line6pcm, int cmd)
 #ifdef CONFIG_PM
 	case SNDRV_PCM_TRIGGER_RESUME:
 #endif
-		err = line6_pcm_acquire(line6pcm, LINE6_BIT_PCM_ALSA_CAPTURE_STREAM);
+		err = line6_pcm_acquire(line6pcm,
+					LINE6_BIT_PCM_ALSA_CAPTURE_STREAM);
 
 		if (err < 0)
 			return err;
@@ -367,7 +369,8 @@ int snd_line6_capture_trigger(struct snd_line6_pcm *line6pcm, int cmd)
 #ifdef CONFIG_PM
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 #endif
-		err = line6_pcm_release(line6pcm, LINE6_BIT_PCM_ALSA_CAPTURE_STREAM);
+		err = line6_pcm_release(line6pcm,
+					LINE6_BIT_PCM_ALSA_CAPTURE_STREAM);
 
 		if (err < 0)
 			return err;
-- 
1.7.12.1

