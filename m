Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932971Ab1IIIrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 04:47:13 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38117 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932827Ab1IIIrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 04:47:11 -0400
Subject: [PATCH] ASoC: tpa6130a2: Remove obsolete cleanup for clientdata
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Wolfram Sang <w.sang@pengutronix.de>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Sep 2011 16:47:00 +0800
Message-ID: <1315558020.2332.0.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i2c core will clear the clientdata pointer automatically,
we don't have to set the `data' field to NULL in remove() or
if probe() failed anymore.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/tpa6130a2.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/tpa6130a2.c b/sound/soc/codecs/tpa6130a2.c
index 239e0c4..b2572c4 100644
--- a/sound/soc/codecs/tpa6130a2.c
+++ b/sound/soc/codecs/tpa6130a2.c
@@ -446,7 +446,6 @@ err_regulator:
 		gpio_free(data->power_gpio);
 err_gpio:
 	kfree(data);
-	i2c_set_clientdata(tpa6130a2_client, NULL);
 	tpa6130a2_client = NULL;
 
 	return ret;
-- 
1.7.4.1



