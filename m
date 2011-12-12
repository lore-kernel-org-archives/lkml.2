Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab1LLMdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 07:33:23 -0500
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:5266
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752169Ab1LLMdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 07:33:20 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <rtc-linux@googlegroups.com>
CC: <a.zummo@towertech.it>, <kernel@pengutronix.de>,
        <linux-kernel@vger.kernel.org>, <w.sang@pengutronix.de>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v2 1/2] rtc: Kconfig: Place RTC_DRV_IMXDI and RTC_MXC under "on-CPU RTC drivers"
Date: Mon, 12 Dec 2011 10:33:06 -0200
Message-ID: <1323693187-3466-1-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1323548042-25432-1-git-send-email-festevam@gmail.com>
References: <1323548042-25432-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RTC_DRV_IMXDI and RTC_MXC are on-chip RTC modules, so move them under 
"on-CPU RTC drivers" selection menu.

While at it change the dependency of RTC_DRV_IMXDI from ARCH_MX25 to SOC_IMX25.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Changes since v1:
- No changes. Only introduced a new patch in the series
for renaming RTC_MXC to RTC_DRV_MXC 

 drivers/rtc/Kconfig |   42 +++++++++++++++++++++---------------------
 1 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 53eb4e5..fdc32ba 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -613,27 +613,6 @@ config RTC_DRV_MSM6242
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-msm6242.
 
-config RTC_DRV_IMXDI
-	tristate "Freescale IMX DryIce Real Time Clock"
-	depends on ARCH_MX25
-	depends on RTC_CLASS
-	help
-	   Support for Freescale IMX DryIce RTC
-
-	   This driver can also be built as a module, if so, the module
-	   will be called "rtc-imxdi".
-
-config RTC_MXC
-	tristate "Freescale MXC Real Time Clock"
-	depends on ARCH_MXC
-	depends on RTC_CLASS
-	help
-	   If you say yes here you get support for the Freescale MXC
-	   RTC module.
-
-	   This driver can also be built as a module, if so, the module
-	   will be called "rtc-mxc".
-
 config RTC_DRV_BQ4802
 	tristate "TI BQ4802"
 	help
@@ -731,6 +710,16 @@ config RTC_DRV_DAVINCI
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-davinci.
 
+config RTC_DRV_IMXDI
+	tristate "Freescale IMX DryIce Real Time Clock"
+	depends on SOC_IMX25
+	depends on RTC_CLASS
+	help
+	   Support for Freescale IMX DryIce RTC
+
+	   This driver can also be built as a module, if so, the module
+	   will be called "rtc-imxdi".
+
 config RTC_DRV_OMAP
 	tristate "TI OMAP1"
 	depends on ARCH_OMAP15XX || ARCH_OMAP16XX || ARCH_OMAP730 || ARCH_DAVINCI_DA8XX
@@ -1070,4 +1059,15 @@ config RTC_DRV_PUV3
 	  This drive can also be built as a module. If so, the module
 	  will be called rtc-puv3.
 
+config RTC_MXC
+	tristate "Freescale MXC Real Time Clock"
+	depends on ARCH_MXC
+	depends on RTC_CLASS
+	help
+	   If you say yes here you get support for the Freescale MXC
+	   RTC module.
+
+	   This driver can also be built as a module, if so, the module
+	   will be called "rtc-mxc".
+
 endif # RTC_CLASS
-- 
1.7.1


