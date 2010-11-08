Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751185Ab0KHFVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 00:21:17 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44306 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab0KHFVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 00:21:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=fHrKZA1RZ8m4rJs+eJKe6tcWzkiD/aisfOKpsZYRka+Ts/W9kg+twBuIPEy3aa5koa
         R7dcrTJlWdlTQASSQ/nwbPWRis6zQY9XaUkx79cTj8Y2xSMV+MZD94ajuCt03Uu0v2Su
         aT2C66a8rI/hPd6vb5Y5SsK3B6qNaqVbUVI3E=
Subject: [PATCH] ASoC: Return proper error if snd_soc_register_dais fails
	in psc_i2s_of_probe
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Mon, 08 Nov 2010 13:24:58 +0800
Message-Id: <1289193898.682.3.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/fsl/mpc5200_psc_i2s.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/fsl/mpc5200_psc_i2s.c b/sound/soc/fsl/mpc5200_psc_i2s.c
index 74ffed4..9018fa5 100644
--- a/sound/soc/fsl/mpc5200_psc_i2s.c
+++ b/sound/soc/fsl/mpc5200_psc_i2s.c
@@ -160,7 +160,7 @@ static int __devinit psc_i2s_of_probe(struct platform_device *op,
 	rc = snd_soc_register_dais(&op->dev, psc_i2s_dai, ARRAY_SIZE(psc_i2s_dai));
 	if (rc != 0) {
 		pr_err("Failed to register DAI\n");
-		return 0;
+		return rc;
 	}
 
 	psc_dma = dev_get_drvdata(&op->dev);
-- 
1.7.2



