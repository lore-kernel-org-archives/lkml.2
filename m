Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab1I1CAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 22:00:30 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43857 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab1I1CA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 22:00:29 -0400
Subject: [PATCH 1/6] ASoC: Remove unused "control_data" field of struct
 ak4671_priv
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Joonyoung Shim <jy0922.shim@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Sep 2011 10:00:18 +0800
Message-ID: <1317175218.14102.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The control_data field is used to initialize the codec's control_data field,
but since this is also done by the snd-soc-cache core, the redundant
assignment can be removed and the field can be dropped.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/ak4671.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/ak4671.c b/sound/soc/codecs/ak4671.c
index 88b29f8..2ecf128 100644
--- a/sound/soc/codecs/ak4671.c
+++ b/sound/soc/codecs/ak4671.c
@@ -26,7 +26,6 @@
 /* codec private data */
 struct ak4671_priv {
 	enum snd_soc_control_type control_type;
-	void *control_data;
 };
 
 /* ak4671 register cache & default register settings */
@@ -675,7 +674,6 @@ static int __devinit ak4671_i2c_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	i2c_set_clientdata(client, ak4671);
-	ak4671->control_data = client;
 	ak4671->control_type = SND_SOC_I2C;
 
 	ret = snd_soc_register_codec(&client->dev,
-- 
1.7.4.1



