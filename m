Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab1HNQIA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:08:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36576 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076Ab1HNQH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:07:56 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:55 2011
Message-Id: <20110812210555.701518521@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel Mack <zonque@gmail.com>, Clemens Ladisch <clemens@ladisch.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [41/90] ALSA: snd-usb: Accept UAC2 FORMAT_TYPE descriptors with
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------
 bLength > 6

From: Clemens Ladisch <clemens@ladisch.de>

commit 824818b148db42173446707df4cbd61cd7133272 upstream.

The Focusrite Scarlett 18i6 USB has them that way, which is probably a
bug. Anyway, the driver should simply ignore this fact.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Reported-by: Nicolai Krakowiak <nicolai.krakowiak@gmail.com>
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/usb/endpoint.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -352,7 +352,7 @@ int snd_usb_parse_audio_endpoints(struct
 			continue;
 		}
 		if (((protocol == UAC_VERSION_1) && (fmt->bLength < 8)) ||
-		    ((protocol == UAC_VERSION_2) && (fmt->bLength != 6))) {
+		    ((protocol == UAC_VERSION_2) && (fmt->bLength < 6))) {
 			snd_printk(KERN_ERR "%d:%u:%d : invalid UAC_FORMAT_TYPE desc\n",
 				   dev->devnum, iface_no, altno);
 			continue;


