Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965224Ab2EPTrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 15:47:47 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:49168 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab2EPTro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 15:47:44 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sage Ahn <syahn@gctsemi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] staging: gdm72xx: WIMAX_GDM72XX_USB_PM should depend on USB_SUSPEND
Date: Wed, 16 May 2012 21:47:40 +0200
Message-Id: <1337197660-7852-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use Kconfig logic instead of a rude #error in the driver source,
which breaks m68k-allmodconfig.
Also remove the "default n", as that's the default.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
http://kisskb.ellerman.id.au/kisskb/buildresult/6335693/

 drivers/staging/gdm72xx/Kconfig   |    2 +-
 drivers/staging/gdm72xx/gdm_usb.c |    6 ------
 2 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/gdm72xx/Kconfig b/drivers/staging/gdm72xx/Kconfig
index 5c37cba..fc58427 100644
--- a/drivers/staging/gdm72xx/Kconfig
+++ b/drivers/staging/gdm72xx/Kconfig
@@ -38,7 +38,7 @@ if WIMAX_GDM72XX_USB
 
 config WIMAX_GDM72XX_USB_PM
 	bool "Enable power managerment support"
-	default n
+	depends on USB_SUSPEND
 
 endif # WIMAX_GDM72XX_USB
 
diff --git a/drivers/staging/gdm72xx/gdm_usb.c b/drivers/staging/gdm72xx/gdm_usb.c
index 004786b..f60e890 100644
--- a/drivers/staging/gdm72xx/gdm_usb.c
+++ b/drivers/staging/gdm72xx/gdm_usb.c
@@ -17,12 +17,6 @@
 #include <linux/usb.h>
 #include <asm/byteorder.h>
 
-#ifdef CONFIG_WIMAX_GDM72XX_USB_PM
-#ifndef CONFIG_USB_SUSPEND
-#error "USB host doesn't support USB Selective Suspend."
-#endif
-#endif
-
 #include "gdm_usb.h"
 #include "gdm_wimax.h"
 #include "usb_boot.h"
-- 
1.7.0.4

