Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab1LTApd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 19:45:33 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36867 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753704Ab1LTAnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 19:43:35 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Felipe Balbi <balbi@ti.com>, Vladimir Zapolskiy <vz@mleia.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Tony Lindgren <tony@atomide.com> (maintainer:OMAP SUPPORT),
        Russell King <linux@arm.linux.org.uk> (maintainer:ARM PORT),
        linux-omap@vger.kernel.org (open list:OMAP SUPPORT),
        linux-arm-kernel@lists.infradead.org (open list:ARM PORT)
Subject: [PATCH 03/10] arm: omap2: fix omap3 touchbook kconfig warning
Date: Tue, 20 Dec 2011 02:42:20 +0200
Message-Id: <1324341747-5922-4-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.7.8.rc1.14.g248db
In-Reply-To: <1324341747-5922-1-git-send-email-felipe.contreras@gmail.com>
References: <1324341747-5922-1-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

warning: (MACH_OMAP3_TOUCHBOOK && DRM_RADEON_KMS && DRM_I915 && STUB_POULSBO && FB_BACKLIGHT && USB_APPLEDISPLAY && FB_OLPC_DCON && ASUS_LAPTOP && SONY_LAPTOP && THINKPAD_ACPI && EEEPC_LAPTOP && ACPI_ASUS && ACPI_CMPC && SAMSUNG_Q10) selects BACKLIGHT_CLASS_DEVICE which has unmet direct dependencies (HAS_IOMEM && BACKLIGHT_LCD_SUPPORT)

A lot of boards need BACKLIGHT_CLASS_DEVICE for the framebuffers to
work, but it's not *needed* for the device itself. It might be nice to
enable it by default somewhoe if graphics stuff is enabled, but that's
another story.

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 arch/arm/mach-omap2/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index eb7c3ac..dbecb9a 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -211,7 +211,6 @@ config MACH_OMAP3_TOUCHBOOK
 	bool "OMAP3 Touch Book"
 	depends on ARCH_OMAP3
 	default y
-	select BACKLIGHT_CLASS_DEVICE
 
 config MACH_OMAP_3430SDP
 	bool "OMAP 3430 SDP board"
-- 
1.7.8.rc1.14.g248db

