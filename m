Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab1GVRkt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 13:40:49 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:54774 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab1GVRks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 13:40:48 -0400
From: Borislav Petkov <bp@amd64.org>
To: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>
Cc: alsa-devel@alsa-project.org, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH] sound, hda_codec: Fix compilation warnings
Date: Fri, 22 Jul 2011 19:40:37 +0200
Message-Id: <1311356437-28816-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Convert macro to an inline function to shut up gcc:

sound/pci/hda/patch_sigmatel.c: In function `stac92xx_init´:
sound/pci/hda/patch_sigmatel.c:4385:3: warning: statement with no effect
sound/pci/hda/patch_sigmatel.c: In function `stac92xx_resume´:
sound/pci/hda/patch_sigmatel.c:4925:3: warning: statement with no effect
sound/pci/hda/hda_codec.c: In function `snd_hda_mixer_amp_switch_put´:
sound/pci/hda/patch_realtek.c:4176:2: warning: statement with no effect
sound/pci/hda/hda_codec.c:2320:2: warning: statement with no effect
sound/pci/hda/patch_realtek.c: In function `alc_resume´:
sound/pci/hda/patch_realtek.c:4558:2: warning: statement with no effect
sound/pci/hda/patch_realtek.c: In function `alc269_resume´:
sound/pci/hda/patch_realtek.c:14878:2: warning: statement with no effect

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 sound/pci/hda/hda_codec.h |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/hda_codec.h b/sound/pci/hda/hda_codec.h
index 59c9730..79ede92 100644
--- a/sound/pci/hda/hda_codec.h
+++ b/sound/pci/hda/hda_codec.h
@@ -1005,8 +1005,12 @@ int hda_call_check_power_status(struct hda_codec *codec, hda_nid_t nid)
 		return codec->patch_ops.check_power_status(codec, nid);
 	return 0;
 }
-#else	
-#define hda_call_check_power_status(codec, nid)		0
+#else
+static inline
+int hda_call_check_power_status(struct hda_codec *codec, hda_nid_t nid)
+{
+	return 0;
+}
 #endif
 
 /*
-- 
1.7.4.rc2

