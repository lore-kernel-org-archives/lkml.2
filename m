Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514Ab0IRTIC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:08:02 -0400
Received: from kroah.org ([198.145.64.141]:51872 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756164Ab0IRTCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:02:25 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:00:02 2010
Message-Id: <20100918190002.418788773@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:59:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>,
        David Henningsson <david.henningsson@canonical.com>
Subject: [112/123] ALSA: hda - Handle missing NID 0x1b on ALC259 codec
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=alsa-hda-handle-missing-nid-0x1b-on-alc259-codec.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 5d4abf93ea3192cc666430225a29a4978c97c57d upstream.

Since ALC259/269 use the same parser of ALC268, the pin 0x1b was ignored
as an invalid widget.  Just add this NID to handle properly.
This will add the missing mixer controls for some devices.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -12389,6 +12389,7 @@ static int alc268_new_analog_output(stru
 		dac = 0x02;
 		break;
 	case 0x15:
+	case 0x1b:
 	case 0x21: /* ALC269vb has this pin, too */
 		dac = 0x03;
 		break;


