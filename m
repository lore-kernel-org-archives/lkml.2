Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab0KWHxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 02:53:36 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64695 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab0KWHxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 02:53:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HTB27vFuHdJ+jXmQRPh/vUdAzHBnOzx0CIZZcsijuAylw8ZdtTZXJY30Y2ZX1ArZqV
         RoR1QqwWaFoEbSDkM5GZuCCVTRbGFTpJ26acWvDSKxqqywZ+eqXsDISLO+6qEwGTMZ2o
         hVkZtB4ARW7lzm4hGgD/t1N+nAHBMppCh6baY=
Subject: [PATCH 3/3] ASoC: wm8994 - fix memory leaks
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1290499069.7286.6.camel@mola>
References: <1290498981.7286.4.camel@mola>  <1290499069.7286.6.camel@mola>
Content-Type: text/plain
Date: Tue, 23 Nov 2010 15:58:39 +0800
Message-Id: <1290499119.7286.8.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8994.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 63a3895..2833994 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -2503,6 +2503,8 @@ static int  wm8994_codec_remove(struct snd_soc_codec *codec)
 	wm8994_free_irq(codec->control_data, WM8994_IRQ_MIC2_DET, wm8994);
 	wm8994_free_irq(codec->control_data, WM8994_IRQ_MIC1_SHRT, wm8994);
 	wm8994_free_irq(codec->control_data, WM8994_IRQ_MIC1_DET, wm8994);
+	kfree(wm8994->retune_mobile_texts);
+	kfree(wm8994->drc_texts);
 	kfree(wm8994);
 
 	return 0;
-- 
1.7.2



