Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab0EZSDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 14:03:47 -0400
Received: from liberdade2.minaslivre.org ([74.50.53.203]:55427 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980Ab0EZSDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 14:03:46 -0400
X-Greylist: delayed 539 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 May 2010 14:03:46 EDT
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Baruch Siach <baruch@tkos.co.il>,
       =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH] fbdev: fix frame buffer devices menu
Date: Wed, 26 May 2010 14:54:37 -0300
Message-Id: <1274896477-6832-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f601441916d1e19291d0b4f044b4a7551e2924d0 has inserted the symbol
HAVE_FB_IMX, which does not depend on FB after the menuconfig FB. This
breaks the menu, presenting most of the drivers outside of it, when
using menuconfig.

Moving the symbol to the start of the file, just like HAVE_FB_ATMEL,
fixes the problem without breaking it for iMX25 configurations (tested
with ARCH=arm, no build).

Cc: Baruch Siach <baruch@tkos.co.il>
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/video/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 1e6fec4..3d94a14 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -8,6 +8,9 @@ menu "Graphics support"
 config HAVE_FB_ATMEL
 	bool
 
+config HAVE_FB_IMX
+	bool
+
 source "drivers/char/agp/Kconfig"
 
 source "drivers/gpu/vga/Kconfig"
@@ -400,9 +403,6 @@ config FB_SA1100
 	  If you plan to use the LCD display with your SA-1100 system, say
 	  Y here.
 
-config HAVE_FB_IMX
-	bool
-
 config FB_IMX
 	tristate "Motorola i.MX LCD support"
 	depends on FB && (HAVE_FB_IMX || ARCH_MX1 || ARCH_MX2)
-- 
1.7.1

