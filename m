Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab2HFSbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 14:31:17 -0400
Received: from www17.your-server.de ([213.133.104.17]:47685 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756879Ab2HFSbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 14:31:16 -0400
Subject: [PATCH] arm: imx: Use PTR_RET rather than if(IS_ERR(.. [1]
From: Thomas Meyer <thomas@m3y3r.de>
To: "[kernel@pengutronix.de, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org]"@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Mon, 06 Aug 2012 19:51:16 +0200
Message-ID: <1344275476.14513.96.camel@localhost.localdomain>
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semantic patch that makes this change is available
in scripts/coccinelle/api/ptr_ret.cocci.

More information about semantic patching is available at
http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/arch/arm/mach-imx/mach-mx31moboard.c b/arch/arm/mach-imx/mach-mx31moboard.c
--- a/arch/arm/mach-imx/mach-mx31moboard.c
+++ b/arch/arm/mach-imx/mach-mx31moboard.c
@@ -445,10 +445,7 @@ static int __init moboard_usbh2_init(voi
 		return -ENODEV;
 
 	pdev = imx31_add_mxc_ehci_hs(2, &usbh2_pdata);
-	if (IS_ERR(pdev))
-		return PTR_ERR(pdev);
-
-	return 0;
+	return PTR_RET(pdev);
 }
 
 static const struct gpio_led mx31moboard_leds[] __initconst = {
diff -u -p a/arch/arm/mach-imx/mx31moboard-devboard.c b/arch/arm/mach-imx/mx31moboard-devboard.c
--- a/arch/arm/mach-imx/mx31moboard-devboard.c
+++ b/arch/arm/mach-imx/mx31moboard-devboard.c
@@ -214,10 +214,7 @@ static int __init devboard_usbh1_init(vo
 	usbh1_pdata.otg = phy;
 
 	pdev = imx31_add_mxc_ehci_hs(1, &usbh1_pdata);
-	if (IS_ERR(pdev))
-		return PTR_ERR(pdev);
-
-	return 0;
+	return PTR_RET(pdev);
 }
 
 
diff -u -p a/arch/arm/mach-imx/mx31moboard-marxbot.c b/arch/arm/mach-imx/mx31moboard-marxbot.c
--- a/arch/arm/mach-imx/mx31moboard-marxbot.c
+++ b/arch/arm/mach-imx/mx31moboard-marxbot.c
@@ -328,10 +328,7 @@ static int __init marxbot_usbh1_init(voi
 	usbh1_pdata.otg = phy;
 
 	pdev = imx31_add_mxc_ehci_hs(1, &usbh1_pdata);
-	if (IS_ERR(pdev))
-		return PTR_ERR(pdev);
-
-	return 0;
+	return PTR_RET(pdev);
 }
 
 static const struct fsl_usb2_platform_data usb_pdata __initconst = {
