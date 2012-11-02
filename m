Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955Ab2KBTYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 15:24:34 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:25591 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757005Ab2KBTYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 15:24:18 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+79BfXdzfURTqrdgNeUBUH
Subject: [PATCH 6/6] ARM: OMAP2+: Move iommu/iovmm headers to platform_data
To: linux-kernel@vger.kernel.org
From: Tony Lindgren <tony@atomide.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>, linux-omap@vger.kernel.org,
        Ido Yariv <ido@wizery.com>, linux-arm-kernel@lists.infradead.org
Date: Fri, 02 Nov 2012 12:24:14 -0700
Message-ID: <20121102192414.4253.23689.stgit@muffinssi.local>
In-Reply-To: <20121102192221.4253.34303.stgit@muffinssi.local>
References: <20121102192221.4253.34303.stgit@muffinssi.local>
User-Agent: StGit/0.16-2-g0d85
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move iommu/iovmm headers from plat/ to platform_data/ as part of the
single zImage work.

Partially based on an earlier version by Ido Yariv <ido@wizery.com>.

Cc: Joerg Roedel <joro@8bytes.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Ido Yariv <ido@wizery.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Omar Ramirez Luna <omar.luna@linaro.org>
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/devices.c              |    2 +-
 arch/arm/mach-omap2/omap-iommu.c           |    2 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |    2 +-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |    2 +-
 drivers/iommu/omap-iommu-debug.c           |    3 +--
 drivers/iommu/omap-iommu.c                 |    2 +-
 drivers/iommu/omap-iommu2.c                |    2 +-
 drivers/iommu/omap-iovmm.c                 |    3 +--
 drivers/media/platform/omap3isp/ispvideo.c |    1 -
 include/linux/platform_data/iommu-omap.h   |    0 
 10 files changed, 8 insertions(+), 11 deletions(-)
 rename arch/arm/plat-omap/include/plat/iommu.h => include/linux/platform_data/iommu-omap.h (100%)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index cba60e0..1002ff8 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -126,7 +126,7 @@ static struct platform_device omap2cam_device = {
 
 #if defined(CONFIG_IOMMU_API)
 
-#include <plat/iommu.h>
+#include <linux/platform_data/iommu-omap.h>
 
 static struct resource omap3isp_resources[] = {
 	{
diff --git a/arch/arm/mach-omap2/omap-iommu.c b/arch/arm/mach-omap2/omap-iommu.c
index df298d4..a6a4ff8 100644
--- a/arch/arm/mach-omap2/omap-iommu.c
+++ b/arch/arm/mach-omap2/omap-iommu.c
@@ -13,7 +13,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 
-#include <plat/iommu.h>
+#include <linux/platform_data/iommu-omap.h>
 
 #include "soc.h"
 #include "common.h"
diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
index f67b7ee..621bc71 100644
--- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -26,8 +26,8 @@
 #include <plat/mmc.h>
 #include <linux/platform_data/asoc-ti-mcbsp.h>
 #include <linux/platform_data/spi-omap2-mcspi.h>
+#include <linux/platform_data/iommu-omap.h>
 #include <plat/dmtimer.h>
-#include <plat/iommu.h>
 
 #include "am35xx.h"
 
diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
index 652d028..5850b3e 100644
--- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
@@ -27,10 +27,10 @@
 #include <plat/dma.h>
 #include <linux/platform_data/spi-omap2-mcspi.h>
 #include <linux/platform_data/asoc-ti-mcbsp.h>
+#include <linux/platform_data/iommu-omap.h>
 #include <plat/mmc.h>
 #include <plat/dmtimer.h>
 #include <plat/common.h>
-#include <plat/iommu.h>
 
 #include "omap_hwmod_common_data.h"
 #include "cm1_44xx.h"
diff --git a/drivers/iommu/omap-iommu-debug.c b/drivers/iommu/omap-iommu-debug.c
index d0427bd..d97fbe4 100644
--- a/drivers/iommu/omap-iommu-debug.c
+++ b/drivers/iommu/omap-iommu-debug.c
@@ -19,8 +19,7 @@
 #include <linux/platform_device.h>
 #include <linux/debugfs.h>
 #include <linux/omap-iommu.h>
-
-#include <plat/iommu.h>
+#include <linux/platform_data/iommu-omap.h>
 
 #include "omap-iopgtable.h"
 #include "omap-iommu.h"
diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index df84087..badc17c 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -26,7 +26,7 @@
 
 #include <asm/cacheflush.h>
 
-#include <plat/iommu.h>
+#include <linux/platform_data/iommu-omap.h>
 
 #include "omap-iopgtable.h"
 #include "omap-iommu.h"
diff --git a/drivers/iommu/omap-iommu2.c b/drivers/iommu/omap-iommu2.c
index 29e98a2..c020202 100644
--- a/drivers/iommu/omap-iommu2.c
+++ b/drivers/iommu/omap-iommu2.c
@@ -19,8 +19,8 @@
 #include <linux/omap-iommu.h>
 #include <linux/slab.h>
 #include <linux/stringify.h>
+#include <linux/platform_data/iommu-omap.h>
 
-#include <plat/iommu.h>
 #include "omap-iommu.h"
 
 /*
diff --git a/drivers/iommu/omap-iovmm.c b/drivers/iommu/omap-iovmm.c
index 3e3b242..46d87569 100644
--- a/drivers/iommu/omap-iovmm.c
+++ b/drivers/iommu/omap-iovmm.c
@@ -18,12 +18,11 @@
 #include <linux/scatterlist.h>
 #include <linux/iommu.h>
 #include <linux/omap-iommu.h>
+#include <linux/platform_data/iommu-omap.h>
 
 #include <asm/cacheflush.h>
 #include <asm/mach/map.h>
 
-#include <plat/iommu.h>
-
 #include "omap-iopgtable.h"
 #include "omap-iommu.h"
 
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index a4b8290..21f7313 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -35,7 +35,6 @@
 #include <linux/vmalloc.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-ioctl.h>
-#include <plat/iommu.h>
 #include <plat/omap-pm.h>
 
 #include "ispvideo.h"
diff --git a/arch/arm/plat-omap/include/plat/iommu.h b/include/linux/platform_data/iommu-omap.h
similarity index 100%
rename from arch/arm/plat-omap/include/plat/iommu.h
rename to include/linux/platform_data/iommu-omap.h

