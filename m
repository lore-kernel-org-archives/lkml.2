Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933531Ab1C3VHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:07:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:61735 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933516Ab1C3VHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621237423"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: tiwai@suse.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [131/275] ALSA: caiaq - Fix possible string-buffer overflow
Message-Id: <20110330210611.A08683E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Takashi Iwai <tiwai@suse.de>

commit eaae55dac6b64c0616046436b294e69fc5311581 upstream.

Use strlcpy() to assure not to overflow the string array sizes by
too long USB device name string.

Reported-by: Rafa <rafa@mwrinfosecurity.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/usb/caiaq/audio.c |    2 +-
 sound/usb/caiaq/midi.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/sound/usb/caiaq/audio.c
===================================================================
--- linux-2.6.35.y.orig/sound/usb/caiaq/audio.c	2011-03-29 22:51:15.343330571 -0700
+++ linux-2.6.35.y/sound/usb/caiaq/audio.c	2011-03-29 23:03:01.006274422 -0700
@@ -640,7 +640,7 @@
 	}
 
 	dev->pcm->private_data = dev;
-	strcpy(dev->pcm->name, dev->product_name);
+	strlcpy(dev->pcm->name, dev->product_name, sizeof(dev->pcm->name));
 
 	memset(dev->sub_playback, 0, sizeof(dev->sub_playback));
 	memset(dev->sub_capture, 0, sizeof(dev->sub_capture));
Index: linux-2.6.35.y/sound/usb/caiaq/midi.c
===================================================================
--- linux-2.6.35.y.orig/sound/usb/caiaq/midi.c	2011-03-29 22:51:15.342330597 -0700
+++ linux-2.6.35.y/sound/usb/caiaq/midi.c	2011-03-29 23:03:01.007274396 -0700
@@ -136,7 +136,7 @@
 	if (ret < 0)
 		return ret;
 
-	strcpy(rmidi->name, device->product_name);
+	strlcpy(rmidi->name, device->product_name, sizeof(rmidi->name));
 
 	rmidi->info_flags = SNDRV_RAWMIDI_INFO_DUPLEX;
 	rmidi->private_data = device;
