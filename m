Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933261Ab2GYOhL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 10:37:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:4026 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933148Ab2GYOhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 10:37:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="185943496"
Date: Wed, 25 Jul 2012 22:36:58 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Dave Airlie <airlied@redhat.com>
Cc: dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Subject: Re: [PATCH] nouveau: fix build error on IA64
Message-ID: <20120725143658.GA1651@localhost>
References: <20120725080008.GA18012@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120725080008.GA18012@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -	select ACPI_WMI if ACPI
> +	select ACPI_WMI if ACPI && !IA64
>  	select MXM_WMI if ACPI

Sorry, the MXM_WMI line should also be changed. Although MXM_WMI
depends on ACPI_WMI, "select" is dumb and will ignore that dependency..

Thanks,
Fengguang
---
From: Fengguang Wu <fengguang.wu@intel.com>
Date: Wed, 25 Jul 2012 15:56:35 +0800
Subject: [PATCH] nouveau: fix build error on IA64

I'm not sure if this is the best way, however it does fix these link
errors on IA64:

ERROR: "wmi_has_guid" [drivers/gpu/drm/nouveau/nouveau.ko] undefined!
ERROR: "wmi_evaluate_method" [drivers/gpu/drm/nouveau/nouveau.ko] undefined!

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 drivers/gpu/drm/nouveau/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux.orig/drivers/gpu/drm/nouveau/Kconfig	2012-07-25 19:09:37.715358715 +0800
+++ linux/drivers/gpu/drm/nouveau/Kconfig	2012-07-25 22:34:43.775298923 +0800
@@ -11,8 +11,8 @@ config DRM_NOUVEAU
 	select FRAMEBUFFER_CONSOLE if !EXPERT
 	select FB_BACKLIGHT if DRM_NOUVEAU_BACKLIGHT
 	select ACPI_VIDEO if ACPI && X86 && BACKLIGHT_CLASS_DEVICE && VIDEO_OUTPUT_CONTROL && INPUT
-	select ACPI_WMI if ACPI
-	select MXM_WMI if ACPI
+	select ACPI_WMI if ACPI && !IA64
+	select MXM_WMI if ACPI && !IA64
 	select POWER_SUPPLY
 	help
 	  Choose this option for open-source nVidia support.
