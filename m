Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab1JBAzV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 20:55:21 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43653 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab1JBAzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 20:55:15 -0400
Subject: [PATCH] ASoC: wm8782: Add __devexit_p at necessary place
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Johannes Stezenbach <js@sig21.net>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 02 Oct 2011 08:55:02 +0800
Message-ID: <1317516902.8024.0.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the comments in include/linux/init.h:

"Pointers to __devexit functions must use __devexit_p(function_name), the
wrapper will insert either the function_name or NULL, depending on the config
options."

We have __devexit annotation for wm8782_remove(), thus add __devexit_p at
necessary place.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8782.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm8782.c b/sound/soc/codecs/wm8782.c
index a2a09f8..f2ced71 100644
--- a/sound/soc/codecs/wm8782.c
+++ b/sound/soc/codecs/wm8782.c
@@ -60,7 +60,7 @@ static struct platform_driver wm8782_codec_driver = {
 		.owner = THIS_MODULE,
 	},
 	.probe = wm8782_probe,
-	.remove = wm8782_remove,
+	.remove = __devexit_p(wm8782_remove),
 };
 
 static int __init wm8782_init(void)
-- 
1.7.4.1



