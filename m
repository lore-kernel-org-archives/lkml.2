Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab1HNDXY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 23:23:24 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45225 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab1HNDXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 23:23:23 -0400
Subject: [PATCH] ASoC: soc-core: Fix checking return value of
 debugfs_create_dir
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Aug 2011 11:23:13 +0800
Message-ID: <1313292193.4421.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have CONFIG_DEBUG_FS guard around the place calling debugfs_create_dir,
thus debugfs_create_dir returns NULL on failure.

Also use pr_warn to print the warning.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/soc-core.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index ae93aa8..69d17ec 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -3356,11 +3356,8 @@ static int __init snd_soc_init(void)
 {
 #ifdef CONFIG_DEBUG_FS
 	snd_soc_debugfs_root = debugfs_create_dir("asoc", NULL);
-	if (IS_ERR(snd_soc_debugfs_root) || !snd_soc_debugfs_root) {
-		printk(KERN_WARNING
-		       "ASoC: Failed to create debugfs directory\n");
-		snd_soc_debugfs_root = NULL;
-	}
+	if (!snd_soc_debugfs_root)
+		pr_warn("ASoC: Failed to create debugfs directory\n");
 
 	if (!debugfs_create_file("codecs", 0444, snd_soc_debugfs_root, NULL,
 				 &codec_list_fops))
-- 
1.7.4.1



