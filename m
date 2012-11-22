Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab2KVSi2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:38:28 -0500
Received: from gloria.sntech.de ([95.129.55.99]:35345 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448Ab2KVSiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:38:25 -0500
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Alan Cox <alan@linux.intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: [PATCH] serial: samsung: add devicetree properties for non-Exynos SoCs
Date: Thu, 22 Nov 2012 11:37:44 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201211221137.44849.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until now only the Exynos SoCs could use the serial driver via the
device tree. This patch adds compatible properties for the other
supported SoCs as well.

Tested on a s3c2416 based machine.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 drivers/tty/serial/samsung.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index 740458c..60eb125 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -1701,6 +1701,16 @@ MODULE_DEVICE_TABLE(platform, s3c24xx_serial_driver_ids);
 
 #ifdef CONFIG_OF
 static const struct of_device_id s3c24xx_uart_dt_match[] = {
+	{ .compatible = "samsung,s3c2410-uart",
+		.data = (void *)S3C2410_SERIAL_DRV_DATA },
+	{ .compatible = "samsung,s3c2412-uart",
+		.data = (void *)S3C2412_SERIAL_DRV_DATA },
+	{ .compatible = "samsung,s3c2440-uart",
+		.data = (void *)S3C2440_SERIAL_DRV_DATA },
+	{ .compatible = "samsung,s3c6400-uart",
+		.data = (void *)S3C6400_SERIAL_DRV_DATA },
+	{ .compatible = "samsung,s5pv210-uart",
+		.data = (void *)S5PV210_SERIAL_DRV_DATA },
 	{ .compatible = "samsung,exynos4210-uart",
 		.data = (void *)EXYNOS4210_SERIAL_DRV_DATA },
 	{},
-- 
1.7.2.3
