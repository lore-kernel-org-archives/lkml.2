Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab1ABH6z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:58:55 -0500
Received: from mail.windriver.com ([147.11.1.11]:35242 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab1ABHXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:01 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Takashi Iwai <tiwai@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 096/260] ALSA: hda - Handle missing NID 0x1b on ALC259 codec
Date: Sun,  2 Jan 2011 02:16:32 -0500
Message-Id: <1293952756-15010-97-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:21:55.0696 (UTC) FILETIME=[BC349F00:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 5d4abf93ea3192cc666430225a29a4978c97c57d upstream.

Since ALC259/269 use the same parser of ALC268, the pin 0x1b was ignored
as an invalid widget.  Just add this NID to handle properly.
This will add the missing mixer controls for some devices.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index f310f3c..1df35cd 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -12911,6 +12911,7 @@ static int alc268_new_analog_output(struct alc_spec *spec, hda_nid_t nid,
 		dac = 0x02;
 		break;
 	case 0x15:
+	case 0x1b:
 	case 0x21: /* ALC269vb has this pin, too */
 		dac = 0x03;
 		break;
-- 
1.7.3.3

