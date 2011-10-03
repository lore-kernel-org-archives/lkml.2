Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab1JCIMH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 04:12:07 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53277 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab1JCIMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 04:12:03 -0400
Subject: [PATCH] ASoC: Staticise simtec_audio_resume()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jassi Brar <jassisinghbrar@gmail.com>, Ben Dooks <ben@simtec.co.uk>,
        Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Oct 2011 16:11:52 +0800
Message-ID: <1317629512.2820.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is exported via resume callback of struct dev_pm_ops rather than referenced
directly and so should be staticised.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/samsung/s3c24xx_simtec.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/samsung/s3c24xx_simtec.c b/sound/soc/samsung/s3c24xx_simtec.c
index 349566f..c8d525b 100644
--- a/sound/soc/samsung/s3c24xx_simtec.c
+++ b/sound/soc/samsung/s3c24xx_simtec.c
@@ -300,7 +300,7 @@ static void detach_gpio_amp(struct s3c24xx_audio_simtec_pdata *pd)
 }
 
 #ifdef CONFIG_PM
-int simtec_audio_resume(struct device *dev)
+static int simtec_audio_resume(struct device *dev)
 {
 	simtec_call_startup(pdata);
 	return 0;
-- 
1.7.4.1



