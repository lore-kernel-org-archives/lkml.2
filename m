Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab0IRTPW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:15:22 -0400
Received: from kroah.org ([198.145.64.141]:43429 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756812Ab0IRTPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:17 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:02 2010
Message-Id: <20100918191302.166507869@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [056/129] ALSA: usb - Release capture substream URBs properly
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 76195fb096ca6db2f8bbaffb96e3025aaf1649a0 upstream.

Due to the wrong "return" in the loop, a capture substream won't be
released at disconnection properly if the device is capture only and has
no playback substream.  This caused Oops occasionally at the device
reconnection.

Reported-by: Kim Minhyoung <minhyoung.kim@lge.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/usb/card.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -126,7 +126,7 @@ static void snd_usb_stream_disconnect(st
 	for (idx = 0; idx < 2; idx++) {
 		subs = &as->substream[idx];
 		if (!subs->num_formats)
-			return;
+			continue;
 		snd_usb_release_substream_urbs(subs, 1);
 		subs->interface = -1;
 	}


