Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab1HJHzZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 03:55:25 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:32828 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab1HJHzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 03:55:24 -0400
From: stufever@gmail.com
To: linux-kernel@vger.kernel.org
Cc: tiwai@suse.de, Wang Shaoyan <wangshaoyan.pt@taobao.com>
Subject: [PATCH] ALSA: hda - Add CONFIG_SND_HDA_POWER_SAVE to stac_vrefout_set()
Date: Wed, 10 Aug 2011 16:01:04 +0800
Message-Id: <1312963264-17192-1-git-send-email-wangshaoyan.pt@taobao.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wang Shaoyan <wangshaoyan.pt@taobao.com>

In commit 45eebda7, it add new function stac_vrefout_set, but it
is only used in code between CONFIG_SND_HDA_POWER_SAVE macro, so
add the macro to avoid such warning:

  sound/pci/hda/patch_sigmatel.c:676:12: warning: 'stac_vrefout_set' defined but not used

Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
---
 sound/pci/hda/patch_sigmatel.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index aa376b5..5145b66 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -673,6 +673,7 @@ static int stac92xx_smux_enum_put(struct snd_kcontrol *kcontrol,
 	return 0;
 }
 
+#ifdef CONFIG_SND_HDA_POWER_SAVE
 static int stac_vrefout_set(struct hda_codec *codec,
 					hda_nid_t nid, unsigned int new_vref)
 {
@@ -696,6 +697,7 @@ static int stac_vrefout_set(struct hda_codec *codec,
 
 	return 1;
 }
+#endif
 
 static unsigned int stac92xx_vref_set(struct hda_codec *codec,
 					hda_nid_t nid, unsigned int new_vref)
-- 
1.7.4.1

