Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab1EFAtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:49:51 -0400
Received: from kroah.org ([198.145.64.141]:36979 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755933Ab1EFAZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:17 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:13 2011
Message-Id: <20110506002213.171549909@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Risto Suominen <Risto.Suominen@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [081/143] ALSA: powermac - Lineout detection on G4 DA
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Risto Suominen <Risto.Suominen@gmail.com>

commit b6d7335001f331f2d295ff15d67e385615ceff81 upstream.

Lineout (Pro Speaker) detection on PowerMac G4 Digital Audio (Tumbler).

Signed-off-by: Risto Suominen <Risto.Suominen@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 sound/ppc/tumbler.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/sound/ppc/tumbler.c
+++ b/sound/ppc/tumbler.c
@@ -1137,7 +1137,8 @@ static long tumbler_find_device(const ch
 		gp->inactive_val = (*base) ? 0x4 : 0x5;
 	} else {
 		const u32 *prop = NULL;
-		gp->active_state = IS_G4DA && !strcmp(device, "keywest-gpio15");
+		gp->active_state = IS_G4DA
+				&& !strncmp(device, "keywest-gpio1", 13);
 		gp->active_val = 0x4;
 		gp->inactive_val = 0x5;
 		/* Here are some crude hacks to extract the GPIO polarity and
@@ -1315,6 +1316,9 @@ static int __devinit tumbler_init(struct
  	if (irq <= NO_IRQ)
 		irq = tumbler_find_device("line-output-detect",
 					  NULL, &mix->line_detect, 1);
+	if (IS_G4DA && irq <= NO_IRQ)
+		irq = tumbler_find_device("keywest-gpio16",
+					  NULL, &mix->line_detect, 1);
 	mix->lineout_irq = irq;
 
 	tumbler_reset_audio(chip);


