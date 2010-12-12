Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab0LMAKH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:10:07 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36211 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222Ab0LLXqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:55 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: crimsun@ubuntu.com, tiwai@suse.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [113/223] ALSA: ac97: Apply quirk for Dell Latitude D610 binding Master and Headphone controls
Message-Id: <20101212234654.3B351B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:54 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/pci/intel8x0.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux/sound/pci/intel8x0.c
===================================================================
--- linux.orig/sound/pci/intel8x0.c
+++ linux/sound/pci/intel8x0.c
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
