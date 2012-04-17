Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab2DQVH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 17:07:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:59135 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855Ab2DQVHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 17:07:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="133650428"
From: Seth Heasley <seth.heasley@intel.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, James Ralston <james.d.ralston@intel.com>,
        Seth Heasley <seth.heasley@intel.com>
Subject: [PATCH 2/3] gpio-sch: Add Intel Centerton DeviceID for GPIO
Date: Tue, 17 Apr 2012 14:04:21 -0700
Message-Id: <1334696661-3569-1-git-send-email-seth.heasley@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Intel Centerton processor DeviceID for GPIO. The DeviceID is defined in include/linux/pci_ids.h

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
---
 drivers/gpio/Kconfig    |    9 ++++++---
 drivers/gpio/gpio-sch.c |    8 ++++++++
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index e03653d..d84eb4d 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -162,13 +162,13 @@ config GPIO_VR41XX
 	  Say yes here to support the NEC VR4100 series General-purpose I/O Uint
 
 config GPIO_SCH
-	tristate "Intel SCH/TunnelCreek GPIO"
+	tristate "Intel SCH/TunnelCreek/Centerton GPIO"
 	depends on PCI && X86
 	select MFD_CORE
 	select LPC_SCH
 	help
-	  Say yes here to support GPIO interface on Intel Poulsbo SCH
-	  or Intel Tunnel Creek processor.
+	  Say yes here to support GPIO interface on Intel Poulsbo SCH,
+	  Intel Tunnel Creek processor or Intel Centerton processor.
 	  The Intel SCH contains a total of 14 GPIO pins. Ten GPIOs are
 	  powered by the core power rail and are turned off during sleep
 	  modes (S3 and higher). The remaining four GPIOs are powered by
@@ -177,6 +177,9 @@ config GPIO_SCH
 	  system from the Suspend-to-RAM state.
 	  The Intel Tunnel Creek processor has 5 GPIOs powered by the
 	  core power rail and 9 from suspend power supply.
+	  The Intel Centerton processor has a total of 30 GPIO pins.
+	  Twenty-one are powered by the core power rail and 9 from the
+	  suspend power supply.
 
 config GPIO_VX855
 	tristate "VIA VX855/VX875 GPIO"
diff --git a/drivers/gpio/gpio-sch.c b/drivers/gpio/gpio-sch.c
index 8cadf4d..424dce8 100644
--- a/drivers/gpio/gpio-sch.c
+++ b/drivers/gpio/gpio-sch.c
@@ -232,6 +232,14 @@ static int __devinit sch_gpio_probe(struct platform_device *pdev)
 			sch_gpio_resume.ngpio = 9;
 			break;
 
+		case PCI_DEVICE_ID_INTEL_CENTERTON_ILB:
+			sch_gpio_core.base = 0;
+			sch_gpio_core.ngpio = 21;
+
+			sch_gpio_resume.base = 21;
+			sch_gpio_resume.ngpio = 9;
+			break;
+
 		default:
 			return -ENODEV;
 	}
-- 
1.7.4.4

