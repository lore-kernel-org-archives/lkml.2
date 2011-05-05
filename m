Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab1EEIAg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 04:00:36 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35794 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab1EEIAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 04:00:35 -0400
From: srinath@mistralsolutions.com
To: linux-omap@vger.kernel.org
Cc: jdk@ti.com, tony@atomide.com, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        khilman@deeprootsystems.com, nagendra@mistralsolutions.com,
        umeshk@mistralsolutions.com,
        "Srinath.R" <srinath@mistralsolutions.com>
Subject: [Patch v1] AM35xx-Craneboard:Update
Date: Thu,  5 May 2011 12:45:08 +0530
Message-Id: <1304579708-16018-1-git-send-email-srinath@mistralsolutions.com>
X-Mailer: git-send-email 1.7.1.226.g770c5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinath.R <srinath@mistralsolutions.com>

Replaced gpio_request()/gpio_direction_output() with gpio_request_one() in am3517_crane_init.

Signed-off-by: Srinath.R <srinath@mistralsolutions.com>
---
 arch/arm/mach-omap2/board-am3517crane.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-omap2/board-am3517crane.c b/arch/arm/mach-omap2/board-am3517crane.c
index a890d24..b8c7150 100644
--- a/arch/arm/mach-omap2/board-am3517crane.c
+++ b/arch/arm/mach-omap2/board-am3517crane.c
@@ -89,19 +89,13 @@ static void __init am3517_crane_init(void)
 		return;
 	}
 
-	ret = gpio_request(GPIO_USB_POWER, "usb_ehci_enable");
+	ret = gpio_request_one(GPIO_USB_POWER, GPIOF_OUT_INIT_HIGH,
+				"usb_ehci_enable");
 	if (ret < 0) {
 		pr_err("Can not request GPIO %d\n", GPIO_USB_POWER);
 		return;
 	}
 
-	ret = gpio_direction_output(GPIO_USB_POWER, 1);
-	if (ret < 0) {
-		gpio_free(GPIO_USB_POWER);
-		pr_err("Unable to initialize EHCI power\n");
-		return;
-	}
-
 	usbhs_init(&usbhs_bdata);
 }
 
-- 
1.5.3.4

