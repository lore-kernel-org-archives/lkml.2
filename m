Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab1G0Dql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 23:46:41 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:27577 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995Ab1G0Dqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 23:46:40 -0400
X-AuditID: cbfee61a-b7cf0ae000006bc6-af-4e2f8a1e64f8
Date: Wed, 27 Jul 2011 12:46:32 +0900
From: Kyungmin Park <kmpark@infradead.org>
Subject: [PATCH] serial: samsung: Fix compiler error when !CONFIG_PM_SLEEP
To: Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-id: <20110727034632.GA31896@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 27 Jul 2011 03:46:58.0436 (UTC)
 FILETIME=[D5EF6C40:01CC4C0F]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>

drivers/tty/serial/samsung.c: In function 's3c24xx_serial_init':
drivers/tty/serial/samsung.c:1237: error: lvalue required as unary '&' operand

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index afc6294..318ab90 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -1225,15 +1225,15 @@ static const struct dev_pm_ops s3c24xx_serial_pm_ops = {
 	.suspend = s3c24xx_serial_suspend,
 	.resume = s3c24xx_serial_resume,
 };
-#else /* !CONFIG_PM_SLEEP */
-#define s3c24xx_serial_pm_ops	NULL
 #endif /* CONFIG_PM_SLEEP */
 
 int s3c24xx_serial_init(struct platform_driver *drv,
 			struct s3c24xx_uart_info *info)
 {
 	dbg("s3c24xx_serial_init(%p,%p)\n", drv, info);
+#ifdef CONFIG_PM_SLEEP
 	drv->driver.pm = &s3c24xx_serial_pm_ops;
+#endif
 
 	return platform_driver_register(drv);
 }
