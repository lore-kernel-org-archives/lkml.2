Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832Ab0CaAbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:31:50 -0400
Received: from kroah.org ([198.145.64.141]:48811 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247Ab0C3XMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:12:03 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:18 2010
Message-Id: <20100330225817.572195515@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:57:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Takashi Iwai <tiwai@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [15/89] ALSA: usb-audio - Avoid Oops after disconnect
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 78b8d5d2ee280c463908fd75f3bdf246bcb6ac8d upstream.

As the release of substreams may be done asynchronously from the
disconnection, close callback needs to check the shutdown flag before
actually accessing the usb interface.

Reference: Novell bnc#505027
	http://bugzilla.novell.com/show_bug.cgi?id=565027

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/usb/usbaudio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/usbaudio.c
+++ b/sound/usb/usbaudio.c
@@ -1934,7 +1934,7 @@ static int snd_usb_pcm_close(struct snd_
 	struct snd_usb_stream *as = snd_pcm_substream_chip(substream);
 	struct snd_usb_substream *subs = &as->substream[direction];
 
-	if (subs->interface >= 0) {
+	if (!as->chip->shutdown && subs->interface >= 0) {
 		usb_set_interface(subs->dev, subs->interface, 0);
 		subs->interface = -1;
 	}


