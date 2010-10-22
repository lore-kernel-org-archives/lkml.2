Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376Ab0JVS4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:56:33 -0400
Received: from kroah.org ([198.145.64.141]:34126 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759339Ab0JVS4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:25 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:31 2010
Message-Id: <20101022185231.302549809@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <error27@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [044/103] OSS: soundcard: locking bug in sound_ioctl()
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Carpenter <error27@gmail.com>

commit d4cfa4d12f46e2520f4c1d1a92e891ce068b7464 upstream.

We shouldn't return directly here because we're still holding the
&soundcard_mutex.

This bug goes all the way back to the start of git.  It's strange that
no one has complained about it as a runtime bug.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/oss/soundcard.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/oss/soundcard.c
+++ b/sound/oss/soundcard.c
@@ -389,11 +389,11 @@ static long sound_ioctl(struct file *fil
 	case SND_DEV_DSP:
 	case SND_DEV_DSP16:
 	case SND_DEV_AUDIO:
-		return audio_ioctl(dev, file, cmd, p);
+		ret = audio_ioctl(dev, file, cmd, p);
 		break;
 
 	case SND_DEV_MIDIN:
-		return MIDIbuf_ioctl(dev, file, cmd, p);
+		ret = MIDIbuf_ioctl(dev, file, cmd, p);
 		break;
 
 	}


