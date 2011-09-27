Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab1I0Mk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 08:40:29 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34060 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab1I0Mk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 08:40:28 -0400
Subject: [PATCH 1/6] ASoC: Remove unused "control_data" field of struct
 wm8904_priv
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
In-Reply-To: <1317127128.7207.1.camel@phoenix>
References: <1317127128.7207.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Sep 2011 20:40:22 +0800
Message-ID: <1317127222.7207.3.camel@phoenix>
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
 sound/soc/codecs/wm8904.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm8904.c b/sound/soc/codecs/wm8904.c
index b085575..9fc8f4c 100644
--- a/sound/soc/codecs/wm8904.c
+++ b/sound/soc/codecs/wm8904.c
@@ -50,7 +50,6 @@ static const char *wm8904_supply_names[WM8904_NUM_SUPPLIES] = {
 struct wm8904_priv {
 
 	enum wm8904_type devtype;
-	void *control_data;
 
 	struct regulator_bulk_data supplies[WM8904_NUM_SUPPLIES];
 
@@ -2540,7 +2539,6 @@ static __devinit int wm8904_i2c_probe(struct i2c_client *i2c,
 
 	wm8904->devtype = id->driver_data;
 	i2c_set_clientdata(i2c, wm8904);
-	wm8904->control_data = i2c;
 	wm8904->pdata = i2c->dev.platform_data;
 
 	ret = snd_soc_register_codec(&i2c->dev,
-- 
1.7.4.1



