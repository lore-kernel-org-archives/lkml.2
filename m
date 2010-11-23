Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab0KWHwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 02:52:45 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34574 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab0KWHwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 02:52:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=IHvuzj9V/jcR4s4MIO2sGuskGMekMFE1mmWEJVKy+OvGbAe4mUlaP7lsr6jcFCJLV8
         ewXAfdu1a+vZcq1wVZq5xROb6nvGW0oJkaGeS1Jj+QKQq3aghlPSlPzyovytVO6eyoZ5
         xIIIhFxt/zE2WUA5lfpLJbz64GCONkDI33wDk=
Subject: [PATCH 2/3] ASoC: wm8904 - fix memory leaks
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1290498981.7286.4.camel@mola>
References: <1290498981.7286.4.camel@mola>
Content-Type: text/plain
Date: Tue, 23 Nov 2010 15:57:49 +0800
Message-Id: <1290499069.7286.6.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8904.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/wm8904.c b/sound/soc/codecs/wm8904.c
index da91928..d0024666 100644
--- a/sound/soc/codecs/wm8904.c
+++ b/sound/soc/codecs/wm8904.c
@@ -2498,6 +2498,8 @@ static int wm8904_remove(struct snd_soc_codec *codec)
 
 	wm8904_set_bias_level(codec, SND_SOC_BIAS_OFF);
 	regulator_bulk_free(ARRAY_SIZE(wm8904->supplies), wm8904->supplies);
+	kfree(wm8904->retune_mobile_texts);
+	kfree(wm8904->drc_texts);
 
 	return 0;
 }
-- 
1.7.2



