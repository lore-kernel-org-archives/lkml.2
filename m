Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612Ab2CMARe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:17:34 -0400
Received: from mail.windriver.com ([147.11.1.11]:46526 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757307Ab2CMARa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:17:30 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Takashi Iwai <tiwai@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 005/196] ALSA: hda - Fix SPDIF out regression on ALC889
Date: Mon, 12 Mar 2012 20:12:13 -0400
Message-Id: <1331597724-31358-6-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 20b67dddcc5f29d3d0c900225d85e0ac655bc69d upstream.

The commit 5a8cfb4e8ae317d283f84122ed20faa069c5e0c4
    ALSA: hda - Use ALC_INIT_DEFAULT for really default initialization
changed to use the default initialization method for ALC889, but
this caused a regression on SPDIF output on some machines.
This seems due to the COEF setup included in the default init procedure.
For making SPDIF working again, the COEF-setup has to be avoided for
the id 0889.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=24342
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/pci/hda/patch_realtek.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 8070ba2..d388680 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -1148,7 +1148,7 @@ static void alc_auto_init_amp(struct hda_codec *codec, int type)
 		case 0x10ec0883:
 		case 0x10ec0885:
 		case 0x10ec0887:
-		case 0x10ec0889:
+		/*case 0x10ec0889:*/ /* this causes an SPDIF problem */
 			alc889_coef_init(codec);
 			break;
 		case 0x10ec0888:
-- 
1.7.9.3

