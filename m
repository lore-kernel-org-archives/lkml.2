Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966097Ab0GPQQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 12:16:37 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35131 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966003Ab0GPQQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 12:16:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=YEpPqZgAbrIpexdWoDB9nQnjdYj//4kn5eNNHtiKAv99GukcA6bmYXmVv+uoZSky87
         nNG07NxbrFQFt/AyZVHvRiLLYQU7wiihN7GHHI2LSNpITkTNpKp+mL5bpt+Eh9KaBbnS
         DQT92hWnOsj7fBkYLJqNjaLj5YklRVaFuJHSI=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        Miguel Aguilar <miguel.aguilar@ridgerun.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH 13/15] sound/soc: davinci: check kzalloc() result (typo)
Date: Fri, 16 Jul 2010 20:16:17 +0400
Message-Id: <1279296977-25267-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code checks 'davinci_vc' after kzalloc() and do not checks
'davinci_vcif_dev' that kzalloc() result is assigned to. It seems that
it is a typo (autocompletion?).

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 sound/soc/davinci/davinci-vcif.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/davinci/davinci-vcif.c b/sound/soc/davinci/davinci-vcif.c
index 9aa980d..4867853 100644
--- a/sound/soc/davinci/davinci-vcif.c
+++ b/sound/soc/davinci/davinci-vcif.c
@@ -203,7 +203,7 @@ static int davinci_vcif_probe(struct platform_device *pdev)
 	int ret;
 
 	davinci_vcif_dev = kzalloc(sizeof(struct davinci_vcif_dev), GFP_KERNEL);
-	if (!davinci_vc) {
+	if (!davinci_vcif_dev) {
 		dev_dbg(&pdev->dev,
 			"could not allocate memory for private data\n");
 		return -ENOMEM;
-- 
1.7.0.4

