Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab2JHNRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 09:17:23 -0400
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:57245 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752664Ab2JHNRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 09:17:19 -0400
From: Constantine Shulyupin <const@MakeLinux.com>
To: nsekhar@ti.com, gregkh@linuxfoundation.org
Cc: Constantine Shulyupin <const@MakeLinux.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] usb: remove CONFIG_USB_MUSB_HOST etc
Date: Mon,  8 Oct 2012 15:17:07 +0200
Message-Id: <1349702227-24875-1-git-send-email-const@MakeLinux.com>
X-Mailer: git-send-email 1.7.9.5
X-Identified-User: {1470:box668.bluehost.com:makelinu:makelinux.net} {sentby:smtp auth 77.127.126.110 authed with poster@makelinux.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Constantine Shulyupin <const@MakeLinux.com>

Remove USB configuration in arch/arm/mach-davinci/usb.c accordingly 
CONFIG_USB_MUSB_OTG CONFIG_USB_MUSB_PERIPHERAL CONFIG_USB_MUSB_HOST 
and set MUSB_OTG configuration by default
because this configuration options are removed from Kconfig.

Signed-off-by: Constantine Shulyupin <const@MakeLinux.com>
 
---
 arch/arm/mach-davinci/usb.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/arm/mach-davinci/usb.c b/arch/arm/mach-davinci/usb.c
index f77b953..34509ff 100644
--- a/arch/arm/mach-davinci/usb.c
+++ b/arch/arm/mach-davinci/usb.c
@@ -42,14 +42,8 @@ static struct musb_hdrc_config musb_config = {
 };
 
 static struct musb_hdrc_platform_data usb_data = {
-#if defined(CONFIG_USB_MUSB_OTG)
 	/* OTG requires a Mini-AB connector */
 	.mode           = MUSB_OTG,
-#elif defined(CONFIG_USB_MUSB_PERIPHERAL)
-	.mode           = MUSB_PERIPHERAL,
-#elif defined(CONFIG_USB_MUSB_HOST)
-	.mode           = MUSB_HOST,
-#endif
 	.clock		= "usb",
 	.config		= &musb_config,
 };
-- 
1.7.9.5

