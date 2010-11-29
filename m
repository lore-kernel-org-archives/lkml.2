Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab0K2Gu0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 01:50:26 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:50857 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab0K2GuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 01:50:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TTt4UpQD8FO4rXW5SHvOT/4clw8T3XuQj8BCyVgWA/2KkBI2CnnOqWJStx2b2LQJKI
         cQRX2eYTWJFMR+8Kew8LMwhoBNuR/O2sKTlH5Q6FxZSb+j4yscIludzpeemUcF6/uT61
         neKtxmWT0y1hAxFgiVrzdoXfuJQQjv3N9LKRc=
Subject: [PATCH 2/2] ASoC: Add missing dev_set_drvdata in p1022_ds_probe
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Timur Tabi <timur@freescale.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1291013698.19113.1.camel@mola>
References: <1291013698.19113.1.camel@mola>
Content-Type: text/plain
Date: Mon, 29 Nov 2010 14:55:58 +0800
Message-Id: <1291013758.19113.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise, calling dev_get_drvdata in p1022_ds_remove returns NULL.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/fsl/p1022_ds.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/fsl/p1022_ds.c b/sound/soc/fsl/p1022_ds.c
index 63b9eaa..026b756 100644
--- a/sound/soc/fsl/p1022_ds.c
+++ b/sound/soc/fsl/p1022_ds.c
@@ -498,6 +498,7 @@ static int p1022_ds_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "platform device add failed\n");
 		goto error;
 	}
+	dev_set_drvdata(&pdev->dev, sound_device);
 
 	of_node_put(codec_np);
 
-- 
1.7.2



