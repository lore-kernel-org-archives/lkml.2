Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934183Ab0HXX3J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:29:09 -0400
Received: from kroah.org ([198.145.64.141]:40575 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933062Ab0HXW7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:59:37 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:42:18 2010
Message-Id: <20100824224218.175901528@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:42:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel T Chen <crimsun@ubuntu.com>, Takashi Iwai <tiwai@suse.de>
Subject: [71/91] ALSA: intel8x0: Mute External Amplifier by default for ThinkPad X31
In-Reply-To: <20100824224617.GA5440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel T Chen <crimsun@ubuntu.com>

commit 9c77b846ec8b4e0c7107dd7f820172462dc84a61 upstream.

BugLink: https://bugs.launchpad.net/bugs/619439

This ThinkPad model needs External Amplifier muted for audible playback,
so set the inv_eapd quirk for it.

Reported-and-tested-by: Dennis Bell <dennis.bell@parkerg.co.uk>
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/intel8x0.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -1776,6 +1776,12 @@ static struct ac97_quirk ac97_quirks[] _
         },
 	{
 		.subvendor = 0x1014,
+		.subdevice = 0x0534,
+		.name = "ThinkPad X31",
+		.type = AC97_TUNE_INV_EAPD
+	},
+	{
+		.subvendor = 0x1014,
 		.subdevice = 0x1f00,
 		.name = "MS-9128",
 		.type = AC97_TUNE_ALC_JACK


