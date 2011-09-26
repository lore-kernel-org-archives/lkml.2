Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508Ab1IZNoK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 09:44:10 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:55127 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750952Ab1IZNoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 09:44:08 -0400
X-Authenticated: #623905
X-Provags-ID: V01U2FsdGVkX1+h9Sgm8nahVVTkhwEKkCSBG5VZ2YytxSfl2pbsPL
	r8DuLRnDvLU1JL
Date: Mon, 26 Sep 2011 15:43:59 +0200 (CEST)
From: Thomas Pfaff <tpfaff@gmx.net>
X-X-Sender: tpfaff@lxtpfaff.pcs.ditec.de
To: tiwai@suse.de, gregkh@suse.de
cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH] usb-audio: Check for possible chip NULL pointer before
 clearing probing flag
Message-ID: <alpine.LNX.2.00.1109261529160.10952@lxtpfaff.pcs.ditec.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before clearing the probing flag in the error exit path, check that the 
chip pointer is not NULL.

Signed-off-by: Thomas Pfaff <tpfaff@gmx.net>

---
diff -urp a/sound/usb/card.c b/sound/usb/card.c
--- a/sound/usb/card.c	2011-09-26 14:58:02.468672118 +0200
+++ b/sound/usb/card.c	2011-09-26 15:00:30.313110086 +0200
@@ -530,9 +530,11 @@ snd_usb_audio_probe(struct usb_device *d
 	return chip;
 
  __error:
-	if (chip && !chip->num_interfaces)
-		snd_card_free(chip->card);
-	chip->probing = 0;
+	if (chip) {
+		if (!chip->num_interfaces)
+			snd_card_free(chip->card);
+		chip->probing = 0;
+	}
 	mutex_unlock(&register_mutex);
  __err_val:
 	return NULL;
