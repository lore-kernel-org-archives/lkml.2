Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab0G1Qkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 12:40:52 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39164 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab0G1Qku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 12:40:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=krLt6auSccIse2VjgdNzk+Y+WaZ+6ii+6FkzhHijsbsu3qYT+J+I+CUD3uJ9lncMIi
         7nU5fTrHTnWwuiVMDXKdYY2kvLtbC5K1rLSaNBcK9ae2CaoraGu5wzgQlfeMDP0a1ijL
         4cs1JHsER495gWpFCEf8Q7iBhRDIyrUR1Kyqw=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/10] ALSA: msnd: check request_region() return value
Date: Wed, 28 Jul 2010 20:40:21 +0400
Message-Id: <1280335221-23345-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

request_region() may fail, if so return -ENOMEM.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 sound/isa/msnd/msnd_pinnacle.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/sound/isa/msnd/msnd_pinnacle.c b/sound/isa/msnd/msnd_pinnacle.c
index 60b6abd..ed42f8e 100644
--- a/sound/isa/msnd/msnd_pinnacle.c
+++ b/sound/isa/msnd/msnd_pinnacle.c
@@ -549,7 +549,10 @@ static int __devinit snd_msnd_attach(struct snd_card *card)
 		printk(KERN_ERR LOGNAME ": Couldn't grab IRQ %d\n", chip->irq);
 		return err;
 	}
-	request_region(chip->io, DSP_NUMIO, card->shortname);
+	if (request_region(chip->io, DSP_NUMIO, card->shortname) == NULL) {
+		free_irq(chip->irq, chip);
+		return -ENOMEM;
+	}
 
 	if (!request_mem_region(chip->base, BUFFSIZE, card->shortname)) {
 		printk(KERN_ERR LOGNAME
-- 
1.7.0.4

