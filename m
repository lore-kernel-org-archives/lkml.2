Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab0KXIjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 03:39:17 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37866 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab0KXIjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 03:39:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=ugvH23tpD6NdGBPpaqic2PSDQZ873W6x7UowtZWWEBTtv/IAWyKoR6AgSnL+x3yTlU
         fVD5+L3T9prTAqAQXmyFShPa8NYCO8vFNauz3FXN+TizHPdwxJw+PwjnqkaImvuWdTim
         VzqTShKi32f9Z2ymsubgbhVNeHQth5S3nwgio=
Subject: [PATCH] ASoC: nuc900-ac97: fix a memory leak
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Wan ZongShun <mcuos.com@gmail.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Wed, 24 Nov 2010 16:44:23 +0800
Message-Id: <1290588263.7545.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/nuc900/nuc900-ac97.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/nuc900/nuc900-ac97.c b/sound/soc/nuc900/nuc900-ac97.c
index 293dc74..e00e39d 100644
--- a/sound/soc/nuc900/nuc900-ac97.c
+++ b/sound/soc/nuc900/nuc900-ac97.c
@@ -384,7 +384,6 @@ out0:
 
 static int __devexit nuc900_ac97_drvremove(struct platform_device *pdev)
 {
-
 	snd_soc_unregister_dai(&pdev->dev);
 
 	clk_put(nuc900_ac97_data->clk);
@@ -392,6 +391,7 @@ static int __devexit nuc900_ac97_drvremove(struct platform_device *pdev)
 	release_mem_region(nuc900_ac97_data->res->start,
 				resource_size(nuc900_ac97_data->res));
 
+	kfree(nuc900_ac97_data);
 	nuc900_ac97_data = NULL;
 
 	return 0;
-- 
1.7.2



