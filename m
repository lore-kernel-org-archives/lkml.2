Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab1BVW25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:28:57 -0500
Received: from kroah.org ([198.145.64.141]:46804 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754783Ab1BVWWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:22:05 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:41 2011
Message-Id: <20110222221841.390562355@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:17:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [44/70] ALSA: caiaq - Fix possible string-buffer overflow
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

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
@@ -785,7 +785,7 @@ int snd_usb_caiaq_audio_init(struct snd_
 	}
 
 	dev->pcm->private_data = dev;
-	strcpy(dev->pcm->name, dev->product_name);
+	strlcpy(dev->pcm->name, dev->product_name, sizeof(dev->pcm->name));
 
 	memset(dev->sub_playback, 0, sizeof(dev->sub_playback));
 	memset(dev->sub_capture, 0, sizeof(dev->sub_capture));
--- a/sound/usb/caiaq/midi.c
+++ b/sound/usb/caiaq/midi.c
@@ -136,7 +136,7 @@ int snd_usb_caiaq_midi_init(struct snd_u
 	if (ret < 0)
 		return ret;
 
-	strcpy(rmidi->name, device->product_name);
+	strlcpy(rmidi->name, device->product_name, sizeof(rmidi->name));
 
 	rmidi->info_flags = SNDRV_RAWMIDI_INFO_DUPLEX;
 	rmidi->private_data = device;


