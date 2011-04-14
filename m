Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965114Ab1DNR7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:59:34 -0400
Received: from mail.windriver.com ([147.11.1.11]:42395 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965080Ab1DNR7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:59:14 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Takashi Iwai <tiwai@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 206/209] ALSA: caiaq - Fix possible string-buffer overflow
Date: Thu, 14 Apr 2011 13:56:04 -0400
Message-Id: <1302803767-9715-93-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit eaae55dac6b64c0616046436b294e69fc5311581 upstream

Use strlcpy() to assure not to overflow the string array sizes by
too long USB device name string.

Reported-by: Rafa <rafa@mwrinfosecurity.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/usb/caiaq/audio.c |    2 +-
 sound/usb/caiaq/midi.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/usb/caiaq/audio.c b/sound/usb/caiaq/audio.c
index 4328cad..a184e91 100644
--- a/sound/usb/caiaq/audio.c
+++ b/sound/usb/caiaq/audio.c
@@ -640,7 +640,7 @@ int snd_usb_caiaq_audio_init(struct snd_usb_caiaqdev *dev)
 	}
 
 	dev->pcm->private_data = dev;
-	strcpy(dev->pcm->name, dev->product_name);
+	strlcpy(dev->pcm->name, dev->product_name, sizeof(dev->pcm->name));
 
 	memset(dev->sub_playback, 0, sizeof(dev->sub_playback));
 	memset(dev->sub_capture, 0, sizeof(dev->sub_capture));
diff --git a/sound/usb/caiaq/midi.c b/sound/usb/caiaq/midi.c
index 2f218c7..a1a4708 100644
--- a/sound/usb/caiaq/midi.c
+++ b/sound/usb/caiaq/midi.c
@@ -136,7 +136,7 @@ int snd_usb_caiaq_midi_init(struct snd_usb_caiaqdev *device)
 	if (ret < 0)
 		return ret;
 
-	strcpy(rmidi->name, device->product_name);
+	strlcpy(rmidi->name, device->product_name, sizeof(rmidi->name));
 
 	rmidi->info_flags = SNDRV_RAWMIDI_INFO_DUPLEX;
 	rmidi->private_data = device;
-- 
1.7.4.4

