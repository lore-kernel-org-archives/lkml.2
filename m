Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab2FSPon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 11:44:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50926 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab2FSPom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 11:44:42 -0400
Date: Tue, 19 Jun 2012 17:44:39 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: [PATCH 2/2 v3] regulator: extend the fixed dummy voltage regulator
 to accept voltage
In-Reply-To: <Pine.LNX.4.64.1206191742030.6204@axis700.grange>
Message-ID: <Pine.LNX.4.64.1206191743110.6204@axis700.grange>
References: <20120618094145.GC3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181145520.23884@axis700.grange>
 <20120618100657.GG3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181212180.23884@axis700.grange>
 <20120618115738.GI3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181755370.23884@axis700.grange>
 <20120618162058.GT3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181826210.23884@axis700.grange>
 <20120618163758.GU3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181850280.23884@axis700.grange>
 <20120618172808.GX3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206191742030.6204@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:faYUW8n6OnjNElAaAIYpp2BFf0Suel7i6eY6FXhxg0u
 G35tV2BM9NSgtv6LT09iNs8nhQ5EghoMNHVLzw6MqP+rJCsNwJ
 XPh2LWuZQXun9kMV66OEWOb33T2vm1uCwgbLltsB7olMW0lNan
 eGLSvijjxFUzSVKWldnxYvXCUbj06+/fDpbW2yG+BBF5QjaMuN
 NclBqQs1bbcpBaXtpYqR+pz9kmtI68SgoKE+PUL3B7zBt+UTgY
 FpJTOWMD5S9oujXbyS89A5juWp7F9s6/FdN9A/irlbIAiSSrIf
 Dglx5oe4DRPOPNOboRHbi8ktgMiNE8esvU1nHAkYl6iKdd5Rwz
 Owf0pV5Dlw0WP2aoHUBjzaMY8k40Vy4Jry0xnMtwepDw8QbveY
 vjPnxr73lc+bw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivially extend the regulator_register_always_on() helper function to be
even more useful by adding a voltage parameter to it.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/regulator/fixed-helper.c |    5 +++--
 include/linux/regulator/fixed.h  |    6 +++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/fixed-helper.c b/drivers/regulator/fixed-helper.c
index 3aa268d..f9d0279 100644
--- a/drivers/regulator/fixed-helper.c
+++ b/drivers/regulator/fixed-helper.c
@@ -24,9 +24,10 @@ static void regulator_fixed_release(struct device *dev)
  * @name: name to be used for the regulator
  * @supplies: consumers for this regulator
  * @num_supplies: number of consumers
+ * @uv: voltage in microvolts
  */
 struct platform_device *regulator_register_always_on(int id, const char *name,
-		struct regulator_consumer_supply *supplies, int num_supplies)
+	struct regulator_consumer_supply *supplies, int num_supplies, int uv)
 {
 	struct fixed_regulator_data *data;
 
@@ -40,7 +41,7 @@ struct platform_device *regulator_register_always_on(int id, const char *name,
 		return NULL;
 	}
 
-	data->cfg.microvolts = 0;
+	data->cfg.microvolts = uv;
 	data->cfg.gpio = -EINVAL;
 	data->cfg.enabled_at_boot = 1;
 	data->cfg.init_data = &data->init_data;
diff --git a/include/linux/regulator/fixed.h b/include/linux/regulator/fixed.h
index 6b9325b..680f24e 100644
--- a/include/linux/regulator/fixed.h
+++ b/include/linux/regulator/fixed.h
@@ -59,16 +59,16 @@ struct regulator_consumer_supply;
 
 #if IS_ENABLED(CONFIG_REGULATOR)
 struct platform_device *regulator_register_always_on(int id, const char *name,
-		struct regulator_consumer_supply *supplies, int num_supplies);
+		struct regulator_consumer_supply *supplies, int num_supplies, int uv);
 #else
 static inline struct platform_device *regulator_register_always_on(int id, const char *name,
-		struct regulator_consumer_supply *supplies, int num_supplies)
+		struct regulator_consumer_supply *supplies, int num_supplies, int uv)
 {
 	return NULL;
 }
 #endif
 
 #define regulator_register_fixed(id, s, ns) regulator_register_always_on(id, \
-						"fixed-dummy", s, ns)
+						"fixed-dummy", s, ns, 0)
 
 #endif
-- 
1.7.2.5

