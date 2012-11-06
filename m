Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab2KFVz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 16:55:59 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:63700 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab2KFVzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 16:55:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Rob Clark <rob@ti.com>, Inki Dae <inki.dae@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>
Subject: [PATCH 8/8] drm/exynos: don't include plat/gpio-cfg.h
Date: Tue,  6 Nov 2012 22:55:33 +0100
Message-Id: <1352238933-4886-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1352238933-4886-1-git-send-email-arnd@arndb.de>
References: <1352238933-4886-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:w5catrIsb9xX4nKcS8hutbtl0r/8R0IZBJ9ypLmotvp
 /Dz4BAzzveLu1PZyucpGV5q/HvjKfSpLs/ShQL+bB7D+R+3Kfs
 wKiFjVI6pkO7UzMxOktM96S7LZ8qTq3U5ZyshR8NN02g2fHIb9
 To1HzVl8m3NRRoCjExPvcqDh8p5Ilzn2oR2MJawtQ/6FZJJpjT
 4MIwj84j15AIGfL4OYQPAmNJI40+xbM0abaozK4fbTh/x5X9Am
 OFGIL+dV7HbHTK5oP7teAGzsJfuIWj1h5rL+CqlKMJGmSRgKu7
 pph1S12e0dK+6Frnf7HC+Mju2LSaEorIURU4g9avI1v0LsXRwf
 4xK9WA0C9dSsGn9aa/jvGzTF8rFxa0vh9+4iaR8nxZvgw9ea4f
 K8egbCrME0iig==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch  9eb3e9e6f3 "drm/exynos: add support for ARCH_MULTIPLATFORM"
allowed building the exynos hdmi driver on non-samsung platforms,
which unfortunately broke compilation in combination with 22c4f42897
"drm: exynos: hdmi: add support for exynos5 hdmi", which added
an inclusion of the samsung-specific plat/gpio-cfg.h header file.

Fortunately, that header file is not required any more here, so
we can simply revert the inclusion in order to build the ARM
allyesconfig again without getting this error:

drivers/gpu/drm/exynos/exynos_hdmi.c:37:27: fatal error: plat/gpio-cfg.h: No such file or directory

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Rob Clark <rob@ti.com>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Rahul Sharma <rahul.sharma@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_hdmi.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
index 2c115f8..7f0fc4e 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -34,7 +34,6 @@
 #include <linux/regulator/consumer.h>
 #include <linux/io.h>
 #include <linux/of_gpio.h>
-#include <plat/gpio-cfg.h>
 
 #include <drm/exynos_drm.h>
 
-- 
1.7.10

