Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333Ab0HXXk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:40:59 -0400
Received: from kroah.org ([198.145.64.141]:52422 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932788Ab0HXW6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:58:06 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:42:12 2010
Message-Id: <20100824224212.666073031@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:41:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [07/91] ALSA: riptide - Fix detection / load of firmware files
In-Reply-To: <20100824224617.GA5440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit a5ba6beb839cfa288960c92cd2668a2601c24dda upstream.

The detection and loading of firmeware on riptide driver has been broken
due to rewrite of some codes, checking the presense wrongly.
This patch fixes the logic again.

Reference: kernel bug 16596
	https://bugzilla.kernel.org/show_bug.cgi?id=16596

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/riptide/riptide.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/sound/pci/riptide/riptide.c
+++ b/sound/pci/riptide/riptide.c
@@ -1224,15 +1224,14 @@ static int try_to_load_firmware(struct c
 		    firmware.firmware.ASIC, firmware.firmware.CODEC,
 		    firmware.firmware.AUXDSP, firmware.firmware.PROG);
 
+	if (!chip)
+		return 1;
+
 	for (i = 0; i < FIRMWARE_VERSIONS; i++) {
 		if (!memcmp(&firmware_versions[i], &firmware, sizeof(firmware)))
-			break;
-	}
-	if (i >= FIRMWARE_VERSIONS)
-		return 0; /* no match */
+			return 1; /* OK */
 
-	if (!chip)
-		return 1; /* OK */
+	}
 
 	snd_printdd("Writing Firmware\n");
 	if (!chip->fw_entry) {


