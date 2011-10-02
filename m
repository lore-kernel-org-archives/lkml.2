Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab1JBOtX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 10:49:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61451 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab1JBOrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 10:47:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Archit Taneja <archit@ti.com>, Amber Jain <amber@ti.com>,
        Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH 20/30] media/omap_vout: disable driver for now
Date: Sun,  2 Oct 2011 16:45:50 +0200
Message-Id: <1317566760-25681-21-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317566760-25681-1-git-send-email-arnd@arndb.de>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:YTFh68Hb/SobSU3j0GHw9FN8RxFDs7trt+r73JS5QGS
 ppi5Bf/8EvvfvSqNGiPn5qk9Bn4w4gMSK8ze6MQcd/bLsVlotp
 /X7vFtMNnqDlZUPHy7O0gmnqO2ATwFluGbDDd5TFfKIM01QKHk
 rKgtH37zKnlyVMaggzYbUJf8OzX08/X53ohB7Cv0W+SZj1zSEQ
 t8+hDvUYaScXeFswNL+EBoW4W5CX71SAOm1BzWfXfmL+waG1e9
 dLGl688uacBpOeqj8/8exO6OveYeeC9grprT/U0gbZYyq8Yprm
 dUdlbP1JWF3VACXXXN8wXYtjCa73NhGHAi4PcjDm1Ief3JAV8e
 oQxBOHEmsABCMmc9PckJFwvD4Rb3mh2S8BdbUJ0NKNbGuWPLdx
 kXOdDh6kuZHiQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver was broken by 8cff88c5d "OMAP: DSS2: remove update_mode
from omapdss":

/home/arnd/linux-arm/drivers/media/video/omap/omap_vout.c: In function 'omap_vout_probe':
/home/arnd/linux-arm/drivers/media/video/omap/omap_vout.c:2202:15: error: 'struct omap_dss_driver' has no member
named 'set_update_mode'
/home/arnd/linux-arm/drivers/media/video/omap/omap_vout.c:2203:12: error: 'struct omap_dss_driver' has no member
named 'set_update_mode'
/home/arnd/linux-arm/drivers/media/video/omap/omap_vout.c:2204:8: error: 'OMAP_DSS_UPDATE_MANUAL' undeclared (first
use in this function)
/home/arnd/linux-arm/drivers/media/video/omap/omap_vout.c:2204:8: note: each undeclared identifier is reported only
once for each function it appears in
/home/arnd/linux-arm/drivers/media/video/omap/omap_vout.c:2206:15: error: 'struct omap_dss_driver' has no member
named 'set_update_mode'
/home/arnd/linux-arm/drivers/media/video/omap/omap_vout.c:2207:12: error: 'struct omap_dss_driver' has no member
named 'set_update_mode'
/home/arnd/linux-arm/drivers/media/video/omap/omap_vout.c:2208:8: error: 'OMAP_DSS_UPDATE_AUTO' undeclared (first use
in this function)
make[3]: *** [drivers/media/video/omap/omap_vout.o] Error 1
make[2]: *** [drivers/media/video/omap] Error 2
make[1]: *** [drivers/media/video/] Error 2
make: *** [sub-make] Error 2

Let's disable it for now.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Archit Taneja <archit@ti.com>
Cc: Amber Jain <amber@ti.com>
Cc: Vaibhav Hiremath <hvaibhav@ti.com>
---
 drivers/media/video/omap/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap/Kconfig b/drivers/media/video/omap/Kconfig
index 390ab09..ee21f36 100644
--- a/drivers/media/video/omap/Kconfig
+++ b/drivers/media/video/omap/Kconfig
@@ -4,6 +4,7 @@ config VIDEO_OMAP2_VOUT_VRFB
 config VIDEO_OMAP2_VOUT
 	tristate "OMAP2/OMAP3 V4L2-Display driver"
 	depends on ARCH_OMAP2 || ARCH_OMAP3
+	depends on BROKEN # broken by 8cff88c5da "OMAP: DSS2: remove update_mode from omapdss"
 	select VIDEOBUF_GEN
 	select VIDEOBUF_DMA_CONTIG
 	select OMAP2_DSS
-- 
1.7.5.4

