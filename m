Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407Ab2ILXfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:35:22 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37074 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756343Ab2ILXfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:35:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Pavel Roskin <proski@gnu.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 074/108] ALSA: snd-usb: use list_for_each_safe for endpoint resources
Date: Wed, 12 Sep 2012 16:29:12 -0700
Message-Id: <20120912232458.273348106@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Roskin <proski@gnu.org>

commit 03d2f44e967b3c2cf79a6dfb904c8880616c7f83 upstream.

snd_usb_endpoint_free() frees the structure that contains its argument.

Signed-off-by: Pavel Roskin <proski@gnu.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/card.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -553,7 +553,7 @@ static void snd_usb_audio_disconnect(str
 				     struct snd_usb_audio *chip)
 {
 	struct snd_card *card;
-	struct list_head *p;
+	struct list_head *p, *n;
 
 	if (chip == (void *)-1L)
 		return;
@@ -570,7 +570,7 @@ static void snd_usb_audio_disconnect(str
 			snd_usb_stream_disconnect(p);
 		}
 		/* release the endpoint resources */
-		list_for_each(p, &chip->ep_list) {
+		list_for_each_safe(p, n, &chip->ep_list) {
 			snd_usb_endpoint_free(p);
 		}
 		/* release the midi resources */


