Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab0KURkS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 12:40:18 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43618 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982Ab0KURkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 12:40:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=tLqDLBL9Q9ahOIAAL7xjWOy/0Ast1rY0E6EJ+PP1yj/DjxU5jkaoCW2XxUHdP9i6y4
         3ghRvrTXLk6WP9kPtXEak9HSggD02j2OLE3mywLtdrqiDgx5Mpp0XpyXF7XQJtJde882
         +OVtYhRaQk98b1xs21KTCIhyWKi6TLQeTuJYs=
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-janitors@vger.kernel.org
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ALSA: snd-atmel-abdac: test wrong variable
Date: Sun, 21 Nov 2010 20:40:07 +0300
Message-Id: <1290361209-15121-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After clk_get() pclk is checked second time instead of sample_clk check.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested only.

 sound/atmel/abdac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/atmel/abdac.c b/sound/atmel/abdac.c
index f2f41c8..4e47baa 100644
--- a/sound/atmel/abdac.c
+++ b/sound/atmel/abdac.c
@@ -420,7 +420,7 @@ static int __devinit atmel_abdac_probe(struct platform_device *pdev)
 		return PTR_ERR(pclk);
 	}
 	sample_clk = clk_get(&pdev->dev, "sample_clk");
-	if (IS_ERR(pclk)) {
+	if (IS_ERR(sample_clk)) {
 		dev_dbg(&pdev->dev, "no sample clock\n");
 		retval = PTR_ERR(pclk);
 		goto out_put_pclk;
-- 
1.7.0.4

