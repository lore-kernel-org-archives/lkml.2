Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966861Ab2EOVDQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 17:03:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37707 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966833Ab2EOVDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 17:03:11 -0400
From: mathieu.poirier@linaro.org
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, mathieu.poirier@linaro.org
Subject: [PATCH 3/5] video/console: automatically select a font
Date: Tue, 15 May 2012 15:02:59 -0600
Message-Id: <1337115781-27979-4-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1337115781-27979-1-git-send-email-mathieu.poirier@linaro.org>
References: <1337115781-27979-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The frame buffer console needs at least one font to be built into
the kernel, so add the necessary Kconfig magic to guarantee that
one of the available font is always on. If a user accidentally
disables all fonts manually, the 8x16 font will be selected
anyway.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/video/console/Kconfig |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/video/console/Kconfig b/drivers/video/console/Kconfig
index c2d11fe..e2c96d0 100644
--- a/drivers/video/console/Kconfig
+++ b/drivers/video/console/Kconfig
@@ -224,5 +224,19 @@ config FONT_10x18
 	  big letters. It fits between the sun 12x22 and the normal 8x16 font.
 	  If other fonts are too big or too small for you, say Y, otherwise say N.
 
+config FONT_AUTOSELECT
+	def_bool y
+	depends on FRAMEBUFFER_CONSOLE || SGI_NEWPORT_CONSOLE || STI_CONSOLE || USB_SISUSBVGA_CON
+	depends on !FONT_8x8
+	depends on !FONT_6x11
+	depends on !FONT_7x14
+	depends on !FONT_PEARL_8x8
+	depends on !FONT_ACORN_8x8
+	depends on !FONT_MINI_4x6
+	depends on !FONT_SUN8x16
+	depends on !FONT_SUN12x22
+	depends on !FONT_10x18
+	select FONT_8x16
+
 endmenu
 
-- 
1.7.5.4

