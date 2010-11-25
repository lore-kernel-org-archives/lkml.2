Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751243Ab0KYD2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 22:28:06 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:52984 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab0KYD2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 22:28:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=bcphVoB9ww6nZ4E9SsE9ASjTFMSfZ+c1WDTyRNo9KcYsRIDq36Hw5rrky7+ztK/6hI
         l7v7UHGMkEIM5L4lH0iMYeicS0ZZQjy2CKXbY+s8madFJsEQUb0r4SpxMwegArs1xLeF
         UNQwySthFAaMxespnldZsq1Zo1EVX5bsW6kZs=
Subject: [PATCH] ASoC: davinci-vcif - fix a memory leak
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Miguel Aguilar <miguel.aguilar@ridgerun.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jarkko Nikula <jhnikula@gmail.com>, alsa-devel@alsa-project.org
Content-Type: text/plain
Date: Thu, 25 Nov 2010 11:33:14 +0800
Message-Id: <1290655994.30158.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/davinci/davinci-vcif.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/sound/soc/davinci/davinci-vcif.c b/sound/soc/davinci/davinci-vcif.c
index fb4cc1e..9d2afcc 100644
--- a/sound/soc/davinci/davinci-vcif.c
+++ b/sound/soc/davinci/davinci-vcif.c
@@ -247,7 +247,10 @@ fail:
 
 static int davinci_vcif_remove(struct platform_device *pdev)
 {
+	struct davinci_vcif_dev *davinci_vcif_dev = dev_get_drvdata(&pdev->dev);
+
 	snd_soc_unregister_dai(&pdev->dev);
+	kfree(davinci_vcif_dev);
 
 	return 0;
 }
-- 
1.7.2



