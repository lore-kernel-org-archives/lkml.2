Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab0KURk0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 12:40:26 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43618 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935Ab0KURkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 12:40:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=wFSFAu6LroX+AUbt+R/FX/cRJf1QHdj6eJ2M0WQAp+S+rV/Cx8gTsFXMWRWAd8vh32
         oceTCbkcLK2chviDOqByLVQbjQAeh+t8IQ9etXOpOXJeCrL+hCG4KbxFPXtT9kC8g8VW
         wF9eufjZ8uLlvdXHS7iM2tUpSced6kTV+W53A=
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-janitors@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Timur Tabi <timur@freescale.com>, Jarkko Nikula <jhnikula@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ASoC: atmel: test wrong variable
Date: Sun, 21 Nov 2010 20:40:14 +0300
Message-Id: <1290361216-15166-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After clk_get() mclk is checked second time instead of pllb check.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Cannot compile this driver, so it is not tested.

 sound/soc/atmel/sam9g20_wm8731.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/atmel/sam9g20_wm8731.c b/sound/soc/atmel/sam9g20_wm8731.c
index da9c303..68072a2 100644
--- a/sound/soc/atmel/sam9g20_wm8731.c
+++ b/sound/soc/atmel/sam9g20_wm8731.c
@@ -223,7 +223,7 @@ static int __init at91sam9g20ek_init(void)
 	}
 
 	pllb = clk_get(NULL, "pllb");
-	if (IS_ERR(mclk)) {
+	if (IS_ERR(pllb)) {
 		printk(KERN_ERR "ASoC: Failed to get PLLB\n");
 		ret = PTR_ERR(mclk);
 		goto err_mclk;
-- 
1.7.0.4

