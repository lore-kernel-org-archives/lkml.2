Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab1ABH65 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:58:57 -0500
Received: from mail.windriver.com ([147.11.1.11]:35240 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab1ABHXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:01 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Takashi Iwai <tiwai@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 097/260] ALSA: hda - Handle pin NID 0x1a on ALC259/269
Date: Sun,  2 Jan 2011 02:16:33 -0500
Message-Id: <1293952756-15010-98-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:21:56.0617 (UTC) FILETIME=[BCC12790:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit b08b1637ce1c0196970348bcabf40f04b6b3d58e upstream.

The pin NID 0x1a should be handled as well as NID 0x1b.
Also added comments.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/pci/hda/patch_realtek.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 1df35cd..7b516f1 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -12911,7 +12911,8 @@ static int alc268_new_analog_output(struct alc_spec *spec, hda_nid_t nid,
 		dac = 0x02;
 		break;
 	case 0x15:
-	case 0x1b:
+	case 0x1a: /* ALC259/269 only */
+	case 0x1b: /* ALC259/269 only */
 	case 0x21: /* ALC269vb has this pin, too */
 		dac = 0x03;
 		break;
-- 
1.7.3.3

