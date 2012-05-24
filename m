Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab2EXOCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 10:02:39 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42022 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab2EXOCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 10:02:38 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH] [emu10k1]: remove the kcallloc cast (reported from make coccicheck's drop_kmalloc_cast.cocci)
Date: Thu, 24 May 2012 19:32:29 +0530
Message-Id: <1337868149-17783-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 sound/pci/emu10k1/emufx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/emu10k1/emufx.c b/sound/pci/emu10k1/emufx.c
index dae4050..272f8ac 100644
--- a/sound/pci/emu10k1/emufx.c
+++ b/sound/pci/emu10k1/emufx.c
@@ -1815,7 +1815,7 @@ static int __devinit _snd_emu10k1_init_efx(struct snd_emu10k1 *emu)
 
 	if ((icode = kzalloc(sizeof(*icode), GFP_KERNEL)) == NULL)
 		return -ENOMEM;
-	if ((icode->gpr_map = (u_int32_t __user *)
+	if ((icode->gpr_map =
 	     kcalloc(256 + 160 + 160 + 2 * 512, sizeof(u_int32_t),
 		     GFP_KERNEL)) == NULL ||
             (controls = kcalloc(SND_EMU10K1_GPR_CONTROLS,
-- 
1.7.9.5

