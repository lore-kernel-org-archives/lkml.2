Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab2IFMwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 08:52:07 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:43479 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755612Ab2IFMvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 08:51:11 -0400
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: alan@linux.intel.com, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH v4 19/21] serial: omap: remove unnecessary header and add a missing one
Date: Thu,  6 Sep 2012 15:45:38 +0300
Message-Id: <1346935540-1792-20-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.12.rc3
In-Reply-To: <1346935540-1792-1-git-send-email-balbi@ti.com>
References: <20120906122948.GC29202@arwen.pp.htv.fi>
 <1346935540-1792-1-git-send-email-balbi@ti.com>
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
index 1ba1f43..881b652 100644
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
@@ -40,7 +41,6 @@
 #include <linux/of.h>
 #include <linux/gpio.h>
 
-#include <plat/dmtimer.h>
 #include <plat/omap-serial.h>
 
 #define UART_BUILD_REVISION(x, y)	(((x) << 8) | (y))
-- 
1.7.12.rc3

