Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab1FCScw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 14:32:52 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:43253 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab1FCScv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 14:32:51 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-131.messagelabs.com!1307125962!9076516!19
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.180]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Date: Fri, 3 Jun 2011 13:32:41 -0500
Subject: RE: [PATCH] gpio: Samsung: make Kconfig options def_bool
Thread-Topic: [PATCH] gpio: Samsung: make Kconfig options def_bool
Thread-Index: AcwiG6lPmKGzKUL7SHKCF92k98PNBgAAJPqw
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F381FC52E5@AUSP01VMBX24.collaborationhost.net>
References: <201106021014.59699.hartleys@visionengravers.com>
 <20110603182545.GH15616@ponder.secretlab.ca>
In-Reply-To: <20110603182545.GH15616@ponder.secretlab.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Samsung GPIO drivers are always built-in when the relevant
platform is selected.  Change the Kconfig symbol to def_bool y
dependant on the platform.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Grant Likely <grant.likely@secretlab.ca>

---

v2: updated based on mainline

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 4a7f631..2967002 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -87,32 +87,20 @@ config GPIO_IT8761E
 	  Say yes here to support GPIO functionality of IT8761E super I/O chip.
 
 config GPIO_EXYNOS4
-	bool "Samsung Exynos4 GPIO library support"
-	default y if CPU_EXYNOS4210
-	depends on ARM
-	help
-	  Say yes here to support Samsung Exynos4 series SoCs GPIO library
+	def_bool y
+	depends on CPU_EXYNOS4210
 
 config GPIO_PLAT_SAMSUNG
-	bool "Samsung SoCs GPIO library support"
-	default y if SAMSUNG_GPIOLIB_4BIT
-	depends on ARM
-	help
-	  Say yes here to support Samsung SoCs GPIO library
+	def_bool y
+	depends on SAMSUNG_GPIOLIB_4BIT
 
 config GPIO_S5PC100
-	bool "Samsung S5PC100 GPIO library support"
-	default y if CPU_S5PC100
-	depends on ARM
-	help
-	  Say yes here to support Samsung S5PC100 SoCs GPIO library
+	def_bool y
+	depends on CPU_S5PC100
 
 config GPIO_S5PV210
-	bool "Samsung S5PV210/S5PC110 GPIO library support"
-	default y if CPU_S5PV210
-	depends on ARM
-	help
-	  Say yes here to support Samsung S5PV210/S5PC110 SoCs GPIO library
+	def_bool y
+	depends on CPU_S5PV210
 
 config GPIO_PL061
 	bool "PrimeCell PL061 GPIO support"
