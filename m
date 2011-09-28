Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933500Ab1I1W4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:56:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54977 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933422Ab1I1Wtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:49:51 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:49 2011
Message-Id: <20110928220149.507401304@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:03:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Pfaff <tpfaff@gmx.net>, Takashi Iwai <tiwai@suse.de>
Subject: [229/244] ALSA: usb-audio: Check for possible chip NULL pointer before clearing probing flag
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Pfaff <tpfaff@gmx.net>

commit 61a6a108d15213f5ee06332e1e7766d3860e4453 upstream.

Before clearing the probing flag in the error exit path, check that the
chip pointer is not NULL.

Signed-off-by: Thomas Pfaff <tpfaff@gmx.net>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/usb/card.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -529,9 +529,11 @@ static void *snd_usb_audio_probe(struct
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


