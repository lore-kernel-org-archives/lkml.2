Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030302Ab2HWKnB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 06:43:01 -0400
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:59608 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933833Ab2HWKhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 06:37:36 -0400
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
Subject: [PATCH v3 11/23] serial: omap: drop unnecessary check from remove
Date: Thu, 23 Aug 2012 13:32:51 +0300
Message-Id: <1345717983-18179-12-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.12.rc3
In-Reply-To: <1345717983-18179-1-git-send-email-balbi@ti.com>
References: <1345717983-18179-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if platform_get_drvdata() returns NULL, that's
quite a nasty bug on the driver which we want to
catch ASAP. Otherwise, that check is hugely
unneeded.

Tested-by: Shubhrajyoti D <shubhrajyoti@ti.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/tty/serial/omap-serial.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 9f709d4..9581741 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -1336,13 +1336,10 @@ static int serial_omap_remove(struct platform_device *dev)
 {
 	struct uart_omap_port *up = platform_get_drvdata(dev);
 
-	if (up) {
-		pm_runtime_disable(up->dev);
-		uart_remove_one_port(&serial_omap_reg, &up->port);
-		pm_qos_remove_request(&up->pm_qos_request);
-	}
+	pm_runtime_disable(up->dev);
+	uart_remove_one_port(&serial_omap_reg, &up->port);
+	pm_qos_remove_request(&up->pm_qos_request);
 
-	platform_set_drvdata(dev, NULL);
 	return 0;
 }
 
-- 
1.7.12.rc3

