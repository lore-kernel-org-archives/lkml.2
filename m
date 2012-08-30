Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab2H3I1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 04:27:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:25358 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375Ab2H3I1F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 04:27:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,338,1344236400"; 
   d="scan'208";a="215673729"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "airlied@linux.ie" <airlied@linux.ie>,
        "Shi, Yang A" <yang.a.shi@intel.com>
Subject: drm: Adding the option IRQ_ONESHOT to support irq oneshot
Thread-Topic: drm: Adding the option IRQ_ONESHOT to support irq oneshot
Thread-Index: Ac2GiTRA4atAo+8LSdC3HwZnlXLsOg==
Date: Thu, 30 Aug 2012 08:27:01 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A172DCC@SHSMSX101.ccr.corp.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: liu chuansheng <chuansheng.liu@intel.com>
Subject: [PATCH] drm: Adding the option IRQ_ONESHOT to support irq oneshot

For some platforms, we want the irq is handled as one shot,
then even when we use the irq thread, with this option, the new
irq will come until the irq thread finished.

So we have the requirement for IRQ_ONESHOT.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 drivers/gpu/drm/drm_irq.c |    3 +++
 include/drm/drmP.h        |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/drm_irq.c b/drivers/gpu/drm/drm_irq.c
index 03f16f3..7a8a581 100644
--- a/drivers/gpu/drm/drm_irq.c
+++ b/drivers/gpu/drm/drm_irq.c
@@ -345,6 +345,9 @@ int drm_irq_install(struct drm_device *dev)
        if (drm_core_check_feature(dev, DRIVER_IRQ_SHARED))
                sh_flags = IRQF_SHARED;
 
+        if (drm_core_check_feature(dev, DRIVER_IRQ_ONESHOT))
+                sh_flags |= IRQF_ONESHOT;
+
        if (dev->devname)
                irqname = dev->devname;
        else
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index d6b67bb..dfede31 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -152,6 +152,7 @@ int drm_err(const char *func, const char *format, ...);
 #define DRIVER_GEM         0x1000
 #define DRIVER_MODESET     0x2000
 #define DRIVER_PRIME       0x4000
+#define DRIVER_IRQ_ONESHOT 0x8000
 
 #define DRIVER_BUS_PCI 0x1
 #define DRIVER_BUS_PLATFORM 0x2
-- 
1.7.0.4
