Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab1JBU3R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 16:29:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59606 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473Ab1JBU3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 16:29:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Jassi Brar <jassisinghbrar@gmail.com>,
        Sangbeom Kim <sbkim73@samsung.com>
Subject: [PATCH 6/6] ASoC: samsung: add missing __devexit_p() annotations
Date: Sun,  2 Oct 2011 22:28:04 +0200
Message-Id: <1317587284-2776-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317587284-2776-1-git-send-email-arnd@arndb.de>
References: <1317587284-2776-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:kb6V2erUOEdgOoA4Um9zY5klAATDAbaseK8qwe30hN0
 0VFEa2OIirUM1T3EZoWUUVDRqFcU2UkiMH9zra63cjhWzcXq9L
 s0EzHV3pjb1hGhXYq6IwseKM9Gh6EsV85ON0bJh1xBG666gucG
 kPp+v154LI3TrvOD360tWmlPtLJcy3O6gcS7XEpZYDP29XL6n8
 mfcEvXszKYbPDtkNgG8iznfyALMc/naHxPyyygJ+PXq6euusLL
 QVHVM/1Q8FqxbMLU6uJVvd3wwL/FlKluoTxIyJXKaXUe+VM3fV
 0ZNvh39Uox478em+bIj6yO3Vtl/RYyogevWtXnXP0YSp9mH2yu
 /Mtfk0pDekacQWGzpqPsfv31Z1Q4kVC5BP4RphQEzXmOhHau7j
 Msf5zuwxnWT6g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers that refer to a __devexit function in an operations
structure need to annotate that pointer with __devexit_p so
replace it with a NULL pointer when the section gets discarded.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>
---
 sound/soc/samsung/ac97.c |    2 +-
 sound/soc/samsung/i2s.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/samsung/ac97.c b/sound/soc/samsung/ac97.c
index f97110e..65ea538 100644
--- a/sound/soc/samsung/ac97.c
+++ b/sound/soc/samsung/ac97.c
@@ -495,7 +495,7 @@ static __devexit int s3c_ac97_remove(struct platform_device *pdev)
 
 static struct platform_driver s3c_ac97_driver = {
 	.probe  = s3c_ac97_probe,
-	.remove = s3c_ac97_remove,
+	.remove = __devexit_p(s3c_ac97_remove),
 	.driver = {
 		.name = "samsung-ac97",
 		.owner = THIS_MODULE,
diff --git a/sound/soc/samsung/i2s.c b/sound/soc/samsung/i2s.c
index c086b78..0c9ac20 100644
--- a/sound/soc/samsung/i2s.c
+++ b/sound/soc/samsung/i2s.c
@@ -1136,7 +1136,7 @@ static __devexit int samsung_i2s_remove(struct platform_device *pdev)
 
 static struct platform_driver samsung_i2s_driver = {
 	.probe  = samsung_i2s_probe,
-	.remove = samsung_i2s_remove,
+	.remove = __devexit_p(samsung_i2s_remove),
 	.driver = {
 		.name = "samsung-i2s",
 		.owner = THIS_MODULE,
-- 
1.7.5.4

