Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab0HRTPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 15:15:55 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28106 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab0HRTPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 15:15:51 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6078"; a="51462470"
From: Patrick Pannuto <ppannuto@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: ppannuto@codeaurora.org, linux-arm-msm@vger.kernel.org,
        magnus.damm@gmail.com, grant.likely@secretlab.ca, gregkh@suse.de,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 4/4] msm: serial: Move msm_uart_driver onto msm bus
Date: Wed, 18 Aug 2010 12:15:43 -0700
Message-Id: <1282158943-11902-5-git-send-email-ppannuto@codeaurora.org>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1282158943-11902-1-git-send-email-ppannuto@codeaurora.org>
References: <1282158943-11902-1-git-send-email-ppannuto@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Proof of concept; move one device / driver pair

Change-Id: I1afb6f54e6574057699db5b8f9fb7f4456a52010
Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>
---
 arch/arm/mach-msm/board-qsd8x50.c |    3 ++-
 drivers/serial/msm_serial.c       |    4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-msm/board-qsd8x50.c b/arch/arm/mach-msm/board-qsd8x50.c
index e3cc807..0deb369 100644
--- a/arch/arm/mach-msm/board-qsd8x50.c
+++ b/arch/arm/mach-msm/board-qsd8x50.c
@@ -27,6 +27,7 @@
 #include <asm/setup.h>
 
 #include <mach/board.h>
+#include <mach/msm_device.h>
 #include <mach/irqs.h>
 #include <mach/sirc.h>
 #include <mach/gpio.h>
@@ -65,7 +66,7 @@ static void __init qsd8x50_init_irq(void)
 static void __init qsd8x50_init(void)
 {
 	msm8x50_init_uart3();
-	platform_add_devices(devices, ARRAY_SIZE(devices));
+	msm_device_register(&msm_device_uart3);
 }
 
 MACHINE_START(QSD8X50_SURF, "QCT QSD8X50 SURF")
diff --git a/drivers/serial/msm_serial.c b/drivers/serial/msm_serial.c
index f8c816e..3332fe7 100644
--- a/drivers/serial/msm_serial.c
+++ b/drivers/serial/msm_serial.c
@@ -32,6 +32,8 @@
 #include <linux/clk.h>
 #include <linux/platform_device.h>
 
+#include <mach/msm_device.h>
+
 #include "msm_serial.h"
 
 struct msm_port {
@@ -732,7 +734,7 @@ static int __init msm_serial_init(void)
 	if (unlikely(ret))
 		return ret;
 
-	ret = platform_driver_probe(&msm_platform_driver, msm_serial_probe);
+	ret = msm_driver_probe(&msm_platform_driver, msm_serial_probe);
 	if (unlikely(ret))
 		uart_unregister_driver(&msm_uart_driver);
 
-- 
1.7.2.1

