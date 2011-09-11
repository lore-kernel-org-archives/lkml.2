Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab1IKSIG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 14:08:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61696 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab1IKSIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 14:08:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Julia Lawall <julia@diku.dk>
Cc: Liam Girdwood <lrg@ti.com>, kernel-janitors@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sound/soc/kirkwood/kirkwood-i2s.c: fix trivial build regression
Date: Sun, 11 Sep 2011 20:07:30 +0200
Message-ID: <3099701.CcMbBAJgz4@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <1313820761-12042-1-git-send-email-julia@diku.dk>
References: <1313820761-12042-1-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:qtoKelJz6XoOm3Im6m+1U4lDPY71/zVGVffrrApyZqw
 IgZVboTsJF/+jaUoa8aO/Kr5Ah70osEznDm8yNS9dgTsDsI1A0
 A1PjQtfHdw5zo/+Qh20DHOG1mA0AOn6oyQGcv/9ogCU26RgBhk
 kzqwAn/SFeedc8049zEmn/EAblbLf3pOAgKGpy4ojybGE2Klef
 UmAEgkwso7v9KQJ0Y/5lVAQnu6eTxI8HgATAie0ar31ORw3Ha9
 dv5vSvCdrHpmZAHu1C+Me8yqdDjKyxx78b2feMeHbcZCTATGyr
 LlMpXRsBHMy52xvTvKMRx3PNfszhZJinWk5TSXcvTxRMUc5Wj0
 orfYH1civ7sx3bLR7CwA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A fix merged in 3.1-rc2 introduced a small regression, this should get it
to build again.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
On Saturday 20 August 2011 08:12:38 Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Adjust the goto to jump to the error handling code that includes kfree.
> 

/home/arnd/linux-arm/sound/soc/kirkwood/kirkwood-i2s.c: In function 'kirkwood_i2s_dev_probe':
/home/arnd/linux-arm/sound/soc/kirkwood/kirkwood-i2s.c:427:3: error: label 'error_alloc' used but not defined

diff --git a/sound/soc/kirkwood/kirkwood-i2s.c b/sound/soc/kirkwood/kirkwood-i2s.c
index 8f16cd3..d0bcf3f 100644
--- a/sound/soc/kirkwood/kirkwood-i2s.c
+++ b/sound/soc/kirkwood/kirkwood-i2s.c
@@ -424,7 +424,7 @@ static __devinit int kirkwood_i2s_dev_probe(struct platform_device *pdev)
 	if (!priv->mem) {
 		dev_err(&pdev->dev, "request_mem_region failed\n");
 		err = -EBUSY;
-		goto error_alloc;
+		goto err_alloc;
 	}
 
 	priv->io = ioremap(priv->mem->start, SZ_16K);
