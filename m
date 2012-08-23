Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030262Ab2HWKic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 06:38:32 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:35654 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933892Ab2HWKiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 06:38:03 -0400
From: Felipe Balbi <balbi@ti.com>
To: alan@linux.intel.com
Cc: Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH v3 21/23] serial: omap: remove unnecessary header and add a missing one
Date: Thu, 23 Aug 2012 13:33:01 +0300
Message-Id: <1345717983-18179-22-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.12.rc3
In-Reply-To: <1345717983-18179-1-git-send-email-balbi@ti.com>
References: <1345717983-18179-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this driver doesn't use any from <plat/dmtimer.h>, so
we can remove it without any problems.

This will, however cause a problem because omap-serial.c
was relying on indirect inclusion of <linux/platform_device.h>,
let's fix the issue by including <linux/platform_device.h>
on omap-serial.c as it should be.

Tested-by: Shubhrajyoti D <shubhrajyoti@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/tty/serial/omap-serial.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index d49981d..e5a56cb 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -32,6 +32,7 @@
 #include <linux/slab.h>
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
+#include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/clk.h>
 #include <linux/serial_core.h>
@@ -39,7 +40,6 @@
 #include <linux/pm_runtime.h>
 #include <linux/of.h>
 
-#include <plat/dmtimer.h>
 #include <plat/omap-serial.h>
 
 #define UART_BUILD_REVISION(x, y)	(((x) << 8) | (y))
-- 
1.7.12.rc3

