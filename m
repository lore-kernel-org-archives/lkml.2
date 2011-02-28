Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab1B1Qhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:37:53 -0500
Received: from kroah.org ([198.145.64.141]:48128 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755566Ab1B1Qht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:37:49 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Feb 28 08:24:10 2011
Message-Id: <20110228162409.957063642@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Mon, 28 Feb 2011 08:23:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [42/68] ALSA: caiaq - Fix possible string-buffer overflow
In-Reply-To: <20110228163502.GA27221@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit eaae55dac6b64c0616046436b294e69fc5311581 upstream.

Use strlcpy() to assure not to overflow the string array sizes by
too long USB device name string.

Reported-by: Rafa <rafa@mwrinfosecurity.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/usb/caiaq/audio.c |    2 +-
 sound/usb/caiaq/midi.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/sound/usb/caiaq/audio.c
+++ b/sound/usb/caiaq/audio.c
@@ -639,7 +639,7 @@ int snd_usb_caiaq_audio_init(struct snd_
 	}
 
 	dev->pcm->private_data = dev;
-	strcpy(dev->pcm->name, dev->product_name);
+	strlcpy(dev->pcm->name, dev->product_name, sizeof(dev->pcm->name));
 
 	memset(dev->sub_playback, 0, sizeof(dev->sub_playback));
 	memset(dev->sub_capture, 0, sizeof(dev->sub_capture));
--- a/sound/usb/caiaq/midi.c
+++ b/sound/usb/caiaq/midi.c
@@ -135,7 +135,7 @@ int snd_usb_caiaq_midi_init(struct snd_u
 	if (ret < 0)
 		return ret;
 
-	strcpy(rmidi->name, device->product_name);
+	strlcpy(rmidi->name, device->product_name, sizeof(rmidi->name));
 
 	rmidi->info_flags = SNDRV_RAWMIDI_INFO_DUPLEX;
 	rmidi->private_data = device;


