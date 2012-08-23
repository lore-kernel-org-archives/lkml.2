Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030322Ab2HWKkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 06:40:19 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:48715 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933853Ab2HWKho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 06:37:44 -0400
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
        Sourav Poddar <sourav.poddar@ti.com>, Ruchika Kharwar <ruchika@ti.com>,
        Nishanth Menon <nm@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH v3 14/23] serial: omap: fix sequence of pm_runtime_* calls.
Date: Thu, 23 Aug 2012 13:32:54 +0300
Message-Id: <1345717983-18179-15-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.12.rc3
In-Reply-To: <1345717983-18179-1-git-send-email-balbi@ti.com>
References: <1345717983-18179-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ruchika Kharwar <ruchika@ti.com>

pm_runtime_enable() needs to be invoked before
pm_runtime_use_autosuspend(), and
pm_runtime_set_autosuspend_delay() functions.

Tested-by: Shubhrajyoti D <shubhrajyoti@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Ruchika Kharwar <ruchika@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/tty/serial/omap-serial.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 8a60212..8254561 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -1300,12 +1300,12 @@ static int serial_omap_probe(struct platform_device *pdev)
 	INIT_WORK(&up->qos_work, serial_omap_uart_qos_work);
 
 	platform_set_drvdata(pdev, up);
+	pm_runtime_enable(&pdev->dev);
 	pm_runtime_use_autosuspend(&pdev->dev);
 	pm_runtime_set_autosuspend_delay(&pdev->dev,
 			omap_up_info->autosuspend_timeout);
 
 	pm_runtime_irq_safe(&pdev->dev);
-	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_sync(&pdev->dev);
 
 	omap_serial_fill_features_erratas(up);
-- 
1.7.12.rc3

