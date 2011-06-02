Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab1FBRP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 13:15:29 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:52364 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab1FBRP1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 13:15:27 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-132.messagelabs.com!1307034926!27644983!1
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.98]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] gpio: Samsung: make Kconfig options def_bool
Date: Thu, 2 Jun 2011 10:14:58 -0700
User-Agent: KMail/1.9.9
CC: <kyungmin.park@samsung.com>, <grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-ID: <201106021014.59699.hartleys@visionengravers.com>
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

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 18c0b31..2e3cd11 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -87,32 +87,20 @@ config GPIO_IT8761E
 	  Say yes here to support GPIO functionality of IT8761E super I/O chip.
 
 config GPIO_EXYNOS4
-	bool "Samsung Exynos4 GPIO library support"
-	default y
-	depends on ARM && CPU_EXYNOS4210
-	help
-	  Say yes here to support Samsung Exynos4 series SoCs GPIO library
+	def_bool y
+	depends on CPU_EXYNOS4210
 
 config GPIO_PLAT_SAMSUNG
-	bool "Samsung SoCs GPIO library support"
-	default y
-	depends on ARM && SAMSUNG_GPIOLIB_4BIT
-	help
-	  Say yes here to support Samsung SoCs GPIO library
+	def_bool y
+	depends on SAMSUNG_GPIOLIB_4BIT
 
 config GPIO_S5PC100
-	bool "Samsung S5PC100 GPIO library support"
-	default y
-	depends on ARM && CPU_S5PC100
-	help
-	  Say yes here to support Samsung S5PC100 SoCs GPIO library
+	def_bool y
+	depends on CPU_S5PC100
 
 config GPIO_S5PV210
-	bool "Samsung S5PV210/S5PC110 GPIO library support"
-	default y
-	depends on ARM && CPU_S5PV210
-	help
-	  Say yes here to support Samsung S5PV210/S5PC110 SoCs GPIO library
+	def_bool y
+	depends on CPU_S5PV210
 
 config GPIO_PL061
 	bool "PrimeCell PL061 GPIO support"
