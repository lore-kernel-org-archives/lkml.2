Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759151Ab2CMAob (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:44:31 -0400
Received: from mail.windriver.com ([147.11.1.11]:48400 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964855Ab2CMAX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:23:57 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Risto Suominen <Risto.Suominen@gmail.com>,
        Takashi Iwai <tiwai@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 135/196] ALSA: powermac - Lineout detection on G4 DA
Date: Mon, 12 Mar 2012 20:20:48 -0400
Message-Id: <1331598109-31424-90-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Risto Suominen <Risto.Suominen@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit b6d7335001f331f2d295ff15d67e385615ceff81 upstream.

Lineout (Pro Speaker) detection on PowerMac G4 Digital Audio (Tumbler).

Signed-off-by: Risto Suominen <Risto.Suominen@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/ppc/tumbler.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/ppc/tumbler.c b/sound/ppc/tumbler.c
index 3b7471c..696280c 100644
--- a/sound/ppc/tumbler.c
+++ b/sound/ppc/tumbler.c
@@ -1137,7 +1137,8 @@ static long tumbler_find_device(const char *device, const char *platform,
 		gp->inactive_val = (*base) ? 0x4 : 0x5;
 	} else {
 		const u32 *prop = NULL;
-		gp->active_state = IS_G4DA && !strcmp(device, "keywest-gpio15");
+		gp->active_state = IS_G4DA
+				&& !strncmp(device, "keywest-gpio1", 13);
 		gp->active_val = 0x4;
 		gp->inactive_val = 0x5;
 		/* Here are some crude hacks to extract the GPIO polarity and
@@ -1315,6 +1316,9 @@ static int __devinit tumbler_init(struct snd_pmac *chip)
  	if (irq <= NO_IRQ)
 		irq = tumbler_find_device("line-output-detect",
 					  NULL, &mix->line_detect, 1);
+	if (IS_G4DA && irq <= NO_IRQ)
+		irq = tumbler_find_device("keywest-gpio16",
+					  NULL, &mix->line_detect, 1);
 	mix->lineout_irq = irq;
 
 	tumbler_reset_audio(chip);
-- 
1.7.9.3

