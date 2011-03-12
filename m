Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab1CLWuq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 17:50:46 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40480 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091Ab1CLWun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 17:50:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=CqfIskxVUVNq3wOSjrXarnpJsY0WwOSW/f1ngYx7sMreHEH40G9u0xpvT41/L9Bzh/
         JsIgsvJIIThsT+UwRzMepzCofAEK4VTGNeQ0KuidQZ7FzuDlS74U/8v27C/30hGcaem8
         qliiree16+11EegrJMkzQXSint/IVRtBSI8us=
From: Andy Green <andy@warmcat.com>
Subject: [RFC PATCH 1/5] OMAP2+: Panda introduce async platform data definition
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: patches@linaro.org, Andy Green <andy.green@linaro.org>
Date: Sat, 12 Mar 2011 22:50:39 +0000
Message-ID: <20110312225039.27728.24017.stgit@otae.warmcat.com>
In-Reply-To: <20110312224440.27728.60593.stgit@otae.warmcat.com>
References: <20110312224440.27728.60593.stgit@otae.warmcat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is part of an RFC patch series introducing asynchronous platform
data, which may be attached to discovered bus devices at probe time
based on the device path.

As part of the series, platform_data is enabled in usbnet layer.

This patch defines the usbnet platform data, allowing the panda board
definition file to assert the naming of the usbnet network interface
should be eth%d instead of usb%d.

Signed-off-by: Andy Green <andy.green@linaro.org>
---

 arch/arm/mach-omap2/board-omap4panda.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap4panda.c b/arch/arm/mach-omap2/board-omap4panda.c
index e944025..7c7aa74 100644
--- a/arch/arm/mach-omap2/board-omap4panda.c
+++ b/arch/arm/mach-omap2/board-omap4panda.c
@@ -26,6 +26,12 @@
 #include <linux/usb/otg.h>
 #include <linux/i2c/twl.h>
 #include <linux/regulator/machine.h>
+#include <linux/usb.h>
+#include <linux/skbuff.h>
+#include <linux/mii.h>
+#include <linux/netdevice.h>
+#include <linux/if_ether.h>
+#include <linux/usb/usbnet.h>
 
 #include <mach/hardware.h>
 #include <mach/omap4-common.h>
@@ -397,6 +403,17 @@ static struct omap_board_mux board_mux[] __initdata = {
 #define board_mux	NULL
 #endif
 
+struct usbnet_platform_data panda_usbnet_platform_data_usb1_1 = {
+	.flags = USBNET_PLATDATA_FLAG__FORCE_ETH_IFNAME,
+};
+
+struct platform_async_platform_data panda_async_pdata_map[] = {
+	{
+		.device_path = "usb1/1-1/1-1.1",
+		.platform_data = &panda_usbnet_platform_data_usb1_1,
+	},
+};
+
 static void __init omap4_panda_init(void)
 {
 	int package = OMAP_PACKAGE_CBS;
@@ -405,6 +422,9 @@ static void __init omap4_panda_init(void)
 		package = OMAP_PACKAGE_CBL;
 	omap4_mux_init(board_mux, package);
 
+	platform_async_platform_data_register(panda_async_pdata_map,
+					   ARRAY_SIZE(panda_async_pdata_map));
+
 	omap4_panda_i2c_init();
 	platform_add_devices(panda_devices, ARRAY_SIZE(panda_devices));
 	omap_serial_init();

