Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab0GZI3Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 04:29:24 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38628 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab0GZI3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 04:29:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=H5gpJcB6bkmd5PH482mw2sKmaU69UTGQ7PCaQachX/zMVojheLyCPvU0wkTbYdV5ap
         Ji+5OHPtCZ07L2BMRgbU6iZcxhZCruqgLU9ggO2jPe6gGh9UUd6kwuLr/9rGJ6epe1z+
         aerjwRY4gtoFfbdQv99nKSf3Zx8h6QDJLkidk=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Ralf Baechle <ralf@linux-mips.org>,
        Manuel Lauss <manuel.lauss@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH] oss: au1550_ac97: simplify au1550_delay()
Date: Mon, 26 Jul 2010 12:28:32 +0400
Message-Id: <1280132913-8306-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

au1550_delay() uses loop with schedule_timeout() to unconditionally wait
for msec. Use schedule_timeout_uninteruptible() instead.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 sound/oss/au1550_ac97.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/sound/oss/au1550_ac97.c b/sound/oss/au1550_ac97.c
index 0fd256c..c4a4cdc 100644
--- a/sound/oss/au1550_ac97.c
+++ b/sound/oss/au1550_ac97.c
@@ -163,19 +163,10 @@ ld2(unsigned int x)
 static void
 au1550_delay(int msec)
 {
-	unsigned long   tmo;
-	signed long     tmo2;
-
 	if (in_interrupt())
 		return;
 
-	tmo = jiffies + (msec * HZ) / 1000;
-	for (;;) {
-		tmo2 = tmo - jiffies;
-		if (tmo2 <= 0)
-			break;
-		schedule_timeout(tmo2);
-	}
+	schedule_timeout_uninterruptible(msecs_to_jiffies(msec));
 }
 
 static u16
-- 
1.7.0.4

