Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab0F3PWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 11:22:15 -0400
Received: from compulab.co.il ([67.18.134.219]:54657 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756149Ab0F3PWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 11:22:13 -0400
Message-ID: <4C2B616F.90803@compulab.co.il>
Date: Wed, 30 Jun 2010 18:23:27 +0300
From: Denis Turischev <denis@compulab.co.il>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: David Brownell <dbrownell@users.sourceforge.net>
Subject: [PATCH 1/2] gpio: SIO IT8761, Poulsbo SCH are I/O mapped
References: <4B8A2F34.3020505@compulab.co.il>
In-Reply-To: <4B8A2F34.3020505@compulab.co.il>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Super I/O IT8761 and Poulsbo SCH expanders look like I/O mapped
and not memory mapped.

Signed-off-by: Denis Turischev <denis@compulab.co.il>

---
 drivers/gpio/Kconfig |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 724038d..f666023 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -70,12 +70,6 @@ config GPIO_MAX730X

 comment "Memory mapped GPIO expanders:"

-config GPIO_IT8761E
-	tristate "IT8761E GPIO support"
-	depends on GPIOLIB
-	help
-	  Say yes here to support GPIO functionality of IT8761E super I/O chip.
-
 config GPIO_PL061
 	bool "PrimeCell PL061 GPIO support"
 	depends on ARM_AMBA
@@ -94,6 +88,14 @@ config GPIO_VR41XX
 	help
 	  Say yes here to support the NEC VR4100 series General-purpose I/O Uint

+comment "I/O mapped GPIO expanders:"
+
+config GPIO_IT8761E
+	tristate "IT8761E GPIO support"
+	depends on GPIOLIB
+	help
+	  Say yes here to support GPIO functionality of IT8761E super I/O chip.
+
 config GPIO_SCH
 	tristate "Intel SCH GPIO"
 	depends on GPIOLIB && PCI
-- 
1.7.0.4
