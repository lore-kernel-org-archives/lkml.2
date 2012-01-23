Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab2AXAMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 19:12:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41964 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772Ab2AWXpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:45:31 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 15:42:01 2012
Message-Id: <20120123234201.860789277@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 15:40:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Karsten Wiese <fzu@wemgehoertderstaat.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [02/27] ALSA: snd-usb-us122l: Delete calls to preempt_disable
In-Reply-To: <20120123234224.GA19510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Karsten Wiese <fzu@wemgehoertderstaat.de>

commit d0f3a2eb9062560bebca8b923424f3ca02a331ba upstream.

They are not needed here.

Signed-off-by: Karsten Wiese <fzu@wemgehoertderstaat.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/usb/usx2y/usb_stream.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/sound/usb/usx2y/usb_stream.c
+++ b/sound/usb/usx2y/usb_stream.c
@@ -673,7 +673,7 @@ dotry:
 		inurb->transfer_buffer_length =
 			inurb->number_of_packets *
 			inurb->iso_frame_desc[0].length;
-		preempt_disable();
+
 		if (u == 0) {
 			int now;
 			struct usb_device *dev = inurb->dev;
@@ -685,19 +685,17 @@ dotry:
 		}
 		err = usb_submit_urb(inurb, GFP_ATOMIC);
 		if (err < 0) {
-			preempt_enable();
 			snd_printk(KERN_ERR"usb_submit_urb(sk->inurb[%i])"
 				   " returned %i\n", u, err);
 			return err;
 		}
 		err = usb_submit_urb(outurb, GFP_ATOMIC);
 		if (err < 0) {
-			preempt_enable();
 			snd_printk(KERN_ERR"usb_submit_urb(sk->outurb[%i])"
 				   " returned %i\n", u, err);
 			return err;
 		}
-		preempt_enable();
+
 		if (inurb->start_frame != outurb->start_frame) {
 			snd_printd(KERN_DEBUG
 				   "u[%i] start_frames differ in:%u out:%u\n",


