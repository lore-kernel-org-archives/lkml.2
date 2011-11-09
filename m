Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab1KIONi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 09:13:38 -0500
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:46705 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751396Ab1KIONh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 09:13:37 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, Stephen Warren <swarren@nvidia.com>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>
Cc: Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v2] pinctrl: hide subsystem from the populace
Date: Wed, 9 Nov 2011 15:12:56 +0100
Message-ID: <1320847976-13579-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Machines that have embedded pin controllers need to select them
explicitly, so why broadcast their config options to menuconfig.
We provide a helpful submenu for those machines that do select
it, making it possible to enable debugging for example.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Removed some more pointless help text
---
 drivers/pinctrl/Kconfig |   22 +++++++---------------
 1 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index ef56644..e17e2f8 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -2,23 +2,17 @@
 # PINCTRL infrastructure and drivers
 #
 
-menuconfig PINCTRL
-	bool "PINCTRL Support"
+config PINCTRL
+	bool
 	depends on EXPERIMENTAL
-	help
-	  This enables the PINCTRL subsystem for controlling pins
-	  on chip packages, for example multiplexing pins on primarily
-	  PGA and BGA packages for systems on chip.
-
-	  If unsure, say N.
 
 if PINCTRL
 
+menu "Pin controllers"
+	depends on PINCTRL
+
 config PINMUX
 	bool "Support pinmux controllers"
-	help
-	  Say Y here if you want the pincontrol subsystem to handle pin
-	  multiplexing drivers.
 
 config DEBUG_PINCTRL
 	bool "Debug PINCTRL calls"
@@ -30,14 +24,12 @@ config PINMUX_SIRF
 	bool "CSR SiRFprimaII pinmux driver"
 	depends on ARCH_PRIMA2
 	select PINMUX
-	help
-	  Say Y here to enable the SiRFprimaII pinmux driver
 
 config PINMUX_U300
 	bool "U300 pinmux driver"
 	depends on ARCH_U300
 	select PINMUX
-	help
-	  Say Y here to enable the U300 pinmux driver
+
+endmenu
 
 endif
-- 
1.7.3.2

