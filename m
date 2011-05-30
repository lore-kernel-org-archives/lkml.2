Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab1E3K4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 06:56:54 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:28351 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab1E3K4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 06:56:53 -0400
Date: Mon, 30 May 2011 12:49:01 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: alsa-devel@alsa-project.org, Daniel Mack <zonque@gmail.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Torsten Schenk <torsten.schenk@zoho.com>, Takashi Iwai <tiwai@suse.de>,
        Jaroslav Kysela <perex@perex.cz>
Subject: [PATCH] Sound, 6fire: Don't leak firmware in error path
Message-ID: <alpine.LNX.2.00.1105301245060.6250@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the error paths in 
sound/usb/6fire/firmware.c::usb6fire_fw_ezusb_upload() neglects to free 
the memory allocated for the firmware before returning, thus leaking the 
memory.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 firmware.c |    1 +
 1 file changed, 1 insertion(+)

  patch against 3.0-rc1
  compile tested only

diff --git a/sound/usb/6fire/firmware.c b/sound/usb/6fire/firmware.c
index d47beff..a91719d 100644
--- a/sound/usb/6fire/firmware.c
+++ b/sound/usb/6fire/firmware.c
@@ -227,6 +227,7 @@ static int usb6fire_fw_ezusb_upload(
 	ret = usb6fire_fw_ihex_init(fw, rec);
 	if (ret < 0) {
 		kfree(rec);
+		release_firmware(fw);
 		snd_printk(KERN_ERR PREFIX "error validating ezusb "
 				"firmware %s.\n", fwname);
 		return ret;


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

