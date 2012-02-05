Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab2BEW06 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:26:58 -0500
Received: from 1wt.eu ([62.212.114.60]:62075 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754291Ab2BEW0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:53 -0500
Message-Id: <20120205220952.441985700@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:59 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Pavel Hofman <pavel.hofman@ivitera.com>, Takashi Iwai <tiwai@suse.de>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 70/91] ALSA: ice1724 - Check for ac97 to avoid kernel oops
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit e7848163aa2a649d9065f230fadff80dc3519775 upstream.

Cards with identical PCI ids but no AC97 config in EEPROM do not have
the ac97 field initialized. We must check for this case to avoid kernel oops.

Signed-off-by: Pavel Hofman <pavel.hofman@ivitera.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 sound/pci/ice1712/amp.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

Index: longterm-2.6.27/sound/pci/ice1712/amp.c
===================================================================
--- longterm-2.6.27.orig/sound/pci/ice1712/amp.c	2012-02-05 22:34:32.865918049 +0100
+++ longterm-2.6.27/sound/pci/ice1712/amp.c	2012-02-05 22:34:44.825915033 +0100
@@ -67,8 +67,11 @@
 
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
 


