Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab0KYJSn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 04:18:43 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64981 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab0KYJSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 04:18:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=obu0+RvaS1oiP4+wxIKLOidFIry392CFToAJJPNUoGjCOFA/JC+DJO7a3ltaYJ5FCJ
         1FyVxgKrNnahdLLSp9PCCPtWatPYtvEtBQ28B7hHFR/QeKv3+h/cI2fjAMOQJDj1giuU
         iOq9KgEP8P9c/+jK0bBLs7IFu4n639toZpJzQ=
Subject: [PATCH] ASoC: Call snd_soc_unregister_dais instead of
	snd_soc_unregister_dai in sh4_soc_dai_remove
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Manuel Lauss <mano@roarinelk.homelinux.net>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain
Date: Thu, 25 Nov 2010 17:23:55 +0800
Message-Id: <1290677035.1928.3.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We call snd_soc_register_dais() in sh4_soc_dai_probe(),
thus we should call snd_soc_unregister_dais() in sh4_soc_dai_remove().

Otherwise, we got "too many arguments to function 'snd_soc_unregister_dai'"
error message.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/sh/ssi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/sh/ssi.c b/sound/soc/sh/ssi.c
index 40bbdf1..05192d9 100644
--- a/sound/soc/sh/ssi.c
+++ b/sound/soc/sh/ssi.c
@@ -387,7 +387,7 @@ static int __devinit sh4_soc_dai_probe(struct platform_device *pdev)
 
 static int __devexit sh4_soc_dai_remove(struct platform_device *pdev)
 {
-	snd_soc_unregister_dai(&pdev->dev, ARRAY_SIZE(sh4_ssi_dai));
+	snd_soc_unregister_dais(&pdev->dev, ARRAY_SIZE(sh4_ssi_dai));
 	return 0;
 }
 
-- 
1.7.2



