Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab1CLWvL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 17:51:11 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40480 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab1CLWvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 17:51:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=c4hxcEu44pIKmPL2nGefbwwtwVz40CtoUj8PSznYoo825tdf1567lYxlehFsSMg8KR
         BG2BUj35dq9w8IGIUWWBwEKweniLq4TjETzfwWmsM2t9j3+S60QR5D5mnOwPswDXZ/5G
         0ERIlIwfqubztAKnde8PB30ocyx5kis0WMNOI=
From: Andy Green <andy@warmcat.com>
Subject: [RFC PATCH 4/5] OMAP2+: Set onboard Ethernet MAC address using unique
 CPU ID data
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: patches@linaro.org, Andy Green <andy.green@linaro.org>
Date: Sat, 12 Mar 2011 22:51:02 +0000
Message-ID: <20110312225102.27728.59452.stgit@otae.warmcat.com>
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

This patch used the usbnet platform data in the panda board
definition file to set the MAC address of the USB <-> Ethernet
onboard bridge to a unique value derived from unique CPU ID
data.

Signed-off-by: Andy Green <andy.green@linaro.org>
---

 arch/arm/mach-omap2/board-omap4panda.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap4panda.c b/arch/arm/mach-omap2/board-omap4panda.c
index 7c7aa74..312154b 100644
--- a/arch/arm/mach-omap2/board-omap4panda.c
+++ b/arch/arm/mach-omap2/board-omap4panda.c
@@ -35,6 +35,7 @@
 
 #include <mach/hardware.h>
 #include <mach/omap4-common.h>
+#include <mach/id.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -404,7 +405,8 @@ static struct omap_board_mux board_mux[] __initdata = {
 #endif
 
 struct usbnet_platform_data panda_usbnet_platform_data_usb1_1 = {
-	.flags = USBNET_PLATDATA_FLAG__FORCE_ETH_IFNAME,
+	.flags = USBNET_PLATDATA_FLAG__FORCE_ETH_IFNAME |
+			USBNET_PLATDATA_FLAG__USE_MAC,
 };
 
 struct platform_async_platform_data panda_async_pdata_map[] = {
@@ -422,6 +424,8 @@ static void __init omap4_panda_init(void)
 		package = OMAP_PACKAGE_CBL;
 	omap4_mux_init(board_mux, package);
 
+	omap2_die_id_to_mac(panda_usbnet_platform_data_usb1_1.mac,
+				 sizeof(panda_usbnet_platform_data_usb1_1.mac));
 	platform_async_platform_data_register(panda_async_pdata_map,
 					   ARRAY_SIZE(panda_async_pdata_map));
 

