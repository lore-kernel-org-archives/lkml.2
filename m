Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab3AHXhP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:37:15 -0500
Received: from mail.windriver.com ([147.11.1.11]:63430 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961Ab3AHXhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:37:11 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Daniel T Chen <crimsun@ubuntu.com>, Takashi Iwai <tiwai@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 10/77] ALSA: hda: Use position_fix=1 for Acer Aspire 5538 to enable capture on internal mic
Date: Tue, 8 Jan 2013 18:34:49 -0500
Message-ID: <1357688156-25387-11-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel T Chen <crimsun@ubuntu.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit dd5a089edfa51a74692604b4b427953d8e16bc35 upstream.

BugLink: https://launchpad.net/bugs/685161

The reporter of the bug states that he must use position_fix=1 to enable
capture for the internal microphone, so set it for his machine's PCI
SSID.  Verified using 2.6.35 and the 2010-12-04 alsa-driver build.

Reported-and-tested-by: Ralph Wabel <rwabel@gmx.net>
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/pci/hda/hda_intel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 2a6c825..3a532c8 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2266,6 +2266,7 @@ static int azx_dev_free(struct snd_device *device)
  */
 static struct snd_pci_quirk position_fix_list[] __devinitdata = {
 	SND_PCI_QUIRK(0x1025, 0x009f, "Acer Aspire 5110", POS_FIX_LPIB),
+	SND_PCI_QUIRK(0x1025, 0x026f, "Acer Aspire 5538", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1028, 0x01cc, "Dell D820", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1028, 0x01de, "Dell Precision 390", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1028, 0x01f6, "Dell Latitude 131L", POS_FIX_LPIB),
-- 
1.7.12.1

