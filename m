Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab0KWHvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 02:51:19 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:33092 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab0KWHvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 02:51:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=WpQwhxrVcgwyHa+K2wasNpia/Ner8pINkNRDuKzYDjHAehPCNvNHGQNWCFtw7cs15D
         5iaFNjyH6Sxz+fb8v+wxasN95F210DyKKtHiXNuFoyTaEJS9NokgX5alAGX0XFm6mAco
         I868gB599wG6OqCDuOO9oX2x5U4TNP3rXwuw0=
Subject: [PATCH 1/3] ASoC: max98088 - fix a memory leak
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Peter Hsiang <Peter.Hsiang@maxim-ic.com>,
        Jesse Marroquin <jesse.marroquin@maxim-ic.com>
Content-Type: text/plain
Date: Tue, 23 Nov 2010 15:56:21 +0800
Message-Id: <1290498981.7286.4.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/max98088.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/max98088.c b/sound/soc/codecs/max98088.c
index 4ee5b1a..b679586 100644
--- a/sound/soc/codecs/max98088.c
+++ b/sound/soc/codecs/max98088.c
@@ -2020,7 +2020,10 @@ err_access:
 
 static int max98088_remove(struct snd_soc_codec *codec)
 {
+       struct max98088_priv *max98088 = snd_soc_codec_get_drvdata(codec);
+
        max98088_set_bias_level(codec, SND_SOC_BIAS_OFF);
+       kfree(max98088->eq_texts);
 
        return 0;
 }
-- 
1.7.2



