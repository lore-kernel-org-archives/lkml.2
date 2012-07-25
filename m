Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab2GYIAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 04:00:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:49000 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755575Ab2GYIAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 04:00:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="172910755"
Date: Wed, 25 Jul 2012 16:00:08 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Dave Airlie <airlied@redhat.com>
Cc: dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Subject: [PATCH] nouveau: fix build error on IA64
Message-ID: <20120725080008.GA18012@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not sure if this is the best way, however it does fix the last 2
allmodconfig errors on IA64:

ERROR: "wmi_has_guid" [drivers/gpu/drm/nouveau/nouveau.ko] undefined!
ERROR: "wmi_evaluate_method" [drivers/gpu/drm/nouveau/nouveau.ko] undefined!

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 drivers/gpu/drm/nouveau/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/Kconfig b/drivers/gpu/drm/nouveau/Kconfig
index 97a8126..046bb56 100644
--- a/drivers/gpu/drm/nouveau/Kconfig
+++ b/drivers/gpu/drm/nouveau/Kconfig
@@ -11,7 +11,7 @@ config DRM_NOUVEAU
 	select FRAMEBUFFER_CONSOLE if !EXPERT
 	select FB_BACKLIGHT if DRM_NOUVEAU_BACKLIGHT
 	select ACPI_VIDEO if ACPI && X86 && BACKLIGHT_CLASS_DEVICE && VIDEO_OUTPUT_CONTROL && INPUT
-	select ACPI_WMI if ACPI
+	select ACPI_WMI if ACPI && !IA64
 	select MXM_WMI if ACPI
 	select POWER_SUPPLY
 	help
-- 
1.7.10

