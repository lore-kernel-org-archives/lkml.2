Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab1JXDbY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 23:31:24 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41691 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab1JXDbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 23:31:23 -0400
Message-ID: <1319427072.5773.1.camel@phoenix>
Subject: [PATCH] ASoC: wm8996: Avoid a redundant i2c_get_clientdata call in
 wm8996_i2c_remove
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Date: Mon, 24 Oct 2011 11:31:12 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8996.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm8996.c b/sound/soc/codecs/wm8996.c
index 645c980..32324c9 100644
--- a/sound/soc/codecs/wm8996.c
+++ b/sound/soc/codecs/wm8996.c
@@ -3144,7 +3144,7 @@ static __devexit int wm8996_i2c_remove(struct i2c_client *client)
 	snd_soc_unregister_codec(&client->dev);
 	if (wm8996->pdata.ldo_ena > 0)
 		gpio_free(wm8996->pdata.ldo_ena);
-	kfree(i2c_get_clientdata(client));
+	kfree(wm8996);
 	return 0;
 }
 
-- 
1.7.5.4



