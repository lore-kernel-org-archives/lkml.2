Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab0KVP7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 10:59:23 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35540 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab0KVP7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 10:59:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ijv2cfVnQp5QhybJc40P4XhldDGsmKaplohTbloLlhaizyq+1LZ2m/cLIz/uNj1903
         B8l2k6OBj5j12GMbL6haqyFn4obe2Qd+r4dZvn2omo05fMV9w8WazbKUv4dV3KD94W/J
         Paeg6NGfNWTwFQRp0wePxTVXnDVAuJDjkZB2I=
Date: Mon, 22 Nov 2010 18:59:13 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Timur Tabi <timur@freescale.com>, Lars-Peter Clausen <lars@metafoo.de>,
        alsa-devel@alsa-project.org, Jarkko Nikula <jhnikula@gmail.com>
Subject: [PATCH v2] ASoC: atmel: test wrong variable
Message-ID: <20101122155913.GA9089@albatros>
References: <1290361216-15166-1-git-send-email-segoon@openwall.com>
 <20101122094353.f76830b5.jhnikula@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101122094353.f76830b5.jhnikula@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After clk_get() mclk is checked second time instead of pllb check.
In patch v1 Jarkko Nikula noticed that PTR_ERR() is also has wrong argument.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 sound/soc/atmel/sam9g20_wm8731.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/atmel/sam9g20_wm8731.c b/sound/soc/atmel/sam9g20_wm8731.c
index da9c303..f16e00c 100644
--- a/sound/soc/atmel/sam9g20_wm8731.c
+++ b/sound/soc/atmel/sam9g20_wm8731.c
@@ -223,9 +223,9 @@ static int __init at91sam9g20ek_init(void)
 	}
 
 	pllb = clk_get(NULL, "pllb");
-	if (IS_ERR(mclk)) {
+	if (IS_ERR(pllb)) {
 		printk(KERN_ERR "ASoC: Failed to get PLLB\n");
-		ret = PTR_ERR(mclk);
+		ret = PTR_ERR(pllb);
 		goto err_mclk;
 	}
 	ret = clk_set_parent(mclk, pllb);
-- 
1.7.0.4
