Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981Ab1ITHJN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 03:09:13 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58487 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab1ITHJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 03:09:11 -0400
Subject: [PATCH] ASoC: fsl: Fix error handling if platform_device_add fails
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Timur Tabi <timur@freescale.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Sep 2011 15:09:00 +0800
Message-ID: <1316502540.4269.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call platform_device_put() instead of platform_device_unregister() if
platform_device_add() fails.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/fsl/mpc8610_hpcd.c |    2 +-
 sound/soc/fsl/p1022_ds.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/fsl/mpc8610_hpcd.c b/sound/soc/fsl/mpc8610_hpcd.c
index 358f0ba..31af405 100644
--- a/sound/soc/fsl/mpc8610_hpcd.c
+++ b/sound/soc/fsl/mpc8610_hpcd.c
@@ -505,7 +505,7 @@ static int mpc8610_hpcd_probe(struct platform_device *pdev)
 	return 0;
 
 error_sound:
-	platform_device_unregister(sound_device);
+	platform_device_put(sound_device);
 error:
 	kfree(machine_data);
 error_alloc:
diff --git a/sound/soc/fsl/p1022_ds.c b/sound/soc/fsl/p1022_ds.c
index e8849ed..2c064a9 100644
--- a/sound/soc/fsl/p1022_ds.c
+++ b/sound/soc/fsl/p1022_ds.c
@@ -506,7 +506,7 @@ static int p1022_ds_probe(struct platform_device *pdev)
 
 error:
 	if (sound_device)
-		platform_device_unregister(sound_device);
+		platform_device_put(sound_device);
 
 	kfree(mdata);
 error_put:
-- 
1.7.4.1



