Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab2IFMuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 08:50:46 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:54659 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753331Ab2IFMuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 08:50:39 -0400
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
Subject: [PATCH v4 10/21] serial: omap: make sure to suspend device before remove
Date: Thu,  6 Sep 2012 15:45:29 +0300
Message-Id: <1346935540-1792-11-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.12.rc3
In-Reply-To: <1346935540-1792-1-git-send-email-balbi@ti.com>
References: <20120906122948.GC29202@arwen.pp.htv.fi>
 <1346935540-1792-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

before removing the driver, let's make sure
to force device into a suspended state in order
to conserve power.

Tested-by: Shubhrajyoti D <shubhrajyoti@ti.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/tty/serial/omap-serial.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index c19d340..0ceca44 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -1369,6 +1369,7 @@ static int serial_omap_remove(struct platform_device *dev)
 {
 	struct uart_omap_port *up = platform_get_drvdata(dev);
 
+	pm_runtime_put_sync(up->dev);
 	pm_runtime_disable(up->dev);
 	uart_remove_one_port(&serial_omap_reg, &up->port);
 	pm_qos_remove_request(&up->pm_qos_request);
-- 
1.7.12.rc3

