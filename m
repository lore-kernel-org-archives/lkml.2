Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934273Ab1CXUok (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:44:40 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24078 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932184Ab1CXUoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:44:39 -0400
Date: Thu, 24 Mar 2011 21:44:34 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: alsa-devel@alsa-project.org
cc: linux-kernel@vger.kernel.org, Torsten Schenk <torsten.schenk@zoho.com>,
        Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>
Subject: [PATCH] TerraTec DMX 6Fire USB: Don't leak firmware when
 usb6fire_fw_ihex_init() fails.
Message-ID: <alpine.LNX.2.00.1103242141310.31709@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to release_firmware() what we request_firmware()'ed when 
usb6fire_fw_ihex_init() fails or we'll leak memory.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 firmware.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/6fire/firmware.c b/sound/usb/6fire/firmware.c
index 9081a54..2761392 100644
--- a/sound/usb/6fire/firmware.c
+++ b/sound/usb/6fire/firmware.c
@@ -254,6 +254,7 @@ static int usb6fire_fw_ezusb_upload(
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

