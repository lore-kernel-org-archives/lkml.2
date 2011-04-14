Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315Ab1DNSMB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:12:01 -0400
Received: from mail.windriver.com ([147.11.1.11]:42012 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933249Ab1DNR6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:58:22 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Daniel T Chen <crimsun@ubuntu.com>,
        Takashi Iwai <tiwai@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 158/209] ALSA: hda: Use model=lg quirk for LG P1 Express to enable playback and capture
Date: Thu, 14 Apr 2011 13:55:16 -0400
Message-Id: <1302803767-9715-45-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel T Chen <crimsun@ubuntu.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 77c4d5cdb81d25a45fbdfb84dd3348121219a072 upstream.

BugLink: https://launchpad.net/bugs/595482

The original reporter states that audible playback from the internal
speaker is inaudible despite the hardware being properly detected.  To
work around this symptom, he uses the model=lg quirk to properly enable
both playback, capture, and jack sense.  Another user corroborates this
workaround on separate hardware.  Add this PCI SSID to the quirk table
to enable it for further LG P1 Expresses.

Reported-and-tested-by: Philip Peitsch <philip.peitsch@gmail.com>
Tested-by: nikhov
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index a1d30d3..8070ba2 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4149,6 +4149,7 @@ static struct snd_pci_quirk alc880_cfg_tbl[] = {
 	SND_PCI_QUIRK(0x1734, 0x10b0, "Fujitsu", ALC880_FUJITSU),
 	SND_PCI_QUIRK(0x1854, 0x0018, "LG LW20", ALC880_LG_LW),
 	SND_PCI_QUIRK(0x1854, 0x003b, "LG", ALC880_LG),
+	SND_PCI_QUIRK(0x1854, 0x005f, "LG P1 Express", ALC880_LG),
 	SND_PCI_QUIRK(0x1854, 0x0068, "LG w1", ALC880_LG),
 	SND_PCI_QUIRK(0x1854, 0x0077, "LG LW25", ALC880_LG_LW),
 	SND_PCI_QUIRK(0x19db, 0x4188, "TCL S700", ALC880_TCL_S700),
-- 
1.7.4.4

