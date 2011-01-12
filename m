Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab1ALPTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 10:19:44 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47234 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab1ALPTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 10:19:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=LpqKPUuE6j/YowQmAnEUTel6A7nKu8kZCI/lhXUGno4206VO6y5FwAWtLwKwTjMcLh
         ch6S9oB3Q9dskNe9OInkEjDkh5+b3IO6lMolbjVUZZdogmvsjW03JByeh81RUr5Cfi00
         o+1R+PMg4rnFuKz20ZgvNvmMxnZ38HuqXHRKE=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] video: move SH_MIPI_DSI/SH_LCD_MIPI_DSI to the top of menu
Date: Wed, 12 Jan 2011 18:19:35 +0300
Message-Id: <1294845575-4508-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kconfig entries SH_MIPI_DSI and SH_LCD_MIPI_DSI while being invisible to
the user, broke the FrameBuffer menu (at least in menuconfig), as they
aren't depending on respective menuconfig item (FB). In result several
items got moved to the main "Graphics support" menu. Move these two
problematic items to the top of drivers/video/Kbuild to restore nice
display of FB menu.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 drivers/video/Kconfig |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 27c1fb4..055e1a7 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -11,6 +11,13 @@ config HAVE_FB_ATMEL
 config HAVE_FB_IMX
 	bool
 
+config SH_MIPI_DSI
+	tristate
+	depends on (SUPERH || ARCH_SHMOBILE) && HAVE_CLK
+
+config SH_LCD_MIPI_DSI
+	bool
+
 source "drivers/char/agp/Kconfig"
 
 source "drivers/gpu/vga/Kconfig"
@@ -1898,13 +1905,6 @@ config FB_W100
 
 	  If unsure, say N.
 
-config SH_MIPI_DSI
-	tristate
-	depends on (SUPERH || ARCH_SHMOBILE) && HAVE_CLK
-
-config SH_LCD_MIPI_DSI
-	bool
-
 config FB_SH_MOBILE_LCDC
 	tristate "SuperH Mobile LCDC framebuffer support"
 	depends on FB && (SUPERH || ARCH_SHMOBILE) && HAVE_CLK
-- 
1.7.2.3

