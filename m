Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab0LHBCG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:02:06 -0500
Received: from kroah.org ([198.145.64.141]:49115 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932226Ab0LHBB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:01:59 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:37 2010
Message-Id: <20101208005737.225790685@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:58:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel T Chen <crimsun@ubuntu.com>, Takashi Iwai <tiwai@suse.de>
Subject: [158/289] ALSA: ac97: Apply quirk for Dell Latitude D610 binding Master and Headphone controls
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel T Chen <crimsun@ubuntu.com>

commit 0613a59456980161d0cd468bae6c63d772743102 upstream.

BugLink: https://launchpad.net/bugs/669279

The original reporter states: "The Master mixer does not change the
volume from the headphone output (which is affected by the headphone
mixer). Instead it only seems to control the on-board speaker volume.
This confuses PulseAudio greatly as the Master channel is merged into
the volume mix."

Fix this symptom by applying the hp_only quirk for the reporter's SSID.
The fix is applicable to all stable kernels.

Reported-and-tested-by: Ben Gamari <bgamari@gmail.com>
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/intel8x0.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -1866,6 +1866,12 @@ static struct ac97_quirk ac97_quirks[] _
 	},
 	{
 		.subvendor = 0x1028,
+		.subdevice = 0x0182,
+		.name = "Dell Latitude D610",	/* STAC9750/51 */
+		.type = AC97_TUNE_HP_ONLY
+	},
+	{
+		.subvendor = 0x1028,
 		.subdevice = 0x0186,
 		.name = "Dell Latitude D810", /* cf. Malone #41015 */
 		.type = AC97_TUNE_HP_MUTE_LED


