Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995Ab0KLVis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:38:48 -0500
Received: from mail.perches.com ([173.55.12.10]:1060 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932954Ab0KLViT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:38:19 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH 14/14] sound/ppc: Use printf extension %pR for struct resource
Date: Fri, 12 Nov 2010 13:38:04 -0800
Message-Id: <434a77317cc09300e79b7768170eec7ae04adb92.1289597644.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289597644.git.joe@perches.com>
References: <cover.1289597644.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using %pR standardizes the struct resource output.

Signed-off-by: Joe Perches <joe@perches.com>
---
 sound/ppc/pmac.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/sound/ppc/pmac.c b/sound/ppc/pmac.c
index 8508117..b47cfd4 100644
--- a/sound/ppc/pmac.c
+++ b/sound/ppc/pmac.c
@@ -1228,10 +1228,8 @@ int __devinit snd_pmac_new(struct snd_card *card, struct snd_pmac **chip_return)
 					       chip->rsrc[i].start + 1,
 					       rnames[i]) == NULL) {
 				printk(KERN_ERR "snd: can't request rsrc "
-				       " %d (%s: 0x%016llx:%016llx)\n",
-				       i, rnames[i],
-				       (unsigned long long)chip->rsrc[i].start,
-				       (unsigned long long)chip->rsrc[i].end);
+				       " %d (%s: %pR)\n",
+				       i, rnames[i], &chip->rsrc[i]);
 				err = -ENODEV;
 				goto __error;
 			}
@@ -1256,10 +1254,8 @@ int __devinit snd_pmac_new(struct snd_card *card, struct snd_pmac **chip_return)
 					       chip->rsrc[i].start + 1,
 					       rnames[i]) == NULL) {
 				printk(KERN_ERR "snd: can't request rsrc "
-				       " %d (%s: 0x%016llx:%016llx)\n",
-				       i, rnames[i],
-				       (unsigned long long)chip->rsrc[i].start,
-				       (unsigned long long)chip->rsrc[i].end);
+				       " %d (%s: %pR)\n",
+				       i, rnames[i], &chip->rsrc[i]);
 				err = -ENODEV;
 				goto __error;
 			}
-- 
1.7.3.1.g432b3.dirty

