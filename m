Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab2APSsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 13:48:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42887 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755951Ab2APSsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 13:48:39 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 16 10:45:16 2012
Message-Id: <20120116184516.596654354@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Mon, 16 Jan 2012 10:44:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Pavel Hofman <pavel.hofman@ivitera.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [10/48] ALSA: ice1724 - Check for ac97 to avoid kernel oops
In-Reply-To: <20120116184527.GA11972@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Hofman <pavel.hofman@ivitera.com>

commit e7848163aa2a649d9065f230fadff80dc3519775 upstream.

Cards with identical PCI ids but no AC97 config in EEPROM do not have
the ac97 field initialized. We must check for this case to avoid kernel oops.

Signed-off-by: Pavel Hofman <pavel.hofman@ivitera.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/ice1712/amp.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/sound/pci/ice1712/amp.c
+++ b/sound/pci/ice1712/amp.c
@@ -68,8 +68,11 @@ static int __devinit snd_vt1724_amp_init
 
 static int __devinit snd_vt1724_amp_add_controls(struct snd_ice1712 *ice)
 {
-	/* we use pins 39 and 41 of the VT1616 for left and right read outputs */
-	snd_ac97_write_cache(ice->ac97, 0x5a, snd_ac97_read(ice->ac97, 0x5a) & ~0x8000);
+	if (ice->ac97)
+		/* we use pins 39 and 41 of the VT1616 for left and right
+		read outputs */
+		snd_ac97_write_cache(ice->ac97, 0x5a,
+			snd_ac97_read(ice->ac97, 0x5a) & ~0x8000);
 	return 0;
 }
 


