Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761451Ab0HMKVm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 06:21:42 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41728 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761431Ab0HMKVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 06:21:41 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Cc: Igor Grinberg <grinberg@compulab.co.il>,
        Mike Rapoport <mike@compulab.co.il>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] ARM: imx: fix build failure concerning otg/ulpi
Date: Fri, 13 Aug 2010 12:21:31 +0200
Message-Id: <1281694891-7527-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275464450-23003-2-git-send-email-grinberg@compulab.co.il>
References: <1275464450-23003-2-git-send-email-grinberg@compulab.co.il>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The build failure was introduced by

	13dd0c9 (USB: otg/ulpi: extend the generic ulpi driver.)

Cc: Igor Grinberg <grinberg@compulab.co.il>
Cc: Mike Rapoport <mike@compulab.co.il>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/arm/mach-imx/mach-cpuimx27.c  |    4 ++--
 arch/arm/mach-imx/mach-pca100.c    |    4 ++--
 arch/arm/mach-mx25/mach-cpuimx25.c |    2 +-
 arch/arm/mach-mx3/mach-cpuimx35.c  |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-imx/mach-cpuimx27.c b/arch/arm/mach-imx/mach-cpuimx27.c
index 575ff1a..339150a 100644
--- a/arch/arm/mach-imx/mach-cpuimx27.c
+++ b/arch/arm/mach-imx/mach-cpuimx27.c
@@ -279,13 +279,13 @@ static void __init eukrea_cpuimx27_init(void)
 #if defined(CONFIG_USB_ULPI)
 	if (otg_mode_host) {
 		otg_pdata.otg = otg_ulpi_create(&mxc_ulpi_access_ops,
-				USB_OTG_DRV_VBUS | USB_OTG_DRV_VBUS_EXT);
+				ULPI_OTG_DRVVBUS | ULPI_OTG_DRVVBUS_EXT);
 
 		mxc_register_device(&mxc_otg_host, &otg_pdata);
 	}
 
 	usbh2_pdata.otg = otg_ulpi_create(&mxc_ulpi_access_ops,
-				USB_OTG_DRV_VBUS | USB_OTG_DRV_VBUS_EXT);
+				ULPI_OTG_DRVVBUS | ULPI_OTG_DRVVBUS_EXT);
 
 	mxc_register_device(&mxc_usbh2, &usbh2_pdata);
 #endif
diff --git a/arch/arm/mach-imx/mach-pca100.c b/arch/arm/mach-imx/mach-pca100.c
index a389d11..23c9e1f 100644
--- a/arch/arm/mach-imx/mach-pca100.c
+++ b/arch/arm/mach-imx/mach-pca100.c
@@ -419,13 +419,13 @@ static void __init pca100_init(void)
 #if defined(CONFIG_USB_ULPI)
 	if (otg_mode_host) {
 		otg_pdata.otg = otg_ulpi_create(&mxc_ulpi_access_ops,
-				USB_OTG_DRV_VBUS | USB_OTG_DRV_VBUS_EXT);
+				ULPI_OTG_DRVVBUS | ULPI_OTG_DRVVBUS_EXT);
 
 		mxc_register_device(&mxc_otg_host, &otg_pdata);
 	}
 
 	usbh2_pdata.otg = otg_ulpi_create(&mxc_ulpi_access_ops,
-				USB_OTG_DRV_VBUS | USB_OTG_DRV_VBUS_EXT);
+				ULPI_OTG_DRVVBUS | ULPI_OTG_DRVVBUS_EXT);
 
 	mxc_register_device(&mxc_usbh2, &usbh2_pdata);
 #endif
diff --git a/arch/arm/mach-mx25/mach-cpuimx25.c b/arch/arm/mach-mx25/mach-cpuimx25.c
index 56b2e26..0134fb8 100644
--- a/arch/arm/mach-mx25/mach-cpuimx25.c
+++ b/arch/arm/mach-mx25/mach-cpuimx25.c
@@ -138,7 +138,7 @@ static void __init eukrea_cpuimx25_init(void)
 #if defined(CONFIG_USB_ULPI)
 	if (otg_mode_host) {
 		otg_pdata.otg = otg_ulpi_create(&mxc_ulpi_access_ops,
-				USB_OTG_DRV_VBUS | USB_OTG_DRV_VBUS_EXT);
+				USB_OTG_DRV_VBUS | ULPI_OTG_DRVVBUS_EXT);
 
 		mxc_register_device(&mxc_otg, &otg_pdata);
 	}
diff --git a/arch/arm/mach-mx3/mach-cpuimx35.c b/arch/arm/mach-mx3/mach-cpuimx35.c
index 63f970f..117f90e 100644
--- a/arch/arm/mach-mx3/mach-cpuimx35.c
+++ b/arch/arm/mach-mx3/mach-cpuimx35.c
@@ -192,7 +192,7 @@ static void __init mxc_board_init(void)
 #if defined(CONFIG_USB_ULPI)
 	if (otg_mode_host) {
 		otg_pdata.otg = otg_ulpi_create(&mxc_ulpi_access_ops,
-				USB_OTG_DRV_VBUS | USB_OTG_DRV_VBUS_EXT);
+				USB_OTG_DRV_VBUS | ULPI_OTG_DRVVBUS_EXT);
 
 		mxc_register_device(&mxc_otg_host, &otg_pdata);
 	}
-- 
1.7.1

