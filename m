Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab0GZI3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 04:29:45 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38628 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451Ab0GZI3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 04:29:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=DI15M9dpGy1fK0dTr9UtAJsFq/8Kzc3KeM+4oZaOtc3HJSa7vqil+RhTapBaEnuP50
         0y18dxq2Zopxw9nsBcxIUWGI7dzstgpUaMs8luBKV70Mwmkf7MTfwOJy2tbVv+mg2SEF
         MFnv2E+ClDlmDmEFrybXW9bN6Wp/kBot+spGY=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: [PATCH] oss: waveartist: simplify waveartist_sleep()
Date: Mon, 26 Jul 2010 12:29:22 +0400
Message-Id: <1280132962-8346-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

waveartist_sleep() uses loop with schedule_timeout() to unconditionally
wait for msec. Use schedule_timeout_uninteruptible() instead.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 sound/oss/waveartist.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/sound/oss/waveartist.c b/sound/oss/waveartist.c
index e688dde..5246874 100644
--- a/sound/oss/waveartist.c
+++ b/sound/oss/waveartist.c
@@ -184,14 +184,8 @@ waveartist_iack(wavnc_info *devc)
 static inline int
 waveartist_sleep(int timeout_ms)
 {
-	unsigned int timeout = timeout_ms * 10 * HZ / 100;
-
-	do {
-		set_current_state(TASK_INTERRUPTIBLE);
-		timeout = schedule_timeout(timeout);
-	} while (timeout);
-
-	return 0;
+	unsigned int timeout = msecs_to_jiffies(timeout_ms*100);
+	return schedule_timeout_interruptible(timeout);
 }
 
 static int
-- 
1.7.0.4

