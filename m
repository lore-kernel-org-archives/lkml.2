Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab1LTAoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 19:44:21 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36867 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753807Ab1LTAny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 19:43:54 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Felipe Balbi <balbi@ti.com>, Vladimir Zapolskiy <vz@mleia.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de> (supporter:USB SUBSYSTEM),
        linux-usb@vger.kernel.org (open list:MUSB MULTIPOINT H...)
Subject: [PATCH 10/10] musb: cleanup kconfig
Date: Tue, 20 Dec 2011 02:42:27 +0200
Message-Id: <1324341747-5922-11-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.7.8.rc1.14.g248db
In-Reply-To: <1324341747-5922-1-git-send-email-felipe.contreras@gmail.com>
References: <1324341747-5922-1-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The whole thing depends on USB_MUSB_HDRC, just add an 'if'.

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 drivers/usb/musb/Kconfig |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
index b0a46e4..0844b8f 100644
--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -31,9 +31,10 @@ config USB_MUSB_HDRC
 	  To compile this driver as a module, choose M here; the
 	  module will be called "musb-hdrc".
 
+if USB_MUSB_HDRC
+
 choice
 	prompt "Platform Glue Layer"
-	depends on USB_MUSB_HDRC
 
 config USB_MUSB_DAVINCI
 	tristate "DaVinci"
@@ -67,7 +68,6 @@ endchoice
 
 config MUSB_PIO_ONLY
 	bool 'Disable DMA (always use PIO)'
-	depends on USB_MUSB_HDRC
 	default USB_MUSB_TUSB6010 || USB_MUSB_DA8XX || USB_MUSB_AM35X
 	help
 	  All data is copied between memory and FIFO by the CPU.
@@ -80,30 +80,32 @@ config MUSB_PIO_ONLY
 
 config USB_UX500_DMA
 	bool
-	depends on USB_MUSB_HDRC && !MUSB_PIO_ONLY
+	depends on !MUSB_PIO_ONLY
 	default USB_MUSB_UX500
 	help
 	  Enable DMA transfers on UX500 platforms.
 
 config USB_INVENTRA_DMA
 	bool
-	depends on USB_MUSB_HDRC && !MUSB_PIO_ONLY
+	depends on !MUSB_PIO_ONLY
 	default USB_MUSB_OMAP2PLUS || USB_MUSB_BLACKFIN
 	help
 	  Enable DMA transfers using Mentor's engine.
 
 config USB_TI_CPPI_DMA
 	bool
-	depends on USB_MUSB_HDRC && !MUSB_PIO_ONLY
+	depends on !MUSB_PIO_ONLY
 	default USB_MUSB_DAVINCI
 	help
 	  Enable DMA transfers when TI CPPI DMA is available.
 
 config USB_TUSB_OMAP_DMA
 	bool
-	depends on USB_MUSB_HDRC && !MUSB_PIO_ONLY
+	depends on !MUSB_PIO_ONLY
 	depends on USB_MUSB_TUSB6010
 	depends on ARCH_OMAP
 	default y
 	help
 	  Enable DMA transfers on TUSB 6010 when OMAP DMA is available.
+
+endif # USB_MUSB_HDRC
-- 
1.7.8.rc1.14.g248db

