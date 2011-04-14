Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933685Ab1DNS0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:26:04 -0400
Received: from mail.windriver.com ([147.11.1.11]:38179 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933110Ab1DNRqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:30 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Daniel T Chen <crimsun@ubuntu.com>,
        Takashi Iwai <tiwai@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 060/209] ALSA: ac97: Apply quirk for Dell Latitude D610 binding Master and Headphone controls
Date: Thu, 14 Apr 2011 13:41:30 -0400
Message-Id: <1302803039-9400-61-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel T Chen <crimsun@ubuntu.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/pci/intel8x0.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/sound/pci/intel8x0.c b/sound/pci/intel8x0.c
index 4677492..ebfa1f8 100644
--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -1866,6 +1866,12 @@ static struct ac97_quirk ac97_quirks[] __devinitdata = {
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
-- 
1.7.4.4

