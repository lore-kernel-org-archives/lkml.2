Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab0K2Gt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 01:49:27 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55282 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab0K2Gt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 01:49:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=RzwY8JFqZaRdKe2k+t5Y5YEdnavzYojzITXDaIWEG+K89fWYGSLVO18VhLnyVTVlXs
         ZHDhnMCoPzQCtK92kGlIGCh9aXkC0jPotUuV6ykjFniS+Lb+tkfFUMoZFnw/Z/vy2mzg
         nW7bDInsxLc5H00SnF4F9hItyx1cJvZOTns6U=
Subject: [PATCH 1/2] ASoC: Add missing dev_set_drvdata in mpc8610_hpcd_probe
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Timur Tabi <timur@freescale.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain
Date: Mon, 29 Nov 2010 14:54:58 +0800
Message-Id: <1291013698.19113.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise, calling dev_get_drvdata in mpc8610_hpcd_remove returns NULL.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/fsl/mpc8610_hpcd.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/fsl/mpc8610_hpcd.c b/sound/soc/fsl/mpc8610_hpcd.c
index 0d7dcf1..7d7847a 100644
--- a/sound/soc/fsl/mpc8610_hpcd.c
+++ b/sound/soc/fsl/mpc8610_hpcd.c
@@ -498,6 +498,7 @@ static int mpc8610_hpcd_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "platform device add failed\n");
 		goto error;
 	}
+	dev_set_drvdata(&pdev->dev, sound_device);
 
 	of_node_put(codec_np);
 
-- 
1.7.2



