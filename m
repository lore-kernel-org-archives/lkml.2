Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759908Ab2IEXZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 19:25:21 -0400
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:57169 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759696Ab2IEXZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 19:25:19 -0400
Message-ID: <5047DF49.6070502@xenotime.net>
Date: Wed, 05 Sep 2012 16:24:57 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Subject: [PATCH -next] soc: fix wm0010.c printk format warning
References: <20120905161230.3bab1de6d4c8c8e466c3b0df@canb.auug.org.au>
In-Reply-To: <20120905161230.3bab1de6d4c8c8e466c3b0df@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix printk format warning:

sound/soc/codecs/wm0010.c:411:2: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: alsa-devel@alsa-project.org
---
 sound/soc/codecs/wm0010.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20120905.orig/sound/soc/codecs/wm0010.c
+++ linux-next-20120905/sound/soc/codecs/wm0010.c
@@ -408,7 +408,7 @@ static int wm0010_boot(struct snd_soc_co
 	wm0010->state = WM0010_BOOTROM;
 	spin_unlock_irqrestore(&wm0010->irq_lock, flags);
 
-	dev_dbg(codec->dev, "Downloading %d byte stage 2 loader\n", fw->size);
+	dev_dbg(codec->dev, "Downloading %zu byte stage 2 loader\n", fw->size);
 
 	/* Copy to local buffer first as vmalloc causes problems for dma */
 	img = kzalloc(fw->size, GFP_KERNEL);
